/*********
FE_513: Homework Assignment 2
Name: Rishikesh Yadav
CWID: 20007668
*********/

/******* Question 1 ********/

--1.1 Creating table  ”World”.
DROP TABLE IF EXISTS World;

CREATE TABLE IF NOT EXISTS World(
	name varchar(30), 
	continent varchar(30), 
	area bigint,
	population bigint,
	gdp bigint,
	PRIMARY KEY (name)
);

--1.2 Inserting sample records in  ”World”.
INSERT INTO World(name,continent,area,population,gdp)
VALUES('Afghanistan', 'Asia', 652230, 25500100, 20343000000),
	  ('Albania', 'Europe', 28748, 2831741, 12960000000),
	  ('Algeria','Africa',2381741,37100000,188681000000),
	  ('Andorra', 'Europe', 468, 78115, 3712000000),
	  ('Angola', 'Africa', 1246700, 20609294, 100990000000);
	  
SELECT * FROM World;

--1.3 Query to report the name, population, and area of the big countries.
SELECT name, population, area FROM World
WHERE area>=3000000
OR population >= 25000000;


/******* Question 2 ********/

--2.1 Creating enum type choice.
CREATE TYPE choice AS ENUM('Y', 'N');

--2.2 Creating table  ”Products table”.
DROP TABLE IF EXISTS Products_table;
CREATE TABLE IF NOT EXISTS Products_table(
	product_id int,
	low_fats choice,
	recyclable choice,
	PRIMARY KEY (product_id)
);

--2.3 Inserting sample records in Products_table.
INSERT INTO Products_table(product_id,low_fats,recyclable)
VALUES(0,'Y','N'),
	  (1,'Y','Y'),
	  (2,'N','Y'),
	  (3,'Y','Y'),
	  (4,'N','N');

SELECT * FROM Products_table;

--2.4 Query to find the ids of products that are both low-fat and recyclable.
SELECT product_id FROM Products_table
WHERE low_fats = 'Y'
AND recyclable = 'Y';