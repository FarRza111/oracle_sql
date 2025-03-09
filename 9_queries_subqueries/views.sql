/*

 SQL-də view (görünüş) əsas cədvəldəki məlumatlara əsaslanan virtual cədvəldir.
 View özü məlumatları saxlamır, sadəcə SELECT sorğusunun nəticəsini göstərir.

                    View-lərin əsas üstünlükləri:

Məlumat təhlükəsizliyini artırır (müəyyən sütun və sətirlərə giriş məhdudlaşdırıla bilər).
Sorğuları sadələşdirir (mürəkkəb SQL sorğularını daha asan istifadə etməyə imkan verir).
Məlumat bütövlüyünü qoruyur (biznes qaydalarını tətbiq etməyə kömək edir).

                    İki əsas növü var:

Dəyişdirilə bilən view-lər (bəzi şərtlər ödənildikdə INSERT, UPDATE, DELETE icazəlidir).
Yalnız oxuna bilən view-lər (WITH READ ONLY istifadə edildikdə dəyişikliklərə icazə verilmir).


 */



CREATE VIEW emp_view AS
   SELECT last_name, salary*12 annual_salary
   FROM employees
   WHERE department_id = 20;


--------- READ ONLY -------

CREATE VIEW employee_ro (emp_id, name, department, salary)
AS SELECT employee_id, last_name, department_id, salary
FROM hr.employees
WITH READ ONLY;

/*error bcs it is read only access */
INSERT INTO employee_ro (emp_id, name, department, salary)
VALUES (105, 'Aliyev', 'HR', 4500);


/*
 Bu SQL sorğusu emp_sal adlı bir görünüş (view) yaradır və
 employees cədvəlindən müəyyən sütunları seçir. UNIQUE və PRIMARY KEY məhdudiyyətləri qeyd olunur,
 lakin icra olunmur (yalnız məntiqi olaraq tanınır).
 */


CREATE VIEW emp_sal (emp_id, last_name,
      email UNIQUE RELY DISABLE NOVALIDATE,
   CONSTRAINT id_pk PRIMARY KEY (emp_id) RELY DISABLE NOVALIDATE)
   AS SELECT employee_id, last_name, email FROM employees;

select * from emp_sal;


--------------------

CREATE VIEW clerk AS
   SELECT employee_id, last_name, department_id, job_id
   FROM employees
   WHERE job_id = 'PU_CLERK'
      or job_id = 'SH_CLERK'
      or job_id = 'ST_CLERK';

UPDATE clerk SET job_id = 'PU_MAN' WHERE employee_id = 118;

---------------------

------------------------ CONSTRAINT ----------------------
DROP view clerk;

CREATE VIEW clerk AS
   SELECT employee_id, last_name, department_id, job_id
   FROM employees
   WHERE job_id = 'PU_CLERK'
      or job_id = 'SH_CLERK'
      or job_id = 'ST_CLERK'
   WITH CHECK OPTION;

select * from clerk;
/*this will work*/
UPDATE clerk
SET job_id = 'SH_CLERK'
WHERE employee_id = 115;

/*this won't update anything*/
select * from clerk;
UPDATE clerk
SET job_id = 'IT_PROG'
WHERE employee_id = 101;



-----DUPLICATE_DELETE----

DELETE FROM employees
WHERE (employee_id, first_name, last_name) IN (
    SELECT employee_id, first_name, last_name
    FROM (
        SELECT
            employee_id,
            first_name,
            last_name,
            ROW_NUMBER() OVER (PARTITION BY employee_id, first_name, last_name ORDER BY employee_id) AS rn
        FROM employees
    )
    WHERE rn > 1
);
