/* ------------------------- HIERARCHY/LEAF/NODE ------------------------- */
/* Bu sorğu iyerarxik məlumatları (məsələn, işçilər və menecerlər) göstərir. 
   CONNECT_BY_ISLEAF sütunu ilə hər bir sətrin "leaf" (son) olub-olmadığı yoxlanılır. 
   LEVEL sütunu iyerarxiyanın səviyyəsini, SYS_CONNECT_BY_PATH isə hər bir işçinin iyerarxik yolunu göstərir. 
   START WITH employee_id = 100 ilə iyerarxiya 100 nömrəli işçidən başlayır. 
   CONNECT BY PRIOR employee_id = manager_id ilə menecer-işçi əlaqəsi qurulur. */
SELECT
       last_name "Employee", CONNECT_BY_ISLEAF "IsLeaf",
       LEVEL, SYS_CONNECT_BY_PATH(last_name, '/') "Path"
  FROM employees
  WHERE LEVEL <= 3 AND department_id = 80
  START WITH employee_id = 100
  CONNECT BY PRIOR employee_id = manager_id AND LEVEL <= 4
  ORDER BY "Employee", "IsLeaf";


/* Nəticə:
Employee                      IsLeaf      LEVEL Path
------------------------- ---------- ---------- -------------------------
Abel                               1          3 /King/Zlotkey/Abel
Ande                               1          3 /King/Errazuriz/Ande
Banda                              1          3 /King/Errazuriz/Banda
Bates                              1          3 /King/Cambrault/Bates
Bernstein                          1          3 /King/Russell/Bernstein
Bloom                              1          3 /King/Cambrault/Bloom
Cambrault                          0          2 /King/Cambrault
Cambrault                          1          3 /King/Russell/Cambrault
Doran                              1          3 /King/Partners/Doran
Errazuriz                          0          2 /King/Errazuriz
Fox                                1          3 /King/Cambrault/Fox
. . .
*/

/* ------------------------- Sequence ------------------------- */
/* Bu hissədə employees_seq adlı yeni bir sequence (ardıcıllıq) yaradılır. 
   Bu sequence 1-dən başlayır və hər dəfə 1 vahid artır. 
   NOCACHE seçimi ilə sequence dəyərləri cache edilmir. */


CREATE SEQUENCE employees_seq
	START WITH 1
	INCREMENT BY 1
	NOCACHE;

/* employees cədvəlinə yeni bir işçi əlavə edilir. 
   employees_seq.nextval ilə yeni işçi üçün unikal employee_id yaradılır. */
INSERT INTO employees
  VALUES (employees_seq.nextval, 'John', 'Doe', 'jdoe', '555-1212',
          TO_DATE(SYSDATE), 'PU_CLERK', 2500, null, null, 30);

/* Yeni əlavə edilən işçinin məlumatları seçilir. */
SELECT * FROM EMPLOYEES WHERE first_name = 'John';

/* ------------------------- XMLTABLE ------------------------- */
/* Bu sorğu XML məlumatlarını cədvəl formatına çevirir. 
   XMLTYPE ilə XML məlumatları yaradılır. 
   XMLTABLE funksiyası ilə XML məlumatları sütunlara ayrılır. */
SELECT *
FROM XMLTABLE(
    '/employees/employee'
    PASSING XMLTYPE(
        '<employees>
            <employee>
                <employee_id>101</employee_id>
                <name>
                    <first>John</first>
                    <last>Doe</last>
                </name>
                <hire_date>2023-10-01</hire_date>
            </employee>
        </employees>'
    )
    COLUMNS
        employee_id   NUMBER        PATH 'employee_id',
        first_name   VARCHAR2(50)  PATH 'name/first',
        last_name    VARCHAR2(50)  PATH 'name/last',
        hire_date    DATE          PATH 'hire_date'
);


/* Nəticə:
EMPLOYEE_ID FIRST_NAME LAST_NAME HIRE_DATE
----------- ---------- --------- ---------
        101 John       Doe       2023-10-01
*/

/* ------------------------- ROWNUM ------------------------- */
/* Bu sorğu ilə employees cədvəlindəki ilk 10 sətr seçilir. 
   ROWNUM ilə sətirlər nömrələnir və ROWNUM < 11 şərti ilə ilk 10 sətr göstərilir. */
SELECT *
  FROM employees
  WHERE ROWNUM < 11
  ORDER BY last_name;

/* Bu sorğu ilə maaşı ən aşağı olan 10 işçi seçilir. 
   Əvvəlcə sətirlər maaşa görə sıralanır, sonra ROWNUM ilə ilk 10 sətr göstərilir. */
SELECT SALARY, LAST_NAME
FROM (SELECT * FROM HR.EMPLOYEES ORDER BY SALARY ASC) WHERE ROWNUM < 11;

/* Nümunə 1: Ən yüksək maaş alan 5 işçinin ID və maaşını göstərir. 
   Əvvəlcə sətirlər maaşa görə azalan sıra ilə sıralanır, sonra ROWNUM ilə ilk 5 sətr seçilir. */
SELECT *
FROM (
    SELECT SALARY, EMPLOYEE_ID
    FROM hr.employees 
    ORDER BY SALARY DESC
) WHERE ROWNUM <= 5;

/* Nəticə:
SALARY EMPLOYEE_ID
------ -----------
  24000         100
  17000         101
  17000         102
  15000         103
  14000         104
*/