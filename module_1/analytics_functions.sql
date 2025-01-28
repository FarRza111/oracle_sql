-- 1. Employee Salary Ranking by Department
--
-- Rank employees by their salary within each department.

SELECT
    first_name,
    last_name,
    department_id,
    salary,
    RANK() OVER (PARTITION BY department_id ORDER BY salary DESC) AS salary_rank
FROM HR.employees;



-- 2. Cumulative Salary by Department
--
-- Calculate the cumulative salary for employees within each department.

SELECT
    first_name,
    last_name,
    department_id,
    salary,
    SUM(salary) OVER (PARTITION BY department_id ORDER BY salary DESC) AS cumulative_salary
FROM HR.employees;


-- 3. Moving Average of Salaries
--
-- Calculate the 3-month moving average of salaries for employees (assuming hire_date is used as a time metric).

SELECT
    first_name,
    last_name,
    hire_date,
    salary,
    AVG(salary) OVER (ORDER BY hire_date ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS moving_avg_salary
FROM HR.employees;


-- 4. Top 3 Highest-Paid Employees in Each Department
--
-- Find the top 3 highest-paid employees in each department.

SELECT
    first_name,
    last_name,
    department_id,
    salary
FROM (
    SELECT
        first_name,
        last_name,
        department_id,
        salary,
        DENSE_RANK() OVER (PARTITION BY department_id ORDER BY salary DESC) AS salary_rank
    FROM HR.employees
)
WHERE salary_rank <= 3;

--
-- 5. Employee Salary Comparison with Department Average
--
-- Compare each employee's salary with the average salary of their department.

SELECT
    first_name,
    last_name,
    department_id,
    salary,
    AVG(salary) OVER (PARTITION BY department_id) AS avg_department_salary,
    salary - AVG(salary) OVER (PARTITION BY department_id) AS salary_difference
FROM HR.employees;

--
-- 6. Employee Tenure Analysis
--
-- Calculate the tenure (in years) of each employee and rank them by tenure within their department.

SELECT
    first_name,
    last_name,
    department_id,
    hire_date,
    ROUND((SYSDATE - hire_date) / 365, 2) AS tenure_years,
    RANK() OVER (PARTITION BY department_id ORDER BY (SYSDATE - hire_date) DESC) AS tenure_rank
FROM HR.employees;

--
-- 7. Employee Salary Growth Over Time
--
-- Calculate the percentage growth in salary for employees who have had multiple jobs (using job_history).
SELECT
    e.first_name,
    e.last_name,
    jh.start_date,
    jh.end_date,
    e.salary AS current_salary,
    LAG(e.salary) OVER (PARTITION BY e.employee_id ORDER BY jh.start_date) AS previous_salary,
    ROUND((e.salary - LAG(e.salary) OVER (PARTITION BY e.employee_id ORDER BY jh.start_date)) / LAG(e.salary) OVER (PARTITION BY e.employee_id ORDER BY jh.start_date) * 100, 2) AS salary_growth_percentage
FROM HR.employees e
JOIN HR.job_history jh ON e.employee_id = jh.employee_id;

--
-- 9. Department-Wide Salary Distribution
--
-- Analyze the distribution of salaries within each department using percentiles.
SELECT
    department_id,
    PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY salary) AS percentile_25,
    PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY salary) AS median_salary,
    PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY salary) AS percentile_75
FROM HR.employees
GROUP BY department_id;





