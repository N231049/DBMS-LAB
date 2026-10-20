USE taxation_db;

# part E
-- task 1
SELECT CURRENT_USER();

SELECT *
FROM taxation_db.income_record
LIMIT 5;

UPDATE taxation_db.income_record
SET amount = amount + 100
WHERE income_id = 9999;

DELETE FROM taxation_db.income_record
WHERE income_id = 9999;

-- task 6:
SELECT *
FROM taxation_db.income_record
LIMIT 5;

INSERT INTO taxation_db.income_record
(
    income_id,
    taxpayer_id,
    income_source,
    amount,
    received_date,
    remarks,
    category_id,
    year_id
)
VALUES
(
    9996,
    101,
    'Data Entry Test',
    45000,
    CURRENT_DATE,
    'Testing minimum privilege',
    1,
    1
);

UPDATE taxation_db.income_record
SET amount = 50000
WHERE income_id = 9996;

DELETE FROM taxation_db.income_record
WHERE income_id = 9996;

## part f
-- task 1
SELECT CURRENT_USER();

START TRANSACTION;

INSERT INTO taxation_db.income_record
(
    income_id,
    taxpayer_id,
    income_source,
    amount,
    received_date,
    remarks,
    category_id,
    year_id
)
VALUES
(
    9995,
    101,
    'Annual Income',
    75000,
    CURRENT_DATE,
    'TCL + DCL test',
    1,
    1
);

SELECT *
FROM taxation_db.income_record
WHERE income_id = 9995;

COMMIT;

SELECT *
FROM taxation_db.income_record
WHERE income_id = 9995;

-- task 4
SELECT CURRENT_USER();

SELECT *
FROM taxation_db.income_record;

START TRANSACTION;

INSERT INTO taxation_db.income_record
(income_id, taxpayer_id, income_source, amount, received_date, remarks, category_id, year_id)
VALUES
(9997, 1, 'Minimum Privilege Test', 25000.00, '2026-10-14',
 'Inserted by tax_data_entry', 1, 1);

SELECT *
FROM taxation_db.income_record
WHERE income_id = 9997;

COMMIT;

UPDATE taxation_db.income_record
SET amount = 50000
WHERE income_id = 9997;

DELETE FROM taxation_db.income_record
WHERE income_id = 9997;

-- TASK 6
SELECT CURRENT_USER();
UPDATE taxation_db.income_record
SET amount = 50000
WHERE income_id = 9997;
