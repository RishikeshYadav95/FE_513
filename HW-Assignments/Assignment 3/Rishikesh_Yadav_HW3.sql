/***********  1.1  ***********/
--Creating tables
DROP TABLE IF EXISTS banks_sec_2002;

CREATE TABLE IF NOT EXISTS banks_sec_2002 (
	id INTEGER NOT NULL,
	date DATE NOT NULL,
	security INTEGER NOT NULL
);

DROP TABLE IF EXISTS banks_al_2002;

CREATE TABLE IF NOT EXISTS banks_al_2002 (
	id INTEGER NOT NULL,
	date DATE NOT NULL,
	asset INTEGER NOT NULL,
	liability INTEGER NOT NULL
);

--Reading CSV files and adding data to the tables
COPY banks_sec_2002(id, date, security) FROM 'C:\Users\psyad\Desktop\Stevens\Sem 4\FE 513\HW-Assignments\Assignment 3\banks_sec_2002.csv' DELIMITER ',' CSV HEADER;
COPY banks_al_2002(id, date, asset, liability) FROM 'C:\Users\psyad\Desktop\Stevens\Sem 4\FE 513\HW-Assignments\Assignment 3\banks_al_2002-1.csv' DELIMITER ',' CSV HEADER;

SELECT * FROM banks_sec_2002;
SELECT * FROM banks_al_2002;
--Check duplicate
SELECT id, date, security, count(id) as cnt FROM banks_sec_2002 GROUP BY id, date, security  having count(id) > 1;

--Delete duplicate
DELETE FROM banks_sec_2002 WHERE ctid not in ( SELECT MIN(ctid) FROM banks_sec_2002 GROUP BY id, date, security);

/***********  1.2  ***********/
Select bs.id, bs.date, bs.security, ba.asset, ba.liability from banks_sec_2002 bs
inner join banks_al_2002 ba on ba.id = bs.id and ba.date = bs.date
LIMIT 10;

/***********  1.3  ***********/
CREATE TABLE banks_total AS
SELECT ROW_NUMBER() OVER (ORDER BY bs.id, bs.date) AS pkey, bs.id, bs.date, bs.security, ba.asset, ba.liability from banks_sec_2002 bs
INNER JOIN banks_al_2002 ba ON ba.id = bs.id AND ba.date = bs.date;

ALTER TABLE banks_total ADD PRIMARY KEY(pkey);

SELECT * FROM banks_total;

/***********  1.4  ***********/
Select COUNT(*) as Q1_banks
from banks_total
where (extract(quarter from date) = 1) and security > (0.2 * asset);

Select COUNT(*) as Q2_banks
from banks_total
where (extract(quarter from date) = 2) and security > (0.2 * asset);

Select COUNT(*) as Q3_banks
from banks_total
where (extract(quarter from date) = 3) and security > (0.2 * asset);

Select COUNT(*) as Q4_banks
from banks_total
where (extract(quarter from date) = 4) and security > (0.2 * asset);

/***********  1.5  ***********/
Select COUNT(*) as banks from 
(Select id
from banks_total
where (extract(quarter from date) = 1) and liability > (0.9 * asset)) inc
inner JOIN
(Select id
from banks_total
where (extract(quarter from date) = 2) and liability < (0.9 * asset)) dec on dec.id = inc.id

/***********  1.6  ***********/
COPY banks_total TO 'C:\Users\psyad\Desktop\Stevens\Sem 4\FE 513\HW-Assignments\Assignment 3\banks_total.csv' DELIMITER ',' CSV HEADER;