/* ------------------------- Zibil Qutusunun Sorgulanması ------------------------- */
/*
   Zibil qutusunda (Recycle Bin) olan silinmiş obyektləri sorğulamaq üçün istifadə olunur.
   - `RECYCLEBIN`: Cari istifadəçinin zibil qutusundakı bütün obyektləri göstərir.
   - `USER_RECYCLEBIN`: Cari istifadəçinin zibil qutusundakı obyektləri göstərir (daha ətraflı məlumatla).
*/
SELECT * FROM RECYCLEBIN;
SELECT * FROM USER_RECYCLEBIN;

/* Nəticə:
   - Zibil qutusunda olan bütün silinmiş cədvəllər, indekslər və digər obyektlər göstərilir.
   - Hər bir obyektin adı, silinmə tarixi və bərpa edilə biləcəyi məlumatlar göstərilir.
*/

/* ------------------------- Təkrarlanan Məlumatların Qarşısının Alınması ------------------------- */
/*
   Bu hissədə `job_history` cədvəlində təkrarlanan məlumatların qarşısını almaq üçün yeni bir cədvəl yaradılır.
   - `temporary` adlı yeni cədvəl yaradılır və `hr.job_history` cədvəlindən məlumatlar köçürülür.
   - Köhnə `job_history` cədvəli silinir.
   - Yeni cədvəl `job_history` adı ilə yenidən adlandırılır.
*/
CREATE TABLE temporary
   (employee_id, start_date, end_date, job_id, dept_id)
AS SELECT
     employee_id, start_date, end_date, job_id, department_id
FROM hr.job_history;

/* Nəticə:
   - `temporary` cədvəli yaradılır və `hr.job_history` cədvəlindən məlumatlar köçürülür.
*/

/* Köhnə `job_history` cədvəli silinir. */
DROP TABLE job_history;

/* Nəticə:
   - `job_history` cədvəli zibil qutusuna köçürülür.
*/

/* Yeni cədvəl `job_history` adı ilə yenidən adlandırılır. */
RENAME temporary TO job_history;

/* Nəticə:
   - `temporary` cədvəlinin adı `job_history` olaraq dəyişdirilir.
   - Artıq `job_history` cədvəli təkrarlanan məlumatlar olmadan istifadəyə hazırdır.
*/