-- part A
-- display the total no.of income records
select COUNT(*) AS total_income_records from income_record;

 -- diplay the total income amount recorded in database
 select sum(amount) as total_income from income_record;
 
 -- display the avg income amount
 select avg (amount) as average_income from income_record;
 
 -- 4.
 select max(amount) as highest_income from income_record;
 
 -- 5
 select min(amount) as lowest_income from income_record;
 
 -- level 2
 -- task1
 select c.category_name,count(*) as no_of_records from income_record join income_category c on i.category_id=c.category_id group by c.category_name;
 
 -- task 2
select c.category_name,sum(i.amount) as no_of_records from income_record i join income_category c on i.category_id=c.category_id group by c.category_name;
  
  -- task 3
  select c.category_name, avg(i.amount) as no_of_records from income_record i join income_category c on i.category_id=c.category_id group by c.category_name;
  
  -- task 4
  select c.category_name,max(i.amount) as no_of_records from income_record i join income_category c on i.category_id=c.category_id group by c.category_name;

-- task 5
select c.category_name,min(i.amount) as no_of_records from income_record i join income_category c on i.category_id=c.category_id group by c.category_name;

-- task 6
select f.year_label,sum(i.amount) as total_income from income_record i join financial_year f on i.year_id=f.year_id group by f.year_label;

-- task 7
select f.year_label,count(*) as no_of_records from income_record i join financial_year f on i.year_id=f.year_id group by f.year_label;

-- task 8
select c.category_name,f.year_label,sum(i.amount) as total_income from income_record i join income_category c on i.category_id=c.category_id join financial_year f on i.year_id=f.year_id group by c.category_name,f.year_label;

-- level 3
-- task 1
select c.category_name,sum(i.amount) as total_income from income_record i join income_category c on i.category_id=c.category_id group by c.category_name having sum(i.amount)>1000000;

-- task 2
select c.category_name,avg(i.amount) as avg_income





  


 
 