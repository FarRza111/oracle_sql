/* Hər Bir Sətirin İzahı
Sətir 0: SEÇİM İFADƏSİ
Id: 0 - Bu, icra edilən SQL ifadəsinin ümumi əməliyyatıdır.
Əməliyyat: SEÇİM İFADƏSİ - Bu, bir SEÇİM sorğusunu göstərir.
Sıra: 1 - Optimallaşdırıcı, sorğunun 1 sıra qaytaracağını proqnozlaşdırır.
Bayt: 3 - Qaytarılacaq məlumatın təxmini ölçüsü (baytlarla).
Xərc (%CPU): 1 (0) - İfadənin icrası üçün təxmini xərc 1-dir, CPU istifadəsi 0% olaraq proqnozlaşdırılır.
Vaxt: 00:00:01 - Bu hissənin icrası üçün təxmini vaxt 1 saniyədir.
Sətir 1: QRUPLAMA ÜZRƏ SIRALAMA
Id: 1 - Bu, qruplaşdırma üçün verilənlərin sıralanmasını göstərir.
Əməliyyat: QRUPLAMA ÜZRƏ SIRALAMA - Qaytarılan nəticələrin qruplaşdırıldığını, amma sıralama tələb olunmadığını göstərir.
Sıra: 1 - Proqnoz yenə də eynidir, qruplaşdırma sonrası 1 sıra olacağı gözlənilir.
Bayt: 3 - Qruplaşdırılmış nəticənin ölçüsü dəyişmir.
Xərc (%CPU): 1 (0) - Xərc hələ də aşağıdır, bu da səmərəliliyi göstərir.
Vaxt: 00:00:01 - İcra vaxtı hələ də eynidir.
Sətir 2: İNDİKS ARALIĞI SÜZGÜS
Id: 2 - Bu əməliyyat, məlumatları əldə etmək üçün bir indeksi skan edir.
Əməliyyat: İNDİKS ARALIĞI SÜZGÜS - Sorğunun müəyyən şərtləri qarşılayan sıraları tapmaq üçün bir indeksi istifadə etdiyini göstərir.
Ad: EMP_DEPARTMENT_IX - İstifadə olunan indeksin adı. Bu halda, EMPLOYEES cədvəlində DEPARTMENT_ID sütunu üçün bir indeksdir.
Sıra: 11 - Optimallaşdırıcı, bu əməliyyatın təxminən 11 sıra əldə edəcəyini proqnozlaşdırır.
Bayt: 33 - Əldə edilən məlumatın ölçüsü 33 baytdır.
Xərc (%CPU): 1 (0) - Xərc aşağıdır, bu da indeks vasitəsilə səmərəli əldə etməni göstərir.
Vaxt: 00:00:01 - Bu əməliyyatın icrası üçün təxmin edilən vaxt 1 saniyədir */


EXPLAIN PLAN FOR
SELECT department_id, COUNT(*) AS employee_count
FROM hr.employees
WHERE department_id < 50
GROUP BY department_id
ORDER BY department_id;

SELECT * FROM table(DBMS_XPLAN.DISPLAY);

