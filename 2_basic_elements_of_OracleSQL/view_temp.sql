/*Qısa Xülasə
Görünüş (View) və Cədvəl (Table) arasındakı əsas fərqlər:

Görünüş (View):
Fiziki olaraq məlumatları saxlamır; virtual cədvəl yaradır.
Əsas cədvəldəki dəyişiklikləri real vaxtda əks etdirir.
Məlumatları sadələşdirmək və ya xüsusi bir görünüş təqdim etmək üçün istifadə olunur.
Cədvəl (Table):
Məlumatları fiziki olaraq saxlamağa xidmət edir.
Yaradıldığı zaman məlumatların statik bir snapshotunu təqdim edir; sonrakı dəyişiklikləri əks etdirmir.
Gələcəkdə istifadə üçün məlumat saxlamaq və əməliyyatlar (insert, update, delete) aparmaq üçün istifadə olunur.
Xülasə: Görünüş, dinamik məlumat təqdimatı üçün, cədvəl isə məlumatların saxlanması üçün istifadə edilir */


CREATE VIEW v AS
  SELECT e.last_name, e.department_id, d.location_id
  FROM employees e, departments d
  WHERE e.department_id = d.department_id;

CREATE TABLE t AS
  SELECT * from employees
  WHERE employee_id < 200;






