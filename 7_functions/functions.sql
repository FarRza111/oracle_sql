/* ------------------------- TO_CHAR və TRIM Funksiyaları ------------------------- */
/* Bu sorğu ilə işçilərin işə qəbul tarixindən (hire_date) əvvəlki sıfırlar silinir. 
   - TO_CHAR(hire_date): Tarixi mətn formatına çevirir.
   - TRIM(LEADING 0 FROM hire_date): Tarixdən əvvəlki sıfırları silir. */

SELECT employee_id,
      TO_CHAR(hire_date),
      TO_CHAR(TRIM(LEADING 0 FROM hire_date))
      FROM employees
      WHERE department_id = 60
      ORDER BY employee_id;

/* Nəticə:
EMPLOYEE_ID TO_CHAR(HIRE_DATE) TO_CHAR(TRIM(LEADING0FROMHIRE_DATE))
----------- ------------------ -------------------------------------
        103 07-JUN-94          7-JUN-94
        104 21-MAY-95          21-MAY-95
        105 25-JUN-97          25-JUN-97
        106 05-FEB-98          5-FEB-98
        107 07-FEB-99          7-FEB-99
*/

/* ------------------------- TRUNC Funksiyası (Tarix) ------------------------- */
/* Bu sorğu ilə tarixin ilin başlanğıcına qədər hissəsi kəsilir. 
   - TRUNC(TO_DATE('27-OCT-92','DD-MON-YY'), 'YEAR'): Tarixi ilin başlanğıcına qədər kəsir. */
SELECT TRUNC(TO_DATE('27-OCT-92','DD-MON-YY'), 'YEAR') "New Year" FROM DUAL;

/* Nəticə:
New Year
---------
01-JAN-92
*/

/* Bu sorğu ilə müxtəlif tarixlər üzərində TRUNC funksiyasının müxtəlif variantları tətbiq edilir. 
   - trunc(d): Tarixdən vaxt hissəsini silir.
   - trunc(d, 'ww'): Həftənin başlanğıcına qədər kəsir.
   - trunc(d, 'iw'): Həftənin ilk gününə qədər kəsir.
   - trunc(d, 'mm'): Ayın başlanğıcına qədər kəsir.
   - trunc(d, 'year'): İlin başlanğıcına qədər kəsir. */

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

/* Nəticə:
Original Date         Nearest Day, Time Removed Nearest Week Start of Week Start of Month Start of Year
--------------------- ------------------------- ------------ ------------- -------------- -------------
01-JAN-15            01-JAN-15                 29-DEC-14    29-DEC-14     01-JAN-15      01-JAN-15
10-JAN-15            10-JAN-15                 08-JAN-15    05-JAN-15      01-JAN-15      01-JAN-15
01-FEB-15            01-FEB-15                 29-JAN-15    02-FEB-15      01-FEB-15      01-JAN-15
03-MAR-15 23:45:00   03-MAR-15                 26-FEB-15    02-MAR-15      01-MAR-15      01-JAN-15
11-APR-15 12:34:56   11-APR-15                 09-APR-15    06-APR-15      01-APR-15      01-JAN-15
*/

/* ------------------------- TRUNC Funksiyası (Rəqəm) ------------------------- */
/* Bu sorğu ilə rəqəmin onluq hissəsi kəsilir. 
   - TRUNC(15.79, 1): Rəqəmi 1 onluq yerə qədər kəsir. */
SELECT TRUNC(15.79,1) "Truncate" FROM DUAL;

/* Nəticə:
Truncate
---------
     15.7
*/

/* Bu sorğu ilə rəqəmin tam hissəsi kəsilir. 
   - TRUNC(15.79, -1): Rəqəmi 10-luğa qədər kəsir. */
SELECT TRUNC(15.79,-1) "Truncate" FROM DUAL;

/* Nəticə:
Truncate
---------
       10
*/

/* ------------------------- UPPER Funksiyası ------------------------- */
/* Bu sorğu ilə işçilərin soyadları böyük hərflərə çevrilir. 
   - UPPER(last_name): Soyadı böyük hərflərə çevirir. */
SELECT UPPER(last_name) "Uppercase"
   FROM employees;

/* Nəticə:
Uppercase
---------
KING
KOCHHAR
DE HAAN
HUNOLD
ERNST
...
*/