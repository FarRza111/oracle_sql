/* ------------------------- NCHAR və VARCHAR Mətnləri ------------------------- */
/* Bu sorğu ilə NCHAR və VARCHAR tipli mətnləri seçirik. 
   N'this is an NCHAR string' ifadəsi NCHAR tipli mətni göstərir. 
   'salam fariz ' ifadəsi isə VARCHAR tipli mətni göstərir. */
SELECT N'this is an NCHAR string', 'salam fariz ' FROM DUAL;

/* Nəticə:
N'THISISANNCHARSTRING' 'SALAMFARIZ'
--------------------- ------------
this is an NCHAR string salam fariz
*/

/* ------------------------- CASE İfadələri ------------------------- */
/* CASE ifadəsi ilə müxtəlif şərtlərə əsasən fərqli nəticələr qaytarırıq. */

/* Nümunə 1: Müştərilərin kredit limitinə görə kateqoriya təyin edirik. 
   - credit_limit 100-dürsə, 'Low' kateqoriyası təyin edilir.
   - credit_limit 5000-dürsə, 'High' kateqoriyası təyin edilir.
   - Digər hallarda 'Medium' kateqoriyası təyin edilir. */
SELECT cust_last_name,
   CASE credit_limit WHEN 100 THEN 'Low'
   WHEN 5000 THEN 'High'
   ELSE 'Medium' END AS credit
   FROM customers
   ORDER BY cust_last_name, credit;

/* Nəticə:
CUST_LAST_NAME       CREDIT
-------------------- ------
Adjani               Medium
Adjani               Medium
Alexander            Medium
Alexander            Medium
Altman               High
Altman               Medium
. . .
*/

/* Nümunə 2: İşçilərin maaşlarının ortalamasını hesablayırıq. 
   - Maaş 2000-dən çox olarsa, həmin maaş istifadə olunur.
   - Maaş 2000-dən az olarsa, 2000 qəbul edilir. */
SELECT AVG(CASE WHEN e.salary > 2000 THEN e.salary
   ELSE 2000 END) "Average Salary" FROM employees e;

/* Nəticə:
Average Salary
--------------
          3500
*/

/* ------------------------- Cursor və Procedure ------------------------- */
/* Bu hissədə bir funksiya yaradılır. Bu funksiya menecerin işə qəbul tarixindən əvvəl və sonra işə qəbul olunan işçilərin sayını müqayisə edir. 
   - Əgər menecerdən əvvəl işə qəbul olunan işçilərin sayı daha çox olarsa, 1 qaytarılır.
   - Əks halda, 0 qaytarılır. */
CREATE FUNCTION f(cur SYS_REFCURSOR, mgr_hiredate DATE)
   RETURN NUMBER IS
   emp_hiredate DATE;
   before number :=0;
   after number:=0;
BEGIN
  LOOP
    FETCH cur INTO emp_hiredate;
    EXIT WHEN cur%NOTFOUND;
    IF emp_hiredate > mgr_hiredate THEN
      after:=after+1;
    ELSE
      before:=before+1;
    END IF;
  END LOOP;
  CLOSE cur;
  IF before > after THEN
    RETURN 1;
  ELSE
    RETURN 0;
  END IF;
END;
/

/* Bu sorğu ilə menecerlərin siyahısı alınır. 
   Hər bir menecer üçün f funksiyası çağırılır və nəticə 1 olan menecerlər seçilir. */
SELECT e1.last_name FROM hr.employees e1
   WHERE f(
   CURSOR(SELECT e2.hire_date FROM hr.employees e2
   WHERE e1.employee_id = e2.manager_id),
   e1.hire_date) = 1
   ORDER BY last_name;

/* Nəticə:
LAST_NAME
----------
King
Kochhar
De Haan
...
*/

/* ------------------------- Python Ekvivalenti ------------------------- */
/* Aşağıda SQL funksiyasının Python ekvivalenti təqdim olunub. 
   Bu kod menecerlərin işə qəbul tarixindən əvvəl və sonra işə qəbul olunan işçilərin sayını müqayisə edir. */

/*
# Function to compare hire dates
def f(emp_hire_dates, mgr_hire_date):
    before = 0
    after = 0

    # Loop through each employee's hire date
    for emp_hire_date in emp_hire_dates:
        if emp_hire_date > mgr_hire_date:
            after += 1
        else:
            before += 1

    # Return 1 if more employees were hired before the manager, else 0
    return 1 if before > after else 0


# Simulated employees table (list of dictionaries)
employees = [
    {"employee_id": 101, "last_name": "Smith", "hire_date": "2020-01-01", "manager_id": None},
    {"employee_id": 102, "last_name": "Johnson", "hire_date": "2021-03-15", "manager_id": 101},
    {"employee_id": 103, "last_name": "Brown", "hire_date": "2019-05-10", "manager_id": 101},
    {"employee_id": 104, "last_name": "Davis", "hire_date": "2022-07-20", "manager_id": 101},
    {"employee_id": 105, "last_name": "Wilson", "hire_date": "2018-12-01", "manager_id": 102},
    {"employee_id": 106, "last_name": "Moore", "hire_date": "2023-01-01", "manager_id": 102},
]

# Convert hire_date strings to date objects for comparison
from datetime import datetime

for emp in employees:
    emp["hire_date"] = datetime.strptime(emp["hire_date"], "%Y-%m-%d").date()

# Query to find managers with more employees hired before them than after them
result = []

for manager in employees:
    if manager["manager_id"] is None:  # Skip non-managers
        continue

    # Get the hire dates of employees who report to this manager
    emp_hire_dates = [
        emp["hire_date"] for emp in employees
        if emp["manager_id"] == manager["employee_id"]
    ]

    # Call the function to compare hire dates
    if f(emp_hire_dates, manager["hire_date"]) == 1:
        result.append(manager["last_name"])

# Sort the result by last name
result.sort()

# Print the result
print("Managers with more employees hired before them than after them:")
for name in result:
    print(name)
*/