USE taxi;
show tables;
-- level 1 
-- task 1 :DISPLAY every taxpayer along with the income source using inner join
SELECT t.full_name, ir.income_source
FROM Taxpayer t
INNER JOIN Income_Record ir
ON t.taxpayer_id = ir.taxpayer_id;

-- task 2
SELECT t.full_name, ic.category_name FROM Taxpayer t INNER JOIN Income_Record ir ON t.taxpayer_id = ir.taxpayer_id
INNER JOIN Income_Category ic
ON ir.category_id = ic.category_id;

-- task 3
SELECT ir.income_id, ir.income_source, fy.year_label
FROM Income_Record ir
INNER JOIN Financial_Year fy
ON ir.year_id = fy.year_id;

-- task 4
SELECT t.full_name, t.annual_income, ir.amount
FROM Taxpayer t
INNER JOIN Income_Record ir
ON t.taxpayer_id = ir.taxpayer_id;

-- task 5
SELECT t.full_name, ir.income_source,ic.category_name,fy.year_label FROM Taxpayer t
INNER JOIN Income_Record ir ON t.taxpayer_id = ir.taxpayer_id INNER JOIN Income_Category ic ON ir.category_id = ic.category_id
INNER JOIN Financial_Year fy
ON ir.year_id = fy.year_id;


-- level 2
-- task 1
SELECT t.full_name,ir.income_source FROM Taxpayer t INNER JOIN Income_Record ir ON t.taxpayer_id = ir.taxpayer_id
INNER JOIN Income_Category ic
ON ir.category_id = ic.category_id WHERE ic.category_name = 'Salary';

DESC taxpayer;
DESC income_record;
DESC income_category;
DESC financial_year;

-- task 2
select t.full_name,t.occupation
from taxpayer t inner join income_record ir on t.taxpayer_id=ir.taxpayer_id
inner join income_category ic on ir.category_id=ic.category_id
where ic.category_name='business'; 

-- task 3
select t.full_name,t.pan_number,t.occupation,fy.start_date,fy.end_date
from taxpayer t inner join income_record ir on t.taxpayer_id=ir.taxpayer_id
inner join financial_year fy on ir.year_id=fy.year_id;

-- task 4
select t.full_name,t.pan_number,t.occupation,ic.description
from taxpayer t inner join income_record ir on t.taxpayer_id=ir.taxpayer_id inner join income_category ic on ir.category_id=ic.category_id;

-- task 5 
select t.full_name,t.pan_number,t.occupation,ir.income_source,ir.amount,ic.category_name,fy.year_label
from taxpayer t inner join income_record ir on t.taxpayer_id=ir.taxpayer_id
inner join income_category ic on ir.category_id=ic.category_id
inner join financial_year fy on ir.year_id =fy.year_id;


-- level 3
-- task 1

select t.full_name,ir.income_source 
from taxpayer t left join income_record ir on t.taxpayer_id=ir.taxpayer_id;

-- task 2
select ic.category_name,ir.income_source
from income_record ir right join income_category ic on ir.category_id=ic.category_id;

-- task 3
select t.full_name,ir.income_source 
from taxpayer t left join income_record ir on t.taxpayer_id=ir.taxpayer_id
union select ic.category_name,ir.income_source
from income_record ir right join income_category ic on ir.category_id=ic.category_id;




