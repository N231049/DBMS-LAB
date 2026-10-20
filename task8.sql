USE taxation_db;

SELECT *
FROM income_record;

# task 1
-- Disable AUTOCOMMIT, verify its value, start a transaction, modify the income amount of one taxpayer's income record, verify the modified record before committing.
SET AUTOCOMMIT = 0;
SELECT @@AUTOCOMMIT;

START TRANSACTION;

UPDATE income_record
SET amount = amount + 1000
WHERE income_id = 1001;

SELECT * FROM income_record WHERE income_id = 1001;

# TASK 2
-- A taxpayer has corrected their reported annual income.
-- Update the corresponding Income_Record, verify the change, and use COMMIT to permanently save the corrected income.
START TRANSACTION;

UPDATE income_record
SET amount = 60000
WHERE income_id = 1001;

SELECT * FROM income_record WHERE income_id = 1001;

COMMIT;

SELECT * FROM income_record WHERE income_id = 1001;


# Task 3
-- An incorrect income amount was entered for a taxpayer.
-- Modify the income amount , verify the incorrect modification, execute ROLLBACK, and confirm that the original income amount has been restored.
START TRANSACTION;

UPDATE income_record
SET amount = 40000
WHERE income_id = 1001;

SELECT * FROM income_record WHERE income_id = 1001;

ROLLBACK;

SELECT * FROM income_record WHERE income_id = 1001;

# Task 4
-- A new income record was mistakenly entered for a taxpayer.
-- Insert the record, verify its existence, execute ROLLBACK, and confirm that the newly inserted record no longer exists.
START TRANSACTION;

INSERT INTO income_record
( income_id, taxpayer_id, income_source, amount, received_date, remarks,category_id, year_id)
SELECT
	2001,101,'tcl test income',600000,CURRENT_DATE,'rollback test',category_id, year_id
FROM income_record
WHERE income_id = 1001;

SELECT * FROM income_record
WHERE income_id = 2001;

ROLLBACK;

SELECT * FROM income_record where income_id = 2001;
-- Why did we use SELECT inside the INSERT?
-- Because we're saying:
-- "Take valid category/year values from an existing record and create a new record."
-- That avoids you having to guess foreign-key IDs.

# TASK 5
-- An Income record was accidentally deleted during tax-data maintenance.alter
-- Delete the record, verify its absence, execute ROLLBACK, and confir that the oriinal record has benn restored.
START TRANSACTION;

DELETE FROM income_record WHERE income_id = 1002;

SELECT * FROM income_record WHERE income_id = 1002;

ROLLBACK;

SELECT * FROM income_record WHERE income_id = 1002;

# TASK6
-- Perform two different DML operations in a single tranaction - for example, update one income record and insert another income record - and permanently save both operations using COMMIT.
START TRANSACTION;

UPDATE income_record 
SET amount = amount + 3000
WHERE income_id = 1001;

INSERT INTO income_record
(income_id, taxpayer_id, income_source, amount, received_date, remarks, category_id, year_id)
SELECT
	2002, taxpayer_id ,'combined test income', 700000,CURRENT_DATE,'commit test',category_id,year_id
FROM income_record
WHERE income_id = 1001;

SELECT * FROM income_record WHERE income_id IN (1001,2002);

COMMIT;
-- ONE COMMIT CAN COMMIT MULTIPLE DML OPERATIONS IN THE SAME TRANACTION.

## PART C - TCL : SAVEPOINTS

# TASK1
-- Update the annual income of one taxpayer and create a save point then update the income of a second taxpayer.
-- use rollback to savepoint and verify that:
-- The first update remains, the second update is cancelled.
START TRANSACTION;

UPDATE income_record
SET amount = amount + 5000
WHERE income_id = 1001;

SAVEPOINT S1;

UPDATE income_record
SET amount = amount + 10000
WHERE income_id = 1002;

SELECT * FROM income_record
WHERE income_id IN (1001,1002);

ROLLBACK TO SAVEPOINT s1;

SELECT * FROM income_record
WHERE income_id IN (1001,1002);

COMMIT;

# task 2
-- Insert a new income record for one taxpayer.
-- Create a savepoint.
-- Then modify another taxpayer's income record.
-- Rollback to the savepoint and commit the remaining valid change.


# task3:
-- Create two savepoints during a transaction involving different
-- Income_Record entries.
-- Perform additional modifications and rollback to the first savepoint.
-- Verify which modifications remain.
START TRANSACTION;

UPDATE income_record
SET amount = amount + 1000
WHERE income_id = 1001;

SAVEPOINT s1;

UPDATE income_record
SET amount = amount + 2000
WHERE income_id = 1002;

SAVEPOINT S2;

UPDATE income_record 
SET amount = amount + 3000
WHERE income_id = 1003;

SELECT * FROM income_record
WHERE income_id IN (1001, 1002, 1003);

ROLLBACK TO SAVEPOINT s1;

SELECT * FROM income_record
WHERE income_id IN (1001, 1002,1003);

COMMIT;

# task4:
-- 1. Insert a new income record.
-- 2. Update an existing income record.
-- 3. Delete another income record.
-- 4. Create a savepoint before the deletion.
-- 5. Rollback to the savepoint.
-- 6. Commit the valid changes.
-- Verify the final database state
START TRANSACTION;

INSERT INTO income_record
(income_id, taxpayer_id, income_source, amount,  received_date, remarks, category_id, year_id)
SELECT 
	2003, taxpayer_id, 'intergrated Income', 500000,CURRENT_DATE,'integrated test',category_id, year_id
FROM income_record
WHERE income_id = 1001;

UPDATE income_record
SET amount = amount + 4000
WHERE income_id = 1001;

SAVEPOINT before_delete;

DELETE FROM income_record
WHERE income_id = 1002;

SELECT * FROM income_record
WHERE income_id IN (1001,1002,2003);

COMMIT;

# task 5
-- Create a savepoint while modifying an income record.
-- Release the savepoint using: RELEASE SAVEPOINT savepoint_name;
-- then attempt to rollback to the released savepoint and observe the result.
START TRANSACTION;

UPDATE income_record
SET amount = amount + 1000
WHERE income_id = 1001;

SAVEPOINT sp1;

RELEASE SAVEPOINT sp1;

ROLLBACK TO SAVEPOINT sp1; -- release savepoint doesnot undo the update. It only removes the checkpoint. The error occured is the savepoint does  not exist.

# task 6
-- Demostrate the difference between: rollback and rollback to savepoint; using two different Income_record modifications.
START TRANSACTION;

UPDATE income_record
SET amount = amount + 1000
WHERE income_id = 1001;

SAVEPOINT SP1;

UPDATE income_record 
SET amount = amount + 2000
WHERE income_id = 1002;

ROLLBACK TO SAVEPOINT SP1;

SELECT * FROM income_record 
WHERE income_id IN (1001, 1002);

COMMIT;

-- -- --
START TRANSACTION;

UPDATE income_record
SET amount = amount + 1000
WHERE income_id = 1001;

UPDATE income_record
SET amount = amount + 2000
WHERE income_id = 1002;

ROLLBACK;

## PART D - DCL: USERS AND PRIVILEGES
-- Task 1
-- Create a MySQL user named:
-- tax_clerk1
-- Verify that the user has been created and connect using the new credentials.

DROP USER IF EXISTS 'tax_clerk1'@'localhost';

-- create user
CREATE USER 'tax_clerk1'@'localhost'
IDENTIFIED BY 'Tax@123';

-- verify user
SELECT User, Host
FROM mysql.user
WHERE User = 'tax_clerk1';

-- tells which Database account am i currently using
SELECT CURRENT_USER();

# task 2
-- Grant only SELECT privilege on the Taxpayer table to
-- tax_clerk1.
-- Verify the privilege using:
-- SHOW GRANTS FOR 'tax_clerk1'@'localhost';
-- Then connect as tax_clerk1 and test a SELECT operation
GRANT SELECT
ON taxation_db.taxpayer
TO 'tax_clerk1'@'localhost';

SHOW GRANTS FOR 'tax_clerk1'@'localhost';

SELECT *
FROM taxation_db.taxpayer;

UPDATE taxation_db.taxpayer
SET full_name = 'Test'
WHERE taxpayer_id = 101;

# task 3
-- Grant INSERT privilege on Income_Record to tax_clerk1.
-- Verify the privilege and test whether the user can insert a new income record.
SELECT CURRENT_USER();

GRANT INSERT 
ON taxation_db.income_record
TO 'tax_clerk1'@'localhost';

SHOW GRANTS FOR 'tax_clerk1'@'localhost';

# task 4
-- Without granting UPDATE, attempt to modify an existing
-- Income_Record as tax_clerk1.
-- Verify that the operation is denied.

# task 5
-- Grant SELECT privilege on a suitable taxation summary View to
-- tax_clerk1.
-- Test whether the user can retrieve data from the View.
SELECT CURRENT_USER();

CREATE OR REPLACE VIEW taxation_db.taxation_summary AS
SELECT t.taxpayer_id, t.full_name, SUM(i.amount) AS total_income
FROM taxation_db.taxpayer t
JOIN taxation_db.income_record i
ON t.taxpayer_id = i.taxpayer_id
GROUP BY t.taxpayer_id, t.full_name;

GRANT SELECT ON taxation_db.taxation_summary
TO 'tax_clerk1'@'localhost';

SHOW GRANTS FOR 'tax_clerk1'@'localhost';

# Task 6 
-- Revoke the INSERT privilege from tax_clerk1.
-- Verify the privileges again and reconnect as the test user.
-- Attempt an INSERT operation and verify that it is denied.
SELECT CURRENT_USER();

REVOKE INSERT 
ON taxation_db.income_record
FROM 'tax_clerk1'@'localhost';

SHOW GRANTS FOR 'tax_clerk1'@'localhost';

# PART E - DCL: SECUROTY AND LEAST PRIVILEGE

# TASK1 
-- create a user named: tax_data_entry
-- give the user only select and insert on income_record/
-- test both permitted and restricted operations.
SELECT CURRENT_USER();

DROP USER IF EXISTS 'tax_data_entry'@'localhost';
CREATE USER 'tax_data_entry'@'localhost'
IDENTIFIED BY 'Data@123';
SELECT User, Host
FROM mysql.user
WHERE User = 'tax_data_entry';

GRANT SELECT, INSERT
ON taxation_db.income_record
TO 'tax_data_entry'@'localhost';
SHOW GRANTS FOR 'tax_data_entry'@'localhost';

# task 2
-- Create another user named: tax_officer
-- Grant: SELECT INSERT UPDATE on Income_Record.
-- Attempt a DELETE operation and verify whether it is permitted.
DROP USER IF EXISTS 'tax_officer'@'localhost';
CREATE USER 'tax_officer'@'localhost'
IDENTIFIED BY 'Officer@123';

GRANT SELECT, INSERT, UPDATE
ON taxation_db.income_record
TO 'tax_officer'@'localhost';

SHOW GRANTS FOR 'tax_officer'@'localhost';

# Task 3 
-- Grant SELECT privilege on a taxation summary View to tax_officer.
-- Verify that the user can retrieve the required summarized information through the View.
SELECT CURRENT_USER();

GRANT SELECT
ON taxation_db.taxation_summary
TO 'tax_officer'@'localhost';

SHOW GRANTS FOR 'tax_officer'@'localhost';

# TASK 4
-- Grant multiple privileges to a taxation user.
-- For example: SELECT INSERT UPDATE
-- Then revoke only UPDATE.
-- Verify that:
-- SELECT still works. INSERT still works. UPDATE is no longer permitted.
SELECT CURRENT_USER();

REVOKE UPDATE
ON taxation_db.income_record
FROM 'tax_officer'@'localhost';

SHOW GRANTS FOR 'tax_officer'@'localhost';

# Task 5 Use:
-- SHOW GRANTS to compare the privileges assigned to tax_data_entry and tax_officer.
-- Explain why their privileges are different based on their roles in the taxation system.
SHOW GRANTS FOR 'tax_data_entry'@'localhost';
SHOW GRANTS FOR 'tax_officer'@'localhost';
-- tax_data_entry is given only the privileges required for data entry, such as SELECT  and INSERT in income_record.
-- tax_officer has broder access according to the requirements of the role, including access to the taxation summary View.
-- UPDATE and DELETE privileges are restricted when they are not required. This follows the principle of least privilege.


# task 6:
-- implement a minimum-privilege tax data entry user who can:
-- view taxpayer incom information, enter new income_records but
-- cannot modify existing income+recordds, delete income_records.alter
-- test all four operations using test-user connection.

## part f - intergated tcl and dcl
# task 1:
-- simulate the submission of a new annual income record for a taxpayer.
-- user start transaction -> insert -> verify -> commit
-- confirm that the record remains permanently in the database.

-- this task is in tax_data_entry

# TASK 2
-- Simulate an incorrect correction to a taxpayer's annual income.
-- Perform the update inside a transaction and use ROLLBACK to restore the original income value.
SELECT CURRENT_USER();

SELECT income_id, amount
FROM taxation_db.income_record
WHERE income_id = 9995;

START TRANSACTION;

UPDATE taxation_db.income_record
SET amount = 90000
WHERE income_id = 9995;

SELECT income_id, amount
FROM taxation_db.income_record
WHERE income_id = 9995;

ROLLBACK;

SELECT income_id, amount
FROM taxation_db.income_record
WHERE income_id = 9995;

# Task 3 
-- Perform multiple modifications to different taxpayers' income records.
-- Create a SAVEPOINT after the first valid modification.
-- Make another incorrect modification and use:  ROLLBACK TO SAVEPOINT;
-- Commit the remaining valid modification.
SELECT CURRENT_USER();

SELECT income_id, amount
FROM taxation_db.income_record
LIMIT 5;

START TRANSACTION;

UPDATE taxation_db.income_record
SET amount = amount + 1000
WHERE income_id = 9995;

SELECT income_id, amount
FROM taxation_db.income_record
WHERE income_id = 9995;

SAVEPOINT valid_change;

UPDATE taxation_db.income_record
SET amount = amount + 50000
WHERE income_id = 9999;

SELECT income_id, amount
FROM taxation_db.income_record
WHERE income_id IN (9995, 9999);

ROLLBACK TO SAVEPOINT valid_change;

SELECT income_id, amount
FROM taxation_db.income_record
WHERE income_id IN (9995, 9999);

COMMIT;

# TASK 4:
-- create a minimum-privilege tax data entry user.
-- Grant only the privileges required to enter and view income records.
-- Test: SELECT → permitted INSERT → permitted UPDATE → restricted DELETE → restricted


# Task 5 
-- Create a taxation summary View and grant SELECT access to a user.
-- Test the difference between accessing the permitted View and directly accessing a restricted underlying table.
CREATE OR REPLACE VIEW taxation_db.taxation_summary AS
SELECT
    t.taxpayer_id,
    t.full_name,
    SUM(i.amount) AS total_income
FROM taxation_db.taxpayer t
JOIN taxation_db.income_record i
    ON t.taxpayer_id = i.taxpayer_id
GROUP BY
    t.taxpayer_id,
    t.full_name;
    
GRANT SELECT
ON taxation_db.taxation_summary
TO 'tax_clerk1'@'localhost';

SHOW GRANTS FOR 'tax_clerk1'@'localhost';

# Task 6 
-- Grant an unnecessary privilege to a taxation user.
-- Then:
-- 1. Verify the privilege using SHOW GRANTS.
-- 2. Revoke the unnecessary privilege.
-- 3. Verify the final privileges.
-- 4. Reconnect using the test account.
-- 5. Test the revoked operation.
GRANT UPDATE
ON taxation_db.income_record
TO 'tax_data_entry'@'localhost';

SHOW GRANTS FOR 'tax_data_entry'@'localhost';

REVOKE UPDATE
ON taxation_db.income_record
FROM 'tax_data_entry'@'localhost';

SHOW GRANTS FOR 'tax_data_entry'@'localhost';