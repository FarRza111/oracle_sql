/* ------------------------- Tarix Funksiyaları ------------------------- */
/* Bu sorğu ilə işə qəbul tarixi (hire_date) iki fərqli formata çevrilir: 
   - to_char(hire_date, 'YYYY'): Tarixi 'YYYY' formatında (4 rəqəmli il) çevirir.
   - EXTRACT(YEAR FROM hire_date): Tarixdən ili çıxarır.
   Şərt: İşə qəbul tarixi ilə hazırkı tarix (SYSDATE) arasındakı fərq 365 gündən çox olmalıdır. */

SELECT
    to_char(hire_date,'YYYY'), EXTRACT(YEAR FROM hire_date)
  FROM hr.employees
  WHERE (sysdate - hire_date) >= 365;


/* Nəticə:
TO_CHAR(HIRE_DATE,'YYYY') EXTRACT(YEARFROMHIRE_DATE)
------------------------- -------------------------
2003                     2003
2005                     2005
2006                     2006
...
*/

/* ------------------------- UPDATE İlə Maaş Artımı ------------------------- */
/* Bu sorğu ilə employees cədvəlindəki bütün işçilərin maaşı 10% artırılır. 
   salary * 1.1 ifadəsi ilə hər bir işçinin maaşı 1.1 dəfə artırılır. */
UPDATE employees
  SET salary = salary * 1.1;

/* Nəticə: 
   Bütün işçilərin maaşı 10% artırılır. 
   Məsələn, əgər bir işçinin maaşı 1000 idisə, indi 1100 olacaq.
*/

/* ------------------------- CONCATINATION (Birləşdirmə) ------------------------- */
/* Bu hissədə tab1 adlı yeni bir cədvəl yaradılır və sütunlara məlumatlar əlavə edilir. 
   col1, col2, col3, və col4 sütunları birləşdirilərək "Concatenation" adlı yeni bir sütun yaradılır. */
CREATE TABLE tab1 (col1 VARCHAR2(6), col2 CHAR(6),
                   col3 VARCHAR2(6), col4 CHAR(6));

INSERT INTO tab1 (col1,  col2,     col3,     col4)
          VALUES ('abc', 'def   ', 'ghi   ', 'jkl');

SELECT col1 || col2 || col3 || col4 "Concatenation"
  FROM tab1;

/* Nəticə:
Concatenation
-----------------------
abcdef   ghi   jkl
*/

/* ------------------------- SET Operatorları ------------------------- */
/* UNION: İki və ya daha çox sorğunun nəticələrini birləşdirir və təkrar olunan sətirləri (duplicates) çıxarır. */
SELECT first_name FROM hr.employees WHERE department_id = 10
UNION
SELECT first_name FROM hr.employees WHERE department_id = 10;

/* Nəticə:
FIRST_NAME
----------
Jennifer
...
*/

/* UNION ALL: İki və ya daha çox sorğunun nəticələrini birləşdirir, lakin təkrar olunan sətirləri çıxarmır. */
SELECT first_name FROM hr.employees WHERE department_id = 10
UNION ALL
SELECT first_name FROM hr.employees WHERE department_id = 10;

/* Nəticə:
FIRST_NAME
----------
Jennifer
Jennifer
...
*/

/* INTERSECT: İki sorğunun nəticələrində olan ortaq sətirləri qaytarır. */
SELECT first_name FROM employees WHERE department_id = 10
INTERSECT
SELECT first_name FROM employees WHERE department_id = 20;

/* Nəticə:
FIRST_NAME
----------
(Heç bir ortaq sətir olmadığı üçün nəticə boş olacaq)
*/

/* MINUS: Birinci sorğunun nəticəsində olan, lakin ikinci sorğunun nəticəsində olmayan sətirləri qaytarır. */
SELECT first_name FROM employees WHERE department_id = 10
MINUS
SELECT first_name FROM employees WHERE department_id = 20;

/* Nəticə:
FIRST_NAME
----------
Jennifer
...
*/