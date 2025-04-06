----- Patient Demographics Repor ----------

SELECT
    gender,
    COUNT(*) AS patient_count,
    ROUND(AVG(MONTHS_BETWEEN(SYSDATE, birth_date)/12)) AS avg_age,
    MIN(registration_date) AS earliest_registration,
    MAX(registration_date) AS latest_registration
FROM patients
GROUP BY gender
ORDER BY patient_count DESC;


----- Appointment Volume by Department-----
SELECT
    d.department,
    COUNT(a.appointment_id) AS appointment_count,
    SUM(CASE WHEN a.status = 'Completed' THEN 1 ELSE 0 END) AS completed_count,
    SUM(CASE WHEN a.status = 'No-Show' THEN 1 ELSE 0 END) AS no_show_count,
    ROUND(SUM(CASE WHEN a.status = 'No-Show' THEN 1 ELSE 0 END) * 100.0 /
        NULLIF(COUNT(a.appointment_id), 0), 2) AS no_show_rate
FROM appointments a
JOIN doctors d ON a.doctor_id = d.doctor_id
WHERE a.appointment_date BETWEEN TO_DATE('2023-01-01', 'YYYY-MM-DD')
    AND TO_DATE('2023-12-31', 'YYYY-MM-DD')
GROUP BY d.department
ORDER BY appointment_count DESC;


---- Diagnos Report ----
SELECT
    diagnosis,
    COUNT(*) AS diagnosis_count,
    COUNT(DISTINCT patient_id) AS unique_patients
FROM medical_records
WHERE visit_date >= ADD_MONTHS(TRUNC(SYSDATE), -6)
GROUP BY diagnosis
ORDER BY diagnosis_count DESC
FETCH FIRST 20 ROWS ONLY;


-----Medication prescription trends ------

SELECT
    m.name AS medication,
    m.category,
    COUNT(p.prescription_id) AS prescription_count,
    COUNT(DISTINCT p.patient_id) AS unique_patients,
    COUNT(DISTINCT p.doctor_id) AS prescribing_doctors
FROM prescriptions p
JOIN medications m ON p.medication_id = m.medication_id
WHERE p.prescription_date BETWEEN TO_DATE('2023-01-01', 'YYYY-MM-DD')
    AND TO_DATE('2023-03-31', 'YYYY-MM-DD')
GROUP BY m.name, m.category
ORDER BY prescription_count DESC;


-----Abnormal Lab Result Alert --------


SELECT
    p.patient_id,
    p.first_name,
    p.last_name,
    l.test_name,
    l.result_value,
    l.unit,
    l.reference_range,
    l.test_date,
    d.first_name AS doctor_first_name,
    d.last_name AS doctor_last_name
FROM lab_results l
JOIN patients p ON l.patient_id = p.patient_id
JOIN doctors d ON l.doctor_id = d.doctor_id
WHERE l.abnormal_flag = 'Y'
AND l.test_date >= TRUNC(SYSDATE) - 7
ORDER BY l.test_date DESC;


--- Patient Readmission Analysis -----

WITH patient_visits AS (
    SELECT
        patient_id,
        visit_date,
        LEAD(visit_date) OVER (PARTITION BY patient_id ORDER BY visit_date) AS next_visit_date
    FROM medical_records
)
SELECT
    p.patient_id,
    pat.first_name,
    pat.last_name,
    p.visit_date,
    p.next_visit_date,
    p.next_visit_date - p.visit_date AS days_between_visits
FROM patient_visits p
JOIN patients pat ON p.patient_id = pat.patient_id
WHERE p.next_visit_date IS NOT NULL
AND p.next_visit_date - p.visit_date <= 30
ORDER BY days_between_visits;

;


----Patient Risk -----

WITH patient_metrics AS (
    SELECT
        p.patient_id,
        p.first_name,
        p.last_name,
        COUNT(DISTINCT mr.diagnosis) AS unique_diagnoses,
        COUNT(DISTINCT pr.medication_id) AS unique_medications,
        MAX(l.result_value) AS max_glucose,
        MAX(CASE WHEN l.test_name = 'LDL Cholesterol' THEN l.result_value ELSE NULL END) AS max_ldl
    FROM patients p
    LEFT JOIN medical_records mr ON p.patient_id = mr.patient_id
    LEFT JOIN prescriptions pr ON p.patient_id = pr.patient_id
    LEFT JOIN lab_results l ON p.patient_id = l.patient_id
    WHERE mr.visit_date >= ADD_MONTHS(SYSDATE, -12)
    GROUP BY p.patient_id, p.first_name, p.last_name
)
SELECT
    patient_id,
    first_name,
    last_name,
    unique_diagnoses,
    unique_medications,
    max_glucose,
    max_ldl,
    CASE
        WHEN unique_diagnoses > 5 OR unique_medications > 3 OR max_glucose > 140 OR max_ldl > 160 THEN 'High Risk'
        WHEN unique_diagnoses > 2 OR unique_medications > 1 OR max_glucose > 100 OR max_ldl > 130 THEN 'Medium Risk'
        ELSE 'Low Risk'
    END AS risk_category
FROM patient_metrics
ORDER BY
    CASE
        WHEN unique_diagnoses > 5 OR unique_medications > 3 OR max_glucose > 140 OR max_ldl > 160 THEN 1
        WHEN unique_diagnoses > 2 OR unique_medications > 1 OR max_glucose > 100 OR max_ldl > 130 THEN 2
        ELSE 3
    END,
    last_name, first_name;



--- Real Time Emergency -----

SELECT
    TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS') AS report_time,
    (SELECT COUNT(*) FROM appointments
     WHERE status = 'In Progress'
     AND doctor_id IN (SELECT doctor_id FROM doctors WHERE department = 'Emergency')) AS current_er_patients,
    (SELECT COUNT(*) FROM lab_results
     WHERE test_date = TRUNC(SYSDATE)
     AND abnormal_flag = 'Y'
     AND doctor_id IN (SELECT doctor_id FROM doctors WHERE department = 'Emergency')) AS abnormal_results_today,
    (SELECT ROUND(AVG((SYSDATE - appointment_date) * 24 * 60), 1)
     FROM appointments
     WHERE status = 'In Progress'
     AND doctor_id IN (SELECT doctor_id FROM doctors WHERE department = 'Emergency')) AS avg_wait_time_minutes,
    (SELECT COUNT(DISTINCT patient_id)
     FROM medical_records
     WHERE visit_date >= TRUNC(SYSDATE)
     AND doctor_id IN (SELECT doctor_id FROM doctors WHERE department = 'Emergency')
     AND diagnosis IN ('Myocardial Infarction', 'Stroke', 'Sepsis')) AS critical_cases_today
FROM dual;




