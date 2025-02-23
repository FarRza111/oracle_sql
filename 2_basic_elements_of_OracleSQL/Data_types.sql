SELECT TO_DATE('2009', 'YYYY')
  FROM DUAL;

-- TO_DATE('
-- ---------
-- 01-MAY-09



SELECT TO_CHAR(TO_DATE('01-01-2009', 'MM-DD-YYYY'),'J')
    FROM DUAL;
--
-- TO_CHAR
-- -------
-- 2454833


SELECT TO_DATE('29-FEB-2004', 'DD-MON-YYYY') + TO_YMINTERVAL('4-0')
  FROM DUAL;

-- TO_DATE('
-- ---------
-- 29-FEB-08


SELECT last_name, EXTRACT(YEAR FROM (SYSDATE - hire_date) YEAR TO MONTH)
       || ' years '
       || EXTRACT(MONTH FROM (SYSDATE - hire_date) YEAR TO MONTH)
       || ' months'  "Interval"
  FROM employees;

/*
LAST_NAME                 Interval
------------------------- --------------------
OConnell                  2 years 3 months
Grant                     1 years 9 months
Whalen                    6 years 1 months
Hartstein                 5 years 8 months
Fay                       4 years 2 months
Mavris                    7 years 4 months
Baer                      7 years 4 months
Higgins                   7 years 4 months
Gietz                     7 years 4 months
. . . */

SELECT order_id, EXTRACT(DAY FROM (SYSDATE - order_date) DAY TO SECOND)
       || ' days '
       || EXTRACT(HOUR FROM (SYSDATE - order_date) DAY TO SECOND)
       || ' hours' "Interval"
  FROM orders;

  /*ORDER_ID Interval
---------- --------------------
      2458 780 days 23 hours
      2397 685 days 22 hours
      2454 733 days 21 hours
      2354 447 days 20 hours
      2358 635 days 20 hours
      2381 508 days 18 hours
      2440 765 days 17 hours
      2357 1365 days 16 hours
      2394 602 days 15 hours
      2435 763 days 15 hours
. . .
*/


-- Oracle aşağıdakı ifadədə olduğu kimi rəqəmli ifadədə görünərsə, onu dolayısı ilə NUMBER məlumat növünə çevirir:
SELECT salary + '10', salary
  FROM employees;



SELECT 2 * 1.23, 3 * '2,34' FROM DUAL;

--     2*1.23   3*'2,34'
-- ---------- ----------
--       2,46       7,02


SELECT TO_CHAR(TO_DATE('27-OCT-98', 'DD-MON-RR'), 'YYYY') "Year" FROM DUAL;

-- Year
-- ----
-- 1998

SELECT TO_CHAR(TO_DATE('27-OCT-17', 'DD-MON-RR'), 'YYYY') "Year" FROM DUAL;

-- Year
-- ----
-- 2017


SELECT TO_CHAR(SYSDATE, 'fmDDTH') || ' of ' ||
       TO_CHAR(SYSDATE, 'fmMonth') || ', ' ||
       TO_CHAR(SYSDATE, 'YYYY') "Ides"
  FROM DUAL;

-- Ides
-- ------------------
-- 3RD of April, 2008


SELECT TO_CHAR(SYSDATE, 'DDTH') || ' of ' ||
   TO_CHAR(SYSDATE, 'Month') || ', ' ||
   TO_CHAR(SYSDATE, 'YYYY') "Ides"
  FROM DUAL;

-- Ides
-- -----------------------
-- 03RD of April    , 2008



SELECT TO_CHAR(SYSDATE, 'fmDay') || '''s Special' "Menu"
  FROM DUAL;

-- Menu
-- -----------------
-- Tuesday's Special


SELECT last_name employee, TO_CHAR(hire_date,'fmMonth DD, YYYY') hiredate, Hire_date "dddd"
  FROM employees
  WHERE department_id = 20;


--Updating Hunold with new date
UPDATE employees
SET hire_date = TO_DATE('2008 05 20','YYYY MM DD')
WHERE last_name = 'Hunold';

select * FROM (
select * from employees  WHERE last_name = 'Hunold'
UNION ALL
select * from hr.employees WHERE last_name = 'Hunold') M ;




TO_DATE('98-DEC-25 17:30','YY-MON-DD HH24:MI')

SELECT *
  FROM my_table
  WHERE datecol > TO_DATE('02-OCT-02', 'DD-MON-YY');





SELECT TIMESTAMP '2009-10-29 01:30:00' AT TIME ZONE 'US/Pacific'
  FROM DUAL;


