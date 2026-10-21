-- part A 
-- level 1

use taxi;
select * from income_record where amount=(
	select max(amount) from income_record
);

select * from income_record where amount=(
	select min(amount) from income_record
);

select * from income_record where amount >(
	select avg(amount) from income_record
);

-- task 4
select * from income_record where amount=(
	select max(amount) from income_record
);

-- task 5
select * from taxpayer where taxpayer_id in(select taxpayer_id from taxpayer where occupation='Bussiness owner');

-- level 2
-- task 1
select * from taxpayer where taxpayer_id in (
	select taxpayer_id from income_record
);

-- task 2
select * from taxpayer where taxpayer_id in (
	select taxpayer_id from income_record where category_id in(
    select category_id from income_category where category_name='Business')
);

-- task 3
select * from income_record where year_id in(
	select year_id from financial_year where year_label='2025-2026'
);


-- task 4
select * from income_record where amount>(select min(amount) from income_record
where category_id in (select category_id from income_category where category_name='business' ) );


-- task 5
select * from income_record where amount < (select max(amount) from income_record
where category_id in (select category_id from income_category where category_name='salary' ) );


-- task 6
select * from taxpayer where taxpayer_id in(select taxpayer_id from income_record
where amount>(select avg(amount) from income_record) );


-- task 7
select * from income_category where category_id in (select category_id from income_record);

-- task 8
select * from taxpayer where taxpayer_id not in (
	select taxpayer_id from income_record where category_id in(select category_id from income_category where category_name='investment')
);


-- level 3

-- task 1
select * from taxpayer where taxpayer_id in (select taxpayer_id from income_record
where amount =(select max(amount) from income_record)
);


-- task 2
select * from income_record where amount >(select avg(amount) from income_record 
	where category_id in(select category_id from income_category where category_name='business'));
    
    
-- task 3
select taxpayer_id,sum(amount) as total_income
from income_record group by taxpayer_id 
having sum(amount) >(select avg(total_income) from (
select taxpayer_id,sum(amount) as total_income from income_record group by taxpayer_id) as taxpayer_income
);


-- task 4
select * from income_record where amount>ANY(
	select amount from income_record where category_id in (
    select category_id from income_category where category_name='investment')
    );
    
    
-- task 5
select * from income_record where amount>ALL(
	select amount from income_record where category_id in (
    select category_id from income_category where category_name='investment')
    );
    
    
    
-- task 6
select * from income_category where category_id in(
	select category_id from income_record where amount=(select max(amount) from income_record)
);


-- task 7
select * from financial_year where year_id in (
	select year_id from income_record group by year_id
    having sum(amount)=(select max(total_income) from(
    select year_id,sum(amount) as total_income from
    income_record group by year_id) as year_income)
    );
    
    
-- task 8
select taxpayer_id,sum(amount) as total_income
from income_record group by taxpayer_id having sum(amount)>(
select avg(total_income) from (
select taxpayer_id,sum(amount) as total_income from income_record group by taxpayer_id)
as taxpayer_income);


-- real world taxation analysis
select*
from Taxpayer
where taxpayer_id=(select taxpayer_id from Income_Record group by taxpayer_id order by sum(amount)desc limit 1);


-- task 2
SELECT *
FROM Taxpayer
WHERE taxpayer_id IN (
    SELECT taxpayer_id
    FROM Income_Record
    WHERE amount > (
        SELECT AVG(amount)
        FROM Income_Record
    )
);


-- task 3
SELECT *
FROM Income_Category
WHERE category_id IN (
    SELECT category_id
    FROM Income_Record
    WHERE amount = (
        SELECT MAX(amount)
        FROM Income_Record
    )
);


-- task 4
SELECT *
FROM Taxpayer
WHERE taxpayer_id IN (
    SELECT taxpayer_id
    FROM Income_Record
    WHERE category_id IN (
        SELECT category_id
        FROM Income_Category
        WHERE category_name = 'Business'
    )
)
AND taxpayer_id NOT IN (
    SELECT taxpayer_id
    FROM Income_Record
    WHERE category_id IN (
        SELECT category_id
        FROM Income_Category
        WHERE category_name = 'Investment'
    )
);

-- task 5
SELECT *
FROM Income_Record
WHERE amount > ALL (
    SELECT amount
    FROM Income_Record
    WHERE category_id IN (
        SELECT category_id
        FROM Income_Category
        WHERE category_name = 'Investment'
    )
);


-- task 6
SELECT *
FROM Income_Record
WHERE amount > ANY (
    SELECT amount
    FROM Income_Record
    WHERE category_id IN (
        SELECT category_id
        FROM Income_Category
        WHERE category_name = 'Investment'
    )
);


-- task 7
SELECT taxpayer_id, SUM(amount) AS total_income
FROM Income_Record
GROUP BY taxpayer_id
HAVING SUM(amount) = (
    SELECT MAX(total_income)
    FROM (
        SELECT taxpayer_id, SUM(amount) AS total_income
        FROM Income_Record
        GROUP BY taxpayer_id
    ) AS taxpayer_totals
);

-- task 8
select * from income_record where amount in(select amount from income_record group by category_id,amount
having amount > avg(amount)
);





