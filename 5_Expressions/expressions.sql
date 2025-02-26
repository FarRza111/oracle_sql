select N'this is an NCHAR string', 'salam fariz ' from dual;

-------------------CASE EXPRESSIONS----------------
-- -ex.1
SELECT cust_last_name,
   CASE credit_limit WHEN 100 THEN 'Low'
   WHEN 5000 THEN 'High'
   ELSE 'Medium' END AS credit
   FROM customers
   ORDER BY cust_last_name, credit;

-- CUST_LAST_NAME       CREDIT
-- -------------------- ------
-- Adjani               Medium
-- Adjani               Medium
-- Alexander            Medium
-- Alexander            Medium
-- Altman               High
-- Altman               Medium
-- . . .

-- ex.2
SELECT AVG(CASE WHEN e.salary > 2000 THEN e.salary
   ELSE 2000 END) "Average Salary" FROM employees e;






-- Cursor/Procedure
CREATE FUNCTION f(cur SYS_REFCURSOR, mgr_hiredate DATE)
   RETURN NUMBER IS
   emp_hiredate DATE;
   before number :=0;
   after number:=0;
begin
  loop
    fetch cur into emp_hiredate;
    exit when cur%NOTFOUND;
    if emp_hiredate > mgr_hiredate then
      after:=after+1;
    else
      before:=before+1;
    end if;
  end loop;
  close cur;
  if before > after then
    return 1;
  else
    return 0;
  end if;
end;
/

SELECT e1.last_name FROM hr.employees e1
   WHERE f(
   CURSOR(SELECT e2.hire_date FROM hr.employees e2
   WHERE e1.employee_id = e2.manager_id),
   e1.hire_date) = 1
   ORDER BY last_name;

--Equal of the task above in Python

-- # Function to compare hire dates
-- def f(emp_hire_dates, mgr_hire_date):
--     before = 0
--     after = 0
--
--     # Loop through each employee's hire date
--     for emp_hire_date in emp_hire_dates:
--         if emp_hire_date > mgr_hire_date:
--             after += 1
--         else:
--             before += 1
--
--     # Return 1 if more employees were hired before the manager, else 0
--     return 1 if before > after else 0
--
--
-- # Simulated employees table (list of dictionaries)
-- employees = [
--     {"employee_id": 101, "last_name": "Smith", "hire_date": "2020-01-01", "manager_id": None},
--     {"employee_id": 102, "last_name": "Johnson", "hire_date": "2021-03-15", "manager_id": 101},
--     {"employee_id": 103, "last_name": "Brown", "hire_date": "2019-05-10", "manager_id": 101},
--     {"employee_id": 104, "last_name": "Davis", "hire_date": "2022-07-20", "manager_id": 101},
--     {"employee_id": 105, "last_name": "Wilson", "hire_date": "2018-12-01", "manager_id": 102},
--     {"employee_id": 106, "last_name": "Moore", "hire_date": "2023-01-01", "manager_id": 102},
-- ]
--
-- # Convert hire_date strings to date objects for comparison
-- from datetime import datetime
--
-- for emp in employees:
--     emp["hire_date"] = datetime.strptime(emp["hire_date"], "%Y-%m-%d").date()
--
-- # Query to find managers with more employees hired before them than after them
-- result = []
--
-- for manager in employees:
--     if manager["manager_id"] is None:  # Skip non-managers
--         continue
--
--     # Get the hire dates of employees who report to this manager
--     emp_hire_dates = [
--         emp["hire_date"] for emp in employees
--         if emp["manager_id"] == manager["employee_id"]
--     ]
--
--     # Call the function to compare hire dates
--     if f(emp_hire_dates, manager["hire_date"]) == 1:
--         result.append(manager["last_name"])
--
-- # Sort the result by last name
-- result.sort()
--
-- # Print the result
-- print("Managers with more employees hired before them than after them:")
-- for name in result:
--     print(name)

