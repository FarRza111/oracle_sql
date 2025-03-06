SELECT AVG(salary) "Average"
  FROM employees;

--        Average
-- --------------
--     6461.83178
--


/*
Bu sorğu, hər bir menecerin tabeliyində olan işçilərin maaşlarının hərəkətli ortalamasını (moving average) hesablayır.
Hər işçi üçün əvvəlki, cari və növbəti işçinin maaşlarının ortalaması alınır.
PARTITION BY manager_id işçiləri menecerə görə qruplaşdırır,
ORDER BY hire_date işçiləri işə qəbul tarixinə görə sıralayır və ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING
hər bir işçi üçün əvvəlki və sonrakı maaş dəyərlərini nəzərə alır.
Bu metod, maaş tendensiyalarını izləmək üçün istifadə olunur. 🚀

*/

SELECT manager_id, last_name, hire_date, salary,
       AVG(salary) OVER (PARTITION BY manager_id ORDER BY hire_date
  ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) AS c_mavg
  FROM hr.employees
  ORDER BY manager_id, hire_date, salary;



SELECT COUNT(*) "Total"
  FROM employees;

     Total
----------
       107

SELECT COUNT(*) "Allstars"
  FROM employees
  WHERE commission_pct > 0;

 Allstars
---------
       35

SELECT COUNT(commission_pct) "Count"
  FROM employees;

     Count
----------
        35

SELECT COUNT(DISTINCT manager_id) "Managers"
  FROM employees;

  Managers
----------
        18

--------------------- COUNT/RANGE BWETWEEN----------------------
SELECT last_name, salary,
       COUNT(*) OVER (ORDER BY salary RANGE BETWEEN 50 PRECEDING AND
                      150 FOLLOWING) AS mov_count
  FROM employees
  ORDER BY salary, last_name;

LAST_NAME                     SALARY  MOV_COUNT
------------------------- ---------- ----------
Olson                           2100          3
Markle                          2200          2
Philtanker                      2200          2
Gee                             2400          8
Landry                          2400          8
Colmenares                      2500         10
Marlow                          2500         10
Patel                           2500         10
. . .



-------------SAME---------
select employee_id, any_value(department_id) as dptid, sum(salary) from hr.employees group by employee_id;

select employee_id,  department_id as dptid, sum(salary) from hr.employees group by employee_id,  department_id;


-------------ADD_MONTHs---------

SELECT TO_CHAR(ADD_MONTHS(hire_date, 1), 'DD-MON-YYYY') "Next month"
  FROM employees
  WHERE last_name = 'Baer';

-- Next Month
-- -----------
-- 07-JUL-2002
--



-------------COALESCE-------------
COALESCE(expr1, expr2)
CASE WHEN expr1 IS NOT NULL THEN expr1 ELSE expr2 END



SELECT product_id, list_price, min_price,
       COALESCE(0.9*list_price, min_price, 5) "Sale"
  FROM product_information
  WHERE supplier_id = 102050
  ORDER BY product_id;

-- PRODUCT_ID LIST_PRICE  MIN_PRICE       Sale
-- ---------- ---------- ---------- ----------
--       1769         48                  43.2
--       1770                    73         73
--       2378        305        247      274.5
--       2382        850        731        765
--       3355                                5


