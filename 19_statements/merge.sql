/* ------------------------- Cədvəl Yaradılması ------------------------- */
/*
   İki cədvəl yaradılır: `people_source` və `people_target`.
   Hər iki cədvəl eyni quruluşa malikdir:
   - `person_id`: Hər bir şəxs üçün unikal identifikator (Primary Key).
   - `first_name`: Şəxsin adı.
   - `last_name`: Şəxsin soyadı.
   - `title`: Şəxsin titulu (məsələn, Mr, Mrs, Miss).
*/
CREATE TABLE people_source (
  person_id  INTEGER NOT NULL PRIMARY KEY,
  first_name VARCHAR2(20) NOT NULL,
  last_name  VARCHAR2(20) NOT NULL,
  title      VARCHAR2(10) NOT NULL
);

CREATE TABLE people_target (
  person_id  INTEGER NOT NULL PRIMARY KEY,
  first_name VARCHAR2(20) NOT NULL,
  last_name  VARCHAR2(20) NOT NULL,
  title      VARCHAR2(10) NOT NULL
);

/* ------------------------- İlkin Məlumatların Əlavə Edilməsi ------------------------- */
/*
   `people_target` və `people_source` cədvəllərinə nümunə məlumatlar əlavə edilir.
   - `people_target` cədvəlində iki ilkin qeyd var.
   - `people_source` cədvəlində üç qeyd var, onlardan biri `people_target` cədvəlindəki qeydlə uyğun gəlir.
*/
INSERT INTO people_target VALUES (1, 'John', 'Smith', 'Mr');
INSERT INTO people_target VALUES (2, 'alice', 'jones', 'Mrs');

INSERT INTO people_source VALUES (2, 'Alice', 'Jones', 'Mrs.');
INSERT INTO people_source VALUES (3, 'Jane', 'Doe', 'Miss');
INSERT INTO people_source VALUES (4, 'Dave', 'Brown', 'Mr');

COMMIT;

/* ------------------------- MERGE INTO (Yalnız Yeniləmə) ------------------------- */
/*
   `MERGE` ifadəsi ilə `people_target` cədvəlindəki qeydlər `people_source` cədvəlinə uyğun olaraq yenilənir.
   - `ON` şərti `person_id` dəyərlərinin uyğunluğunu yoxlayır.
   - Əgər uyğunluq tapılsa, `UPDATE` ifadəsi `people_target` cədvəlindəki `first_name`, `last_name` və `title` sahələrini yeniləyir.
*/
MERGE INTO people_target pt
USING people_source ps
ON    (pt.person_id = ps.person_id)
WHEN MATCHED THEN UPDATE
  SET pt.first_name = ps.first_name,
      pt.last_name = ps.last_name,
      pt.title = ps.title;

/* Nəticə:
   - `person_id = 2` olan qeyd `people_target` cədvəlində yenilənir.
   - `first_name` "alice" -> "Alice", `last_name` "jones" -> "Jones", `title` "Mrs" -> "Mrs." olaraq dəyişir.
*/

/* ------------------------- MERGE INTO (Yalnız Əlavə Etmə) ------------------------- */
/*
   `MERGE` ifadəsi ilə `people_target` cədvəlinə yeni qeydlər əlavə edilir.
   - `ON` şərti `person_id` dəyərlərinin uyğunluğunu yoxlayır.
   - Əgər uyğunluq tapılmasa, `INSERT` ifadəsi ilə yeni qeydlər əlavə edilir.
*/
MERGE INTO people_target pt
USING people_source ps
ON    (pt.person_id = ps.person_id)
WHEN NOT MATCHED THEN INSERT
  (pt.person_id, pt.first_name, pt.last_name, pt.title)
  VALUES (ps.person_id, ps.first_name, ps.last_name, ps.title);

/* Nəticə:
   - `person_id = 3` və `person_id = 4` olan qeydlər `people_target` cədvəlinə əlavə edilir.
   - Yeni qeydlər: (3, 'Jane', 'Doe', 'Miss') və (4, 'Dave', 'Brown', 'Mr').
*/

/* ------------------------- MERGE INTO (Yeniləmə və Əlavə Etmə) ------------------------- */
/*
   `MERGE` ifadəsi ilə `people_target` cədvəlindəki qeydlər yenilənir və yeni qeydlər əlavə edilir.
   - `ON` şərti `person_id` dəyərlərinin uyğunluğunu yoxlayır.
   - Əgər uyğunluq tapılsa, `UPDATE` ifadəsi ilə qeydlər yenilənir.
   - Əgər uyğunluq tapılmasa, `INSERT` ifadəsi ilə yeni qeydlər əlavə edilir.
*/
MERGE INTO people_target pt
USING people_source ps
ON    (pt.person_id = ps.person_id)
WHEN MATCHED THEN UPDATE
  SET pt.first_name = ps.first_name,
      pt.last_name = ps.last_name,
      pt.title = ps.title
WHEN NOT MATCHED THEN INSERT
  (pt.person_id, pt.first_name, pt.last_name, pt.title)
  VALUES (ps.person_id, ps.first_name, ps.last_name, ps.title);

/* Nəticə:
   - `person_id = 2` olan qeyd yenilənir.
   - `person_id = 3` və `person_id = 4` olan qeydlər əlavə edilir.
   - `people_target` cədvəlinin son halı:
     (1, 'John', 'Smith', 'Mr'),
     (2, 'Alice', 'Jones', 'Mrs.'),
     (3, 'Jane', 'Doe', 'Miss'),
     (4, 'Dave', 'Brown', 'Mr').
*/