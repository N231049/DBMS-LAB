CREATE SYNONYM taxpayer FOR SYSTEM.taxpayer;
CREATE SYNONYM income_category FOR SYSTEM.income_category;
CREATE SYNONYM income_record FOR SYSTEM.income_record;
CREATE SYNONYM financial_year FOR SYSTEM.financial_year;

SELECT * FROM taxpayer;
SELECT * FROM income_category;
SELECT * FROM income_record;
SELECT * FROM financial_year;

SET SERVEROUTPUT ON;
-- PART A
-- TASK 1
BEGIN
    DBMS_OUTPUT.PUT_LINE('Welcome to TaxationDB');
END;
/

-- TASK 3
DECLARE
    v_name taxpayer.full_name%type;
    v_income taxpayer.annual_income%TYPE;
BEGIN
    SELECT full_name, annual_income
    INTO v_name,v_income
    FROM taxpayer
    WHERE TAXPAYER_ID = 102;
    
    DBMS_OUTPUT.PUT_LINE('NAME: ' || v_name);
    DBMS_OUTPUT.PUT_LINE('ANNUAL INCOME: ' || v_income);
END;
/

-- level 0:
-- Q1:
DECLARE
    v_taxpayer_id taxpayer.taxpayer_id%type := 102;
    v_income taxpayer.annual_income%TYPE;
    v_tax NUMBER;
BEGIN
    SELECT annual_income
    INTO v_income
    FROM taxpayer
    WHERE taxpayer_id = v_taxpayer_id;
    
    v_tax := v_income * 0.10;
    
    DBMS_OUTPUT.PUT_LINE('TAXPAYER ID: ' || v_taxpayer_id);
    DBMS_OUTPUT.PUT_LINE('ANNUAL INCOME: ' || v_income);
    DBMS_OUTPUT.PUT_LINE('10% OF ANNUAL INCOME: ' || v_tax);
END;
/

-- Q2:
CREATE OR REPLACE PROCEDURE display_taxpayer
(
    p_taxpayer_id IN taxpayer.taxpayer_id%TYPE
)
AS
    v_name       taxpayer.full_name%TYPE;
    v_pan        taxpayer.pan_number%TYPE;
    v_occupation taxpayer.occupation%TYPE;
    v_income     taxpayer.annual_income%TYPE;
BEGIN
    SELECT full_name, pan_number, occupation, annual_income
    INTO v_name, v_pan, v_occupation, v_income
    FROM taxpayer
    WHERE taxpayer_id = p_taxpayer_id;

    DBMS_OUTPUT.PUT_LINE('Name: ' || v_name);
    DBMS_OUTPUT.PUT_LINE('PAN: ' || v_pan);
    DBMS_OUTPUT.PUT_LINE('Occupation: ' || v_occupation);
    DBMS_OUTPUT.PUT_LINE('Annual Income: ' || v_income);
END;
/

EXEC display_taxpayer(103);

-- Q3:
DECLARE
    v_taxpayer_id taxpayer.taxpayer_id%TYPE := 104;
    v_is_active taxpayer.is_active%TYPE;
BEGIN
    SELECT is_active
    INTO v_is_active
    FROM taxpayer
    WHERE taxpayer_id = v_taxpayer_id;
    
    IF v_is_active = 1 THEN 
        DBMS_OUTPUT.PUT_LINE('Taxpayer is Active');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Taxpayer is Inactive');
    END IF;
END;
/

-- Q4:
CREATE OR REPLACE FUNCTION check_taxable( p_amount IN NUMBER )
RETURN VARCHAR2
AS 
BEGIN
    IF p_amount > 0 THEN 
        RETURN 'Taxable';
    ELSE 
        RETURN 'Non Taxable';
    END IF;
END;
/

SELECT check_taxable(500000) AS status
FROM dual;
SELECT check_taxable(0) AS status
FROM dual;

-- Q5:
CREATE OR REPLACE PROCEDURE display_numbers
AS
BEGIN
    FOR i IN 1..10 LOOP
        DBMS_OUTPUT.PUT_LINE(i);
    END LOOP;
END;
/

EXEC display_numbers;

-- level 1
-- Q1:
CREATE OR REPLACE PROCEDURE classify_taxpayer_income( 
p_taxpayer_id IN taxpayer.taxpayer_id%TYPE ) AS
v_income taxpayer.annual_income%TYPE;
BEGIN 
    SELECT annual_income
    INTO v_income
    FROM taxpayer
    WHERE taxpayer_id = p_taxpayer_id;
    
    IF v_income > 1000000 THEN
        DBMS_OUTPUT.PUT_LINE('HOGH INCOME');
    ELSIF v_income >= 50000 THEN
        DBMS_OUTPUT.PUT_LINE('MEDIUM INCOME');
    ELSE
        DBMS_OUTPUT.PUT_LINE('LOW INCOME');
    END IF;
END;
/

EXEC classify_taxpayer_income(105);

-- q2:
CREATE OR REPLACE FUNCTION get_annual_income
( p_taxpayer_id IN taxpayer.taxpayer_id%TYPE )
RETURN NUMBER AS
v_income taxpayer.annual_income%TYPE;
BEGIN 
    SELECT annual_income
    INTO v_income
    FROM taxpayer
    WHERE taxpayer_id = p_taxpayer_id;
    
    RETURN v_income;
END;
/

SELECT full_name, get_annual_income(taxpayer_id) AS annual_income
FROM taxpayer;

-- level 2
-- q1:
CREATE OR REPLACE PROCEDURE display_active_taxpayers
AS
    CURSOR taxpayer_cursor IS
        SELECT full_name, annual_income, occupation
        FROM taxpayer
        WHERE is_active = 1;

    v_name       taxpayer.full_name%TYPE;
    v_income     taxpayer.annual_income%TYPE;
    v_occupation taxpayer.occupation%TYPE;
BEGIN
    OPEN taxpayer_cursor;

    LOOP
        FETCH taxpayer_cursor
        INTO v_name, v_income, v_occupation;

        EXIT WHEN taxpayer_cursor%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE(
            'Name: ' || v_name ||
            ', Annual Income: ' || v_income ||
            ', Occupation: ' || v_occupation
        );
    END LOOP;

    CLOSE taxpayer_cursor;
END;
/

EXEC display_active_taxpayers; 

-- q2:
CREATE OR REPLACE PROCEDURE find_taxpayer 
( p_taxpayer_id IN taxpayer.taxpayer_id%TYPE ) 
AS
    v_name taxpayer.full_name%TYPE;
    v_income taxpayer.annual_income%TYPE;
BEGIN
    SELECT full_name, annual_income
    INTO v_name, v_income
    FROM taxpayer
    WHERE taxpayer_id = p_taxpayer_id;
   
    DBMS_OUTPUT.PUT_LINE('TAXPAYER NAME: ' || v_name);
    DBMS_OUTPUT.PUT_LINE('ANNUAL INCOME: ' || v_income);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('TAXPAYER NOT FOUND');
END;
/

EXEC find_taxpayer(102);
EXEC find_taxpayer(1002); 
 

-- optional questions
-- optional 1:
CREATE OR REPLACE PROCEDURE update_annual_income
( p_taxpayer_id IN taxpayer.taxpayer_id%TYPE,
  p_new_income IN taxpayer.annual_income%TYPE) AS v_count NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_count
    FROM taxpayer
    WHERE taxpayer_id = p_taxpayer_id;
    
    IF v_count > 0 THEN
        UPDATE taxpayer
        SET annual_income = p_new_income
        WHERE taxpayer_id = p_taxpayer_id;
        
        DBMS_OUTPUT.PUT_LINE('ANNUAL INCOME UPDATED SUCCESSFULLY');
    ELSE
        DBMS_OUTPUT.PUT_LINE('TAXPAYER NOT FOUND');
    END IF;
END;
/

EXEC update_annual_income(101,1000000);


-- OPTIONAL 2:
CREATE OR REPLACE PROCEDURE classify_income_case
( p_income IN NUMBER ) AS v_category VARCHAR2(20);
BEGIN
    v_category :=
        CASE 
            WHEN p_income > 1000000 THEN 'high'
            WHEN p_income >= 50000 THEN ' Medium'
            ELSE 'low'
        END;
        
    DBMS_OUTPUT.PUT_LINE(v_category);
END;
/

EXEC classify_income_case(950000);

-- optional 3:
CREATE OR REPLACE PROCEDURE display_income_records
(
    p_taxpayer_id IN taxpayer.taxpayer_id%TYPE
)
AS
BEGIN
    FOR rec IN
    (
        SELECT
            ir.income_source,
            ic.category_name,
            ir.amount,
            ir.received_date,
            fy.year_label
        FROM income_record ir
        JOIN income_category ic
            ON ir.category_id = ic.category_id
        JOIN financial_year fy
            ON ir.year_id = fy.year_id
        WHERE ir.taxpayer_id = p_taxpayer_id
    )
    LOOP
        DBMS_OUTPUT.PUT_LINE(
            'Income Source: ' || rec.income_source ||
            ', Category: ' || rec.category_name ||
            ', Amount: ' || rec.amount ||
            ', Received Date: ' || rec.received_date ||
            ', Financial Year: ' || rec.year_label
        );
    END LOOP;
END;
/
SET SERVEROUTPUT ON;

EXEC display_income_records(101);

-- optional 4:
CREATE OR REPLACE PROCEDURE process_income_records
AS
    CURSOR income_cursor IS
        SELECT
            ir.income_id,
            ir.income_source,
            ir.amount,
            fy.year_label
        FROM income_record ir
        JOIN financial_year fy
            ON ir.year_id = fy.year_id;

    v_income_id     income_record.income_id%TYPE;
    v_income_source income_record.income_source%TYPE;
    v_amount        income_record.amount%TYPE;
    v_year_label    financial_year.year_label%TYPE;
BEGIN
    OPEN income_cursor;

    LOOP
        FETCH income_cursor
        INTO v_income_id,
             v_income_source,
             v_amount,
             v_year_label;

        EXIT WHEN income_cursor%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE(
            'Income ID: ' || v_income_id ||
            ', Income Source: ' || v_income_source ||
            ', Amount: ' || v_amount ||
            ', Financial Year: ' || v_year_label
        );
    END LOOP;

    CLOSE income_cursor;
END;
/

SET SERVEROUTPUT ON;

EXEC process_income_records;


-- optional 5:
CREATE OR REPLACE FUNCTION classify_tax_income
(
    p_income IN NUMBER
)
RETURN VARCHAR2
AS
BEGIN
    IF p_income <= 500000 THEN
        RETURN 'No Tax Category';

    ELSIF p_income <= 1000000 THEN
        RETURN 'Moderate Income';

    ELSE
        RETURN 'High Income';
    END IF;
END;
/

SELECT classify_tax_income(400000) AS classification
FROM dual;

SELECT classify_tax_income(750000) AS classification
FROM dual;

SELECT classify_tax_income(1500000) AS classification
FROM dual;