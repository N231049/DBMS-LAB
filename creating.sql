CREATE DATABASE temp1;
DROP DATABASE temp1;
drop database temp2;

create database temp2;
CREATE DATABASE college;
CREATE DATABASE IF NOT EXISTS college;
USE college;
create table student(
	id INT PRIMARY KEY,
    name varchar(50),
    age INT NOT NULL
);

INSERT INTO student VALUES(1,"kiran",26);
INSERT INTO student VALUES(2,"SHRADHA",24);
SELECT * FROM student;

SHOW DATABASES;
show tables;


DROP TABLE student;
drop table college;
