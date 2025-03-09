/* ------------------------- UNION Operatoru ------------------------- */
/* Bu sorğu ilə departments və warehouses cədvəllərindəki məlumatlar birləşdirilir.
   - TO_CHAR(NULL): Bir cədvəldə olmayan sütun üçün NULL dəyər əlavə edir. */
SELECT location_id, department_name "Department",
   TO_CHAR(NULL) "Warehouse"  FROM departments
   UNION
   SELECT location_id, TO_CHAR(NULL) "Department", warehouse_name
   FROM warehouses;

/* Nəticə:
LOCATION_ID Department       Warehouse
----------- ---------------  ---------------
       1700 IT               (null)
       1700 (null)           Southlake, Texas
       1800 Shipping         (null)
       1800 (null)           San Francisco
       ...
*/

/* ------------------------- UNION ALL Operatoru ------------------------- */
/* UNION operatoru yalnız unikal sətirləri qaytarır, UNION ALL isə bütün sətirləri qaytarır.
   - UNION ALL: Təkrar olunan sətirləri çıxarmır. */
SELECT product_id FROM order_items
UNION
SELECT product_id FROM inventories
ORDER BY product_id;

/* Nəticə:
PRODUCT_ID
----------
         1
         2
         3
         ...
*/

SELECT location_id  FROM locations
UNION ALL
SELECT location_id  FROM departments
ORDER BY location_id;

/* Nəticə:
LOCATION_ID
-----------
       1400
       1400
       1500
       1500
       ...
*/

/* ------------------------- INTERSECT Operatoru ------------------------- */
/* INTERSECT operatoru ilə iki sorğunun nəticələrində olan ortaq sətirlər qaytarılır. */
SELECT product_id FROM inventories
INTERSECT
SELECT product_id FROM order_items
ORDER BY product_id;

/* Nəticə:
PRODUCT_ID
----------
         1
         2
         3
         ...
*/

/* ------------------------- MINUS Operatoru ------------------------- */
/* MINUS operatoru ilə birinci sorğunun nəticəsində olan, lakin ikinci sorğunun nəticəsində olmayan sətirlər qaytarılır. */
SELECT product_id FROM inventories
MINUS
SELECT product_id FROM order_items
ORDER BY product_id;

/* Nəticə:
PRODUCT_ID
----------
         4
         5
         6
         ...
*/

/* ------------------------- COMMIT İfadəsi ------------------------- */
/* Bu hissədə COMMIT ifadəsinin müxtəlif nümunələri təqdim olunur.
   - COMMIT WORK: Tranzaksiyanı təsdiqləyir.
   - COMMIT WRITE BATCH: Tranzaksiyanı partiyalı şəkildə təsdiqləyir.
   - COMMIT COMMENT: Tranzaksiyaya şərh əlavə edir. */

-- Step 1: regions cədvəli yaradılır.
CREATE TABLE regions
AS
SELECT * FROM HR.Regions;

-- Step 2: regions cədvəli sorğulanır.
SELECT * FROM regions;

-- Step 3: regions cədvəlinə yeni sətir əlavə edilir.
INSERT INTO regions VALUES (5, 'Antarctica');

-- Step 4: Tranzaksiya təsdiqlənir.
COMMIT WORK;

-- Step 5: Partiyalı şəkildə tranzaksiya təsdiqlənir.
COMMIT WRITE BATCH;

-- Step 6: Tranzaksiyaya şərh əlavə edilir.
COMMIT
    COMMENT 'In-doubt transaction Code 36, Call (415) 555-2637';

/* ------------------------- SEQUENCE (Ardıcıllıq) ------------------------- */
/* Bu hissədə SEQUENCE yaradılır və istifadə olunur.
   - START WITH: Ardıcıllığın başlanğıc dəyəri.
   - INCREMENT BY: Ardıcıllığın artım dəyəri.
   - NOCACHE: Ardıcıllıq dəyərləri cache edilmir.
   - NOCYCLE: Ardıcıllıq maksimum dəyərə çatdıqda yenidən başlamır. */

-- Step 1: customers_seq ardıcıllığı yaradılır.
CREATE SEQUENCE customers_seq
 START WITH     1000
 INCREMENT BY   1
 NOCACHE
 NOCYCLE;

-- Step 2: customers cədvəli yaradılır.
CREATE TABLE customers (
    customer_id NUMBER PRIMARY KEY,
    customer_name VARCHAR2(100),
    email VARCHAR2(100)
);

-- Step 3: customers_seq ardıcıllığı ilə məlumat əlavə edilir.
INSERT INTO customers (customer_id, customer_name, email)
VALUES (customers_seq.NEXTVAL, 'John Doe', 'john.doe@example.com');

INSERT INTO customers (customer_id, customer_name, email)
VALUES (customers_seq.NEXTVAL, 'Jane Smith', 'jane.smith@example.com');

-- Step 4: customers cədvəli sorğulanır.
SELECT * FROM customers;

/* Nəticə:
CUSTOMER_ID CUSTOMER_NAME EMAIL
----------- ------------- --------------------
       1000 John Doe      john.doe@example.com
       1001 Jane Smith    jane.smith@example.com
*/

-- Step 5: Ardıcıllığın hazırkı dəyəri yoxlanılır.
SELECT customers_seq.CURRVAL FROM dual;

/* Nəticə:
CURRVAL
-------
   1001
*/

-- Step 6: customers cədvəli sorğulanır.
SELECT * FROM customers;

/* Nəticə:
CUSTOMER_ID CUSTOMER_NAME EMAIL
----------- ------------- --------------------
       1000 John Doe      john.doe@example.com
       1001 Jane Smith    jane.smith@example.com
*/