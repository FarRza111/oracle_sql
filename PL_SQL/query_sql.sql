======================== DECLARE/BEGIN/END STATEMENTS ========================

DECLARE
  some_condition  BOOLEAN;
  pi              NUMBER := 3.1415926;
  radius          NUMBER := 15;
  area            NUMBER;
BEGIN
  /* Perform some simple tests and assignments */

  IF 2 + 2 = 4 THEN
    some_condition := TRUE;
  /* We expect this THEN to always be performed */
  END IF;

  /* This line computes the area of a circle using pi,
  which is the ratio between the circumference and diameter.
  After the area is computed, the result is displayed. */

  area := pi * radius**2;
  DBMS_OUTPUT.PUT_LINE('The area is: ' || TO_CHAR(area));
END;
/




DECLARE
    x NUMBER := 10;
    y NUMBER := 5;
    result NUMBER;
BEGIN
    IF x > y THEN
        result := x;
    ELSE
        result := y;
    END IF;

    DBMS_OUTPUT.PUT_LINE(result); -- Semicolon added here
END;
/


