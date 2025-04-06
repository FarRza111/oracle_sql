DECLARE

    num1 number :=20;
    num2 NUMBER := 50;

BEGIN
    dbms_output.put_line('Outer Variable num1: ' || num1);
   dbms_output.put_line('Outer Variable num2: ' || num2);

    DECLARE
        num2 number := 23443;
        num1 number := 29239;

    BEGIN

        dbms_output.put_line('Outer Variable num1: ' || num1);
        dbms_output.put_line('Outer Variable num2: ' || num2);

    END;


END;


====================== ASSIGNING SQL QUERIES TO VARIABLES ======================


CREATE TABLE employees
AS
SELECT * FROM HR.EMPLOYEES;

DECLARE
    v_empName  employees.LAST_NAME%TYPE;
    v_salary   employees.SALARY%TYPE;

BEGIN

    SELECT Last_name, salary
    INTO v_empName, v_salary
    FROM HR.EMPLOYEES
    WHERE EMPLOYEE_ID = 100;
    DBMS_OUTPUT.PUT_LINE('Employee: ' || v_empName || ', Salary: ' || v_salary);

EXCEPTION
    WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('EMP Not Found');


END;