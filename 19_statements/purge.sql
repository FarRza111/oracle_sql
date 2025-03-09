/*

Remove a table or index from your recycle bin and release all of the space associated with the object

Remove part or all of a dropped tablespace or tablespace set from the recycle bin

Remove the entire recycle bin

 */



SELECT * FROM RECYCLEBIN;
SELECT * FROM USER_RECYCLEBIN;



--------------------- Duplicate Ingestion Prevention ----------------

CREATE TABLE temporary
   (employee_id, start_date, end_date, job_id, dept_id)
AS SELECT
     employee_id, start_date, end_date, job_id, department_id
FROM hr.job_history;

DROP TABLE job_history;

RENAME temporary TO job_history;


       