-------TO_CHAR/TRIM-----
--This example trims leading zeros from the hire date of the employees in the hr schema:
SELECT employee_id,
      TO_CHAR(hire_date),
      TO_CHAR(TRIM(LEADING 0 FROM hire_date))
      FROM employees
      WHERE department_id = 60
      ORDER BY employee_id;



---- TRUNC ----
SELECT TRUNC(TO_DATE('27-OCT-92','DD-MON-YY'), 'YEAR')
  "New Year" FROM DUAL;

-- New Year
-- ---------
-- 01-JAN-92


WITH dates AS (
  SELECT date'2015-01-01' d FROM dual union
  SELECT date'2015-01-10' d FROM dual union
  SELECT date'2015-02-01' d FROM dual union
  SELECT timestamp'2015-03-03 23:45:00' d FROM dual union
  SELECT timestamp'2015-04-11 12:34:56' d FROM dual
)
SELECT d "Original Date",
       trunc(d) "Nearest Day, Time Removed",
       trunc(d, 'ww') "Nearest Week",
       trunc(d, 'iw') "Start of Week",
       trunc(d, 'mm') "Start of Month",
       trunc(d, 'year') "Start of Year"
FROM dates;



SELECT TRUNC(15.79,1) "Truncate" FROM DUAL;

--   Truncate
-- ----------
--       15.7

SELECT TRUNC(15.79,-1) "Truncate" FROM DUAL;

--   Truncate
-- ----------
--         10

------UPPER-----
SELECT UPPER(last_name) "Uppercase"
   FROM employees;






