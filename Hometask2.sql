
use school_data_large;


SELECT
    s.name,
    s.gender,
    sc.math_score
FROM
    students s
JOIN student_scores sc 
    ON s.student_id = sc.student_id
JOIN student_attendance sa 
    ON s.student_id = sa.student_id
WHERE
    sa.status = 'Absent'
    AND sc.math_score > (
        SELECT AVG(sc_inner.math_score)
        FROM students s_inner
        JOIN student_scores sc_inner 
            ON s_inner.student_id = sc_inner.student_id
        WHERE
            s_inner.gender = s.gender 
    )
    Limit 20;
    
    
    
    
    select count(*) student_id
    from student_attendance
    
    