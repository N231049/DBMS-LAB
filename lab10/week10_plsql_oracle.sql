-- task1
CREATE OR REPLACE FUNCTION calculate_tax ( p_income IN NUMBER ) 
RETURN NUMBER
AS v_tax NUMBER(12,2);
BEGIN
    IF p_income <= 500000 THEN
        v_tax := 0;
    ELSIF p_income <= 1000000 THEN
        v_tax := (p_income - 500000) * 0.10 ;
    ELSIF p_income <= 1500000 THEN
        v_tax := ((p_income - 1000000) * 0.20) + 500000;
    ELSE
        v_tax := ((p_income -1500000) * 0.30) + 150000;
    END IF;
    
    RETURN v_tax;
END;
/

SELECT calculate_tax(1200000) AS tax
FROM dual;

-- task 2:
CREATE OR REPLACE PROCEDURE generate_tax_assessment
( p_taxpayer_id IN taxpayer.taxpayer_id%TYPE ) AS
    v_name taxpayer.full_name%TYPE;
    v_pan taxpayer.pan_number%TYPE;
    v_income taxpayer.annual_income%TYPE;
    v_occupation taxpayer.occupation%TYPE;
    v_tax NUMBER(12,2);
    v_net_income NUMBER(12,2);
BEGIN
    SELECT full_name, pan_number, annual_income, occupation
    INTO v_name, v_pan, v_income,v_occupation
    FROM taxpayer
    WHERE taxpayer_id = p_taxpayer_id;
    
    v_tax := calculate_tax(v_income);
    
    v_net_income := v_income - v_tax;
    
    DBMS_OUTPUT.PUT_LINE('TAXPAYER NAME: ' || v_name);
    DBMS_OUTPUT.PUT_LINE('PAN Number: ' || v_pan);
    DBMS_OUTPUT.PUT_LINE('Annual Income: ' || v_income);
    DBMS_OUTPUT.PUT_LINE('Occupation: ' || v_occupation);
    DBMS_OUTPUT.PUT_LINE('Tax Amount: ' || v_tax);
    DBMS_OUTPUT.PUT_LINE('Net Income after Tax: ' || v_net_income);

EXCEPTION
    WHEN NO_DATA_FOUND THEN 
        DBMS_OUTPUT.PUT_LINE('TAXPAYER NOT FOUND');
END;
/

EXEC generate_tax_assessment(103);

-- task3:
CREATE OR REPLACE FUNCTION income_classification( p_income IN NUMBER )
RETURN VARCHAR2
AS
BEGIN 
    IF p_income <= 500000 THEN
        RETURN 'LOW_INCOME';
    ELSIF p_income <= 1000000 THEN
        RETURN 'HIGH INCOME';
    ELSE
        RETURN 'VERY HIGH INCOME';
    END IF;
END;
/


SELECT income_classification(1800000) AS category
FROM dual;

-- level 1
-- q1:
CREATE OR REPLACE PROCEDURE taxpayer_summary
( p_taxpayer_id IN taxpayer.taxpayer_id%TYPE )
AS
    v_name taxpayer.full_name%TYPE;
    v_income taxpayer.annual_income%TYPE;
    v_category VARCHAR2(30);
    v_tax NUMBER(12,2);
    v_net_income NUMBER(12,2);
BEGIN
    SELECT full_name, annual_income
    INTO v_name, v_income
    FROM taxpayer
    WHERE taxpayer_id = p_taxpayer_id;
    
    v_category := income_classification(v_income);
    v_tax := calculate_tax(v_income);
    v_net_income := v_income - v_tax;
    
    DBMS_OUTPUT.PUT_LINE('TAXPAYER NAME: ' || v_name);
    DBMS_OUTPUT.PUT_LINE('ANNUAL INCOME: ' || v_income);
    DBMS_OUTPUT.PUT_LINE('INCOME_CATEGORY: ' || v_category);
    DBMS_OUTPUT.PUT_LINE('CALCULATED TAX: ' || v_tax);
    DBMS_OUTPUT.PUT_LINE('NET INCOME: ' || v_net_income);
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('TAXPAYER NOT FOUND');
END;
/

SET SERVEROUTPUT ON;

EXEC taxpayer_summary(105);

-- q2:
CREATE OR REPLACE PROCEDURE income_record_summary
( p_taxpayer_id IN taxpayer.taxpayer_id%TYPE ) AS
v_name taxpayer.full_name%TYPE;
v_annual_income taxpayer.annual_income%TYPE;
v_total_income NUMBER(12,2);
v_difference NUMBER(12,2);
BEGIN
    SELECT full_name, annual_income
    INTO v_name, v_annual_income
    FROM taxpayer
    WHERE taxpayer_id = p_taxpayer_id;
    
    SELECT NVL(SUM(amount), 0)
    INTO v_total_income
    FROM income_record
    WHERE taxpayer_id = p_taxpayer_id;
    
    IF v_total_income = 0 THEN
        DBMS_OUTPUT.PUT_LINE('TAXPAYER NAME: ' || v_name);
    ELSE
        v_difference := v_annual_income - v_total_income;

        DBMS_OUTPUT.PUT_LINE('Taxpayer Name: ' || v_name);
        DBMS_OUTPUT.PUT_LINE('Total Recorded Income: ' || v_total_income);
        DBMS_OUTPUT.PUT_LINE('Annual Income: ' || v_annual_income);
        DBMS_OUTPUT.PUT_LINE('Difference: ' || v_difference);
    END IF;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Taxpayer not found');
END;
/

EXEC income_record_summary(101);

-- LEVEL1
--Q3:
CREATE OR REPLACE PROCEDURE conditional_assessment(
    p_taxpayer_id IN taxpayer.taxpayer_id%TYPE)
AS
    v_name taxpayer.full_name%TYPE;
    v_income taxpayer.annual_income%TYPE;
    v_status VARCHAR2(30);
BEGIN 
    SELECT full_name, annual_income
    INTO v_name,v_income
    FROM taxpayer
    WHERE taxpayer_id = p_taxpayer_id;
    
    IF v_income <= 500000 THEN
        v_status := ' no tax assessment';
    ELSIF v_income <= 1000000 THEN
        v_status := 'Standard Assessment';
    ELSE
        v_status := 'High Income Assessment';
    END IF;

    DBMS_OUTPUT.PUT_LINE('Taxpayer Name: ' || v_name);
    DBMS_OUTPUT.PUT_LINE('Annual Income: ' || v_income);
    DBMS_OUTPUT.PUT_LINE('Assessment Status: ' || v_status);

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Taxpayer not found');
END;
/

EXEC conditional_assessment(101);

-- level 2
-- q1:
CREATE OR REPLACE PROCEDURE active_tax_assessment
AS
    CURSOR taxpayer_cursor IS
        SELECT full_name, annual_income
        FROM taxpayer
        WHERE is_active = 1;

    v_category VARCHAR2(30);
    v_tax NUMBER(12,2);
    v_net_income NUMBER(12,2);
BEGIN
    FOR rec IN taxpayer_cursor
    LOOP
        v_category := income_classification(rec.annual_income);
        v_tax := calculate_tax(rec.annual_income);
        v_net_income := rec.annual_income - v_tax;

        DBMS_OUTPUT.PUT_LINE('Taxpayer Name: ' || rec.full_name );
        DBMS_OUTPUT.PUT_LINE('Annual Income: ' || rec.annual_income);
        DBMS_OUTPUT.PUT_LINE('Income Category: ' || v_category );
        DBMS_OUTPUT.PUT_LINE('Calculated Tax: ' || v_tax);
        DBMS_OUTPUT.PUT_LINE( 'Net Income: ' || v_net_income );
    END LOOP;
END;
/

EXEC active_tax_assessment;

-- q2:
CREATE OR REPLACE PROCEDURE conditional_cursor_assessment
AS
    CURSOR taxpayer_cursor IS
        SELECT full_name, annual_income
        FROM taxpayer
        WHERE is_active = 1;

    v_tax NUMBER(12,2);
    v_category VARCHAR2(30);
BEGIN
    FOR rec IN taxpayer_cursor
    LOOP
        IF rec.annual_income <= 500000 THEN
            v_tax := 0;
            v_category := 'NO TAX';
        ELSIF rec.annual_income <= 1000000 THEN
            v_tax := (rec.annual_income - 500000) * 0.10;
            v_category := 'Standard Assessment';
        ELSE
            v_tax := calculate_tax(rec.annual_income);
            v_category := 'High Income Assessment';
        END IF;
        
        DBMS_OUTPUT.PUT_LINE('Taxpayer Name: ' || rec.full_name);
        DBMS_OUTPUT.PUT_LINE('Annual Income: ' || rec.annual_income);
        DBMS_OUTPUT.PUT_LINE('Tax Amount: ' || v_tax);
        DBMS_OUTPUT.PUT_LINE('Assessment Category: ' || v_category );
    END LOOP;
END;
/
  
EXEC conditional_cursor_assessment;

-- q3:
CREATE OR REPLACE PROCEDURE update_taxpayer_income
(
    p_taxpayer_id IN taxpayer.taxpayer_id%TYPE,
    p_new_income  IN taxpayer.annual_income%TYPE
)
AS
    v_name       taxpayer.full_name%TYPE;
    v_old_income taxpayer.annual_income%TYPE;
BEGIN
    SELECT full_name, annual_income
    INTO v_name, v_old_income
    FROM taxpayer
    WHERE taxpayer_id = p_taxpayer_id;

    IF p_new_income < 0 THEN
        DBMS_OUTPUT.PUT_LINE('Invalid income. Income cannot be negative.');
    ELSE
        UPDATE taxpayer
        SET annual_income = p_new_income
        WHERE taxpayer_id = p_taxpayer_id;

        DBMS_OUTPUT.PUT_LINE('Income updated successfully.');
        DBMS_OUTPUT.PUT_LINE('Taxpayer Name: ' || v_name);
        DBMS_OUTPUT.PUT_LINE('Updated Annual Income: ' || p_new_income);
    END IF;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Taxpayer not found');
END;
/

EXEC update_taxpayer_income(101, 900000);
EXEC update_taxpayer_income(101, -5000);
EXEC update_taxpayer_income(999, 500000);

-- q4:
CREATE OR REPLACE PROCEDURE exception_tax_assessment
(
    p_taxpayer_id IN taxpayer.taxpayer_id%TYPE
)
AS
    v_name   taxpayer.full_name%TYPE;
    v_income taxpayer.annual_income%TYPE;
    v_tax    NUMBER(12,2);
BEGIN
    SELECT full_name, annual_income
    INTO v_name, v_income
    FROM taxpayer
    WHERE taxpayer_id = p_taxpayer_id;

    v_tax := calculate_tax(v_income);

    DBMS_OUTPUT.PUT_LINE('Taxpayer Name: ' || v_name);
    DBMS_OUTPUT.PUT_LINE('Annual Income: ' || v_income);
    DBMS_OUTPUT.PUT_LINE(  'Calculated Tax: ' || v_tax);

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Taxpayer not found' );

    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE( 'An unexpected error occurred: ' || SQLERRM);
END;
/

EXEC exception_tax_assessment(101);
EXEC exception_tax_assessment(999);

-- LEVEL 3
-- Q1
CREATE OR REPLACE PROCEDURE complete_tax_assessment
( p_taxpayer_id IN taxpayer.taxpayer_id%TYPE )
AS
    v_name       taxpayer.full_name%TYPE;
    v_pan        taxpayer.pan_number%TYPE;
    v_occupation taxpayer.occupation%TYPE;
    v_income     taxpayer.annual_income%TYPE;

    v_category   VARCHAR2(30);
    v_tax        NUMBER(12,2);
    v_net_income NUMBER(12,2);
BEGIN
    SELECT full_name, pan_number, occupation, annual_income
    INTO v_name, v_pan,v_occupation,v_income
    FROM taxpayer
    WHERE taxpayer_id = p_taxpayer_id;

    v_category := income_classification(v_income);
    v_tax := calculate_tax(v_income);

    v_net_income := v_income - v_tax;

    DBMS_OUTPUT.PUT_LINE('Taxpayer Name: ' || v_name);
    DBMS_OUTPUT.PUT_LINE('PAN Number: ' || v_pan);
    DBMS_OUTPUT.PUT_LINE('Occupation: ' || v_occupation);
    DBMS_OUTPUT.PUT_LINE('Annual Income: ' || v_income );
    DBMS_OUTPUT.PUT_LINE('Income Category: ' || v_category);
    DBMS_OUTPUT.PUT_LINE( 'Tax Amount: ' || v_tax );
    DBMS_OUTPUT.PUT_LINE('Net Income: ' || v_net_income );

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE( 'Taxpayer not found' );
END;
/

EXEC complete_tax_assessment(101);
EXEC complete_tax_assessment(999);

-- Q 2 
CREATE OR REPLACE PROCEDURE income_record_cursor
AS
    CURSOR income_cursor IS
        SELECT
            ir.income_id,
            ir.taxpayer_id,
            ir.income_source,
            ic.category_name,
            ir.amount,
            ir.received_date,
            fy.year_label
        FROM income_record ir
        JOIN income_category ic
            ON ir.category_id = ic.category_id
        JOIN financial_year fy
            ON ir.year_id = fy.year_id;

    v_record_category VARCHAR2(30);
BEGIN
    FOR rec IN income_cursor
    LOOP
        IF rec.amount <= 50000 THEN
            v_record_category := 'Small Income Record';
        ELSIF rec.amount <= 200000 THEN
            v_record_category := 'Medium Income Record';
        ELSE
            v_record_category := 'Large Income Record';
        END IF;
        DBMS_OUTPUT.PUT_LINE('Income ID: ' || rec.income_id);
        DBMS_OUTPUT.PUT_LINE('Taxpayer ID: ' || rec.taxpayer_id);
        DBMS_OUTPUT.PUT_LINE('Income Source: ' || rec.income_source);
        DBMS_OUTPUT.PUT_LINE('Category: ' || rec.category_name );
        DBMS_OUTPUT.PUT_LINE('Amount: ' || rec.amount);
        DBMS_OUTPUT.PUT_LINE('Received Date: ' || rec.received_date);
        DBMS_OUTPUT.PUT_LINE('Financial Year: ' || rec.year_label);
        DBMS_OUTPUT.PUT_LINE('Record Classification: ' || v_record_category);
    END LOOP;
END;
/

EXEC income_record_cursor;

-- Q3
CREATE OR REPLACE PROCEDURE combined_tax_cursor
AS
    CURSOR taxpayer_cursor IS
        SELECT full_name,annual_income
        FROM taxpayer
        WHERE is_active = 1;

    v_category   VARCHAR2(30);
    v_tax  NUMBER(12,2);
    v_net_income NUMBER(12,2);
BEGIN
    FOR rec IN taxpayer_cursor
    LOOP
        v_category := income_classification(rec.annual_income);
        v_tax := calculate_tax(rec.annual_income);
        v_net_income := rec.annual_income - v_tax;

        DBMS_OUTPUT.PUT_LINE('Taxpayer Name: ' || rec.full_name);
        DBMS_OUTPUT.PUT_LINE('Annual Income: ' || rec.annual_income);
        DBMS_OUTPUT.PUT_LINE('Income Category: ' || v_category);
        DBMS_OUTPUT.PUT_LINE('Tax Amount: ' || v_tax);
        DBMS_OUTPUT.PUT_LINE('Net Income: ' || v_net_income);
        DBMS_OUTPUT.PUT_LINE('-----------------------------');
    END LOOP;
END;
/

EXEC combined_tax_cursor;



-- CHALLENGE QUESTION
-- TAXPAYER ASSESSMENT SUMMARY
CREATE OR REPLACE PROCEDURE taxpayer_assessment_summary
AS
    CURSOR taxpayer_cursor IS
        SELECT full_name, annual_income
        FROM taxpayer
        WHERE is_active = 1;

    v_tax NUMBER(12,2);
    v_category VARCHAR2(30);
    v_status VARCHAR2(40);

    v_total_taxpayers NUMBER := 0;
    v_total_income NUMBER(14,2) := 0;
    v_total_tax NUMBER(14,2) := 0;
BEGIN
    FOR rec IN taxpayer_cursor
    LOOP
        v_tax := calculate_tax(rec.annual_income);
        v_category := income_classification(rec.annual_income);

        IF rec.annual_income <= 500000 THEN
            v_status := 'No Tax Assessment';
        ELSIF rec.annual_income <= 1000000 THEN
            v_status := 'Standard Assessment';
        ELSE
            v_status := 'High Income Assessment';
        END IF;

        DBMS_OUTPUT.PUT_LINE('Taxpayer Name: ' || rec.full_name);
        DBMS_OUTPUT.PUT_LINE('Annual Income: ' || rec.annual_income);
        DBMS_OUTPUT.PUT_LINE('Tax Amount: ' || v_tax);
        DBMS_OUTPUT.PUT_LINE( 'Income Category: ' || v_category);
        DBMS_OUTPUT.PUT_LINE('Assessment Status: ' || v_status );
        DBMS_OUTPUT.PUT_LINE('-----------------------------');

        v_total_taxpayers := v_total_taxpayers + 1;
        v_total_income := v_total_income + rec.annual_income;
        v_total_tax := v_total_tax + v_tax;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE( '=================================' );
    DBMS_OUTPUT.PUT_LINE( 'Total Taxpayers Processed: ' || v_total_taxpayers);
    DBMS_OUTPUT.PUT_LINE('Total Income: ' || v_total_income);
    DBMS_OUTPUT.PUT_LINE('Total Tax: ' || v_total_tax);

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE( 'Error while processing assessment: ' ||SQLERRM);
END;
/

EXEC taxpayer_assessment_summary;