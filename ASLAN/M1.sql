---------------------Indexing----------------------------------


SELECT * FROM (
    SELECT
        TO_CHAR(hire_date, 'D') AS day_of_week,
        TO_CHAR(hire_date, 'MM') AS month,
        TO_CHAR(hire_date, 'YYYY') AS year,
        EXTRACT(Day FROM hire_date) AS day,
        TO_CHAR(hire_date, 'YYYY') * 100 + TO_CHAR(hire_date, 'MM') AS yearMonthIndex,
        TO_CHAR(hire_date, 'YYYY') * 12 + TO_CHAR(hire_date, 'MM') - 1 AS YearMonthSequential
    FROM HR.EMPLOYEES
)
WHERE YearMonthSequential = (
    SELECT MAX(TO_CHAR(hire_date, 'YYYY') * 12 + TO_CHAR(hire_date, 'MM') - 1) - 1
    FROM HR.EMPLOYEES
);


SELECT MAX(hire_date) FROM HR.EMPLOYEES;




---------------- MonthOverMonth Delta -------------------------

SELECT
  DeltaTab.*, D.DEPARTMENT_NAME
FROM (
  SELECT
      A.*,
      -- (current_month_count - previous_month_count),
  current_month_count - NVL(previous_month_count, 0) as DeltaMonth,
  ((current_month_count - NVL(previous_month_count, 0 )) / NVL(previous_month_count,1)) * 100 AS  DelteChangePercentage
  FROM (
  SELECT
   DEPARTMENT_ID,
   TO_CHAR(hire_date, 'YYYY-MM') AS hire_month,
   COUNT(*) AS current_month_count,
   LAG(COUNT(*)) OVER (ORDER BY TO_CHAR(hire_date, 'YYYY-MM')) AS previous_month_count
  FROM HR.employees
  GROUP BY
  Hire_month,
  DEPARTMENT_ID
  ) A
) DeltaTab
LEFT JOIN HR.DEPARTMENTS D ON DeltaTab.department_id = D.DEPARTMENT_ID;



-----------------------

SELECT
  department_id,
  avg_sal,
  NrOfEmployees,
  RANK() OVER (ORDER BY avg_sal DESC) AS rankno
   ,CASE
      WHEN avg_sal > 10000 THEN 'High Paying'
      WHEN avg_sal >  5000 THEN 'Medium Paying'
      ELSE 'Unknown'
  END PaymentStatus


FROM (
SELECT
  DEPARTMENT_ID,
  ROUND(AVG(salary),2) avg_sal,
  COUNT(*) NrOfEmployees,
  MIN(salary) MinSal,
  MAX(salary) MaxSal
FROM HR.EMPLOYEES
GROUP BY DEPARTMENT_ID
HAVING COUNT(*) > 0
)
WHERE
   NrOfEmployees <= 50
FETCH FIRST 10 ROWS ONLY;



----------------------Highest Salary by YearMonth partition by-------------------


SELECT * FROM (
select
    department_id,
    extract(year from HIRE_DATE) * 100 + extract(month from hire_date) as yearMonth,
    salary,
    rank() over (partition by extract(year from HIRE_DATE) * 100 + extract(month from hire_date) order by salary desc) as rk
    FROM hr.employees
) A
    WHERE
        rk = 1;


--------------------- Highest Salary fro Last Six Month -------------------------



DECLARE

   v_sal_rank NUMBER := 2; -- istədiyin ayi buradan dəyişə bilərsən
   v_month NUMBER := 6 ;-- istədiyin ayi buradan dəyişə bilərsən

BEGIN
   FOR rec IN (
       SELECT *
       FROM (
           SELECT
               employee_id,
               first_name,
               last_name,
               salary,
               hire_date,
               EXTRACT(YEAR FROM hire_date) * 12 + TO_NUMBER(TO_CHAR(hire_date, 'MM')) - 1 AS hire_month_num,
               RANK() OVER (
                   PARTITION BY EXTRACT(YEAR FROM hire_date) * 12 + TO_NUMBER(TO_CHAR(hire_date, 'MM')) - 1
                   ORDER BY salary DESC
               ) AS sal_rank
           FROM hr.employees
           WHERE hire_date >= ADD_MONTHS((SELECT MAX(hire_date) FROM employees), - v_month)
       )
       WHERE sal_rank = v_sal_rank
       ORDER BY hire_month_num ASC
   ) LOOP
       DBMS_OUTPUT.PUT_LINE('Month: ' || rec.hire_month_num ||
                            ', Emp: ' || rec.employee_id ||
                            ', Name: ' || rec.first_name || ' ' || rec.last_name ||
                            ', Salary: ' || rec.salary);
   END LOOP;
END;
/





SELECT *
FROM (
   SELECT
       employee_id,
       first_name,
       last_name,
       salary,
       hire_date,
       EXTRACT(YEAR FROM hire_date) * 12 + TO_NUMBER(TO_CHAR(hire_date, 'MM')) - 1 AS hire_month_num,
       RANK() OVER (
           PARTITION BY EXTRACT(YEAR FROM hire_date) * 12 + TO_NUMBER(TO_CHAR(hire_date, 'MM')) - 1
           ORDER BY salary DESC
       ) AS sal_rank
   FROM employees
   WHERE hire_date >= ADD_MONTHS((SELECT MAX(hire_date) FROM employees), -&v_month)
)
WHERE sal_rank = &v_sal_rank
ORDER BY hire_month_num ASC;




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




-----Consequtive 2 days Orders---------


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





------ Which departments have more employees than the average department size, and what percentage of the total workforce do they represent? -----


WITH finalDf AS (
select  
    *
 from 
    (
    select
         count(employee_id) empCount, DEPARTMENT_ID 
    from hr.employees group by department_id
    ) emp_count_tab
    WHERE 
        empCount > 
    (
        select avg(emp_count) avgEmpCount 
        /* Yaxud bu formada manual average taba bileriy
         select sum(empCount) /12 
        from (
            select
                count(employee_id) empCount, 
                DEPARTMENT_ID 
            from hr.employees group by department_id)  */
        
        from (
        select count(*) emp_count from hr.employees group by department_id) avg_dep
        ) 
)

SELECT 
    f.*,

    ROUND((empcount / (select count(*) from hr.employees)) * 100,2) emp_prop
FROM finalDf f ;











