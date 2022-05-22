DROP SCHEMA IF EXISTS training;
CREATE SCHEMA training;
USE training;

DROP TABLE IF EXISTS departments;
CREATE TABLE departments (
    department_id int primary key NOT NULL AUTO_INCREMENT,
    department_name varchar(20)
) ENGINE=INNODB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS employees;
CREATE TABLE employees (
    employee_id int primary key NOT NULL AUTO_INCREMENT,
    department_id int,
    name varchar(20),
    age int,
    CONSTRAINT fk_department_id
    FOREIGN KEY (department_id) 
    REFERENCES departments (department_id)
    ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=INNODB DEFAULT CHARSET=utf8;