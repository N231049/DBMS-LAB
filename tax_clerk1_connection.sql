# part D 
-- task 2
SELECT CURRENT_USER();

SELECT *
FROM taxation_db.taxpayer;

UPDATE taxation_db.taxpayer
SET full_name = 'Test'
WHERE taxpayer_id = 101;

-- task 3
USE taxation_db;
SELECT CURRENT_USER();

INSERT INTO income_record
(income_id, taxpayer_id, income_source, amount, received_date, remarks,category_id,year_id)
VALUES
(9999, 101, 'DCL test income', 600000, CURRENT_DATE, 'insert privilege test',3,2);

-- task 4
SELECT CURRENT_USER();

-- error
UPDATE taxation_db.income_record
SET amount = 60000
WHERE income_id = 9999;


-- task 5
SELECT CURRENT_USER();

SELECT * FROM taxation_db.taxation_summary;

-- task 6
SELECT CURRENT_USER();
INSERT INTO taxation_db.income_record
(income_id,taxpayer_id,income_source,amount,received_date,remarks,category_id,year_id)
VALUES
(9998,101,'DCL Revoke Test',50000,CURREENT_DATE,'Testing revoked INSERT privilege',1,1);

# PART F
-- TASK 5
SELECT CURRENT_USER();

SELECT *
FROM taxation_db.taxation_summary;
SELECT *
FROM taxation_db.income_record;


