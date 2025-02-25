-------------------------------- HIERARCHY/LEAF/NODE--------------------------------

SELECT last_name "Employee", CONNECT_BY_ISLEAF "IsLeaf",
       LEVEL, SYS_CONNECT_BY_PATH(last_name, '/') "Path"
  FROM employees
  WHERE LEVEL <= 3 AND department_id = 80
  START WITH employee_id = 100
  CONNECT BY PRIOR employee_id = manager_id AND LEVEL <= 4
  ORDER BY "Employee", "IsLeaf";

-- Employee                      IsLeaf      LEVEL Path
-- ------------------------- ---------- ---------- -------------------------
-- Abel                               1          3 /King/Zlotkey/Abel
-- Ande                               1          3 /King/Errazuriz/Ande
-- Banda                              1          3 /King/Errazuriz/Banda
-- Bates                              1          3 /King/Cambrault/Bates
-- Bernstein                          1          3 /King/Russell/Bernstein
-- Bloom                              1          3 /King/Cambrault/Bloom
-- Cambrault                          0          2 /King/Cambrault
-- Cambrault                          1          3 /King/Russell/Cambrault
-- Doran                              1          3 /King/Partners/Doran
-- Errazuriz                          0          2 /King/Errazuriz
-- Fox                                1          3 /King/Cambrault/Fox
-- . . .


------------------------- Sequence ------------------

CREATE SEQUENCE employees_seq
	START WITH 1
	INCREMENT BY 1
	NOCACHE

;

INSERT INTO employees
  VALUES (employees_seq.nextval, 'John', 'Doe', 'jdoe', '555-1212',
          TO_DATE(SYSDATE), 'PU_CLERK', 2500, null, null, 30);

SELECT * FROM EMPLOYEES WHERE first_name = 'John';


------------------------------XMLTABLE-------------------------

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



-----------------------------ROWNUM-----------------------

SELECT *
  FROM employees
  WHERE ROWNUM < 11
  ORDER BY last_name;


SELECT SALARY, LAST_NAME
FROM (select * FROM HR.EMPLOYEES ORDER BY SALARY ASC ) WHERE ROWNUM < 11; --SALARY ilkin olaraq descending order, sonra rownum

--ex.1: 5 maximum maas alan iscinin id ve maasini goster

SELECT
*
FROM (
SELECT
    SALARY, EMPLOYEE_ID
FROM hr.employees ORDER BY SALARY DESC) WHERE ROWNUM <= 5;


----------------------------