/*********
content:
1. Table join
2. Set operation
*********/

/********** 1 table joining ***********/
--1.1 create example table at first
DROP TABLE IF EXISTS departments;
CREATE TABLE
IF NOT EXISTS departments (
 department_id serial PRIMARY KEY,
 department_name VARCHAR (255) NOT NULL
);

DROP TABLE IF EXISTS employees;
CREATE TABLE
IF NOT EXISTS employees (
 employee_id serial PRIMARY KEY,
 employee_name VARCHAR (255),
 department_id INTEGER
);

INSERT INTO departments (department_id, department_name)
VALUES(1,'Sales'),
	  (2,'Marketing'),
	  (3,'HR'),
	  (4,'IT'),
	  (5,'Production');
	  
INSERT INTO employees (employee_name,department_id)
VALUES('Bette Nicholson', 1),
	  ('Christian Gable', 1),
	  ('Joe Swank', 2),
	  ('Fred Costner', 3),
	  ('Sandra Kilmer', 4),
	  ('Julia Mcqueen', NULL);

SELECT * FROM departments;
SELECT * FROM employees;

--1.2 Joining multiple tables 

-- 0. natural join
-- try to avoid this
SELECT employee_name, department_name 
FROM employees e 
NATURAL JOIN departments d;

-- 1. inner join
SELECT *
FROM employees e INNER JOIN departments d 
ON d.department_id = e.department_id;

SELECT * 
FROM departments;
-- 2. left/right join
SELECT employee_name, department_name 
FROM employees e RIGHT JOIN departments d 
ON d.department_id = e.department_id;

-- 3. full outer join
SELECT employee_name, department_name 
FROM employees e FULL OUTER JOIN departments d
ON d.department_id = e.department_id;

SELECT employee_name, department_name 
FROM employees e FULL OUTER JOIN departments d 
USING (department_id);-- -- equivalent to above clause

-- 4. cross join
SELECT employee_name, department_name 
FROM employees e CROSS JOIN departments d;


/******** 2 set operation *********************/
--2.1 create table example
DROP TABLE IF EXISTS employees;
CREATE TABLE employees (
 employee_id serial PRIMARY KEY,
 employee_name VARCHAR (255) NOT NULL
);

DROP TABLE IF EXISTS keys; 
CREATE TABLE keys (
 employee_id INT PRIMARY KEY,
 age INT  NOT NULL,
 FOREIGN KEY (employee_id) 
	REFERENCES employees (employee_id)
); -- key employees

DROP TABLE IF EXISTS hipos;
CREATE TABLE hipos (
 employee_id INT PRIMARY KEY,
 age INT NOT NULL,
 FOREIGN KEY (employee_id) 
	REFERENCES employees (employee_id)
); --  high potential employees

INSERT INTO employees (employee_name) 
VALUES ('Joyce Edwards'),
	   ('Diane Collins'),
	   ('Alice Stewart'),
	   ('Julie Sanchez'),
	   ('Heather Morris'),
	   ('Teresa Rogers'),
	   ('Doris Reed'),
	   ('Gloria Cook'),
	   ('Evelyn Morgan'),
	   ('Jean Bell');
	   
INSERT INTO keys 
VALUES(1, 22),
	  (2, 31),
	  (5, 25),
	  (7, 54);
	  
INSERT INTO hipos 
VALUES(9, 21),
	  (2, 31),
	  (5, 25),
	  (10, 36);

SELECT * FROM employees;
SELECT * FROM keys;
SELECT * FROM hipos;

--2.2 performing set operations 
-- 2.2.1 UNION
-- select employees who are either key, or high potential
SELECT employee_id
FROM keys 
UNION 
SELECT employee_id
FROM hipos; 

-- 2.2.2 INTERSECT
-- select employees who are both key, and high potential
SELECT employee_id 
FROM keys 
INTERSECT 
SELECT employee_id 
FROM hipos; 

SELECT employee_id
FROM keys INNER JOIN hipos
USING (employee_id);

-- 2.2.3 EXCEPT
-- select employees who are key, but not high potential
SELECT employee_id 
FROM keys 
EXCEPT 
SELECT employee_id
FROM hipos; 


