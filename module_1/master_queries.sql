-- 1. get all the employees

SELECT * FROM HR.employees;


-- 2. Retrieve Employee Names and Salaries
SELECT first_name, last_name, salary FROM employees;

-- 3. Filter Employees by Department ID
SELECT first_name, last_name, department_id
FROM employees
WHERE department_id = 50;


-- Sort Employees by Salary (Descending Order)
SELECT first_name, last_name, salary
FROM employees
ORDER BY salary DESC;

-- 5. Find Employees with a Specific Job ID
SELECT first_name, last_name, job_id
FROM employees
WHERE job_id = 'IT_PROG';

-- Count number of employees
SELECT COUNT(*) AS total_employees FROM employees;


-- 7. Find Employees with Salaries Above $10,000
SELECT first_name, last_name, salary
FROM employees
WHERE salary > 10000;

-- 8. Retrieve Employee Names with Department Names
SELECT e.first_name, e.last_name, d.department_name
FROM employees e
JOIN departments d ON e.department_id = d.department_id;


-- 9. Find Employees and Their Managers
SELECT e.first_name AS employee_name, m.first_name AS manager_name
FROM employees e
LEFT JOIN employees m ON e.manager_id = m.employee_id;

-- 10. Find the Highest Salary in Each Department
SELECT department_id, MAX(salary) AS max_salary
FROM employees
GROUP BY department_id;


-- 11. Find Employees Who Earn More Than Their Managers
SELECT e.first_name, e.last_name, e.salary, m.salary AS manager_salary
FROM employees e
JOIN employees m ON e.manager_id = m.employee_id
WHERE e.salary > m.salary;

-- 12. Find Departments with No Employees
SELECT d.department_name
FROM departments d
LEFT JOIN employees e ON d.department_id = e.department_id
WHERE e.employee_id IS NULL;


-- 15. Rank Employees by Salary Within Their Department

SELECT first_name, last_name, department_id, salary,
       RANK() OVER (PARTITION BY department_id ORDER BY salary DESC) AS salary_rank
FROM employees;

-- 16. Find the Second Highest Salary

SELECT MAX(salary) AS second_highest_salary
FROM employees
WHERE salary < (SELECT MAX(salary) FROM employees);


-- 17. Find Employees Who Have Changed Jobs
SELECT e.first_name, e.last_name, j.job_title
FROM employees e
JOIN jobs j ON e.job_id = j.job_id
WHERE e.job_id != (SELECT job_id FROM job_history WHERE employee_id = e.employee_id);


-- 18. Find Employees with Salaries Above the Department Average
SELECT first_name, last_name, salary, department_id
FROM employees e
WHERE salary > (SELECT AVG(salary) FROM employees WHERE department_id = e.department_id);


-- 19. Find the Top 5 Earning Employees
SELECT first_name, last_name, salary
FROM (SELECT first_name, last_name, salary
      FROM employees
      ORDER BY salary DESC)
WHERE ROWNUM <= 5;

-- 20. Find Employees and Their Location Details
SELECT e.first_name, e.last_name, l.city, l.state_province, c.country_name
FROM employees e
JOIN departments d ON e.department_id = d.department_id
JOIN locations l ON d.location_id = l.location_id
JOIN countries c ON l.country_id = c.country_id;