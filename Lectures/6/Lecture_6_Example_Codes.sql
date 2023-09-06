/*********
content:
1. primary key
2. foreign key
*********/


/******* 1 primary key ********/

-- 1.1 Initialize table with primary key(one column)
DROP TABLE IF EXISTS employees;

CREATE TABLE employees (
 employee_id INT PRIMARY KEY,
 department_name VARCHAR (255)
);

INSERT INTO employees 
VALUES (1, 'Sales'),
	   (2,'Marketing'),
	   (3, 'HR'),
	   (4, 'IT'),
	   (5, 'Production');
	   
SELECT * 
FROM employees;

/* be careful when insert data into table with primary key */
-- gets error when exists duplicate value in primary key column: 
-- duplicate key value violates unique constraint "employees_pkey"
INSERT INTO employees 
VALUES(1, 'Sales');

-- gets error when put null for primary key: 
-- null value in column "employee_id" violates not-null constraint
INSERT INTO employees 
VALUES (null, 'Maintenance');
	   
--  no error when put null for department_name
INSERT INTO employees 
VALUES (6, null));
	   
-- 1.2 Primary key consisting of two columns
DROP TABLE IF EXISTS employees;

CREATE TABLE employees (
 employee_id INT,
 department_name VARCHAR (255),
 employee_name VARCHAR (255),
 PRIMARY KEY (employee_id, department_name)
);

SELECT *
FROM employees;

INSERT INTO employees 
VALUES (1, 'Sales', 'John'),
	   (2,'Marketing', 'Mike'),
	   (3, 'HR', 'Harry'),
	   (4, 'HR', 'Tony'),
	   (4, 'Production', 'Tony');
	   
-- 1.3 Define primary key when changing the existing table structure
DROP TABLE  IF EXISTS employees;

CREATE TABLE employees (
 employee_id int,
 department_name VARCHAR (255)
);

INSERT INTO employees 
VALUES (1, 'Sales'),
	   (2,'Marketing'),
	   (3, 'HR'),
	   (4, 'IT'),
	   (5, 'Production');
	   
SELECT * FROM employees;

-- 1.3.1 add primary key
ALTER TABLE employees 
ADD CONSTRAINT PK_employees PRIMARY KEY (employee_id, department_name); 

-- 1.3.2 auto-incremented primary key
ALTER TABLE employees 
ADD COLUMN idx SERIAL PRIMARY KEY;

-- 1.3.3 drop primary key. 
-- Because we didn’t specify a name for the foreign key constraint explicitly, 
-- PostgreSQL assigned a name with the pattern: table_column_pkey
ALTER TABLE employees 
DROP CONSTRAINT employees_pkey; 

/******* 2 foreign key ********/

-- 2.1 Define simple PostgreSQL foreign key constraint
DROP TABLE IF EXISTS contacts;
DROP TABLE IF EXISTS customers;

CREATE TABLE customers(
   customer_id SERIAL,
   customer_name VARCHAR(255) NOT NULL,
   PRIMARY KEY(customer_id)
);

CREATE TABLE contacts(
   contact_id SERIAL,
   customer_id INT,
   contact_name VARCHAR(255) NOT NULL,
   phone VARCHAR(15),
   email VARCHAR(100),
   PRIMARY KEY(contact_id),
   CONSTRAINT fk_customer
      FOREIGN KEY(customer_id) 
	  	REFERENCES customers(customer_id)
);

-- insert values into both tables
INSERT INTO customers(customer_name)
VALUES('BlueBird Inc'),
      ('Dolphin LLC');	   
	   
INSERT INTO contacts(customer_id, contact_name, phone, email)
VALUES(1,'John Doe','(408)-111-1234','john.doe@bluebird.dev'),
      (1,'Jane Doe','(408)-123-4567','jane.doe@notebook.dev'),
      (2,'David Wright','(408)-222-1234','david.wright@dolphin.dev');
	  
SELECT * 
FROM customers;

SELECT * 
FROM contacts;

-- 2.2 Delete action on foreign key

-- 2.2.1 no action
DELETE FROM customers
WHERE customer_id = 1;

-- 2.2.2 'CASCADE'
ALTER TABLE contacts
DROP CONSTRAINT fk_customer;

ALTER TABLE contacts
ADD CONSTRAINT fk_customer
FOREIGN KEY(customer_id) 
REFERENCES customers(customer_id)
ON DELETE CASCADE;

DELETE FROM customers
WHERE customer_id = 1;

SELECT *
FROM contacts;

-- 2.2.1 'set null' action
ALTER TABLE contacts
DROP CONSTRAINT fk_customer;

ALTER TABLE contacts
ADD CONSTRAINT fk_customer
FOREIGN KEY(customer_id) 
REFERENCES customers(customer_id)
ON DELETE SET NULL;

DELETE FROM customers
WHERE customer_id = 1;

SELECT *
FROM contacts;


