SELECT last_name "Employee", CONNECT_BY_ISLEAF "IsLeaf",
       LEVEL, SYS_CONNECT_BY_PATH(last_name, '/') "Path"
  FROM employees
  WHERE LEVEL <= 3 AND department_id = 80
  START WITH employee_id = 100
  CONNECT BY PRIOR employee_id = manager_id AND LEVEL <= 4
  ORDER BY "Employee", "IsLeaf";

-- Employee                      IsLeaf      LEVEL Path
-- ------------------------- ---------- ---------- -------------------------
-- Abel                               1          3 /King/Zlotkey/Abel
-- Ande                               1          3 /King/Errazuriz/Ande
-- Banda                              1          3 /King/Errazuriz/Banda
-- Bates                              1          3 /King/Cambrault/Bates
-- Bernstein                          1          3 /King/Russell/Bernstein
-- Bloom                              1          3 /King/Cambrault/Bloom
-- Cambrault                          0          2 /King/Cambrault
-- Cambrault                          1          3 /King/Russell/Cambrault
-- Doran                              1          3 /King/Partners/Doran
-- Errazuriz                          0          2 /King/Errazuriz
-- Fox                                1          3 /King/Cambrault/Fox
-- . . .