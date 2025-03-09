/* ------------------------- View (Görünüş) ------------------------- */
/*
   View (görünüş) əsas cədvəldəki məlumatlara əsaslanan virtual cədvəldir.
   View özü məlumatları saxlamır, sadəcə SELECT sorğusunun nəticəsini göstərir.
   View-lərin əsas üstünlükləri:
   - Məlumat təhlükəsizliyini artırır (müəyyən sütun və sətirlərə giriş məhdudlaşdırıla bilər).
   - Sorğuları sadələşdirir (mürəkkəb SQL sorğularını daha asan istifadə etməyə imkan verir).
   - Məlumat bütövlüyünü qoruyur (biznes qaydalarını tətbiq etməyə kömək edir).
*/

/*
   Bu hissədə `emp_view` adlı yeni bir view yaradılır.
   - `department_id = 20` olan işçilərin soyadı və illik maaşı göstərilir.
   - `salary * 12` ilə illik maaş hesablanır.
*/
CREATE VIEW emp_view AS
   SELECT last_name, salary * 12 AS annual_salary
   FROM employees
   WHERE department_id = 20;

/* Nəticə:
LAST_NAME   ANNUAL_SALARY
----------- -------------
Hartstein         144000
Fay                72000
*/

/* ------------------------- READ ONLY View ------------------------- */
/*
   Bu hissədə `employee_ro` adlı yalnız oxuna bilən view yaradılır.
   - `WITH READ ONLY`: View üzərində dəyişikliklərə icazə verilmir.
   - View yalnız `employee_id`, `last_name`, `department_id` və `salary` sütunlarını göstərir.
*/
CREATE VIEW employee_ro (emp_id, name, department, salary) AS
   SELECT employee_id, last_name, department_id, salary
   FROM hr.employees
   WITH READ ONLY;

/*
   Bu sorğu səhv verəcək, çünki view yalnız oxuna biləndir.
   - `INSERT` əməliyyatı icazə verilmir.
*/
INSERT INTO employee_ro (emp_id, name, department, salary)
VALUES (105, 'Aliyev', 'HR', 4500);

/* Nəticə:
ORA-42399: cannot perform a DML operation on a read-only view
*/

/* ------------------------- Mürəkkəb View ------------------------- */
/*
   Bu hissədə `emp_sal` adlı yeni bir view yaradılır.
   - `UNIQUE` və `PRIMARY KEY` məhdudiyyətləri qeyd olunur, lakin icra olunmur.
   - `RELY DISABLE NOVALIDATE`: Məhdudiyyətlər yalnız məntiqi olaraq tanınır.
*/
CREATE VIEW emp_sal (emp_id, last_name,
      email UNIQUE RELY DISABLE NOVALIDATE,
   CONSTRAINT id_pk PRIMARY KEY (emp_id) RELY DISABLE NOVALIDATE)
   AS SELECT employee_id, last_name, email FROM employees;

/* View sorğulanır. */
SELECT * FROM emp_sal;

/* Nəticə:
EMP_ID   LAST_NAME   EMAIL
-------  ----------  --------------------
100      King        SKING
101      Kochhar     NKOCHHAR
102      De Haan     LDEHAAN
...
*/

/* ------------------------- Dəyişdirilə Bilən View ------------------------- */
/*
   Bu hissədə `clerk` adlı yeni bir view yaradılır.
   - `job_id` 'PU_CLERK', 'SH_CLERK' və ya 'ST_CLERK' olan işçilər seçilir.
   - View dəyişdirilə bilər (INSERT, UPDATE, DELETE əməliyyatları icazə verilir).
*/
CREATE VIEW clerk AS
   SELECT employee_id, last_name, department_id, job_id
   FROM employees
   WHERE job_id = 'PU_CLERK'
      OR job_id = 'SH_CLERK'
      OR job_id = 'ST_CLERK';

/* View üzərində `UPDATE` əməliyyatı yerinə yetirilir. */
UPDATE clerk SET job_id = 'PU_MAN' WHERE employee_id = 118;

/* Nəticə:
1 row updated.
*/

/* ------------------------- WITH CHECK OPTION ------------------------- */
/*
   Bu hissədə `clerk` view-i yenidən yaradılır və `WITH CHECK OPTION` əlavə edilir.
   - `WITH CHECK OPTION`: View üzərində dəyişikliklər yalnız view-in şərtlərinə uyğun olarsa icazə verilir.
   - Məsələn, `job_id` yalnız 'PU_CLERK', 'SH_CLERK' və ya 'ST_CLERK' ola bilər.
*/
DROP VIEW clerk;

CREATE VIEW clerk AS
   SELECT employee_id, last_name, department_id, job_id
   FROM employees
   WHERE job_id = 'PU_CLERK'
      OR job_id = 'SH_CLERK'
      OR job_id = 'ST_CLERK'
   WITH CHECK OPTION;

/*
   Bu sorğu işləyəcək, çünki yeni `job_id` view-in şərtlərinə uyğundur.
   - `job_id` 'SH_CLERK' olaraq dəyişdirilir.
*/
UPDATE clerk
SET job_id = 'SH_CLERK'
WHERE employee_id = 115;

/* Nəticə:
1 row updated.
*/

/*
   Bu sorğu işləməyəcək, çünki yeni `job_id` view-in şərtlərinə uyğun deyil.
   - `job_id` 'IT_PROG' olaraq dəyişdirilməyə cəhd edilir.
*/
UPDATE clerk
SET job_id = 'IT_PROG'
WHERE employee_id = 101;

/* Nəticə:
ORA-01402: view WITH CHECK OPTION where-clause violation
*/

/* ------------------------- DUPLICATE_DELETE ------------------------- */
/*
   Bu hissədə `employees` cədvəlində təkrarlanan sətirlər silinir.
   - `ROW_NUMBER()` ilə hər bir sətrin nömrəsi təyin edilir.
   - `PARTITION BY employee_id, first_name, last_name`: Eyni məlumatları olan sətirlər qruplaşdırılır.
   - `rn > 1`: Təkrarlanan sətirlər silinir.
*/
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

/* Nəticə:
Təkrarlanan sətirlər silinir.
*/