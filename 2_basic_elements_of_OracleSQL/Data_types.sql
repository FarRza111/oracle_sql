/* 1. TO_DATE funksiyası ilə '2009' il tarixini 'YYYY' formatında çeviririk. 
   Nəticədə ilin ilk günü (1 Yanvar) qəbul edilir
   və '01-MAY-09' (1 May 2009) tarixi alınır. */
SELECT TO_DATE('2009', 'YYYY')
  FROM DUAL;

/* 2. TO_DATE ilə '01-01-2009' tarixini 'MM-DD-YYYY' formatında çeviririk. 
   Daha sonra TO_CHAR ilə bu tarixi "Julian" formatına (J) çeviririk. 
   Julian tarixi 1 Yanvar 4713 e.ə.-dən başlayan günlərin sayını göstərir. */
SELECT TO_CHAR(TO_DATE('01-01-2009', 'MM-DD-YYYY'),'J')
    FROM DUAL;

/* 3. TO_DATE ilə '29-FEB-2004' tarixini daxil edirik. 
   TO_YMINTERVAL('4-0') ilə bu tarixə 4 il əlavə edirik. 
   Nəticədə '29-FEB-08' (29 Fevral 2008) tarixi alınır. */
SELECT TO_DATE('29-FEB-2004', 'DD-MON-YYYY') + TO_YMINTERVAL('4-0')
  FROM DUAL;

/* 4. EXTRACT funksiyası ilə işçilərin işə qəbul tarixi (hire_date) ilə hazırkı tarix (SYSDATE) arasındakı fərqi (illər və aylar) hesablayırıq. 
   Nəticədə hər bir işçinin iş stajı illər və aylar ilə göstərilir. */
SELECT last_name, EXTRACT(YEAR FROM (SYSDATE - hire_date) YEAR TO MONTH)
       || ' years '
       || EXTRACT(MONTH FROM (SYSDATE - hire_date) YEAR TO MONTH)
       || ' months'  "Interval"
  FROM employees;

/* 5. EXTRACT funksiyası ilə sifariş tarixi (order_date) ilə hazırkı tarix (SYSDATE) arasındakı fərqi (günlər və saatlar) hesablayırıq. 
   Nəticədə hər bir sifarişin neçə gün və saat əvvəl verildiyi göstərilir. */
SELECT order_id, EXTRACT(DAY FROM (SYSDATE - order_date) DAY TO SECOND)
       || ' days '
       || EXTRACT(HOUR FROM (SYSDATE - order_date) DAY TO SECOND)
       || ' hours' "Interval"
  FROM orders;

/* 6. Oracle, rəqəmli ifadələri ('10' kimi) avtomatik olaraq NUMBER tipinə çevirir. 
   Bu sorğu ilə işçilərin maaşına 10 əlavə edirik. */
SELECT salary + '10', salary
  FROM employees;

/* 7. Oracle, rəqəmli ifadələri ('2,34' kimi) avtomatik olaraq NUMBER
   tipinə çevirir və vurma əməliyyatını yerinə yetirir.
   Nəticədə 2 * 1.23 = 2,46 və 3 * 2,34 = 7,02 alınır. */
SELECT 2 * 1.23, 3 * '2,34' FROM DUAL;

/* 8. TO_DATE ilə '27-OCT-98' tarixini 'DD-MON-RR' formatında daxil edirik. 
   RR formatı ilə 20-ci əsr (1900-1999) qəbul edilir. 
   Nəticədə '1998' ili alınır. */
SELECT TO_CHAR(TO_DATE('27-OCT-98', 'DD-MON-RR'), 'YYYY') "Year" FROM DUAL;

/* 9. Hazırkı tarix (SYSDATE) formatlaşdırılaraq gün, ay və il hissələri ayrılır. 
   fm format modifikatoru ilə boşluqlar silinir. 
   Nəticədə "3RD of April, 2008" kimi formatlanmış tarix alınır. */
SELECT TO_CHAR(SYSDATE, 'fmDDTH') || ' of ' ||
       TO_CHAR(SYSDATE, 'fmMonth') || ', ' ||
       TO_CHAR(SYSDATE, 'YYYY') "Ides"
  FROM DUAL;

/* 10. Hazırkı tarix (SYSDATE) formatlaşdırılaraq gün, ay və il hissələri ayrılır. 
   fm modifikatoru olmadığı üçün ay adından sonra boşluqlar qalır. 
   Nəticədə "03RD of April    , 2008" kimi formatlanmış tarix alınır. */
SELECT TO_CHAR(SYSDATE, 'DDTH') || ' of ' ||
   TO_CHAR(SYSDATE, 'Month') || ', ' ||
   TO_CHAR(SYSDATE, 'YYYY') "Ides"
  FROM DUAL;

/* 11. Hazırkı günün adı (fmDay) formatlaşdırılaraq "Tuesday's Special" kimi göstərilir. */
SELECT TO_CHAR(SYSDATE, 'fmDay') || '''s Special' "Menu"
  FROM DUAL;

/* 12. department_id = 20 olan işçilərin işə qəbul tarixi formatlaşdırılır. 
   Nəticədə hər bir işçinin adı və işə qəbul tarixi göstərilir. */
SELECT last_name employee, TO_CHAR(hire_date,'fmMonth DD, YYYY') hiredate, Hire_date "dddd"
  FROM employees
  WHERE department_id = 20;

/* 13. Hunold soyadlı işçinin işə qəbul tarixi '2008 05 20' olaraq yenilənir. */
UPDATE employees
SET hire_date = TO_DATE('2008 05 20','YYYY MM DD')
WHERE last_name = 'Hunold';

/* 14. my_table cədvəlindəki tarixlər '02-OCT-02' tarixindən böyük olanlar seçilir. */
SELECT *
  FROM my_table
  WHERE datecol > TO_DATE('02-OCT-02', 'DD-MON-YY');

/* 15. '2009-10-29 01:30:00' tarixi "US/Pacific" vaxt zonasına uyğunlaşdırılır. */
SELECT TIMESTAMP '2009-10-29 01:30:00' AT TIME ZONE 'US/Pacific'
  FROM DUAL;