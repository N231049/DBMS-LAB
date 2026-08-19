create database student;
create table s1(
roll_no int primary key,
full_name varchar(50),
age int 
);

insert into s1(roll_no ,full_name,age ) values
(1,"kiranmai",17),
(2,"jabille",18),
(3,"akhil",17),
(4,"jaya",18);

create table s2(
roll_no1 int primary key,
full_name1 varchar(50),
age1 int,
proid int  
);

insert into s2(roll_no1 ,full_name1,age1,proid ) values
(1,"kiri",17,1),
(2,"jab",18,2),
(3,"akhilaaa",17,3),
(4,"jayasri",18,4);

select * from s1;
select * from s2;
select * from s1 cross join s2;
select * from s1 inner join s2 on s2.proid=s1.roll_no;
select * from s1 inner join s2 on s2.proid>=s1.roll_no;
select * from s1 natural join s2;
select * from s1 left outer join s2 on s1.roll_no=s2.proid;
select * from s1 right outer join s2 on s1.roll_no=s2.proid;

select * from s1 full outer join s2 on s1.roll_no=s2.proid;




