drop database college;
create database college;
USE college;
create table student(
	rollno int primary key,
    name varchar(50),
    marks int not null,
    grade varchar(1),
    city varchar(50)
);

insert into student(rollno,name,marks,grade,city) 
values
(101,'kinnu',55,'A','pune'),
(102,'kiran',55,'B','puneooo'),
(103,'kiranmai',55,'c','penta'),
(104,'diwani',55,'D','pig'),
(105,'mental',55,'e','punga'),
(106,'kullu',55,'f','puen');

select*from student;
select city from student;/*the star selcts all the columns while if you mention any column name that will get you all the items stored in that column*/
select distinct name from student;/*the distinct helps us to obtains all the distinct values of that column .*/
select marks,name from student where marks>50;
select city from student where city="punga";
select * from student where marks>80 and city="mumbai";/*here in place of and ,we can place or.. means only if either one condition is true of two is enough.*/
select marks,name from student where marks+50>50;
select marks,name from student where marks!=50;
select name from student where name in ("punga","kullu");
select name from student where name not in ("punga","kullu");
select marks,name from student where marks between 50 and 90;
select * from student limit 3;
select * from student where marks>50 limit 3;
select * from student order by city ASC;/*asc means ascending and desc means descending order*/
select * from student order by name DESC;

/*aggregate functions*/

select max(marks) from student ;
select avg(marks) from student;
select min(marks) from student;
select count(name) from student;
select avg(marks) from student order by marks;/*asc or desc are only used for the text..for somethings like marks you can simply use the column name*/


/*group by clause*/
select city from student group by city;
select city,count(name) from student group by city;
select city,name ,count(rollno) from student group by rollno;







