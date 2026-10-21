-- task1:
DELIMITER //
CREATE FUNCTION calculate_tax( p_income DECIMAL(12,2) )
RETURNS DECIMAL(12,2)
DETERMINISTIC
BEGIN
	DECLARE v_tax DECIMAL(12,2);
    
    IF p_income <= 500000 THEN
		SET v_tax = 0;
    ELSEIF p_income <= 1000000 THEN
        SET v_tax = (p_income - 500000) * 0.10;
    ELSEIF p_income <= 1500000 THEN
        SET v_tax = ((p_income - 1000000) * 0.20) + 50000;
    ELSE
        SET v_tax = ((p_income - 1500000) * 0.30) + 150000;
    END IF;
    
    RETURN v_tax;
END //
DELIMITER ;

SELECT calculate_tax(1800000) AS tax;

-- TASK2:
DELIMITER //
CREATE PROCEDURE generate_tax_assessment( IN p_taxpayer_id INT )
BEGIN 
	DECLARE v_name VARCHAR(100);
    DECLARE v_pan VARCHAR(10);
    DECLARE v_income DECIMAL(12,2);
    DECLARE v_occupation VARCHAR(150);
    DECLARE v_tax DECIMAL(12,2);
    DECLARE v_net_income DECIMAL(12,2);
    DECLARE not_found INT DEFAULT 0;
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND
		SET not_found = 1;
	
    SELECT full_name, pan_number,annual_income, occupation
    INTO v_name,v_pan,v_income, v_occupation
    FROM taxpayer
    WHERE taxpayer_id = p_taxpayer_id;
    
    IF not_found = 1 THEN
		SELECT 'taxpayer not found' AS message;
	ELSE
		SET v_tax = calculate_tax(v_income);
        
        SET v_net_income = v_income - v_tax;
        
        SELECT 
			v_name AS taxpayer_name,
            v_pan AS pan_number,
            v_income AS annual_income,
            v_occupation AS occupation,
            v_tax AS tax_amount,
            v_net_income AS net_income_after_tax;
	END IF;
END //
DELIMITER ;

CALL generate_tax_assessment(103);

-- task 3:
DELIMITER //
CREATE FUNCTION income_classification( p_income DECIMAL(12,2) )
RETURNS VARCHAR(30)
DETERMINISTIC
BEGIN
	IF p_income< 500000 THEN 
		RETURN 'LOW INCOME';
	ELSEIF p_income <= 1000000 THEN
		RETURN 'HIGH INCOME';
	ELSE
		RETURN 'VERY HIGH INCOME';
	END IF;
END //
DELIMITER ;

SELECT income_classification(400000) AS category;

-- level1
-- q1:
DELIMITER //
CREATE PROCEDURE taxpayer_summary(
    IN p_taxpayer_id INT
)
BEGIN
    DECLARE v_name VARCHAR(100);
    DECLARE v_income DECIMAL(12,2);
    DECLARE v_category VARCHAR(30);
    DECLARE v_tax DECIMAL(12,2);
    DECLARE v_net_income DECIMAL(12,2);
    DECLARE not_found INT DEFAULT 0;

    DECLARE CONTINUE HANDLER FOR NOT FOUND
        SET not_found = 1;

    SELECT full_name, annual_income
    INTO v_name, v_income
    FROM taxpayer
    WHERE taxpayer_id = p_taxpayer_id;

    IF not_found = 1 THEN
        SELECT 'Taxpayer not found' AS message;
    ELSE
        SET v_category = income_classification(v_income);
        SET v_tax = calculate_tax(v_income);
        SET v_net_income = v_income - v_tax;

        SELECT
            v_name AS taxpayer_name,
            v_income AS annual_income,
            v_category AS income_category,
            v_tax AS calculated_tax,
            v_net_income AS net_income;
    END IF;
END //
DELIMITER ;

CALL taxpayer_summary(105);

-- q2:
DELIMITER //
CREATE PROCEDURE income_record_summary( IN p_taxpayer_id INT )
BEGIN
	DECLARE v_name VARCHAR(100);
    DECLARE v_annual_income DECIMAL(12,2);
    DECLARE v_total_income DECIMAL(12,2);
    DECLARE v_difference DECIMAL(12,2);
    DECLARE not_found INT DEFAULT 0;
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND
		SET not_found = 1;
        
	SELECT full_name, annual_income
    INTO v_name, v_annual_income
    FROM taxpayer
    WHERE taxpayer_id = p_taxpayer_id;
    
    IF not_found = 1 THEn
		SELECT 'taxpayer not found' AS message;
	ELSE
		SELECT COALESCE(SUM(amount),0)
        INTO v_total_income
        FROM income_record
        WHERE taxpayer_id = p_taxpayer_id;
        
        IF v_total_income = 0 THEN
			SELECT 'No income records found for this taxpayer' AS message;
        ELSE
            SET v_difference = v_annual_income - v_total_income;
            SELECT
                v_name AS taxpayer_name,
                v_total_income AS total_recorded_income,
                v_annual_income AS annual_income,
                v_difference AS difference;
        END IF;
    END IF;
END //
DELIMITER ;

CALL income_record_summary(101);

-- LEVEL 1
-- Q3:
DELIMITER //
CREATE PROCEDURE conditional_assessment( IN p_taxpayer_id INT )
BEGIN
    DECLARE v_name VARCHAR(100);
    DECLARE v_income DECIMAL(12,2);
    DECLARE v_status VARCHAR(30);
    DECLARE not_found INT DEFAULT 0;

    DECLARE CONTINUE HANDLER FOR NOT FOUND
        SET not_found = 1;

    SELECT full_name, annual_income
    INTO v_name, v_income
    FROM taxpayer
    WHERE taxpayer_id = p_taxpayer_id;

    IF not_found = 1 THEN
        SELECT 'Taxpayer not found' AS message;
    ELSE
        IF v_income <= 500000 THEN
            SET v_status = 'No Tax Assessment';
        ELSEIF v_income <= 1000000 THEN
            SET v_status = 'Standard Assessment';
        ELSE
            SET v_status = 'High Income Assessment';
        END IF;
        SELECT
            v_name AS taxpayer_name,
            v_income AS annual_income,
            v_status AS assessment_status;
    END IF;
END //
DELIMITER ;

CALL conditional_assessment(101);

-- level 2
-- q1:
DELIMITER //
CREATE PROCEDURE active_tax_assessment()
BEGIN
    DECLARE v_name VARCHAR(100);
    DECLARE v_income DECIMAL(12,2);
    DECLARE v_category VARCHAR(30);
    DECLARE v_tax DECIMAL(12,2);
    DECLARE v_net_income DECIMAL(12,2);
    DECLARE done INT DEFAULT 0;

    DECLARE taxpayer_cursor CURSOR FOR
        SELECT full_name, annual_income
        FROM taxpayer
        WHERE is_active = 1;

    DECLARE CONTINUE HANDLER FOR NOT FOUND
        SET done = 1;

    OPEN taxpayer_cursor;
    
    read_loop: LOOP
        FETCH taxpayer_cursor
        INTO v_name, v_income;

        IF done = 1 THEN
            LEAVE read_loop;
        END IF;
        
        SET v_category = income_classification(v_income);

        SET v_tax = calculate_tax(v_income);

        SET v_net_income = v_income - v_tax;

        SELECT
            v_name AS taxpayer_name,
            v_income AS annual_income,
            v_category AS income_category,
            v_tax AS calculated_tax,
            v_net_income AS net_income;
    END LOOP;
    CLOSE taxpayer_cursor;
END //
DELIMITER ;

CALL active_tax_assessment();

-- q2:
DELIMITER //
CREATE PROCEDURE conditional_cursor_assessment()
BEGIN
    DECLARE v_name VARCHAR(100);
    DECLARE v_income DECIMAL(12,2);
    DECLARE v_tax DECIMAL(12,2);
    DECLARE v_category VARCHAR(30);
    DECLARE done INT DEFAULT 0;

    DECLARE taxpayer_cursor CURSOR FOR
        SELECT full_name, annual_income
        FROM taxpayer
        WHERE is_active = 1;

    DECLARE CONTINUE HANDLER FOR NOT FOUND
        SET done = 1;

    OPEN taxpayer_cursor;

    read_loop: LOOP
        FETCH taxpayer_cursor
        INTO v_name, v_income;

        IF done = 1 THEN
            LEAVE read_loop;
        END IF;

        IF v_income <= 500000 THEN
            SET v_tax = 0;
            SET v_category = 'NO TAX';
        ELSEIF v_income <= 1000000 THEN
            SET v_tax = (v_income - 500000) * 0.10;
            SET v_category = 'Standard Assessment';
        ELSE
            SET v_tax = calculate_tax(v_income);
            SET v_category = 'High Income Assessment';
        END IF;
        
        SELECT
            v_name AS taxpayer_name,
            v_income AS annual_income,
            v_tax AS tax_amount,
            v_category AS assessment_category;
    END LOOP;
    CLOSE taxpayer_cursor;
END //
DELIMITER ;

CALL conditional_cursor_assessment();

-- q3:
DELIMITER //
CREATE PROCEDURE update_taxpayer_income(
	IN p_taxpayer_id INT, IN p_new_income DECIMAL(12,2)
)
BEGIN
	DECLARE v_name VARCHAR(100);
    DECLARE v_old_income DECIMAL(12,2);
    DECLARE not_found INT DEFAULT 0;

    DECLARE CONTINUE HANDLER FOR NOT FOUND
        SET not_found = 1;
        
    SELECT full_name, annual_income
    INTO v_name, v_old_income
    FROM taxpayer
    WHERE taxpayer_id = p_taxpayer_id;
    
    IF not_found = 1 THEN
        SELECT 'Taxpayer not found' AS message;
    ELSEIF p_new_income < 0 THEN
        SELECT
            'Invalid income. Income cannot be negative.'
            AS message;
    ELSE
        UPDATE taxpayer
        SET annual_income = p_new_income
        WHERE taxpayer_id = p_taxpayer_id;

        SELECT
            'Income updated successfully.' AS message,
            v_name AS taxpayer_name,
            p_new_income AS updated_annual_income;
    END IF;
END //
DELIMITER ;

CALL update_taxpayer_income(101, 900000);
CALL update_taxpayer_income(101, -5000);
CALL update_taxpayer_income(999, 500000);

-- Q4
DELIMITER //
CREATE PROCEDURE exception_tax_assessment(
    IN p_taxpayer_id INT
)
BEGIN
    DECLARE v_name VARCHAR(100);
    DECLARE v_income DECIMAL(12,2);
    DECLARE v_tax DECIMAL(12,2);
    DECLARE not_found INT DEFAULT 0;

    DECLARE CONTINUE HANDLER FOR NOT FOUND
        SET not_found = 1;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SELECT
            'An unexpected SQL error occurred'
            AS message;
    END;

    SELECT full_name, annual_income
    INTO v_name, v_income
    FROM taxpayer
    WHERE taxpayer_id = p_taxpayer_id;

    IF not_found = 1 THEN
        SELECT 'Taxpayer not found' AS message;
    ELSE
        SET v_tax = calculate_tax(v_income);
        
        SELECT
            v_name AS taxpayer_name,
            v_income AS annual_income,
            v_tax AS calculated_tax;
    END IF;
END //
DELIMITER ;

CALL exception_tax_assessment(101);
CALL exception_tax_assessment(999);

-- level3
-- Q1
DELIMITER //
CREATE PROCEDURE complete_tax_assessment(
    IN p_taxpayer_id INT
)
BEGIN
    DECLARE v_name VARCHAR(100);
    DECLARE v_pan VARCHAR(10);
    DECLARE v_occupation VARCHAR(150);
    DECLARE v_income DECIMAL(12,2);
    DECLARE v_category VARCHAR(30);
    DECLARE v_tax DECIMAL(12,2);
    DECLARE v_net_income DECIMAL(12,2);
    DECLARE not_found INT DEFAULT 0;

    DECLARE CONTINUE HANDLER FOR NOT FOUND
        SET not_found = 1;

    SELECT full_name, pan_number, occupation, annual_income
    INTO v_name, v_pan, v_occupation, v_income
    FROM taxpayer
    WHERE taxpayer_id = p_taxpayer_id;

    IF not_found = 1 THEN
        SELECT 'Taxpayer not found' AS message;
    ELSE
        SET v_category = income_classification(v_income);
        SET v_tax = calculate_tax(v_income);
        SET v_net_income = v_income - v_tax;

        SELECT
            v_name AS taxpayer_name,
            v_pan AS pan_number,
            v_occupation AS occupation,
            v_income AS annual_income,
            v_category AS income_category,
            v_tax AS tax_amount,
            v_net_income AS net_income;
    END IF;
END //
DELIMITER ;

CALL complete_tax_assessment(101);
CALL complete_tax_assessment(999);

-- Q2
DELIMITER //
CREATE PROCEDURE income_record_cursor()
BEGIN
    DECLARE v_income_id INT;
    DECLARE v_taxpayer_id INT;
    DECLARE v_income_source VARCHAR(255);
    DECLARE v_category VARCHAR(100);
    DECLARE v_amount DECIMAL(12,2);
    DECLARE v_received_date DATE;
    DECLARE v_financial_year VARCHAR(20);
    DECLARE v_record_category VARCHAR(30);

    DECLARE done INT DEFAULT 0;

    DECLARE income_cursor CURSOR FOR
        SELECT ir.income_id, ir.taxpayer_id, ir.income_source, ic.category_name, ir.amount, ir.received_date,fy.year_label
        FROM income_record ir
        JOIN income_category ic
            ON ir.category_id = ic.category_id
        JOIN financial_year fy
            ON ir.year_id = fy.year_id;

    DECLARE CONTINUE HANDLER FOR NOT FOUND
        SET done = 1;

    OPEN income_cursor;

    read_loop: LOOP
        FETCH income_cursor
        INTO v_income_id, v_taxpayer_id, v_income_source, v_category, v_amount, v_received_date, v_financial_year;

        IF done = 1 THEN
            LEAVE read_loop;
        END IF;

        IF v_amount <= 50000 THEN
            SET v_record_category = 'Small Income Record';
        ELSEIF v_amount <= 200000 THEN
            SET v_record_category ='Medium Income Record';
        ELSE
            SET v_record_category = 'Large Income Record';
        END IF;
        SELECT
            v_income_id AS income_id,
            v_taxpayer_id AS taxpayer_id,
            v_income_source AS income_source,
            v_category AS category,
            v_amount AS amount,
            v_received_date AS received_date,
            v_financial_year AS financial_year,
            v_record_category AS record_classification;
    END LOOP;
    CLOSE income_cursor;
END //
DELIMITER ;

CALL income_record_cursor();

-- Q3:
DELIMITER //
CREATE PROCEDURE combined_tax_cursor()
BEGIN
    DECLARE v_name VARCHAR(100);
    DECLARE v_income DECIMAL(12,2);
    DECLARE v_category VARCHAR(30);
    DECLARE v_tax DECIMAL(12,2);
    DECLARE v_net_income DECIMAL(12,2);
    DECLARE done INT DEFAULT 0;

    DECLARE taxpayer_cursor CURSOR FOR
        SELECT full_name, annual_income
        FROM taxpayer
        WHERE is_active = 1;

    DECLARE CONTINUE HANDLER FOR NOT FOUND
        SET done = 1;

    OPEN taxpayer_cursor;

    read_loop: LOOP
        FETCH taxpayer_cursor
        INTO v_name, v_income;

        IF done = 1 THEN
            LEAVE read_loop;
        END IF;

        SET v_category = income_classification(v_income);
        SET v_tax = calculate_tax(v_income);
        SET v_net_income = v_income - v_tax;

        SELECT
            v_name AS taxpayer_name,
            v_income AS annual_income,
            v_category AS income_category,
            v_tax AS tax_amount,
            v_net_income AS net_income;
    END LOOP;
    CLOSE taxpayer_cursor;
END //
DELIMITER ;

CALL combined_tax_cursor();

-- CHALLENGE QUESTION
DELIMITER //
CREATE PROCEDURE taxpayer_assessment_summary()
BEGIN
    DECLARE v_name VARCHAR(100);
    DECLARE v_income DECIMAL(12,2);
    DECLARE v_tax DECIMAL(12,2);
    DECLARE v_category VARCHAR(30);
    DECLARE v_status VARCHAR(40);

    DECLARE v_total_taxpayers INT DEFAULT 0;
    DECLARE v_total_income DECIMAL(14,2) DEFAULT 0;
    DECLARE v_total_tax DECIMAL(14,2) DEFAULT 0;

    DECLARE done INT DEFAULT 0;

    DECLARE taxpayer_cursor CURSOR FOR
        SELECT full_name, annual_income
        FROM taxpayer
        WHERE is_active = 1;

    DECLARE CONTINUE HANDLER FOR NOT FOUND
        SET done = 1;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SELECT 'Error while processing assessment' AS message;
    END;

    OPEN taxpayer_cursor;

    read_loop: LOOP
        FETCH taxpayer_cursor
        INTO v_name, v_income;
        
        IF done = 1 THEN
            LEAVE read_loop;
        END IF;

        SET v_tax = calculate_tax(v_income);
        SET v_category = income_classification(v_income);

        IF v_income <= 500000 THEN
            SET v_status = 'No Tax Assessment';
        ELSEIF v_income <= 1000000 THEN
            SET v_status ='Standard Assessment';
        ELSE
			SET v_status = 'High Income Assessment';
        END IF;

        SELECT
            v_name AS taxpayer_name,
            v_income AS annual_income,
            v_tax AS tax_amount,
            v_category AS income_category,
            v_status AS assessment_status;

        SET v_total_taxpayers = v_total_taxpayers + 1;
		SET v_total_income = v_total_income + v_income;
        SET v_total_tax = v_total_tax + v_tax;
    END LOOP;
    CLOSE taxpayer_cursor;
    SELECT
        v_total_taxpayers AS total_taxpayers_processed,
        v_total_income AS total_income,
        v_total_tax AS total_tax;
END //
DELIMITER ;

CALL taxpayer_assessment_summary();