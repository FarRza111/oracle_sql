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




