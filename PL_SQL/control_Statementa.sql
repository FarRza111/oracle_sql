==============> MAINLY GO OVER THE DOCUMENTATION <==============

-- https://docs.oracle.com/en/database/oracle/oracle-database/19/lnpls/plsql-control-statements.html#GUID-C4BC9960-5945-4646-BBDE-DC00346F8702



============================ MAIN_USE_CASE ===================

CREATE OR REPLACE
    PROCEDURE s (SALES NUMBER)

    IS
        BONUS NUMBER :=0;

    BEGIN
        IF
            sales > 5000 THEN
            bonus := 1500;

        ELSIF
            sales > 50000 THEN
            BONUS := 1500;
        ELSE
            BONUS := 100;
        END IF;

        DBMS_OUTPUT.PUT_LINE(
             'Sales = ' || sales || ', bonus = ' || bonus || '.'
        );
    END;


BEGIN
  s(55000);
  s(40000);
  s(30000);
END;



================================EX2===============================

DECLARE
  grade CHAR(1);
BEGIN
  grade := 'B';

  IF grade = 'A' THEN
    DBMS_OUTPUT.PUT_LINE('Excellent');
  ELSIF grade = 'B' THEN
    DBMS_OUTPUT.PUT_LINE('Very Good');
  ELSIF grade = 'C' THEN
    DBMS_OUTPUT.PUT_LINE('Good');
  ELSIF grade = 'D' THEN
    DBMS_OUTPUT. PUT_LINE('Fair');
  ELSIF grade = 'F' THEN
    DBMS_OUTPUT.PUT_LINE('Poor');
  ELSE
    DBMS_OUTPUT.PUT_LINE('No such grade');
  END IF;
END;
/

===============================EX3===============================



DECLARE
  PROCEDURE p (
    sales  NUMBER,
    quota  NUMBER,
    emp_id NUMBER
  )
  IS
    bonus  NUMBER := 0;
  BEGIN
    IF sales > (quota + 200) THEN
      bonus := (sales - quota)/4;
    ELSE
      bonus := 50;
    END IF;

    DBMS_OUTPUT.PUT_LINE('bonus = ' || bonus);

    UPDATE employees
    SET salary = salary + bonus
    WHERE employee_id = emp_id;
  END p;
BEGIN
  p(10100, 10000, 120);
  p(10500, 10000, 121);
END;
/


===============================EX4===============================

DECLARE
  grade CHAR(1);
BEGIN
  grade := 'B';

  CASE grade
    WHEN 'A' THEN DBMS_OUTPUT.PUT_LINE('Excellent');
    WHEN 'B' THEN DBMS_OUTPUT.PUT_LINE('Veryyyyyyyyy Gooddddddd');
    WHEN 'C' THEN DBMS_OUTPUT.PUT_LINE('Good');
    WHEN 'D' THEN DBMS_OUTPUT.PUT_LINE('Fair');
    WHEN 'F' THEN DBMS_OUTPUT.PUT_LINE('Poor');
    ELSE DBMS_OUTPUT.PUT_LINE('No such grade');
  END CASE;
END;
/

=============================EXCEPTION============================

DECLARE
  grade CHAR(1);
BEGIN
  grade := 'B';

  CASE
    WHEN grade = 'A' THEN DBMS_OUTPUT.PUT_LINE('Excellent');
    WHEN grade = 'B' THEN DBMS_OUTPUT.PUT_LINE('Very Good');
    WHEN grade = 'C' THEN DBMS_OUTPUT.PUT_LINE('Good');
    WHEN grade = 'D' THEN DBMS_OUTPUT.PUT_LINE('Fair');
    WHEN grade = 'F' THEN DBMS_OUTPUT.PUT_LINE('Poor');
  END CASE;
EXCEPTION
  WHEN CASE_NOT_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('No such grade');
END;
/


=============================LOOPS============================

BEGIN
  FOR i IN 1..5 LOOP
    DBMS_OUTPUT.PUT_LINE('Iteration: ' || i);
  END LOOP;
END;



=============================ITERATE_OVER_ROWS=================

DECLARE
  CURSOR emp_cursor IS
    SELECT employee_id, first_name, last_name
    FROM employees
    WHERE department_id = 50;
BEGIN
  FOR emp_record IN emp_cursor LOOP
    DBMS_OUTPUT.PUT_LINE(
      'Employee ID: ' || emp_record.employee_id || ', ' ||
      'Name: ' || emp_record.first_name || ' ' || emp_record.last_name
    );
  END LOOP;
END;



--------------- EQUALENT IMPLICT -------------------

BEGIN
  FOR emp_record IN (
    SELECT employee_id, first_name, last_name
    FROM employees
    WHERE department_id = 50
  ) LOOP
    DBMS_OUTPUT.PUT_LINE(
      'Employee ID: ' || emp_record.employee_id || ', ' ||
      'Name: ' || emp_record.first_name || ' ' || emp_record.last_name
    );
  END LOOP;
END;

