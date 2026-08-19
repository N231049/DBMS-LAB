create database college3;
use college3;


create table student(
marks int primary key,
name varchar(50)
);

select*from student;
insert into student(marks, name) 
values
(100,'kinnu'),
(199,'channi');

select database();
show tables;

drop database college3;
drop table student;




create database kiranmaicompany;
create table employees(
id int primary key,
name varchar(50),
salary int);
insert into employees(id,name,salary)
values
(1,'kinnu',100000),
(2,'jabille',100000),
(3,'akhil',100000);
select*from employees;
drop table temp3;
create table temp3(
id int,
name varchar(50),
salary int default 30,
primary key (id,name)/*the combination of these two is a primary key ..means no column can have combination of id and ame are same ex:-1,kinnu   1,kinnu    like this*/
);

select database();
insert into temp3(id,name) values (101,'kinnu'); /*dont give the column name if you are using default key..to print the default value*/
insert into temp3(id,name) values (102,'kinnu');
select * from temp3;








