DROP table IF EXISTS bla;
CREATE TABLE bla AS
    WITH data AS (
        SELECT *
        FROM read_json_auto('/Users/Asus/Desktop/KSE/Data_Base_SQL/steam_2025_5k-dataset-games_20250831.json',
                            maximum_object_size = 106144477)
    ),
    raw AS (
        SELECT unnest(games) AS games
        FROM data
    ),
    data_ready as(
        SELECT
            CAST(json_extract(games, '$.appid') AS INTEGER) AS id,
            json_extract_string(games, '$.name_from_applist') AS name,
            json_extract_string(games, '$.app_details.success') AS success,
            CAST(json_extract(games, '$.app_details.fetched_at') AS TIMESTAMP) AS fetched_at,
            CAST(json_extract(games, '$.app_details.data.required_age') AS INTEGER) AS required_age,
            json_extract_string(games, '$.app_details.data.is_free') AS is_free,
            json_extract_string(games, '$.app_details.data.detailed_description') AS detailed_description,
            json_extract_string(games, '$.app_details.data.about_the_game') AS about_the_game,
            json_extract_string(games, '$.app_details.data.short_description') AS short_description,
            CAST(json_extract(games, '$.app_details.data.fullgame.appid')AS INTEGER) AS real_id,
            json_extract_string(games, '$.app_details.data.fullgame.name') AS full_name,
            json_extract_string(games, '$.app_details.data.website') AS website,
            json_extract_string(games, '$.app_details.data.developers') AS developers,
            json_extract_string(games, '$.app_details.data.publishers') AS publishers,
            json_extract_string(games, '$.app_details.data.type') AS type,
            json_extract_string(games, '$.app_details.data.release_date.coming_soon') AS coming_soon,
            json_extract_string(games, '$.app_details.data.release_date.date') as date_release,
            CAST(json_extract(games, '$.app_details.data.ratings.dejus.rating_generated') AS FLOAT) as rating_generated,
            json_extract_string(games, '$.app_details.data.ratings.dejus.rating') as rating,
            json_extract_string(games, '$.app_details.data.ratings.dejus.banned') as banned,
            CAST(json_extract(games, '$.app_details.data.ratings.steam_germany.rating_generated') AS FLOAT) as rating_generated,
            json_extract_string(games, '$.app_details.data.ratings.steam_germany.rating') as rating,
            json_extract_string(games, '$.app_details.data.ratings.steam_germany.banned') as banned
        from raw
    )

SELECT * FROM data_ready;





DROP TABLE IF EXISTS bla2;

CREATE TABLE bla2 AS
WITH reviews_file AS (
    SELECT *
    FROM read_json_auto('/Users/Asus/Desktop/KSE/Data_Base_SQL/steam_2025_5k-dataset-reviews_20250901.json',
                        maximum_object_size = 106144477)
),
games_list AS (
    SELECT unnest(reviews) AS game_obj
    FROM reviews_file
),
user_review_exploded AS (
    SELECT
        CAST(json_extract(game_obj, '$.appid') AS INTEGER) AS id,
        CAST(json_extract(game_obj, '$.review_data.success') AS INTEGER) AS success, -- ADDED THIS
        json_extract(game_obj, '$.review_data.query_summary') AS summary,
        unnest(CAST(json_extract(game_obj, '$.review_data.reviews') AS JSON[])) AS single_review
    FROM games_list
)
SELECT
    id,
    success,
    CAST(json_extract(summary, '$.num_reviews') AS INTEGER) as num_reviews,
    CAST(json_extract(summary, '$.review_score') AS INTEGER) as review_score,
    json_extract_string(summary, '$.review_score_desc') AS review_score_desc,
    CAST(json_extract(summary, '$.total_positive') AS INTEGER) AS total_positive,
    CAST(json_extract(summary, '$.total_negative') AS INTEGER) AS total_negative,
    CAST(json_extract(summary, '$.total_reviews') AS INTEGER) AS total_reviews,
    json_extract_string(single_review, '$.recommendationid') AS recommendationid,
    json_extract_string(single_review, '$.author.steamid') AS steamid,
    CAST(json_extract(single_review, '$.author.num_games_owned') AS INTEGER) AS num_games_owned,
    CAST(json_extract(single_review, '$.author.num_reviews') AS INTEGER) AS num_reviews_person,
    CAST(json_extract(single_review, '$.author.playtime_forever') AS INTEGER) AS playtime_forever,
    CAST(json_extract(single_review, '$.author.playtime_last_two_weeks') AS INTEGER) AS playtime_last_two_weeks,
    CAST(json_extract(single_review, '$.author.playtime_at_review') AS INTEGER) AS playtime_at_review,
    CAST(json_extract(single_review, '$.author.last_played') AS BIGINT) AS last_played,
    json_extract_string(single_review, '$.language') AS language_review,
    json_extract_string(single_review, '$.review') AS review
FROM user_review_exploded;

SELECT * FROM bla2;

CREATE TABLE merged as (
    SELECT *
    FROM bla
    JOIN bla2 b on bla.id = b.id
);
SELECT * FROM merged;


--Analytical part: Do people judge the game after the first few hours of playing
-- (due to the bad technical characteristics) or after some experience in the game (
-- due to the plot or smth)
DROP TABLE if exists judgement;
Create table judgement AS(
SELECT
    CASE
        WHEN playtime_at_review < 120 THEN 'Bad characteristics (<2 hrs)'
        ELSE 'Veteran (>20 hrs)'
    END AS player_type,
    COUNT(*)
FROM merged
GROUP BY
    CASE
        WHEN playtime_at_review < 120 THEN 'Bad characteristics (<2 hrs)'
        ELSE 'Veteran (>20 hrs)'
    END
);
SELECT * FROM judgement;

-- Let's count 5 the most common languages used to comment games

CREATE TABLE languages AS(
SELECT
    language_review,
    COUNT(*) as total_reviews
FROM merged
GROUP BY language_review
ORDER BY total_reviews DESC
LIMIT 5);
SELECT * FROM languages;

-- Who are top 5 people leaving feedback even though having 0 hrs played last 2 weeks?

CREATE TABLE no_playing_hrs AS(
SELECT
    playtime_last_two_weeks,
    steamid,
    num_reviews_person,
    playtime_forever
FROM merged
WHERE playtime_last_two_weeks = 0
ORDER BY num_reviews_person DESC
LIMIT 5);

SELECT * FROM no_playing_hrs;

-- How many people play less then 100, more then 10000, more then 100000 hrs in total?
CREATE TABLE hours AS(
    SELECT
    CASE
        WHEN playtime_forever < 100 THEN '<100'
        WHEN playtime_forever BETWEEN 100 AND 10000 THEN '<10000'
        WHEN playtime_forever BETWEEN 10000 AND 100000 THEN '<100000'
        ELSE 'Hardcore'
    END AS engagement_level,
    COUNT(*) as player_count
FROM merged
GROUP BY 1
ORDER BY player_count DESC
);

SELECT *FROM hours;

-- How many games have total negative scores more than total positive?
CREATE TABLE more_total_negative AS (
    SELECT
        CASE
            WHEN total_negative > total_positive THEN 'more_negative_responses'
        ELSE 'More positive'
    END AS most_responses_sre,
    COUNT(*) as game_count
FROM merged
GROUP BY 1);

SELECT * FROM more_total_negative;


