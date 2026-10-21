create database taxi;
use taxi;
create table taxpayer(
 taxpayer_id int primary key,
 pan_number varchar(10) not null unique,
 full_name varchar(100) not null,
 date_of_birth date not null,
 occupation varchar(50) not null,
 annual_income decimal(12,2) unique,
 email varchar(100) unique,
 is_active boolean
 );
 
 insert into taxpayer(taxpayer_id,pan_number,full_name,date_of_birth,occupation,annual_income,email,is_active)
 values
 (101,'ABCDE1234F','Ravi kumar','1995-06-15','software engineer',850000.00,'ravikumar@gmail.com',True),
 (102,'BCDEF2345G','Priya sharma','1992-11-22','Doctor',1200000.00,'priyasharma@gmail.com',true),
 (103,'CDEFG3456H','Arjun reddy','1998-03-10','Bussiness owner',1800000.00,'arjunreddy@gmail.com',true),
 (104,'DEFGH4567J','sneha patel','1998-08-05','teacher',620000.00,'sneha.patel@example.com',true),
 (105,'EFGHJ5678K','kiran rao','1990-01-18','Freelancer',750000.00,'kiranroa@example.com',true),
 (106,'FGHIJK678L','meera singh','1985-12-30','consultant',1500000.00,'meerasingh@gmail.com',false);
 
 insert into taxpayer(taxpayer_id,pan_number,full_name,date_of_birth,occupation,annual_income,email,is_active)
 values
 (107,'GHIJKL890M','Ravi sooraj','1998-06-15','software',85000.00,'ravisooraj@gmail.com',True);
 
 alter table taxpayer
 add phone_number varchar(11);
 
 update taxpayer
 set annual_income=950000.00
 where annual_income=850000.00;
 
 update taxpayer
 set occupation='software consultant'
 where taxpayer_id=105;
 
 update taxpayer
 set is_active=true
 where taxpayer_id=106;
 
 delete from taxpayer
 where taxpayer_id=107;
 
alter table taxpayer
modify column occupation
varchar(100);
 
 
 select * from taxpayer;
 
 
 /*entity 2*/
 create database income;
 create table income_category(
	category_id int primary key,
    category_name varchar(50) not null unique,
    description varchar(200) not null,
    taxable boolean not null
 );
 
 insert into income_category(category_id,category_name,description,taxable)
 values
 (1,'salary','income received from employement',true),
 (2,'business','income earned from business activities',true),
 (3,'house property','income received from property or rent',true),
 (4,'capital gains','income from transfer of eligible assets',true),
 (5,'other sources','income such as bank interest',true),
 (6,'Agriculture income','income from eligible agriculturL Activities',false);
 
 insert into income_category(category_id,category_name,description,taxable)
 values
 (7,'salaryies','income received from rental income',true);
 select *from income_category;
 
 
 
 
 /*entity 3*/
 create database finance;
 create table Financial_Year(
	year_id int primary key,
    year_label varchar(9) not null unique,
    start_date date not null,
    end_date date not null,
    filing_deadline date ,
    is_current boolean not null
);
 
insert into Financial_Year(year_id,year_label,start_date,end_date,filing_deadline,is_current)
values
(1,'2020-2021','2020-04-01','2021-03-31','2021-07-31',false),
(2,'2021-2022','2021-04-01','2022-03-31','2022-07-31',false),
(3,'2022-2023','2022-04-01','2023-03-31','2023-07-31',false),
(4,'2023-2024','2023-04-01','2024-03-31','2024-07-31',false),
(5,'2024-2025','2024-04-01','2025-03-31','2025-07-31',false),
(6,'2025-2026','2025-04-01','2026-03-31','2026-07-31',true);

select * from Financial_Year;


/*Entity 4:Income record*/

create database Incomess;
CREATE TABLE Income_Record(
income_id int primary key,
taxpayer_id int not null,
income_source varchar(100) not null,
category_name varchar(50) not null,
amount decimal(12,2) not null,
received_date date not null,
financial_year varchar(9) not null
);

insert into Income_Record(income_id,taxpayer_id,income_source,category_name,amount,received_date,financial_year)
values
(1001,101,'TechNova Solutions','Salary',850000.00,'2026-03-31','2025-2026'),
(1002,102,'City care hospital','Salary',1800000.00,'2026-03-31','2025-2026'),
(1003,103,'Reddy Enterprises','Bussiness',1800000.00,'2026-03-31','2025-2026'),
(1004,104,'Sunrise school','Salary',620000.00,'2026-03-31','2025-2026'),
(1005,105,'Web design projects','Bussiness',750000.00,'2026-03-31','2025-2026'),
(1006,106,'Professional Consulting','Bussiness',1500000.00,'2026-03-31','2025-2026');

alter table Income_Record
 add remarks varchar(100);


select*from Income_Record;

/*Task-4*/
create database temp;
create table Tax_office(
office_id int primary key,
office_name varchar(100) not null,
city varchar(50) not null
);

insert into Tax_office(office_id,office_name,city)
values
(1,'microsoft','mumbai'),
(2,'google','banglore');

select*from Tax_office;

truncate table Tax_office;

drop table Tax_office;







 
 

 
