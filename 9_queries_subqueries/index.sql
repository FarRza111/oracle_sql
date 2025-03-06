/*
SQL-də indekslər sorğuların icrasını sürətləndirmək üçün istifadə olunur. Məsələn,
funksiya əsaslı indeks (function-based index) yaradaraq müəyyən
bir ifadəni əvvəlcədən hesablaya və daha sürətli axtarış edə bilərik.

Əsas məqam sorğunun indekslə eyni ifadədən istifadə etməsidir, əks halda indeksdən istifadə olunmayacaq.

Funksiya əsaslı indekslər sorğuları sürətləndirsə də, bəzi çatışmazlıqları var.
Onlar əlavə yaddaş tələb edir, INSERT/UPDATE əməliyyatlarını yavaşlada bilər və yalnız eyni ifadə istifadə olunarsa işləyir.
Çox indeks yaratmaq verilənlər bazasının idarəsini çətinləşdirə bilər.

*/

CREATE INDEX income_ix
ON employees(salary + (salary * commission_pct));



SELECT first_name || ' ' || last_name AS Name
FROM employees
WHERE (salary + (salary * commission_pct)) > 15000;


EXPLAIN PLAN FOR
SELECT first_name || ' ' || last_name
FROM employees
WHERE (salary + (salary * commission_pct)) > 15000;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);


