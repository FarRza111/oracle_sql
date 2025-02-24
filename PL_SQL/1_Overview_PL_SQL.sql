/* */
DECLARE    -- Declarative part (optional)
  -- Declarations of local types, variables, & subprograms

BEGIN      -- Executable part (required)
  -- Statements (which can use items declared in declarative part)

[EXCEPTION -- Exception-handling part (optional)
  -- Exception handlers for exceptions (errors) raised in executable part]
END;


/----------------------------LOOP-------------------------------/
BEGIN
  FOR someone IN (
    SELECT * FROM employees
    WHERE employee_id < 120
    ORDER BY employee_id
  )
  LOOP
    DBMS_OUTPUT.PUT_LINE('First name = ' || someone.first_name ||
                         ', Last name = ' || someone.last_name);
  END LOOP;
END;
/





/--------------------------- Procedure--------------------------/

CREATE table emp
AS SELECT * FROM hr.employees;


CREATE OR REPLACE PROCEDURE increase_salary (
  p_emp_id IN NUMBER,
  p_increment IN NUMBER
) IS
  v_new_salary NUMBER;
BEGIN
  -- Əvvəlcə maaşı artırırıq
  UPDATE emp
  SET salary = salary + p_increment
  WHERE employee_id = p_emp_id
  RETURNING salary INTO v_new_salary;  -- Yeni maaşı dəyişənə yazırıq

  -- Yeni maaşı ekrana çıxarırıq
  DBMS_OUTPUT.PUT_LINE('Yeni maaş: ' || v_new_salary);
END;
/



BEGIN
  increase_salary(100, 500);
END;
/



------------------------