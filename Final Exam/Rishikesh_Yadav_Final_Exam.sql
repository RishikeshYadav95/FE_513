/**********************************************
Name: Rishikesh Yadav
CWID: 20007668
File: Rishikesh_Yadav_Final_Exam.sql
Description: Final exam sql submission for FE 513

***********************************************/

/*************** 1.1 ****************/
DROP TABLE IF EXISTS bank;

CREATE TABLE IF NOT EXISTS bank (
id INTEGER NOT NULL,
date DATE NOT NULL,
asset INTEGER NOT NULL,
liability INTEGER NOT NULL,
idx INTEGER NOT NULL
);

COPY bank (id, date, asset, liability, idx) FROM 'C:\Users\psyad\Desktop\Stevens\Sem 4\FE 513\Final Exam\bank_data-1.csv' DELIMITER ',' CSV HEADER;

SELECT * FROM bank;

/*************** 1.2 ****************/
ALTER TABLE bank ADD PRIMARY KEY(idx);

SELECT * FROM bank;

/*************** 1.3 ****************/
SELECT q1.id, q2.quarter, q2.date, q2.asset FROM
(SELECT id, EXTRACT(quarter FROM date) AS quarter, date, asset,
 ROW_NUMBER() OVER (Partition by id ORDER BY id ASC) AS b
from bank
order by id asc) q1
INNER JOIN
(SELECT id, extract(quarter from date) as quarter, date, asset,
 ROW_NUMBER() OVER (Partition by id ORDER BY asset DESC) AS b
FROM bank
ORDER BY id ASC) q2
ON q1.id = q2.id
AND q1.b = 1 AND q2.b = 1
ORDER BY q2.asset DESC
LIMIT 10

/*************** 1.4 ****************/
EXPLAIN ANALYSE
SELECT q1.id, q2.quarter, q2.date, q2.asset FROM
(SELECT id, EXTRACT(quarter FROM date) AS quarter, date, asset,
 ROW_NUMBER() OVER (Partition by id ORDER BY id ASC) AS b
from bank
order by id asc) q1
INNER JOIN
(SELECT id, extract(quarter from date) as quarter, date, asset,
 ROW_NUMBER() OVER (Partition by id ORDER BY asset DESC) AS b
FROM bank
ORDER BY id ASC) q2
ON q1.id = q2.id
AND q1.b = 1 AND q2.b = 1
ORDER BY q2.asset DESC
LIMIT 10

/*************** 1.5 ****************/
SELECT obsv.quarter, count(*) FROM
	(SELECT q1.id, q2.quarter, q2.date, q2.asset FROM
		(SELECT id, EXTRACT(quarter FROM date) AS quarter, date, asset,
		 ROW_NUMBER() OVER (Partition by id ORDER BY id ASC) AS b
		from bank
		order by id asc) q1
	INNER JOIN
		(SELECT id, extract(quarter from date) as quarter, date, asset,
		 ROW_NUMBER() OVER (Partition by id ORDER BY asset DESC) AS b
		FROM bank
		ORDER BY id ASC) q2
	ON q1.id = q2.id
	AND q1.b = 1 AND q2.b = 1
	ORDER BY q2.asset DESC) obsv
GROUP BY obsv.quarter;

/*************** 1.6 ****************/
SELECT COUNT(*) FROM bank WHERE asset > 100000 AND liability < 100000;

/*************** 1.7 ****************/
SELECT AVG(liability) AS Odd_Average_Liability FROM bank WHERE idx % 2 = 1 ;

/*************** 1.8 ****************/
SELECT AVG(liability) AS Even_Average_Liability FROM bank WHERE idx % 2 = 0 ;
SELECT even.Even_Average_Liability - odd.Odd_Average_Liability AS Liability_Difference
FROM
	(SELECT AVG(liability) AS Even_Average_Liability FROM bank WHERE idx % 2 = 0) even,
	(SELECT AVG(liability) AS Odd_Average_Liability FROM bank WHERE idx % 2 = 1) odd ;

/*************** 1.9 ****************/
SELECT q1.id, q1.quarter, q1.date, q1.asset
FROM
	(SELECT id, EXTRACT(quarter FROM date) AS quarter, date, asset, 
	LAG(asset) OVER w AS prev_asset
	FROM bank
	WINDOW w AS (PARTITION BY id ORDER BY EXTRACT(quarter FROM date) ASC)) q1
WHERE q1.asset > q1.prev_asset
LIMIT 10 ;