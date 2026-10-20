use taxation_db;

# part e
-- task 2
SELECT CURRENT_USER();

SELECT *
FROM taxation_db.income_record
LIMIT 5;

UPDATE taxation_db.income_record
SET amount = amount + 100
WHERE income_id = 9999;

DELETE FROM taxation_db.income_record
WHERE income_id = 9999;


-- TASK 3
SELECT *
FROM taxation_db.taxation_summary;

-- TASK 4
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
    9997,
    101,
    'Officer Test Income',
    50000,
    CURRENT_DATE,
    'Testing INSERT after UPDATE revoke',
    1,
    1
);

UPDATE taxation_db.income_record
SET amount = amount + 100
WHERE income_id = 9997;