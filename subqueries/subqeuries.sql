/* ikisi eyni neticeni qaytarir amma biri scalar deyerle muqayise edir, correlated deyil */

/* Easy Examples for Aslan */


--v0
SELECT
    count(*)
FROM
HR.EMPLOYEES e
WHERE
SALARY >
    (
        SELECT avg(salary) from hr.EMPLOYEES
    )
;


--v1

SELECT
    count(*)
FROM
HR.employees e
WHERE
    salary >
    (
     select avg(salary)
     from hr.employees emp
     WHERE emp.DEPARTMENT_ID = e.DEPARTMENT_ID
)
;

--v1.1

SELECT
    count(*)
FROM hr.employees e
left join (select department_id, avg(salary) avg_sal from hr.EMPLOYEES group by department_id) e2 ON
e.DEPARTMENT_ID = e2.department_id
WHERE salary > e2.avg_sal;


-----

select count(*) from (
select 

	first_name, salary, (select count(*) from hr.employees) as count_, (select avg(salary) avg_ from hr.employees) as avg_sal
from hr.employees
)
    where salary > avg_sal;




--v1.2

WITH ct AS (
SELECT
    salary,
    first_name
    -- ,ROW_NUMBER() OVER (ORDER BY salary) AS row_num
FROM (
    SELECT
        *
        FROM hr.employees n ORDER BY salary DESC

        ) a
)
SELECT * FROM ct WHERE rownum <= 3;



-- 1. Korrelyasiya olunmuş alt sorğu nümunəsi
/* Bu sorğu hər bir işçinin maaşını onun şöbəsindəki orta maaşla müqayisə edir.
   Korrelyasiya olunmuş alt sorğu istifadə olunur, çünki hər bir sətir üçün
   müxtəlif şöbə üzrə orta hesablanmalıdır. */



SELECT e.first_name, e.last_name, e.salary
FROM employees e
WHERE e.salary > (
    SELECT AVG(salary)
    FROM employees
    WHERE department_id = e.department_id
);




-- derived Table

SELECT *
FROM (SELECT first_name, salary FROM employees WHERE salary > 5000) AS "high_salaried"

-- Where Clause

SELECT first_name
FROM employees
WHERE department_id IN (SELECT department_id FROM departments WHERE location_id>1500);

-- Having Clause

SELECT department_id, AVG(salary)
FROM employees
GROUP BY department_id
HAVING AVG(salary) > (SELECT AVG(salary) FROM employees);


-- Scalar SubQuery

SELECT first_name
FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees);


-- Column Subquery

SELECT first_name
FROM employees
WHERE department_id IN (SELECT department_id FROM departments WHERE location_id > 1500);


-- Single Row Subquery

SELECT first_name
FROM employees
WHERE salary = (SELECT MAX(salary) FROM employees);


-- Table Subquery 

SELECT first_name,last_name
FROM employees
WHERE department_id IN (SELECT department_id FROM departments);


-- Correlates Subquery 

/ * Depends on the outer query and is executed for each row processed by the outer query  */
SELECT first_name
FROM employees e1
WHERE salary > (SELECT AVG(salary) FROM employees e2 WHERE e1.department_id = e2.department_id);





-- correlated Subquery

SELECT 
  lastname,
  firstname,
  salary,
  (SELECT avg(salary)
    FROM employee e2
    WHERE e2.dep_id = e1.dep_id) AS avg_dept_salary
FROM employee e1


-- 2. Çoxsəviyyəli alt sorğular
/* Bu sorğu şirkətin ümumi orta maaşından çox orta maaş verən və
   5-dən çox işçisi olan şöbələri tapır. İç-içə alt sorğular istifadə olunub. */


SELECT d.department_name
FROM departments d
WHERE d.department_id IN (
    SELECT department_id
    FROM employees
    GROUP BY department_id
    HAVING AVG(salary) > (
        SELECT AVG(salary)
        FROM employees
    ) AND COUNT(*) >= 5
);


-- 3. NOT EXISTS istifadəsi
/* Son 6 ay ərzində heç bir layihəyə təyin edilməmiş işçiləri tapır.
   NOT EXISTS üsulu səmərəlidir, çünki bir uyğunluq tapdıqda dərhal dayanır. */

SELECT e.employee_id, e.first_name, e.last_name
FROM employees e
WHERE NOT EXISTS (
    SELECT 1
    FROM employee_projects ep
    JOIN projects p ON ep.project_id = p.project_id
    WHERE ep.employee_id = e.employee_id
    AND p.start_date >= ADD_MONTHS(SYSDATE, -6)
);

-- 4. FROM bölməsində alt sorğu
/* Hər işçinin maaşını onun şöbəsindəki ən yüksək maaşa nisbətini hesablayır.
   FROM hissəsində alt sorğu şöbə üzrə maksimum maaşları hesablamaq üçün istifadə olunub. */

SELECT e.employee_id, e.salary,
       e.salary / dept_max.max_salary AS salary_ratio
FROM employees e
JOIN (
    SELECT department_id, MAX(salary) AS max_salary
    FROM employees
    GROUP BY department_id
) dept_max ON e.department_id = dept_max.department_id;

-- 5. SELECT bölməsində skalyar alt sorğu
/* Hər şöbənin adını və həmin şöbədə ən çox maaş alan işçinin adını göstərir.
   SELECT ifadəsində skalyar alt sorğu istifadə olunub. */

SELECT d.department_name,
    (SELECT first_name || ' ' || last_name
     FROM employees
     WHERE department_id = d.department_id
     ORDER BY salary DESC
     FETCH FIRST 1 ROWS ONLY) AS highest_paid_employee
FROM departments d;

-- 6. Performans üçün alternativ yanaşma
/* Korrelyasiya olunmuş alt sorğu əvəzinə JOIN ilə alt sorğu istifadə edilib.
   Bu üsul daha yaxşı performans göstərə bilər, xüsusən böyük verilənlər bazalarında. */

SELECT e.first_name, e.last_name, e.salary
FROM employees e
JOIN (
    SELECT department_id, AVG(salary) AS avg_salary
    FROM employees
    GROUP BY department_id
) dept_avg ON e.department_id = dept_avg.department_id
WHERE e.salary > dept_avg.avg_salary;







