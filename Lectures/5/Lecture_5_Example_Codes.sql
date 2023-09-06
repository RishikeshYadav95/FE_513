/********
Lecture 5- Database Session I
Content: 
 1. create and drop table, alter table, insert data into table
 2. select query
 3. filtering data
 4. grouping data
**********/

/********* create/drop database *****/
CREATE DATABASE test;

DROP DATABASE IF EXISTS test_2;-- check existence of the database before dropping
-- if see "error:unable to drop database because of some auto connections to DB", you need to disconnect the db first, then drop database. 

/************* create/drop and alter table *****************/
CREATE TABLE branch2(
	branch_name varchar(30), 
	branch_city varchar(30), 
	assets integer
);

DROP TABLE IF EXISTS branch2;

ALTER TABLE branch2 
ADD branch_zipcode char(6);

ALTER TABLE branch2 
DROP branch_zipcode;

INSERT INTO branch(branch_name,branch_city,assets) 
VALUES ('Bank of America', 'Los Angeles',3000);
INSERT INTO branch(branch_name,branch_city,assets) 
VALUES ('JPMorgan Chase', 'New York',1400);
INSERT INTO branch(branch_name,branch_city,assets)
VALUES ('Wells Fargo', 'Orlando',2100);

INSERT INTO branch(branch_name,branch_city,assets)
VALUES ('Bank of America', 'Los Angeles',3000),
 	   ('JPMorgan Chase', 'New York',1400), 
	   ('Wells Fargo', 'Orlando',2100);

/****** select query *****/
--select all records from address
SELECT * 
FROM address;

--select specific columns
SELECT address, city_id, phone 
FROM address;

-- order results by city_id
SELECT address, city_id 
FROM address 
ORDER BY city_id;

SELECT address, city_id 
FROM address 
ORDER BY city_id DESC;

-- add constrain(filter rows)
SELECT * 
FROM address 
WHERE city_id;

SELECT phone, city_id 
FROM address 
WHERE city_id BETWEEN 300 AND 400;

SELECT address,city_id,last_update 
FROM address 
WHERE city_id IN (300,400,500,600);

-- multi-constrain
SELECT * 
FROM address 
WHERE city_id>400 
AND address_id > 100;

-- use "distinct" to remove duplicate rows
SELECT DISTINCT address 
FROM address 
WHERE city_id>400;

-- limit number of rows in output
SELECT city_id,address, phone
FROM address 
ORDER BY city_id DESC 
LIMIT 10;

-- patern search
SELECT * 
FROM address 
WHERE phone LIKE '2__________';

SELECT * 
FROM address 
WHERE phone LIKE '_8%';

/************ grouping data ***********/
-- rename selcted column with "as"
SELECT COUNT(city_id) AS observation_number  
FROM address;

SELECT COUNT(*) AS observation_number, city_id 
FROM address 
GROUP BY city_id 
ORDER BY observation_number DESC;

-- HAVING constrain
SELECT COUNT(*), city_id
FROM address 
GROUP BY city_id 
HAVING COUNT(*) > 1;

-- HAVING vs WHERE
SELECT COUNT(*) AS cnt, city_id 
FROM address 
WHERE city_id > 550 
GROUP BY city_id 
ORDER BY cnt DESC;

SELECT COUNT(*) AS cnt, city_id 
FROM address 
GROUP BY city_id 
HAVING city_id > 550 
ORDER BY cnt DESC;

/******* Appendix (load data) **********/
DROP TABLE IF EXISTS address;
CREATE TABLE address (
    address_id integer NOT NULL,
    address character varying(50) NOT NULL,
    address2 character varying(50),
    district character varying(20) NOT NULL,
    city_id smallint NOT NULL,
    postal_code character varying(10),
    phone character varying(20) NOT NULL,
    last_update timestamp without time zone DEFAULT now() NOT NULL
);

-- In terminal
-- \COPY address (address_id, address, address2, district, city_id, postal_code, phone, last_update) FROM '/Users/cheng/Desktop/2171.dat';


