use taxation_db;

show tables;

describe taxpayer;
describe income_category;
describe income_record;
describe financial_year;

SELECT * FROM TAXPAYER;
SELECT * FROM INCOME_CATEGORY;
SELECT * FROM INCOME_RECORD;
SELECT * FROM FINANCIAL_YEAR;

# PART A
-- TASK 2
DELIMITER //
CREATE PROCEDURE welcome_taxation()
BEGIN
	SELECT 'Welcome to TaxationDB' AS message;
END //
DELIMITER ;

CALL welcome_taxation();

-- TASK 4:
DELIMITER //
CREATE PROCEDURE get_taxpayer(IN p_taxpayer_id INT)
BEGIN 
	SELECT full_name, annual_income
    FROM taxpayer
    WHERE taxpayer_id = p_taxpayer_id;
END //
DELIMITER ;

CALL get_taxpayer(102);

-- LEVEL 0
-- Q1:
DELIMITER //
CREATE PROCEDURE calculate_ten_percent(IN p_taxpayer_id INT)
BEGIN
	DECLARE v_income DECIMAL(12,2);
    DECLARE v_ten_percent DECIMAL(12,2);
    
    SELECT annual_income
    INTO v_income
    FROM taxpayer
    WHERE taxpayer_id = p_taxpayer_id;
    
    SET v_ten_percent = v_income * 0.10;
    
    SELECT 	
		p_taxpayer_id AS taxpayer_id,
        v_income AS annual_income,
        v_ten_percent AS ten_percent_income;
END //
DELIMITER ;

CALL calculate_ten_percent(102);

-- Q2:
DELIMITER //
CREATE PROCEDURE display_taxpayer(
	IN p_taxpayer_id INT
)
BEGIN
	SELECT full_name, pan_number, occupation, annual_income
    FROM taxpayer
    WHERE taxpayer_id = p_taxpayer_id;
END //
DELIMITER ;

CALL display_taxpayer(101);

-- Q5:
DELIMITER //
CREATE PROCEDURE display_numbers()
BEGIN 
	DECLARE i INT DEFAULT 1;
    
    WHILE i <= 10 DO
		SELECT i;
        SET i = i + 1;
	END WHILE;
END //
DELIMITER ;

CALL display_numbers();

## level 1
-- q1:
DELIMITER //
CREATE PROCEDURE classify_taxpayer_income
( IN p_taxpayer_id INT )
BEGIN
    DECLARE v_income DECIMAL(12,2);

    SELECT annual_income
    INTO v_income
    FROM taxpayer
    WHERE taxpayer_id = p_taxpayer_id;

    IF v_income > 1000000 THEN
        SELECT 'High Income' AS income_category;
    ELSEIF v_income >= 500000 THEN
        SELECT 'Medium Income' AS income_category;
    ELSE
        SELECT 'Low Income' AS income_category;
    END IF;
END //
DELIMITER ;

CALL classify_taxpayer_income(104);

-- Q2:
DELIMITER //
CREATE FUNCTION get_annual_income( p_taxpayer_id INT )
RETURNS DECIMAL(12,2)
DETERMINISTIC
BEGIN
	DECLARE v_income DECIMAL(12,2);
    
    SELECT annual_income
    INTO v_income
    FROM taxpayer
    WHERE taxpayer_id = p_taxpayer_id;
    
    RETURN v_income;
END //
DELIMITER ;

SELECT full_name, get_annual_income(taxpayer_id) AS annual_income
FROM taxpayer;

-- LEVEL 1
-- Q1:
DELIMITER //
CREATE PROCEDURE display_active_taxpayers()
BEGIN
	DECLARE v_name VARCHAR(100);
    DECLARE v_income DECIMAL(12,2);
    DECLARE v_occupation VARCHAR(150);
    DECLARE done INT DEFAULT 0;
    
    DECLARE taxpayer_cursor CURSOR FOR
		SELECT full_name, annual_income, occupation
        FROM taxpayer
        WHERE is_active = 1;
        
	DECLARE CONTINUE HANDLER FOR NOT FOUND
		SET done = 1;
        
	OPEN taxpayer_cursor;
	
    read_loop: LOOP
		
        FETCH taxpayer_cursor
        INTO v_name, v_income, v_occupation;
        
        IF done = 1 THEN
			LEAVE read_loop;
		END IF;
        
        SELECT 
			v_name AS taxpayer_name,
            v_income AS annual_income,
            v_occupation AS occupation;
            
	END LOOP;
    
    CLOSE taxpayer_cursor;
END //
DELIMITER ;

CALL display_active_taxpayers();

-- q2:
DELIMITER //
CREATE PROCEDURE find_taxpayer( IN p_taxpayer_id INT )
BEGIN
	DECLARE v_name VARCHAR(100);
    DECLARE v_income DECIMAL(12,2);
    DECLARE not_found INT DEFAULT 0;
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND
		SET not_found = 1;
	
    SELECT full_name, annual_income
    INTO v_name, v_income
    FROM taxpayer
    WHERE taxpayer_id = p_taxpayer_id;
    
    IF not_found = 1 THEN
		SELECT 'taxpayer not found' AS message;
	ELSE 
		SELECT 
			v_name AS taxpayer_name,
            v_income AS annual_income;
	END IF;
END //
DELIMITER ;

CALL find_taxpayer(103);
CALL find_taxpayer(1002);

-- Optional questions
-- optional 1:
DELIMITER //
CREATE PROCEDURE update_annual_income(
	IN p_taxpayer_id INT, IN p_new_income DECIMAL(12,2)
    )
BEGIN
	DECLARE v_count INT;
    
    SELECT COUNT(*)
    INTO v_count
    FROM taxpayer
    WHERE taxpayer_id = p_taxpayer_id;
    
    IF v_count > 0 THEN
		UPDATE taxpayer
        SET annual_income = p_new_income
        WHERE taxpayer_id = p_taxpayer_id;
        
        SELECT 'ANNUAL INCOME UPDATED SUCCESSFULLY' AS message;
	ELSE 
		SELECT 'TAXPAYER NOT FOUND' AS message;
	END IF;
END //
DELIMITER ;

CALL update_annual_income(101, 1000000);

-- OPTIONAL 2:
DELIMITER //
CREATE PROCEDURE classify_income_case ( IN p_income DECIMAL(12,2) )
BEGIN 
	DECLARE v_category VARCHAR(20);
    
    SET v_category = 
		CASE
			WHEN p_income > 1000000 THEN 'high'
            WHEN p_income >= 50000 THEN 'Medium'
            ELSE 'LOW'
		END;
	
    SELECT v_category AS income_classification;
END //
DELIMITER ;

CALL classify_income_case(950000);

-- optional 3:
USE taxation_db;

DELIMITER //

CREATE PROCEDURE display_income_records(
    IN p_taxpayer_id INT
)
BEGIN
    SELECT
        ir.income_source AS income_source,
        ic.category_name AS category,
        ir.amount AS amount,
        ir.received_date AS received_date,
        fy.year_label AS financial_year
    FROM income_record ir
    JOIN income_category ic
        ON ir.category_id = ic.category_id
    JOIN financial_year fy
        ON ir.year_id = fy.year_id
    WHERE ir.taxpayer_id = p_taxpayer_id;
END //

DELIMITER ;

CALL display_income_records(101);

-- optional 4:
USE taxation_db;

DELIMITER //

CREATE PROCEDURE process_income_records()
BEGIN
    DECLARE v_income_id INT;
    DECLARE v_income_source VARCHAR(255);
    DECLARE v_amount DECIMAL(12,2);
    DECLARE v_year_label VARCHAR(20);
    DECLARE done INT DEFAULT 0;

    DECLARE income_cursor CURSOR FOR
        SELECT
            ir.income_id,
            ir.income_source,
            ir.amount,
            fy.year_label
        FROM income_record ir
        JOIN financial_year fy
            ON ir.year_id = fy.year_id;

    DECLARE CONTINUE HANDLER FOR NOT FOUND
        SET done = 1;

    OPEN income_cursor;

    read_loop: LOOP

        FETCH income_cursor
        INTO v_income_id,
             v_income_source,
             v_amount,
             v_year_label;

        IF done = 1 THEN
            LEAVE read_loop;
        END IF;

        SELECT
            v_income_id AS income_id,
            v_income_source AS income_source,
            v_amount AS amount,
            v_year_label AS financial_year;

    END LOOP;

    CLOSE income_cursor;
END //

DELIMITER ;

CALL process_income_records();

USE taxation_db;

DELIMITER //

CREATE FUNCTION classify_tax_income(
    p_income DECIMAL(12,2)
)
RETURNS VARCHAR(30)
DETERMINISTIC
BEGIN
    IF p_income <= 500000 THEN
        RETURN 'No Tax Category';

    ELSEIF p_income <= 1000000 THEN
        RETURN 'Moderate Income';

    ELSE
        RETURN 'High Income';
    END IF;
END //

DELIMITER ;

SELECT classify_tax_income(400000) AS classification;

SELECT classify_tax_income(750000) AS classification;

SELECT classify_tax_income(1500000) AS classification;
