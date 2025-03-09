/*=====================================
=         STRING FUNKSIYALARI         =
=====================================*/
SELECT
    UPPER('azerbaycan') AS Boyuk_Herf,
    LOWER('Bakı') AS Kicik_Herf,
    INITCAP('bakİ şəhƏrİ') AS Baş_Herf,
    CONCAT('Salam ', 'Dünya!') AS Birlesdirme,
    SUBSTR('AZERBAYCAN', 5, 4) AS Parca,
    LENGTH('Azərbaycan') AS Uzunluq,
    INSTR('Post Ofisi', 'Ofis') AS Mövqe,
    TRIM('   Salam   ') AS Kesilmis,
    LPAD('123', 5, '0') AS SoldanDolum,
    RPAD('123', 5, '*') AS SagdanDolum,
    REPLACE('Salam Dünya', 'Dünya', 'Azərbaycan') AS Evezleme
FROM dual;

------------------------------------------------------------

/*=====================================
=         NUMBER FUNKSIYALARI         =
=====================================*/
SELECT
    ROUND(123.456, 2) AS Yuvarlaq,
    TRUNC(123.456, 1) AS Kesilmis,
    MOD(10, 3) AS Qaliq,
    FLOOR(8.9) AS AsagiTam,
    CEIL(8.1) AS YuxariTam,
    ABS(-25) AS Mutleq,
    POWER(2, 3) AS Qüvvət,
    SQRT(16) AS KvadratKök
FROM dual;

------------------------------------------------------------

/*=====================================
=         DATE FUNKSIYALARI          =
=====================================*/
SELECT
    SYSDATE AS Sistem_Tarix,
    CURRENT_DATE AS Sessiya_Tarix,
    ADD_MONTHS(SYSDATE, 3) AS Uc_Ay_Sonra,
    MONTHS_BETWEEN(TO_DATE('2024-12-01', 'YYYY-MM-DD'), SYSDATE) AS Ay_Ferqi,
    NEXT_DAY(SYSDATE, 'MONDAY') AS Novbeti_BazarErtesi,
    LAST_DAY(SYSDATE) AS Ayin_Sonu,
    ROUND(SYSDATE, 'MONTH') AS Ay_Uzre_Yuvarlaq,
    TRUNC(SYSDATE, 'YEAR') AS Ilin_Basi,
    EXTRACT(YEAR FROM SYSDATE) AS Cari_Il
FROM dual;

------------------------------------------------------------

/*=====================================
=      CONVERSION FUNKSIYALARI        =
=====================================*/
SELECT
    TO_CHAR(SYSDATE, 'DD-MM-YYYY') AS Tarix_Str,
    TO_CHAR(12345.67, '99999.99') AS Eded_Str,
    TO_DATE('01-03-2025', 'DD-MM-YYYY') AS Tarix_Format,
    TO_NUMBER('12345') + 100 AS Eded_Toplama,
    CAST('2024-03-01' AS DATE) AS Cast_Edilmis
FROM dual;

------------------------------------------------------------

/*=====================================
=        GENERAL FUNKSIYALAR          =
=====================================*/
SELECT
    NVL(NULL, 'Deyeri yoxdur') AS Yoxlama,
    NVL2('Salam', 'Dolu', 'Bos') AS DoluMu,
    NULLIF(10, 10) AS NullDondur,
    COALESCE(NULL, NULL, 'Birinci Dolu') AS IlkDolu,

    -- DECODE nümunəsi
    DECODE(2, 1, 'Bir', 2, 'Iki', 'Digər') AS Decode_Ifade,

    -- CASE nümunəsi
    CASE
        WHEN 90 >= 90 THEN 'Əla'
        WHEN 90 >= 70 THEN 'Yaxşı'
        ELSE 'Zəif'
    END AS Qiymet
FROM dual;
