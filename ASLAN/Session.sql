------MoM - Month over Month Change


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



/*
0.Departamentlərin maaş statistikasını təhlil etmək, 50-dən az işçisi olan hər departamentdə ən yüksək maaş alan işçini müəyyən etmək, departamentləri orta maaşa görə sıralamaq,
onları maaş dərəcələrinə görə təsnif etmək və yalnız ilk 10 nəticəni qaytarmaq üçün CTE istifadə edən SQL sorğusu yazın, bu sorğuda join,
aqreqasiya, pəncərə funksiyaları, alt sorğular və şərti məntiq nümayiş etdirilməlidir

*/


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



------- Salary > Avg Salary


SELECT
   M.last_name || ' ' || M.First_name,
   salary,
   avg_salary
FROM (
SELECT
   e.*
FROM HR.EMPLOYEES E LEFT JOIN HR.DEPARTMENTS D ON E.DEPARTMENT_ID = D.DEPARTMENT_ID ) m
LEFT JOIN
   (
     SELECT
          DEPARTMENT_ID, ROUND(AVG(SALARY),1) avg_salary
     FROM HR.EMPLOYEES
     GROUP BY DEPARTMENT_ID
   ) avg_salary_tab


   ON M.department_id = avg_salary_tab.department_id
   WHERE
   1=1
   AND m.salary > avg_salary_tab.avg_salary;



-------First/Second Salary with 6 Month LookBack period---------


DECLARE

   v_sal_rank NUMBER := 2; -- istədiyin maas ranking buradan dəyişə bilərsən
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



 -------First/Second Salary with 6 Month LookBack period - traditional method with ampersand & (variable define)


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


--------Indexing method - YearMonthNumber, YearMonthSex


SELECT * FROM (


SELECT
   TO_CHAR(HIRE_DATE, 'MM') AS MONTH,
   TO_CHAR(HIRE_DATE, 'YYYY') AS YEAR ,
   EXTRACT(MONTH FROM HIRE_DATE) AS MONTHD,
   EXTRACT(YEAR FROM HIRE_DATE) * 100 + TO_CHAR(HIRE_DATE,'MM') AS YearMonthIndex,

   EXTRACT(YEAR FROM HIRE_DATE) * 12 + TO_CHAR(HIRE_DATE,'MM') - 1 AS YearMonthSequential,
   SALARY
FROM HR.EMPLOYEES
    )
    WHERE
    	YearMonthSequential = (
   		SELECT
    			MAX(TO_CHAR(hire_date, 'YYYY') * 12 + TO_CHAR(hire_date, 'MM') - 1) - 2
   		FROM
    		HR.EMPLOYEES

    )




----------------------------------------

  
SELECT 
    curr.employee_id,
    curr.first_name,
    curr.last_name,
    curr.salary AS current_salary,
    prev.salary AS previous_salary,
    curr.salary - prev.salary AS salary_increase,
    ROUND((curr.salary - prev.salary) / prev.salary * 100, 2) AS percent_increase,
    (SELECT AVG(salary) FROM employees) AS company_avg
FROM employees curr
JOIN (
    SELECT employee_id, salary 
    FROM employees 
    WHERE salary_date = (SELECT MAX(salary_date) FROM employees WHERE salary_date < SYSDATE)
) prev ON curr.employee_id = prev.employee_id
WHERE curr.salary_date = (SELECT MAX(salary_date) FROM employees)
ORDER BY percent_increase DESC;




------Which departments have more employees than the average department size, and what percentage of the total workforce do they represent?-----



WITH finalDf AS (
    SELECT  
        *
    FROM 
        (
        SELECT
             COUNT(employee_id) empCount, 
             DEPARTMENT_ID 
        FROM hr.employees 
        GROUP BY department_id
        ) emp_count_tab
    WHERE 
        empCount > 
        (
            SELECT AVG(emp_count) avgEmpCount 
            FROM (
                SELECT COUNT(*) emp_count 
                FROM hr.employees 
                GROUP BY department_id
            ) avg_dep
        ) 
)

SELECT 
    f.*,

    (SELECT COUNT(*) FROM hr.employees) AS total_employee_count,
     
    ROUND((empCount /  (SELECT COUNT(*) FROM hr.employees) * 100 ),2) as Proportion
FROM finalDf f;










