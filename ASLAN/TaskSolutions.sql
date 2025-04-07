
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

