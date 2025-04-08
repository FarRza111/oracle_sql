
/* It's for calculating overall average of salary */

SELECT
    e.DEPARTMENT_ID, salary, (select avg(salary) from hr.EMPLOYEES) as avgSal
FROM hr.employees e 
    where salary > (select 
                        avg(salary) avgSal    
                    FROM
                    hr.EMPLOYEES e left join hr.departments d on e.DEPARTMENT_ID = e.DEPARTMENT_ID 
                    ) ;


/* It's for comparing the salary based on average of grouped department_id salary */

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
    ORDER BY Salary DESC;



/* Analytic Approach and Validation */



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



---------------------Retrieving Customers with Consecutive 2-Day Purchases Using Analytic Functions--------

--v1.

WITH T AS (


SELECT
   CASE
       WHEN prevDay IS NOT NULL
       THEN TRUNC(ORDER_TMS) - TRUNC(prevDay)
       ELSE NULL
   END AS days_since_last_purchase, z.*
FROM (
   SELECT
       LAG(ORDER_TMS) OVER (PARTITION BY customer_id ORDER BY ORDER_TMS) AS prevDay,
       o.*
   FROM co.orders o
) z


)


SELECT * FROM T WHERE days_since_last_purchase = 1;




--v2--
WITH orders_sequence AS (
select
   customer_id,
   ORDER_TMS AS normal_date,
   LAG(ORDER_TMS) OVER (PARTITION BY customer_id ORDER BY ORDER_TMS) AS prev_date,
   LEAD(ORDER_TMS) OVER (PARTITION BY customer_id ORDER BY ORDER_TMS) AS next_date
FROM co.orders )
   ,
   consectivie_flags AS (
       SELECT
           customer_id,
           normal_date,
           prev_date,
           CASE WHEN  TRUNC(normal_date) - TRUNC(prev_date) = 1 THEN 1 ELSE 0 END as is_consective_prev,
           CASE WHEN  TRUNC(next_date) - TRUNC(normal_date) = 1 THEN 1 ELSE 0 END AS is_consective_next
       FROM  orders_sequence


   )


SELECT
*
FROM
   consectivie_flags


where (is_consective_prev = 1
       -- or is_consective_next = 1
       );









