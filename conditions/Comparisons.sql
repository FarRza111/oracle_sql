-------------ANY()--------------

SELECT * FROM employees
  WHERE salary = ANY
  (SELECT salary
   FROM employees
  WHERE department_id = 30)
  ORDER BY employee_id;


-------------ALL()--------------



SELECT * FROM employees
  WHERE salary >=
  ALL (1400, 3000)
  ORDER BY employee_id;



-------------NOT-----------------


SELECT *
  FROM employees
  WHERE NOT (job_id IS NULL)
  ORDER BY employee_id;
SELECT *
  FROM employees
  WHERE NOT
  (salary BETWEEN 1000 AND 2000)
  ORDER BY employee_id;



-------------TO_DATE()-------------

SELECT * FROM employees
WHERE hire_date < TO_DATE('01-JAN-2004', 'DD-MON-YYYY')
  AND salary > 2500
  ORDER BY employee_id;


-------------LIKE-----------------

SELECT salary
    FROM employees
    WHERE last_name LIKE 'R%'
    ORDER BY salary;

---------------------____REG_EXP________________________---------


SELECT first_name, last_name
FROM employees
WHERE REGEXP_LIKE (first_name, '^Ste(v|ph)en$')
ORDER BY first_name, last_name;


SELECT last_name
FROM employees
WHERE REGEXP_LIKE (last_name, '([aeiou])\1', 'i') --doube vowels in their last name
ORDER BY last_name;

-- LAST_NAME
-- -------------------------
-- De Haan
-- Greenberg
-- Khoo
-- Gee
-- Greene
-- Lee
-- Bloom
-- Feeney;


