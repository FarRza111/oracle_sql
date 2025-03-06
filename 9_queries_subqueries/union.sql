/*This statement shows that you must match data type (using the TO_CHAR function) when columns
  do not exist in one or
  the other table:*/

SELECT location_id, department_name "Department",
   TO_CHAR(NULL) "Warehouse"  FROM departments
   UNION
   SELECT location_id, TO_CHAR(NULL) "Department", warehouse_name
   FROM warehouses;

---------UNIONALL------

/*The UNION operator returns only distinct rows that appear in either result,
  while the UNION ALL operator returns all rows.
  The UNION ALL operator does not eliminate duplicate selected rows:*/


SELECT product_id FROM order_items
UNION
SELECT product_id FROM inventories
ORDER BY product_id;

SELECT location_id  FROM locations
UNION ALL
SELECT location_id  FROM departments
ORDER BY location_id;


--------INTERSECT-------
/*The following statement combines the results with the INTERSECT operator,
  which returns only those unique rows returned by both queries:*/

SELECT product_id FROM inventories
INTERSECT
SELECT product_id FROM order_items
ORDER BY product_id;


------NINUSE-----

/*The following statement combines results with the MINUS operator,
  which returns only unique rows returned by the first query but not by the second:*/

SELECT product_id FROM inventories
MINUS
SELECT product_id FROM order_items
ORDER BY product_id;


----------------COMMIT-----------------
-- Step 1: Create the regions table
CREATE TABLE regions
AS
SELECT * FROM HR.Regions;

-- Step 2: Query the table
SELECT * FROM regions;

-- Step 3: Insert a new row
INSERT INTO regions VALUES (5, 'Antarctica');

-- Step 4: Commit the transaction
COMMIT WORK;

-- Step 5: Commit with batching
COMMIT WRITE BATCH;

-- Step 6: Commit with a comment
COMMIT
    COMMENT 'In-doubt transaction Code 36, Call (415) 555-2637';



-----SEQUENCE----

CREATE SEQUENCE customers_seq
 START WITH     1000
 INCREMENT BY   1
 NOCACHE
 NOCYCLE;

SELECT customers_seq.NEXTVAL FROM dual


-----Insert by Sequence---------

-- Step 1: Create the sequence
CREATE SEQUENCE customers_seq
 START WITH     1000
 INCREMENT BY   1
 NOCACHE
 NOCYCLE;

-- Step 2: Create the customers table
CREATE TABLE customers (
    customer_id NUMBER PRIMARY KEY,
    customer_name VARCHAR2(100),
    email VARCHAR2(100)
);

-- Step 3: Insert data using the sequence
INSERT INTO customers (customer_id, customer_name, email)
VALUES (customers_seq.NEXTVAL, 'John Doe', 'john.doe@example.com');

INSERT INTO customers (customer_id, customer_name, email)
VALUES (customers_seq.NEXTVAL, 'Jane Smith', 'jane.smith@example.com');

-- Step 4: Query the table
SELECT * FROM customers;

-- Step 5: Check the current value of the sequence
SELECT customers_seq.CURRVAL FROM dual;

select * from customers;



------