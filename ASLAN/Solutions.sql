WITH Analytic_Approach AS (

    SELECT
    *
 FROM (
SELECT
    concat(first_name, ' ', last_name) as fullName,
    department_id,
    e.salary,
    ROUND(AVG(salary) OVER (PARTITION BY department_id), 2) AS avg_sal
FROM hr.employees e

) A
 WHERE salary > avg_sal

),

    OurApproach AS (
    SELECT
        emp.salary,
        aggregate_avg.*,
        CONCAT(first_name, ' ' , last_name) full_name,
        CASE
            WHEN
            emp.salary > aggregate_avg.avg_sal
            then 1 else 0
        END as payment_tag
    FROM HR.EMPLOYEES emp

    LEFT JOIN
    (
        SELECT
            DEPARTMENT_ID,
            round(avg(salary),2) avg_sal
        FROM HR.EMPLOYEES
        group by DEPARTMENT_ID
    ) aggregate_avg

ON emp.DEPARTMENT_ID = aggregate_avg.department_id
WHERE
    salary > avg_sal
    ORDER BY Salary DESC
)



select count(*) Tab1_counts, 'T1' as validation  from  Analytic_Approach
UNION ALL
select count(*) Tab2_counts, 'T2' from  OurApproach;

-- SELECT
--     m1.*
-- FROM
-- OurApproach m1
--     LEFT JOIN Analytic_Approach m2  ON m1.department_id = m2.department_id;