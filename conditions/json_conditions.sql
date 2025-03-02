-- 1. JSON Məlumatlarının Saxlanması

-- Cədvəlin yaradılması və JSON məlumatlarının daxil edilməsi
CREATE TABLE t (col1 VARCHAR2(100));

-- Bu cədvəl col1 sütununda JSON formatında məlumatları saxlamaq üçün yaradılır.
-- Düzgün formatlı JSON məlumatları daxil edilir.

INSERT INTO t VALUES ( '[ "LIT192", "CS141", "HIS160" ]' );
INSERT INTO t VALUES ( '{ "Name": "John" }' );
INSERT INTO t VALUES ( '{ "Grade Values" : { A : 4.0, B : 3.0, C : 2.0 } }');
INSERT INTO t VALUES ( '{ "isEnrolled" : true }' );
INSERT INTO t VALUES ( '{ "isMatriculated" : False }' );
INSERT INTO t VALUES (NULL);
INSERT INTO t VALUES ('This is not well-formed JSON data');

-- Son iki sətir düzgün formatda deyil (NULL və JSON standartına uyğun olmayan mətn).

-- 2. Cədvəldəki JSON Verilənlərini Yoxlamaq

-- JSON formatında olan məlumatları tapmaq
SELECT * FROM t WHERE col1 IS JSON;

-- Bu sorğu yalnız düzgün formatlı JSON verilənlərini qaytarır.

-- JSON STRICT və JSON LAX fərqi
SELECT col1 FROM t WHERE col1 IS JSON STRICT;

-- JSON STRICT rejimində aşağıdakı qaydalara uyğun olmayan JSON-lar filtr edilir.

SELECT col1 FROM t WHERE col1 IS NOT JSON STRICT AND col1 IS JSON LAX;

-- JSON LAX rejimi bağışlayıcıdır və kiçik qayda pozuntularını qəbul edir (məsələn, dırnaqsız açar adları).

-- 3. JSON Tipində Cədvəl Yaratmaq

CREATE TABLE j_purchaseorder (
  id RAW(16) NOT NULL,
  date_loaded TIMESTAMP(6) WITH TIME ZONE,
  po_document CLOB CONSTRAINT ensure_json CHECK (po_document IS JSON)
);

-- 4. JSON Məlumatlarını Müqayisə Etmək (JSON_EQUAL)

-- TRUE (1) qaytarır, çünki açarların sırası fərqli olsa da, JSON eynidir.
SELECT JSON_EQUAL(
  ' { "city": "New York", "country": "USA" } ',
  '{"country":"USA", "city": "New York"}'
) FROM dual;

-- FALSE (0) qaytarır, çünki "1" stringdir, 1 isə ədədi dəyərdir.
SELECT JSON_EQUAL('{a:"1"}', '{a:1 }') FROM dual;

-- TRUE (1) qaytarır, çünki boş JSON eynidir.
SELECT JSON_EQUAL('{}', '{ }') FROM dual;

-- TRUE (1) qaytarır, çünki açarların sırası fərqli olsa da, eyni JSON-dur.
SELECT JSON_EQUAL('{a:1, b:2}', '{b:2 , a:1 }') FROM dual;

-- 5. JSON Daxilində Açar Tapmaq (JSON_EXISTS)

SELECT col1 FROM t WHERE JSON_EXISTS(col1, '$[0].first');

-- JSON massivinin birinci ([0]) obyektində first açarı varsa, həmin sətir qaytarılır.

-- 6. Dinamik Dəyişənlə JSON Axtarışı (PASSING)

SELECT * FROM t
  WHERE JSON_EXISTS(col1, '$[1]?(@.middle == $var1)' PASSING 'Anne' AS "var1");

-- Bu SQL sorğusu JSON massivinin ikinci obyektində "middle": "Anne" olub-olmadığını yoxlayır.

-- Bu dərslik sizə Oracle bazasında JSON məlumatlarını saxlamaq, yoxlamaq və istifadə etmək yollarını öyrətdi.




----BETWEEN---
-- expr1 NOT BETWEEN expr2 AND expr3
-- NOT (expr1 BETWEEN expr2 AND expr3)
-- expr1 BETWEEN expr2 AND expr3
-- expr2 <= expr1 AND expr1 <= expr3


---EXISTS---

SELECT department_id
  FROM departments d
  WHERE EXISTS
  (SELECT * FROM employees e
    WHERE d.department_id
    = e.department_id)
   ORDER BY department_id;


SELECT customer_name
FROM customers c
WHERE EXISTS
  (SELECT 1
   FROM orders o
   WHERE o.customer_id = c.customer_id
   AND YEAR(o.order_date) = 2024);


SELECT DISTINCT c.customer_name
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
WHERE YEAR(o.order_date) = 2024;



--------------IN-----------
SELECT 'True' FROM hr.employees
    WHERE department_id NOT IN (10, 20, NULL);

-- Equal
department_id != 10 AND department_id != 20 AND department_id != null


-------------LEVEL----------

/*Oracle SQL-də hierarchical query (iyerarxik sorğu) istifadə edərək
bir menecerin altındakı bütün işçiləri tapmaq üçün istifadə olunur. */

SELECT employee_id, manager_id, last_name, LEVEL lev
      FROM hr.employees v
      START WITH employee_id = 100
      CONNECT BY PRIOR employee_id = manager_id

King (Level 1)
├── Kochhar (Level 2)
    └── Greenberg (Level 3)
        ├── Faviet (Level 4)
        ├── Chen (Level 4)
        ├── Sciarra (Level 4)
        └── Urman (Level 4)


Level 1: King (yuxarı rəhbər, meneceri yoxdur).
Level 2: Kochhar Kingə tabe olur.
Level 3: Greenberg Kochhara tabe olur.
Level 4: Faviet, Chen, Sciarra, və Urman Greenbergə tabe olurlar.





