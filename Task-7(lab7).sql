Use taxi;
show tables;
-- part A
create view highest_income as 
select * from income_record where amount=(
	select max(amount) from income_record);
    

create view lowest_income as 
select*from income_record where amount = (
select min(amount) from income_record
);

create view above_average_income as
select* from income_record where amount >(select avg(amount) from income_record);


create view highest_income_records as 
select * from income_record where amount=(select max(amount) from income_record);

create view business_owners as 
select * from taxpayer where occupation='Business owner';

select * from highest_income;
select* from lowest_income;
select*from above_average_income;
select * from highest_income_records;
select*from business_owners;


-- level 2

create view taxpayers_with_income as
select*from taxpayer where taxpayer_id in(select taxpayer_id from income_record);

create view taxpayers_business_income as
select* from taxpayer where taxpayer_id IN(
select taxpayer_id from income_record where category_id IN (select category_id from income_category
where category_name='Business')
);


create view income_2025_2026 as
select ir.* from income_record ir 
join financial_year fy on ir.year_id=fy.year_id
where fy.year_label='2025-2026';

create view greater_than_min_business_income as
select* from income_record where
amount>(select min(ir.amount) from income_record ir where ir.category_id in (
select category_id from income_category where category_name='business'));


create view less_than_max_business_income as
select* from income_record where
amount>(select max(ir.amount) from income_record ir where ir.category_id in (
select category_id from income_category where category_name='salary'));


create view taxpayers_above_average_income as
select * from taxpayer where taxpayer_id in(select taxpayer_id from income_record 
where amount>(select avg(amount) from income_record));


create view categories_with_income as
select*from income_category where category_id in(select category_id from income_record);


create view taxpayers_without_investment_income as
select*from taxpayer where taxpayer_id not in (
select taxpayer_id from income_record where category_id in(
select category_id from income_category where category_name='investment'));


-- level 3
create view taxpayer_highest_income as
select* from taxpayer where taxpayer_id in(
select taxpayer_id from income_record where amount=(
select max(amount) from income_record));

create view above_average_business_income as
select * from income_record where amount>(
select avg(amount) from income_record where category_id in(
select category_id from income_category where category_name='business'));


create view taxpayers_above_average_total as
select taxpayer_id, sum(amount) as total_income from income_record group by taxpayer_id having sum(amount)>
(select avg(total_income) from (select taxpayer_id,sum(amount) as total_income from 
income_record group by taxpayer_id) as totals );

create view greater_than_any_investment as select*
from income_record where amount>any(select amount 
from income_record where category_id in(select category_id from income_category where category_name='investment'));


create view greater_than_all_investment as select*
from income_record where amount>all(select amount 
from income_record where category_id in(select category_id from income_category where category_name='investment'));


create view category_highest_income as
select*from income_category where category_id in(select category_id from income_record where
amount=(select max(amount) from income_record));


CREATE VIEW year_highest_total_income AS
SELECT year_id, SUM(amount) AS total_income
FROM Income_Record
GROUP BY year_id
HAVING SUM(amount) = (
    SELECT MAX(total_income)
    FROM (
        SELECT year_id, SUM(amount) AS total_income
        FROM Income_Record
        GROUP BY year_id
    ) AS yearly_totals
);

CREATE VIEW taxpayers_greater_than_average_total AS
SELECT taxpayer_id, SUM(amount) AS total_income
FROM Income_Record
GROUP BY taxpayer_id
HAVING SUM(amount) > (
    SELECT AVG(total_income)
    FROM (
        SELECT taxpayer_id, SUM(amount) AS total_income
        FROM Income_Record
        GROUP BY taxpayer_id
    ) AS taxpayer_totals
);


-- real world taxation analysis
SELECT taxpayer_id, amount
FROM Income_Record
WHERE amount = (
    SELECT MAX(amount)
    FROM Income_Record
);


SELECT taxpayer_id, amount
FROM Income_Record
WHERE amount > (
    SELECT avg(amount)
    FROM Income_Record
);


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


SELECT *
FROM Income_Record
WHERE amount > any (
    SELECT amount
    FROM Income_Record
    WHERE category_id IN (
        SELECT category_id
        FROM Income_Category
        WHERE category_name = 'Investment'
    )
);





