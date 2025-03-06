-- PRIMARY KEY məhdudiyyəti ilə cədvəl yaratmaq
CREATE TABLE locations_demo (
    location_id    NUMBER(4) CONSTRAINT loc_id_pk PRIMARY KEY, -- Unikal və NULL olmayan dəyərləri təmin edir
    street_address VARCHAR2(40),
    postal_code    VARCHAR2(12),
    city           VARCHAR2(30),
    state_province VARCHAR2(25),
    country_id     CHAR(2)
);

INSERT INTO locations_demo (location_id, street_address, postal_code, city, state_province, country_id)
VALUES (1001, 'Bakı küçəsi 1', 'AZ1000', 'Bakı', 'Bakı', 'AZ');

-- Alternativ olaraq, PRIMARY KEY ayrıca təyin edilir
CREATE TABLE locations_demo (
    location_id    NUMBER(4),
    street_address VARCHAR2(40),
    postal_code    VARCHAR2(12),
    city           VARCHAR2(30),
    state_province VARCHAR2(25),
    country_id     CHAR(2),
    CONSTRAINT loc_id_pk PRIMARY KEY (location_id) -- PRIMARY KEY unikal və NULL olmayan dəyərləri təmin edir
);

INSERT INTO locations_demo (location_id, street_address, postal_code, city, state_province, country_id)
VALUES (1002, 'Gəncə küçəsi 2', 'AZ2000', 'Gəncə', 'Gəncə', 'AZ');

-- NOT NULL məhdudiyyəti əlavə etmək
ALTER TABLE locations_demo
   MODIFY (country_id CONSTRAINT country_nn NOT NULL); -- country_id NULL ola bilməz

-- Kompozit PRIMARY KEY nümunəsi (bir neçə sütunu birləşdirən əsas açar)
ALTER TABLE sales
    ADD CONSTRAINT sales_pk PRIMARY KEY (prod_id, cust_id) DISABLE; -- Standart olaraq deaktiv edilmişdir

INSERT INTO sales (prod_id, cust_id)
VALUES (101, 5001);

-- XARİCİ AÇAR (FOREIGN KEY) məhdudiyyəti nümunəsi
CREATE TABLE dept_20 (
    employee_id     NUMBER(4),
    last_name       VARCHAR2(10),
    job_id          VARCHAR2(9),
    manager_id      NUMBER(4),
    hire_date       DATE,
    salary          NUMBER(7,2),
    commission_pct  NUMBER(7,2),
    department_id   CONSTRAINT fk_deptno REFERENCES departments(department_id) -- departments cədvəlinə istinad edir
);

INSERT INTO dept_20 (employee_id, last_name, job_id, department_id)
VALUES (1001, 'Məmmədov', 'DEV', 10);

-- Xarici açarın ayrıca təyin edilməsi
CREATE TABLE dept_20 (
    employee_id     NUMBER(4),
    last_name       VARCHAR2(10),
    job_id          VARCHAR2(9),
    manager_id      NUMBER(4),
    hire_date       DATE,
    salary          NUMBER(7,2),
    commission_pct  NUMBER(7,2),
    department_id   NUMBER(2),
    CONSTRAINT fk_deptno FOREIGN KEY (department_id) REFERENCES departments(department_id) -- Xarici açar istinad edir
);

INSERT INTO dept_20 (employee_id, last_name, job_id, department_id)
VALUES (1002, 'Əliyev', 'HR', 20);

-- ON DELETE nümunəsi (üst cədvəldə silmə əməliyyatı)
CREATE TABLE dept_20 (
    employee_id     NUMBER(4) PRIMARY KEY, -- Cədvəlin əsas açarı
    last_name       VARCHAR2(10),
    job_id          VARCHAR2(9),
    manager_id      NUMBER(4) CONSTRAINT fk_mgr REFERENCES employees ON DELETE SET NULL, -- Əgər menecer silinərsə, NULL olaraq təyin edilir
    hire_date       DATE,
    salary          NUMBER(7,2),
    commission_pct  NUMBER(7,2),
    department_id   NUMBER(2) CONSTRAINT fk_deptno REFERENCES departments(department_id) ON DELETE CASCADE -- Ana cədvəldə silindikdə, bağlı sətrlər də silinir
);

INSERT INTO dept_20 (employee_id, last_name, job_id, manager_id, department_id)
VALUES (1003, 'Quliyev', 'IT', 2332, 30);

-- Kompozit FOREIGN KEY nümunəsi
ALTER TABLE dept_20
   ADD CONSTRAINT fk_empid_hiredate FOREIGN KEY (employee_id, hire_date)
   REFERENCES hr.job_history(employee_id, start_date)
   EXCEPTIONS INTO wrong_emp; -- Yanlış məlumatları idarə edir

-- CHECK məhdudiyyəti nümunəsi (dəyərlərin doğruluğunu yoxlayır)
CREATE TABLE divisions (
    div_no    NUMBER CONSTRAINT check_divno CHECK (div_no BETWEEN 10 AND 99) DISABLE, -- div_no 10 ilə 99 arasında olmalıdır
    div_name  VARCHAR2(9) CONSTRAINT check_divname CHECK (div_name = UPPER(div_name)) DISABLE, -- Bütün hərflər böyük olmalıdır
    office    VARCHAR2(10) CONSTRAINT check_office CHECK (office IN ('DALLAS', 'BOSTON', 'PARIS', 'TOKYO')) DISABLE -- Sadəcə icazə verilən dəyərlər istifadə oluna bilər
);

INSERT INTO divisions (div_no, div_name, office)
VALUES (20, 'MARKETING', 'BOSTON');

-- Əmək haqqı üçün CHECK məhdudiyyəti
CREATE TABLE dept_20 (
    employee_id     NUMBER(4) PRIMARY KEY,
    last_name       VARCHAR2(10),
    job_id          VARCHAR2(9),
    manager_id      NUMBER(4),
    salary          NUMBER(7,2),
    commission_pct  NUMBER(7,2),
    department_id   NUMBER(2),
    CONSTRAINT check_sal CHECK (salary * commission_pct <= 5000) -- Əmək haqqı hesablanması məhdudlaşdırılır
);

INSERT INTO dept_20 (employee_id, last_name, job_id, salary, commission_pct)
VALUES (1004, 'Həsənov', 'SALES', 4000, 1.2);

-- TƏXİRƏ SALINA BİLƏN MƏHDUDİYYƏT nümunəsi (Şərtlər tranzaksiya sonuna qədər yoxlanılmaya bilər)
CREATE TABLE games (
    scores NUMBER CHECK (scores >= 0) INITIALLY DEFERRED DEFERRABLE -- Şərt sonradan yoxlanıla bilər
);

INSERT INTO games (scores)
VALUES (10);
