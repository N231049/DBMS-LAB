USE taxi;
SHOW TABLES;

-- part b-built-in string functions

-- level 1

SELECT * FROM Taxpayer;
SELECT * FROM Income_Category;
SELECT * FROM Financial_Year;
SELECT * FROM Income_Record;

-- 1. Taxpayer names in uppercase
SELECT UPPER(full_name) AS name_in_uppercase
FROM Taxpayer;

-- 2. Occupations in lowercase
SELECT LOWER(occupation) AS occupation_in_lowercase
FROM Taxpayer;

-- 3. Length of each taxpayer name
SELECT full_name, LENGTH(full_name) AS name_length
FROM Taxpayer;

-- 4. First four characters of PAN number
-- If you do not have a PAN column, use taxpayer_id instead.
SELECT taxpayer_id,
       LEFT(CAST(taxpayer_id AS CHAR), 4) AS first_four_characters
FROM Taxpayer;

-- 5. Concatenate taxpayer name and occupation
SELECT CONCAT(full_name, ' - ', occupation) AS taxpayer_details
FROM Taxpayer;

-- 6. Replace Income with Inc. in category names
SELECT category_name,
       REPLACE(category_name, 'Income', 'Inc.') AS short_category_name
FROM Income_Category;

-- 7. Remove leading/trailing spaces from taxpayer names
SELECT TRIM(full_name) AS trimmed_name
FROM Taxpayer;

-- 8. Display first name only
SELECT full_name,
       SUBSTRING_INDEX(TRIM(full_name), ' ', 1) AS first_name
FROM Taxpayer;

-- 9. Required display format
SELECT CONCAT(
    'Taxpayer : ', full_name, CHAR(10),
    'Occupation : ', occupation
) AS taxpayer_display
FROM Taxpayer;

-- 10. Taxpayers whose PAN starts with AP
-- Run this only if your Taxpayer table contains pan_number.
SELECT * FROM Taxpayer
WHERE pan_number LIKE 'AP%';


-- PART C - Built-in Numeric Functions

-- 1. Round annual income
SELECT full_name, annual_income,
       ROUND(annual_income) AS rounded_income
FROM Taxpayer;

-- 2. Absolute value of annual_income - 500000
SELECT full_name, annual_income,
       ABS(annual_income - 500000) AS income_difference
FROM Taxpayer;

-- 3. Square of annual income
SELECT full_name, annual_income,
       POWER(annual_income, 2) AS income_square
FROM Taxpayer;

-- 4. Remainder after annual income is divided by 1000
SELECT full_name, annual_income,
       MOD(annual_income, 1000) AS remainder_value
FROM Taxpayer;

-- 5. Annual income rounded to two decimal places
SELECT full_name, annual_income,
       ROUND(annual_income, 2) AS income_two_decimals
FROM Taxpayer;

-- 6. Ceiling and floor values
SELECT full_name, annual_income,
       CEIL(annual_income) AS ceiling_value,
       FLOOR(annual_income) AS floor_value
FROM Taxpayer;

-- 7. Random integer from 1 to 100
SELECT full_name,
       FLOOR(RAND() * 100) + 1 AS random_number
FROM Taxpayer;

-- 8. Square root of annual income
SELECT full_name, annual_income,
       SQRT(annual_income) AS square_root_of_income
FROM Taxpayer;

-- 9. Income after a 10 percent increment
SELECT full_name, annual_income,
       ROUND(annual_income * 1.10, 2) AS income_after_increment
FROM Taxpayer;


-- PART D - Date Functions
-- Replace start_date if your Financial_Year date column
-- has a different name.

-- 1. Today's date
SELECT CURDATE() AS todays_date;

-- 2. Current date and time
SELECT NOW() AS current_date_and_time;

-- 3. Year from each financial-year start date
SELECT start_date,
       YEAR(start_date) AS start_year
FROM Financial_Year;

-- 4. Month from each financial-year start date
SELECT start_date,
       MONTH(start_date) AS start_month
FROM Financial_Year;

-- 5. Day from each financial-year start date
SELECT start_date,
       DAY(start_date) AS start_day
FROM Financial_Year;

-- 6. Financial-year end date: one year after start date
SELECT start_date,
       DATE_ADD(start_date, INTERVAL 1 YEAR) AS end_date
FROM Financial_Year;

-- 7. Start date after adding 30 days
SELECT start_date,
       DATE_ADD(start_date, INTERVAL 30 DAY) AS start_date_plus_30_days
FROM Financial_Year;

-- 8. Start date after subtracting 7 days
SELECT start_date,
       DATE_SUB(start_date, INTERVAL 7 DAY) AS start_date_minus_7_days
FROM Financial_Year;

-- 9. Number of days between today and start date
SELECT start_date,
       DATEDIFF(CURDATE(), start_date) AS number_of_days
FROM Financial_Year;

-- 10. Financial years belonging to the current year
SELECT *
FROM Financial_Year
WHERE YEAR(start_date) = YEAR(CURDATE());


-- PART E - Conversion Functions

-- 1. Convert annual income into integer
SELECT full_name, annual_income,
       CAST(annual_income AS SIGNED) AS income_as_integer
FROM Taxpayer;

-- 2. Convert taxpayer ID into character
SELECT taxpayer_id,
       CAST(taxpayer_id AS CHAR) AS taxpayer_id_as_character
FROM Taxpayer;

-- 3. Convert financial-year start date into DATETIME
SELECT start_date,
       CAST(start_date AS DATETIME) AS start_date_as_datetime
FROM Financial_Year;

-- 4. Convert annual income into DECIMAL
SELECT full_name, annual_income,
       CAST(annual_income AS DECIMAL(12,2)) AS income_as_decimal
FROM Taxpayer;

-- 5. Display annual income as character strings
SELECT full_name, annual_income,
       CAST(annual_income AS CHAR) AS income_as_text
FROM Taxpayer;

-- 6. Convert numeric value before calculating tax
-- Tax rate used here: 10 percent
SELECT full_name, annual_income,
       CAST(annual_income AS DECIMAL(12,2))
       * CAST(0.10 AS DECIMAL(4,2)) AS calculated_tax
FROM Taxpayer;


