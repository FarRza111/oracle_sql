-- İşçilər cədvəlini yaradın
-- hr.employees cədvəlindən bütün məlumatları seçin

SELECT last_name, employee_id, salary + NVL(commission_pct, 0), 
       job_id, e.department_id
  /* Pataballa'nın kompensasiya məbləğindən artıq olan bütün işçiləri seçin. */
  FROM hr.employees e, hr.departments d
  /* DEPARTMENTS cədvəli departament adını əldə etmək üçün istifadə olunur. */
  WHERE e.department_id = d.department_id
    AND salary + NVL(commission_pct, 0) >   /* Alt sorğu:       */
      (SELECT salary + NVL(commission_pct, 0)
        /* ümumi kompensasiya maaş + komissiya_pct */
        FROM employees 
        WHERE last_name = 'Pataballa')
  ORDER BY last_name, employee_id;

SELECT last_name,                                   -- adını seçin
       employee_id                                  -- işçi id-si
       salary + NVL(commission_pct, 0),             -- ümumi kompensasiya
       job_id,                                      -- iş
       e.department_id                              -- və departament
  FROM employees e,                                 -- bütün işçilərin
       departments d
  WHERE e.department_id = d.department_id
    AND salary + NVL(commission_pct, 0) >           -- kompensasiyası
                                                    -- Pataballa'nınkından artıq olan
        (SELECT salary + NVL(commission_pct, 0)      -- Pataballa'nın kompensasiyası
          FROM employees 
          WHERE last_name = 'Pataballa')            -- Pataballa'nın adı
  ORDER BY last_name                                -- və soyadına görə sırala
           employee_id;                             -- və işçi id-sinə görə.
