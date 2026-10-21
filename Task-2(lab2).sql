 USE taxi;
 /*removing the columns*/
ALTER TABLE income_record
drop column  category_name,
drop column financial_year;

-- adding the columns
alter table income_record
add category_id int,
add year_id int;


-- realtionship-1
alter table income_record
add constraint fk_taxpayer
foreign key (taxpayer_id)
references taxpayer(taxpayer_id);

-- relationship-2
alter table income_record
add constraint fk_category
foreign key(category_id)
references income_category(category_id);

-- relationship 3
alter table income_record
add constraint fk_year
foreign key (year_id)
references financial_year(year_id);





UPDATE Income_Record
SET category_id = 1 ,year_id = 6
WHERE income_id=1001;

UPDATE Income_Record
SET category_id=1,year_id=6
WHERE income_id=1002;

UPDATE Income_Record
SET category_id=2,year_id=6
WHERE income_id=1003;

UPDATE Income_Record
SET category_id=1,year_id=6
WHERE income_id=1004;

UPDATE Income_Record
SET category_id=2,year_id=6
WHERE income_id=1005;

UPDATE Income_Record
SET category_id=2,year_id=6
WHERE income_id=1006;
UPDATE Income_Record
SET category_id = 1 ,year_id = 6
WHERE income_id=1001;

UPDATE Income_Record
SET category_id=1,year_id=6
WHERE income_id=1002;

UPDATE Income_Record
SET category_id=2,year_id=6
WHERE income_id=1003;

UPDATE Income_Record
SET category_id=1,year_id=6
WHERE income_id=1004;

UPDATE Income_Record
SET category_id=2,year_id=6
WHERE income_id=1005;

UPDATE Income_Record
SET category_id=2,year_id=6
WHERE income_id=1006;

-- part b
insert into Income_Record(income_id,taxpayer_id,income_source,amount,received_date,category_id,year_id)
values (1007,999,'hello',8000.00,'2023-1-2',1,9);

INSERT INTO Income_Record(income_id,taxpayer_id,income_source,amount,received_date,category_id,year_id)
VALUES (1008,101,'kinnu',90000.0,'2026-1-1',20,6);

INSERT INTO Income_Record(income_id,taxpayer_id,income_source,amount,received_date,category_id,year_id)
VALUES (1008,101,'kinnu',90000.0,'2026-1-1',1,15);

/* task 6
Foreign Key: A column that references a primary key in another table.

Referential Integrity: Ensures related values are valid and consistent.
For example, Income_Record.category_id must exist in Income_Category.

Foreign keys are required to prevent invalid records, such as an income
record for a non-existent taxpayer, category, or financial year.
*/


-- part c
DELETE FROM Taxpayer
WHERE taxpayer_id=101;

DELETE FROM income_category
WHERE category_id=1;

SELECT DISTINCT occupation
FROM Taxpayer;

SELECT DISTINCT category_name
FROM income_category;

SELECT DISTINCT year_label
FROM financial_year;


SELECT DISTINCT income_source
FROM Income_Record;

-- desc income_record;

-- part d

SELECT full_name from Taxpayer
WHERE taxpayer_id IN(
SELECT taxpayer_id
FROM Income_Record
WHERE category_id=1
)
UNION
SELECT full_name FROM taxpayer
WHERE taxpayer_id IN(
SELECT taxpayer_id FROM income_record
WHERE category_id=2
);

SELECT income_source FROM income_record
WHERE year_id=5
UNION
SELECT income_source FROM income_record
WHERE year_id=6;

-- task-3
SELECT full_name FROM taxpayer
WHERE occupation='teacher'
UNION
SELECT full_name FROM taxpayer
WHERE occupation='software engineer';


-- part e :intersect

SELECT full_name FROM taxpayer
WHERE taxpayer_id IN(
SELECT taxpayer_id FROM income_record
WHERE category_id=1
)
AND taxpayer_id In(
SELECT taxpayer_id FROM income_record
WHERE category_id=2
);


SELECT full_name FROM Taxpayer
WHERE taxpayer_id IN(
SELECT taxpayer_id FROM income_record
WHERE year_id=5
)
AND taxpayer_id IN(
SELECT taxpayer_id
FROM income_record
WHERE year_id=6
);


-- part f
-- here in sql it wont suport the except operator directly so we use not in with a subquery

SELECT full_name FROM taxpayer
WHERE taxpayer_id IN(
	SELECT taxpayer_id
    FROM income_record
    WHERE category_id=1
) 
AND taxpayer_id NOT IN(
	SELECT taxpayer_id FROM income_record
    WHERE category_id=2
);


SELECT full_name FROM taxpayer
WHERE taxpayer_id IN(
	SELECT taxpayer_id
    FROM income_record
    WHERE year_id=6
) 
AND taxpayer_id NOT IN(
	SELECT taxpayer_id FROM income_record
    WHERE year_id=5
);


-- PART G
SELECT full_name FROM taxpayer
WHERE taxpayer_id IN(
	SELECT taxpayer_id FROM income_record
);


SELECT full_name,occupation FROM taxpayer
WHERE occupation IN(
	SELECT occupation FROM taxpayer
    WHERE taxpayer_id IN(
		SELECT taxpayer_id FROM income_record
        WHERE category_id=2
   )
);

-- part h

SELECT full_name FROM taxpayer
WHERE taxpayer_id NOT IN(
SELECT taxpayer_id FROM income_record
);

SELECT DISTINCT occupation
FROM Taxpayer
WHERE occupation NOT IN (
    SELECT DISTINCT t.occupation
    FROM Taxpayer t
    JOIN Income_Record i ON i.taxpayer_id = t.taxpayer_id
);


-- part i-EXISTS

SELECT full_name FROM taxpayer t
WHERE EXISTS(
	SELECT 1 FROM income_record i WHERE i.taxpayer_id=t.taxpayer_id
);


SELECT year_label FROM financial_year fy WHERE EXISTS(
	SELECT 1 FROM income_record i WHERE i.year_id=fy.year_id
);

-- part j-NOT EXISTS
SELECT full_name FROM taxpayer t
WHERE NOT EXISTS(
	SELECT 1 FROM income_record i WHERE i.taxpayer_id=t.taxpayer_id
);


SELECT c.category_name
FROM Income_Category c
WHERE NOT EXISTS (
    SELECT 1
    FROM Income_Record i
    WHERE i.category_id = c.category_id
);


-- PART K-ANY
SELECT full_name,annual_income FROM taxpayer
WHERE annual_income > ANY(
	SELECT annual_income FROM taxpayer WHERE occupation='Teacher'
);

SELECT t.full_name,t.annual_income FROM taxpayer t
WHERE t.annual_income > ANY(
	SELECT t2.annual_income FROM taxpayer t2
    WHERE t2.taxpayer_id IN(
		SELECT i.taxpayer_id FROM income_record i WHERE i.category_id=2
    )
);

-- part L

SELECT full_name,annual_income FROM taxpayer
WHERE annual_income > ALL(
	SELECT annual_income FROM taxpayer WHERE occupation='Teacher'
);

SELECT t.full_name,t.annual_income FROM taxpayer t
WHERE t.annual_income > ALL(
	SELECT t2.annual_income FROM taxpayer t2
    WHERE t2.taxpayer_id IN(
		SELECT i.taxpayer_id FROM income_record i WHERE i.category_id=2
    )
);


-- part M

-- Part M

-- 1. Taxpayers in ascending name order
SELECT * FROM Taxpayer
ORDER BY full_name ASC;

-- 2. Annual income greater than 8,00,000
SELECT full_name, annual_income
FROM Taxpayer
WHERE annual_income > 800000;

-- 3. Software Engineers
SELECT *
FROM Taxpayer
WHERE occupation = 'Software Engineer';

-- 4. Income records in the Business category
SELECT i.*
FROM Income_Record i
JOIN Income_Category c ON c.category_id = i.category_id
WHERE c.category_name = 'Business';

-- 5. Amount between 5,00,000 and 10,00,000
SELECT *
FROM Income_Record
WHERE amount BETWEEN 500000 AND 1000000;

-- 6. Names starting with A
SELECT *
FROM Taxpayer
WHERE full_name LIKE 'A%';

-- 7. Taxpayers from a chosen village/city
SELECT *
FROM Taxpayer
WHERE village_or_city = 'Your Village/City';

-- 8. Active taxpayers
SELECT *
FROM Taxpayer
WHERE status = 'Active';

-- 9. Total taxpayers
SELECT COUNT(*) AS total_taxpayers
FROM Taxpayer;

-- 10. Highest annual income
SELECT MAX(annual_income) AS highest_annual_income
FROM Taxpayer;

-- Part N

-- 1. Taxpayer(s) with the highest annual income
SELECT full_name, annual_income
FROM Taxpayer
WHERE annual_income = (
    SELECT MAX(annual_income)
    FROM Taxpayer
);

-- 2. Category with the highest number of income records
SELECT c.category_name, COUNT(*) AS income_record_count
FROM Income_Category c
JOIN Income_Record i ON i.category_id = c.category_id
GROUP BY c.category_id, c.category_name
ORDER BY income_record_count DESC
LIMIT 1;

-- 3. Taxpayer count per occupation
SELECT occupation, COUNT(*) AS taxpayer_count
FROM Taxpayer
GROUP BY occupation;

-- 4. Number of active taxpayers
SELECT COUNT(*) AS active_taxpayer_count
FROM Taxpayer
WHERE status = 'Active';

-- 5. Financial year with the highest number of income records
SELECT f.year_label, COUNT(*) AS income_record_count
FROM Financial_Year f
JOIN Income_Record i ON i.year_id = f.year_id
GROUP BY f.year_id, f.year_label
ORDER BY income_record_count DESC
LIMIT 1;