/* ------------------------- PRIMARY KEY Məhdudiyyəti ------------------------- */
/* Bu hissədə PRIMARY KEY məhdudiyyəti ilə yeni bir cədvəl yaradılır. 
   - location_id: PRIMARY KEY olaraq təyin edilir (unikal və NULL olmayan dəyərlər). */

CREATE TABLE locations_demo (
    location_id    NUMBER(4) CONSTRAINT loc_id_pk PRIMARY KEY,
    street_address VARCHAR2(40),
    postal_code    VARCHAR2(12),
    city           VARCHAR2(30),
    state_province VARCHAR2(25),
    country_id     CHAR(2)
);

/* Cədvələ məlumat əlavə edilir. */

INSERT INTO locations_demo (location_id, street_address, postal_code, city, state_province, country_id)
VALUES (1001, 'Bakı küçəsi 1', 'AZ1000', 'Bakı', 'Bakı', 'AZ');

/* Alternativ olaraq, PRIMARY KEY ayrıca təyin edilir. */

CREATE TABLE locations_demo (
    location_id    NUMBER(4),
    street_address VARCHAR2(40),
    postal_code    VARCHAR2(12),
    city           VARCHAR2(30),
    state_province VARCHAR2(25),
    country_id     CHAR(2),
    CONSTRAINT loc_id_pk PRIMARY KEY (location_id)
);

/* Cədvələ məlumat əlavə edilir. */

INSERT INTO locations_demo (location_id, street_address, postal_code, city, state_province, country_id)
VALUES (1002, 'Gəncə küçəsi 2', 'AZ2000', 'Gəncə', 'Gəncə', 'AZ');

/* ------------------------- NOT NULL Məhdudiyyəti ------------------------- */
/* Bu hissədə country_id sütunu üçün NOT NULL məhdudiyyəti əlavə edilir. 
   - country_id: NULL ola bilməz. */

ALTER TABLE locations_demo
   MODIFY (country_id CONSTRAINT country_nn NOT NULL);

/* ------------------------- Kompozit PRIMARY KEY ------------------------- */
/* Bu hissədə kompozit PRIMARY KEY təyin edilir (bir neçə sütunu birləşdirən əsas açar). 
   - prod_id və cust_id sütunları birlikdə PRIMARY KEY təşkil edir. */

ALTER TABLE sales
    ADD CONSTRAINT sales_pk PRIMARY KEY (prod_id, cust_id) DISABLE;

/* Cədvələ məlumat əlavə edilir. */
INSERT INTO sales (prod_id, cust_id)
VALUES (101, 5001);

/* ------------------------- FOREIGN KEY Məhdudiyyəti ------------------------- */
/* Bu hissədə FOREIGN KEY məhdudiyyəti ilə yeni bir cədvəl yaradılır. 
   - department_id: departments cədvəlinin department_id sütununa istinad edir. */
CREATE TABLE dept_20 (
    employee_id     NUMBER(4),
    last_name       VARCHAR2(10),
    job_id          VARCHAR2(9),
    manager_id      NUMBER(4),
    hire_date       DATE,
    salary          NUMBER(7,2),
    commission_pct  NUMBER(7,2),
    department_id   CONSTRAINT fk_deptno REFERENCES departments(department_id)
);

/* Cədvələ məlumat əlavə edilir. */
INSERT INTO dept_20 (employee_id, last_name, job_id, department_id)
VALUES (1001, 'Məmmədov', 'DEV', 10);

/* Alternativ olaraq, FOREIGN KEY ayrıca təyin edilir. */
CREATE TABLE dept_20 (
    employee_id     NUMBER(4),
    last_name       VARCHAR2(10),
    job_id          VARCHAR2(9),
    manager_id      NUMBER(4),
    hire_date       DATE,
    salary          NUMBER(7,2),
    commission_pct  NUMBER(7,2),
    department_id   NUMBER(2),
    CONSTRAINT fk_deptno FOREIGN KEY (department_id) REFERENCES departments(department_id)
);

/* Cədvələ məlumat əlavə edilir. */
INSERT INTO dept_20 (employee_id, last_name, job_id, department_id)
VALUES (1002, 'Əliyev', 'HR', 20);

/* ------------------------- ON DELETE Məhdudiyyəti ------------------------- */
/* Bu hissədə ON DELETE məhdudiyyəti ilə yeni bir cədvəl yaradılır. 
   - manager_id: employees cədvəlində silinərsə, NULL olaraq təyin edilir.
   - department_id: departments cədvəlində silinərsə, bağlı sətrlər də silinir. */
CREATE TABLE dept_20 (
    employee_id     NUMBER(4) PRIMARY KEY,
    last_name       VARCHAR2(10),
    job_id          VARCHAR2(9),
    manager_id      NUMBER(4) CONSTRAINT fk_mgr REFERENCES employees ON DELETE SET NULL,
    hire_date       DATE,
    salary          NUMBER(7,2),
    commission_pct  NUMBER(7,2),
    department_id   NUMBER(2) CONSTRAINT fk_deptno REFERENCES departments(department_id) ON DELETE CASCADE
);

/* Cədvələ məlumat əlavə edilir. */
INSERT INTO dept_20 (employee_id, last_name, job_id, manager_id, department_id)
VALUES (1003, 'Quliyev', 'IT', 2332, 30);

/* ------------------------- Kompozit FOREIGN KEY ------------------------- */
/* Bu hissədə kompozit FOREIGN KEY təyin edilir. 
   - employee_id və hire_date sütunları birlikdə hr.job_history cədvəlinə istinad edir. */
ALTER TABLE dept_20
   ADD CONSTRAINT fk_empid_hiredate FOREIGN KEY (employee_id, hire_date)
   REFERENCES hr.job_history(employee_id, start_date)
   EXCEPTIONS INTO wrong_emp;

/* ------------------------- CHECK Məhdudiyyəti ------------------------- */
/* Bu hissədə CHECK məhdudiyyəti ilə yeni bir cədvəl yaradılır. 
   - div_no: 10 ilə 99 arasında olmalıdır.
   - div_name: Bütün hərflər böyük olmalıdır.
   - office: Sadəcə icazə verilən dəyərlər istifadə oluna bilər. */
CREATE TABLE divisions (
    div_no    NUMBER CONSTRAINT check_divno CHECK (div_no BETWEEN 10 AND 99) DISABLE,
    div_name  VARCHAR2(9) CONSTRAINT check_divname CHECK (div_name = UPPER(div_name)) DISABLE,
    office    VARCHAR2(10) CONSTRAINT check_office CHECK (office IN ('DALLAS', 'BOSTON', 'PARIS', 'TOKYO')) DISABLE
);

/* Cədvələ məlumat əlavə edilir. */
INSERT INTO divisions (div_no, div_name, office)
VALUES (20, 'MARKETING', 'BOSTON');

/* ------------------------- Əmək Haqqı üçün CHECK Məhdudiyyəti ------------------------- */
/* Bu hissədə əmək haqqı üçün CHECK məhdudiyyəti təyin edilir. 
   - salary * commission_pct <= 5000: Əmək haqqı hesablanması məhdudlaşdırılır. */
CREATE TABLE dept_20 (
    employee_id     NUMBER(4) PRIMARY KEY,
    last_name       VARCHAR2(10),
    job_id          VARCHAR2(9),
    manager_id      NUMBER(4),
    salary          NUMBER(7,2),
    commission_pct  NUMBER(7,2),
    department_id   NUMBER(2),
    CONSTRAINT check_sal CHECK (salary * commission_pct <= 5000)
);

/* Cədvələ məlumat əlavə edilir. */
INSERT INTO dept_20 (employee_id, last_name, job_id, salary, commission_pct)
VALUES (1004, 'Həsənov', 'SALES', 4000, 1.2);

/* ------------------------- TƏXİRƏ SALINA BİLƏN MƏHDUDİYYƏT ------------------------- */
/* Bu hissədə təxirə salına bilən CHECK məhdudiyyəti ilə yeni bir cədvəl yaradılır. 
   - scores: 0-dan böyük və ya bərabər olmalıdır. Şərt tranzaksiya sonuna qədər yoxlanılmaya bilər. */
CREATE TABLE games (
    scores NUMBER CHECK (scores >= 0) INITIALLY DEFERRED DEFERRABLE
);

/* Cədvələ məlumat əlavə edilir. */
INSERT INTO games (scores)
VALUES (10);