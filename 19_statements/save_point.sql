-- Step 1: Create a new table
DROP TABLE temp;

CREATE TABLE temp (
    emp_id    NUMBER PRIMARY KEY,
    emp_name  VARCHAR2(50) NOT NULL,
    position  VARCHAR2(50) NOT NULL,
    salary    NUMBER NOT NULL
);

-- Step 2: Insert Data & Use ROLLBACK
INSERT INTO temp VALUES (101, 'Alice Johnson', 'Manager', 80000);
INSERT INTO temp VALUES (102, 'Bob Smith', 'Developer', 60000);

-- Check data before rollback
SELECT * FROM temp;

-- Rollback all changes (table will be empty)
ROLLBACK;

-- Check again (should return no rows)
SELECT * FROM temp;

-- Step 3: Insert Data & Use SAVEPOINT
INSERT INTO temp VALUES (201, 'Charlie Brown', 'Analyst', 50000);
SAVEPOINT sp1;  -- Savepoint after first insert

INSERT INTO temp VALUES (202, 'Diana Prince', 'HR', 55000);
SAVEPOINT sp2;  -- Savepoint after second insert

INSERT INTO temp VALUES (203, 'Edward Norton', 'Designer', 58000);

-- Check data before rollback
SELECT * FROM temp;

-- Rollback to SAVEPOINT sp2 (undo last insert)
ROLLBACK TO sp2;

-- Check data (203 should be gone, 201 & 202 remain)
SELECT * FROM temp;

-- Rollback to SAVEPOINT sp1 (undo second insert too)
ROLLBACK TO sp1;

-- Check data (Only 201 remains)
SELECT * FROM temp;

-- Commit remaining data (201 is permanently saved)
COMMIT;

-- Final check after commit
SELECT * FROM temp;

/*
ROLLBACK TO sp2; removes 203.
ROLLBACK TO sp1; removes 202, but 201 remains.
COMMIT; permanently saves 201. */


-------------- SAVEPOINT -----------

UPDATE employees
    SET salary = 7000
    WHERE last_name = 'Banda';
SAVEPOINT banda_sal;

UPDATE employees
    SET salary = 12000
    WHERE last_name = 'Greene';
SAVEPOINT greene_sal;

SELECT SUM(salary) FROM employees;

ROLLBACK TO SAVEPOINT banda_sal;

UPDATE employees
    SET salary = 11000
    WHERE last_name = 'Greene';

COMMIT;