/* ------------------------- FETCH FIRST n ROWS ONLY ------------------------- */
/* Bu sorğu ilə employees cədvəlindəki ilk 5 sətr seçilir. 
   - ORDER BY employee_id: Sətirlər employee_id sütununa görə sıralanır.
   - FETCH FIRST 5 ROWS ONLY: İlk 5 sətr seçilir. */

SELECT employee_id, last_name
  FROM employees
  ORDER BY employee_id
  FETCH FIRST 5 ROWS ONLY;

/* Nəticə:
EMPLOYEE_ID LAST_NAME
----------- ---------
        100 King
        101 Kochhar
        102 De Haan
        103 Hunold
        104 Ernst
*/

/* ------------------------- OFFSET və FETCH ------------------------- */
/* Bu sorğu ilə employees cədvəlindəki 6-cı sətirdən başlayaraq növbəti 5 sətr seçilir. 
   - ORDER BY employee_id: Sətirlər employee_id sütununa görə sıralanır.
   - OFFSET 5 ROWS: İlk 5 sətr atlanır.
   - FETCH NEXT 5 ROWS ONLY: Növbəti 5 sətr seçilir. */

SELECT employee_id, last_name
  FROM employees
  ORDER BY employee_id
  OFFSET 5 ROWS FETCH NEXT 5 ROWS ONLY;

/* Nəticə:
EMPLOYEE_ID LAST_NAME
----------- ---------
        105 Austin
        106 Pataballa
        107 Lorentz
        108 Greenberg
        109 Faviet
*/

/* ------------------------- FETCH FIRST n PERCENT ROWS WITH TIES ------------------------- */
/* Bu sorğu ilə employees cədvəlindəki maaşları ən aşağı olan ilk 5% işçilər seçilir. 
   - ORDER BY salary: Sətirlər salary sütununa görə sıralanır.
   - FETCH FIRST 5 PERCENT ROWS WITH TIES: İlk 5% sətr seçilir. 
     WITH TIES seçimi ilə eyni maaşa malik olan işçilər də daxil edilir. */

SELECT employee_id, last_name, salary
  FROM employees
  ORDER BY salary
  FETCH FIRST 5 PERCENT ROWS WITH TIES;

/* Nəticə:
EMPLOYEE_ID LAST_NAME SALARY
----------- --------- ------
        132 Olson      2100
        128 Markle     2200
        136 Philtanker 2200
*/

/* ------------------------- IN Operatoru ilə Çoxlu Şərt ------------------------- */
/* Bu sorğu ilə employees cədvəlindəki müəyyən işçilər seçilir. 
   - IN operatoru ilə bir neçə şərt təyin edilir. 
   - Hər bir şərt (first_name, last_name, email) kombinasiyası ilə müqayisə edilir. */

SELECT * FROM hr.employees
  WHERE (first_name, last_name, email) IN
  (('Guy', 'Himuro', 'GHIMURO'),('Karen', 'Colmenares', 'KCOLMENA'));

/* Nəticə:
EMPLOYEE_ID FIRST_NAME LAST_NAME  EMAIL      PHONE_NUMBER  HIRE_DATE JOB_ID     SALARY COMMISSION_PCT MANAGER_ID DEPARTMENT_ID
----------- ---------- ---------- ---------- ------------ --------- ---------- ------ -------------- ---------- -------------
        132 Guy        Himuro     GHIMURO    515.127.4565  10-AUG-07 PU_CLERK   2600  0.1            124        50
        134 Karen      Colmenares KCOLMENA   515.127.4566  10-AUG-07 PU_CLERK   2500  0.1            124        50
*/