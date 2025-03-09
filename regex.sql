/* ------------------------- REGEXP_LIKE Funksiyası ------------------------- */
/*
   Bu funksiya mətnin müəyyən bir şablona uyğun olub-olmadığını yoxlayır.
   Nəticə TRUE və ya FALSE olaraq qaytarılır.
*/

/* Nümunə 1: E-poçt ünvanının doğruluğunu yoxlama */
SELECT email,
       REGEXP_LIKE(email, '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$') AS is_valid_email
FROM employees;

/* Nəticə:
   - `is_valid_email` sütunu TRUE və ya FALSE olaraq qaytarılır.
   - TRUE: E-poçt ünvanı düzgün formatdadır.
   - FALSE: E-poçt ünvanı düzgün formatda deyil.
*/

/* Nümunə 2: Telefon nömrəsinin formatını yoxlama */
SELECT phone_number,
       REGEXP_LIKE(phone_number, '^\(\d{3}\) \d{3}-\d{4}$') AS is_valid_phone
FROM employees;

/* Nəticə:
   - `is_valid_phone` sütunu TRUE və ya FALSE olaraq qaytarılır.
   - TRUE: Telefon nömrəsi düzgün formatdadır.
   - FALSE: Telefon nömrəsi düzgün formatda deyil.
*/

/* ------------------------- REGEXP_SUBSTR Funksiyası ------------------------- */
/*
   Bu funksiya mətndən müəyyən bir şablona uyğun olan hissəni çıxarır.
*/

/* Nümunə 3: Mətndən rəqəmləri çıxarma */
SELECT 'Salam123Dunya456' AS original_text,
       REGEXP_SUBSTR('Salam123Dunya456', '\d+') AS extracted_number
FROM dual;

/* Nəticə:
ORIGINAL_TEXT       EXTRACTED_NUMBER
------------------- -----------------
Salam123Dunya456    123
*/

/* Nümunə 4: Mətndən e-poçt ünvanını çıxarma */
SELECT 'Contact us at info@example.com or support@test.org' AS original_text,
       REGEXP_SUBSTR('Contact us at info@example.com or support@test.org', '[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}') AS extracted_email
FROM dual;

/* Nəticə:
ORIGINAL_TEXT                                       EXTRACTED_EMAIL
-------------------------------------------------- -----------------
Contact us at info@example.com or support@test.org  info@example.com
*/

/* ------------------------- REGEXP_REPLACE Funksiyası ------------------------- */
/*
   Bu funksiya mətndə müəyyən bir şablona uyğun olan hissəni başqa bir mətnlə əvəz edir.
*/

/* Nümunə 5: Mətndəki rəqəmləri "*" ilə əvəz etmək */
SELECT 'Salam123Dunya456' AS original_text,
       REGEXP_REPLACE('Salam123Dunya456', '\d', '*') AS replaced_text
FROM dual;

/* Nəticə:
ORIGINAL_TEXT       REPLACED_TEXT
------------------- -----------------
Salam123Dunya456    Salam***Dunya***
*/

/* Nümunə 6: Mətndəki boşluqları "-" ilə əvəz etmək */
SELECT 'Salam Dunya 2023' AS original_text,
       REGEXP_REPLACE('Salam Dunya 2023', '\s', '-') AS replaced_text
FROM dual;

/* Nəticə:
ORIGINAL_TEXT       REPLACED_TEXT
------------------- -----------------
Salam Dunya 2023    Salam-Dunya-2023
*/

/* ------------------------- REGEXP_INSTR Funksiyası ------------------------- */
/*
   Bu funksiya mətndə müəyyən bir şablona uyğun olan hissənin başlanğıc mövqeyini tapır.
*/

/* Nümunə 7: Mətndəki ilk rəqəmin mövqeyini tapmaq */
SELECT 'Salam123Dunya456' AS original_text,
       REGEXP_INSTR('Salam123Dunya456', '\d') AS first_digit_position
FROM dual;

/* Nəticə:
ORIGINAL_TEXT       FIRST_DIGIT_POSITION
------------------- --------------------
Salam123Dunya456    6
*/

/* Nümunə 8: Mətndəki ilk e-poçt ünvanının mövqeyini tapmaq */
SELECT 'Contact us at info@example.com or support@test.org' AS original_text,
       REGEXP_INSTR('Contact us at info@example.com or support@test.org', '[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}') AS first_email_position
FROM dual;

/* Nəticə:
ORIGINAL_TEXT                                       FIRST_EMAIL_POSITION
-------------------------------------------------- --------------------
Contact us at info@example.com or support@test.org  15
*/

/* ------------------------- REGEXP_COUNT Funksiyası ------------------------- */
/*
   Bu funksiya mətndə müəyyən bir şablona uyğun olan hissələrin sayını qaytarır.
*/

/* Nümunə 9: Mətndəki rəqəmlərin sayını tapmaq */
SELECT 'Salam123Dunya456' AS original_text,
       REGEXP_COUNT('Salam123Dunya456', '\d') AS digit_count
FROM dual;

/* Nəticə:
ORIGINAL_TEXT       DIGIT_COUNT
------------------- -----------
Salam123Dunya456    6
*/

/* Nümunə 10: Mətndəki sözlərin sayını tapmaq */
SELECT 'Salam Dunya 2023' AS original_text,
       REGEXP_COUNT('Salam Dunya 2023', '\w+') AS word_count
FROM dual;

/* Nəticə:
ORIGINAL_TEXT       WORD_COUNT
------------------- ----------
Salam Dunya 2023    3
*/