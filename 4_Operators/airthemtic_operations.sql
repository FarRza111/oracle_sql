--------------------------

SELECT
    to_char(hire_date,'YYYY'), EXTRACT(YEAR FROM hire_date)
  FROM hr.employees
  where (sysdate - hire_date) >= 365;


---------------------------
UPDATE employees
  SET salary = salary * 1.1;



----------------------------CONCATINATION----------------

CREATE TABLE tab1 (col1 VARCHAR2(6), col2 CHAR(6),
                   col3 VARCHAR2(6), col4 CHAR(6));

INSERT INTO tab1 (col1,  col2,     col3,     col4)
          VALUES ('abc', 'def   ', 'ghi   ', 'jkl');

SELECT col1 || col2 || col3 || col4 "Concatenation"
  FROM tab1;

-- Concatenation
-- ------------------------
-- abcdef   ghi   jkl



--------------------------SET----------------------------
-- iki və ya daha çox sorğunun nəticələrini birləşdirir və təkrar olunan sətirləri (duplicates) çıxarır.

SELECT first_name FROM hr.employees WHERE department_id = 10
UNION
SELECT first_name FROM hr.employees WHERE department_id = 10;



--  iki və ya daha çox sorğunun nəticələrini birləşdirir, lakin təkrar olunan sətirləri çıxarmır.
SELECT first_name FROM hr.employees WHERE department_id = 10
UNION ALL
SELECT first_name FROM hr.employees WHERE department_id = 10;



-------------------------INTERSECT------------------------
-- INTERSECT, iki sorğunun nəticələrində olan ortaq sətirləri qaytarır.

SELECT first_name FROM employees WHERE department_id = 10
INTERSECT
SELECT first_name FROM employees WHERE department_id = 20;


------------------------MINUS------------------------------
--MINUS, birinci sorğunun nəticəsində olan, lakin ikinci sorğunun nəticəsində olmayan sətirləri

SELECT first_name FROM employees WHERE department_id = 10
MINUS
SELECT first_name FROM employees WHERE department_id = 20;






