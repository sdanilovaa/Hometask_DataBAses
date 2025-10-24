 use school_data_large; 
create index status_index on student_attendance (status);
create index math_index on student_scores (math_score);
create index gender_index on students (gender);
   
   explain analyze
    with by_gender_average as (
    select s.gender,
    AVG(sc.math_score) as avg_math_score
    from students s
    join student_scores sc on s.student_id = sc.student_id
    group by s.gender
    )
    select 
    s.name,
    s.gender,
    sc.math_score, 
    g.avg_math_score
    from students s 
    join student_scores sc on s.student_id = sc.student_id
    join student_attendance a on s.student_id = a.student_id
    join by_gender_average g on s.gender = g.gender
    where a.status = 'Absent'
    and math_score > avg_math_score

    
    
    
    
    
    