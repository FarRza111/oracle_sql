/*====================================================================
=                 BANK MÜƏSSƏSƏSİ MƏLUMATLAR BAZASI PROYEKTI         =
=                                                                    =
=  Tapşırıq:                                                         =
=  Siz FinTech şirkətində işləyən bir verilənlər bazası memarısınız. =
=  Bu şirkət onlayn bank xidmətləri göstərir və gündə milyonlarla    =
=  əməliyyat icra edir. Sizin əsas vəzifəniz yüksək performanslı,    =
=  bölünmüş (partitioned) və effektiv işləyən verilənlər bazası       =
=  modeli yaratmaqdır.                                               =
=                                                                    =
=  Tələblər:                                                         =
=  1. Müştərilər, hesablar və əməliyyatlar üçün cədvəllər yaradın.   =
=  2. Əməliyyatlar cədvəlini tarixə görə partition edin.             =
=  3. Dataları daxil edin və nümunə məlumatlar əlavə edin.           =
=  4. Müxtəlif mürəkkəb SQL sorğuları yazın (JOIN, GROUP BY, WINDOW).=
=  5. Hesabatlar üçün VIEW-lar yaradın.                              =
=  6. Transaction idarəetməsi ilə əməliyyat blokları hazırlayın.     =
=                                                                    =
=  Bonus (əlavə tapşırıqlar):                                        =
=  - CHECK constraint ilə balansı sıfırdan aşağı düşməyə qoymayın.   =
=  - Yeni partition əlavə edin (2025 və sonrası).                   =
=  - PL/SQL prosedur ilə faiz hesablama mexanizmi hazırlayın.        =
=====================================================================*/


/*=====================================
=          1. CƏDVƏLLƏRİN YARADILMASI =
=          PARTITION və AÇARLAR       =
=====================================*/

-- 1.1 Müştərilər Cədvəli (Customers)
CREATE TABLE Customers (
    CustomerID NUMBER PRIMARY KEY,
    FirstName VARCHAR2(50),
    LastName VARCHAR2(50),
    Email VARCHAR2(100),
    PhoneNumber VARCHAR2(20),
    RegistrationDate DATE
);

-- 1.2 CustomerID üçün sıra (SEQUENCE)
CREATE SEQUENCE seq_CustomerID START WITH 1 INCREMENT BY 1;

-- 1.3 Müştərilər üçün avtomatik artırma (TRIGGER)
CREATE OR REPLACE TRIGGER trg_Customers_BI
BEFORE INSERT ON Customers
FOR EACH ROW
BEGIN
    :NEW.CustomerID := seq_CustomerID.NEXTVAL;
END;
/

------------------------------------------------------------

-- 1.4 Hesablar Cədvəli (Accounts)
CREATE TABLE Accounts (
    AccountID NUMBER PRIMARY KEY,
    CustomerID NUMBER,
    AccountNumber VARCHAR2(20) UNIQUE,
    AccountType VARCHAR2(20), -- 'Checking', 'Savings'
    Balance NUMBER(12, 2) DEFAULT 0,
    OpenDate DATE,
    CONSTRAINT fk_Account_Customer FOREIGN KEY (CustomerID)
        REFERENCES Customers (CustomerID)
);

-- 1.5 AccountID üçün sıra (SEQUENCE)
CREATE SEQUENCE seq_AccountID START WITH 1 INCREMENT BY 1;

-- 1.6 Hesablar üçün avtomatik artırma (TRIGGER)
CREATE OR REPLACE TRIGGER trg_Accounts_BI
BEFORE INSERT ON Accounts
FOR EACH ROW
BEGIN
    :NEW.AccountID := seq_AccountID.NEXTVAL;
END;
/

------------------------------------------------------------

-- 1.7 Əməliyyatlar Cədvəli (Transactions), Partition ilə
CREATE TABLE Transactions (
    TransactionID NUMBER PRIMARY KEY,
    AccountID NUMBER,
    TransactionDate DATE,
    TransactionType VARCHAR2(20), -- 'Deposit', 'Withdrawal', 'Transfer'
    Amount NUMBER(12, 2),
    Description VARCHAR2(200),
    CONSTRAINT fk_Transaction_Account FOREIGN KEY (AccountID)
        REFERENCES Accounts (AccountID)
)
PARTITION BY RANGE (TransactionDate) (
    PARTITION trans_2023 VALUES LESS THAN (TO_DATE('2024-01-01', 'YYYY-MM-DD')),
    PARTITION trans_2024 VALUES LESS THAN (TO_DATE('2025-01-01', 'YYYY-MM-DD'))
);

-- 1.8 TransactionID üçün sıra (SEQUENCE)
CREATE SEQUENCE seq_TransactionID START WITH 1 INCREMENT BY 1;

-- 1.9 Əməliyyatlar üçün avtomatik artırma (TRIGGER)
CREATE OR REPLACE TRIGGER trg_Transactions_BI
BEFORE INSERT ON Transactions
FOR EACH ROW
BEGIN
    :NEW.TransactionID := seq_TransactionID.NEXTVAL;
END;
/

/*=====================================
=         2. NÜMUNƏ MƏLUMATLARIN DAXİL EDİLMƏSİ        =
=====================================*/

-- 2.1 Müştəri Məlumatları (Customers)
INSERT INTO Customers (FirstName, LastName, Email, PhoneNumber, RegistrationDate)
VALUES ('Aysel', 'Hüseynova', 'aysel.huseynova@example.com', '050-123-45-67', TO_DATE('2023-06-15', 'YYYY-MM-DD'));

INSERT INTO Customers (FirstName, LastName, Email, PhoneNumber, RegistrationDate)
VALUES ('Elvin', 'Məmmədov', 'elvin.mammadov@example.com', '050-987-65-43', TO_DATE('2023-07-10', 'YYYY-MM-DD'));

------------------------------------------------------------

-- 2.2 Hesab Məlumatları (Accounts)
INSERT INTO Accounts (CustomerID, AccountNumber, AccountType, Balance, OpenDate)
VALUES (1, 'AZE12345678', 'Checking', 5000, TO_DATE('2023-06-20', 'YYYY-MM-DD'));

INSERT INTO Accounts (CustomerID, AccountNumber, AccountType, Balance, OpenDate)
VALUES (2, 'AZE87654321', 'Savings', 12000, TO_DATE('2023-07-12', 'YYYY-MM-DD'));

------------------------------------------------------------

-- 2.3 Əməliyyatlar (Transactions)
INSERT INTO Transactions (AccountID, TransactionDate, TransactionType, Amount, Description)
VALUES (1, TO_DATE('2023-08-01', 'YYYY-MM-DD'), 'Deposit', 1000, 'Əmək haqqı köçürməsi');

INSERT INTO Transactions (AccountID, TransactionDate, TransactionType, Amount, Description)
VALUES (1, TO_DATE('2023-08-02', 'YYYY-MM-DD'), 'Withdrawal', 200, 'ATM çıxarışı');

INSERT INTO Transactions (AccountID, TransactionDate, TransactionType, Amount, Description)
VALUES (2, TO_DATE('2024-01-10', 'YYYY-MM-DD'), 'Deposit', 5000, 'Bonus ödənişi');

/*=====================================
=        3. MÜRƏKKƏB SQL SORĞULARI    =
=====================================*/

-- 3.1 Hər Müştərinin Ümumi Balansı
SELECT
    c.FirstName || ' ' || c.LastName AS Müştəri_Adı,
    SUM(a.Balance) AS Ümumi_Balans
FROM Customers c
JOIN Accounts a ON c.CustomerID = a.CustomerID
GROUP BY c.FirstName, c.LastName
ORDER BY Ümumi_Balans DESC;

------------------------------------------------------------

-- 3.2 Aylıq Əməliyyat Xülasəsi (WINDOW funksiyası ilə)
SELECT
    a.AccountNumber,
    TO_CHAR(t.TransactionDate, 'YYYY-MM') AS Ay,
    SUM(t.Amount) OVER (PARTITION BY a.AccountNumber, TO_CHAR(t.TransactionDate, 'YYYY-MM')) AS Aylıq_Yekun
FROM Transactions t
JOIN Accounts a ON t.AccountID = a.AccountID
ORDER BY a.AccountNumber, Ay;

------------------------------------------------------------

-- 3.3 Son 6 Ayda Heç Bir Əməliyyat Etməyən Müştərilər
SELECT c.FirstName, c.LastName
FROM Customers c
WHERE NOT EXISTS (
    SELECT 1
    FROM Accounts a
    JOIN Transactions t ON a.AccountID = t.AccountID
    WHERE a.CustomerID = c.CustomerID
    AND t.TransactionDate >= ADD_MONTHS(SYSDATE, -6)
);

/*=====================================
=           4. VIEW-LARIN YARADILMASI =
=====================================*/

-- 4.1 Ən Yuxarı Müştərilər üzrə VIEW
CREATE OR REPLACE VIEW TopCustomers AS
SELECT
    c.CustomerID,
    c.FirstName || ' ' || c.LastName AS Tam_Ad,
    SUM(a.Balance) AS Ümumi_Balans
FROM Customers c
JOIN Accounts a ON c.CustomerID = a.CustomerID
GROUP BY c.CustomerID, c.FirstName, c.LastName
HAVING SUM(a.Balance) > 10000;

------------------------------------------------------------

-- 4.2 VIEW-dən Sorğu
SELECT * FROM TopCustomers;

/*=====================================
=    5. TRANSAKSIYA İDARƏETMƏ BLOKLARI  =
=====================================*/

-- 5.1 İki Hesab Arasında Köçürmə (Transaction Bloku)
SAVEPOINT ondan_əvvəl;

-- Hesab 1-dən 500 çıxılır
UPDATE Accounts
SET Balance = Balance - 500
WHERE AccountID = 1;

-- Hesab 2-yə 500 əlavə olunur
UPDATE Accounts
SET Balance = Balance + 500
WHERE AccountID = 2;

-- Əgər hər şey düzgündürsə
COMMIT;

-- Problem olarsa
-- ROLLBACK TO ondan_əvvəl;

/*=====================================
=       6. ƏLAVƏ TAPŞIRIQLAR (BONUS)  =
=====================================*/

-- 6.1 2025 və sonrası üçün yeni partition əlavə etmək
ALTER TABLE Transactions
ADD PARTITION trans_2025 VALUES LESS THAN (TO_DATE('2026-01-01', 'YYYY-MM-DD'));

------------------------------------------------------------

-- 6.2 TransactionDate sütununa index əlavə etmək
CREATE INDEX idx_Transactions_TransactionDate
ON Transactions (TransactionDate);

------------------------------------------------------------

-- 6.3 Balansın mənfi olmasının qarşısını alan CHECK constraint
ALTER TABLE Accounts
ADD CONSTRAINT chk_Balance_Positive CHECK (Balance >= 0);

------------------------------------------------------------

-- 6.4 Faizlərin hesablanması üçün prosedur (Savings hesablarına 1% əlavə olunur)
CREATE OR REPLACE PROCEDURE ApplyMonthlyInterest IS
BEGIN
    UPDATE Accounts
    SET Balance = Balance + (Balance * 0.01) -- 1% faiz
    WHERE AccountType = 'Savings';

    COMMIT;
END;
/

/*=====================================
=            SCRIPTLƏRİN SONU         =
=====================================*/
