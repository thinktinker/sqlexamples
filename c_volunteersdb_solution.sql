CREATE DATABASE IF NOT EXISTS volunteersdb;

USE volunteersdb;

-- Create the cities table
-- volunteers table will separately refer to this table via city.id to obtain name of the city
CREATE TABLE IF NOT EXISTS volunteersdb.city (
  id INT NOT NULL AUTO_INCREMENT,
  city_name VARCHAR(100) NOT NULL,
  PRIMARY KEY (id)
);

-- Insert values to city table
INSERT INTO volunteersdb.city (city_name) VALUES
("London"),
("Bristol"),
("Hove");

-- Create the language table
CREATE TABLE IF NOT EXISTS volunteersdb.language (
    id INT NOT NULL AUTO_INCREMENT,
    language_name VARCHAR(255) NOT NULL,
    PRIMARY KEY (id)
);

-- Insert values to language table
INSERT INTO volunteersdb.language (language_name) VALUES
("German"),
("English"),
("Dutch");

-- Create the volunteer table
CREATE TABLE IF NOT EXISTS volunteersdb.volunteer (
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    surname VARCHAR(50) NOT NULL,
    mobile VARCHAR(15) NOT NULL,
    city_id INT NOT NULL,
    CONSTRAINT fk_city_id FOREIGN KEY (city_id) REFERENCES city(id)
);

-- Insert values to volunteers table
INSERT INTO volunteersdb.volunteer (surname, mobile, city_id) VALUES
('Kroner', '020 1234 5678',  1),    -- London
('James', '020 5678 1234', 2),      -- Bristol
('Dexter', '020 7654 4321', 3),     -- Hove
('Stephen', '020 4321 8765', 1);    -- London

-- select all volunteers and their respective cities
SELECT c.city_name, v.surname, v.mobile
FROM volunteersdb.city c, volunteersdb.volunteer v
where c.id = v.city_id;

-- Create the salutation table
CREATE TABLE volunteersdb.salutation (
    id INT NOT NULL AUTO_INCREMENT,
    salutation_name VARCHAR(10) NOT NULL,
    PRIMARY KEY(id)
);

-- Insert values to salutation table
INSERT INTO volunteersdb.salutation (id, salutation_name) VALUES
(1, 'Mr'),
(2, 'Miss'),
(3, 'Mrs');

-- Alter table volunteer to include salutation_id
ALTER TABLE volunteersdb.volunteer
ADD COLUMN salutation_id INT NOT NULL AFTER id;

-- Update the salutations for each volunteer
UPDATE volunteersdb.volunteer SET salutation_id = 1 WHERE id = 1; -- Mr Kroner
UPDATE volunteersdb.volunteer SET salutation_id = 2 WHERE id = 3; -- Ms James
UPDATE volunteersdb.volunteer SET salutation_id = 3 WHERE id = 2; -- Ms Dexter
UPDATE volunteersdb.volunteer SET salutation_id = 1 WHERE id = 4; -- Mr Stephen

-- Add constraint where volunteer table salutation_id 
-- references id from table salutation
ALTER TABLE volunteersdb.volunteer
ADD CONSTRAINT fk_salutation_id FOREIGN KEY (salutation_id) 
REFERENCES salutation(id);

-- Create the referenential integrity between volunteer and language
CREATE TABLE IF NOT EXISTS volunteersdb.volunteer_language(
	volunteer_id INT NOT NULL, 	-- volunteer_id
    language_id INT NOT NULL, 	-- language_id
    CONSTRAINT fk_volunteer_id FOREIGN KEY (volunteer_id) REFERENCES volunteersdb.volunteer(id),	-- constraint between table volunteer
    CONSTRAINT fk_language_id FOREIGN KEY (language_id) REFERENCES volunteersdb.language(id),		-- constraint between table language
    PRIMARY KEY (volunteer_id, language_id) 														-- composite key (volunteer_id and language_id as primary keys)
);

-- Insert volunteers and languages associated
INSERT INTO volunteersdb.volunteer_language(volunteer_id, language_id) VALUES
(1, 1), -- Kroner, German
(1, 2), -- Kroner, English
(2, 2), -- James, English
(3, 1), -- Dexter, German
(3, 2), -- Dexter, English
(3, 3), -- Dexter, Dutch
(4, 1); -- Stephen, German

-- Create a table to manage the hours a volunteer contributes
CREATE TABLE IF NOT EXISTS volunteersdb.volunteer_hour(
	id INT NOT NULL AUTO_INCREMENT PRIMARY KEY, 													 -- id
    volunteer_id INT NOT NULL, 																		 -- volunteer_id (foreign key)
    hours INT NOT NULL, 																			 -- hours
    created_at DATETIME ON UPDATE CURRENT_TIMESTAMP DEFAULT CURRENT_TIMESTAMP, 						 -- create_at
    CONSTRAINT fk_volunteer_hour_id FOREIGN KEY (volunteer_id) REFERENCES volunteersdb.volunteer(id) -- constraint
);

-- Insert the hours each volunteer rakes up per event
INSERT INTO volunteersdb.volunteer_hour (volunteer_id, hours) VALUES
(1, 15);    -- Kroner, 15 hours
INSERT INTO volunteersdb.volunteer_hour (volunteer_id, hours) VALUES
(1, 12);    -- Kroner, 15 hours;
INSERT INTO volunteersdb.volunteer_hour (volunteer_id, hours) VALUES
(2, 32);    -- James,  32 hours
INSERT INTO volunteersdb.volunteer_hour (volunteer_id, hours) VALUES
(3, 11);    -- Dexter, 11 hours
INSERT INTO volunteersdb.volunteer_hour (volunteer_id, hours) VALUES
(3, 7);     -- Dexter, 7 hours
INSERT INTO volunteersdb.volunteer_hour (volunteer_id, hours) VALUES
(3, 5);     -- Dexter, 5 hours

-- **************************************** --
	  -- DML Query relational tables --
-- **************************************** --
-- alot of examples here relate to the assessment --

-- Select information from database tables
SELECT * FROM volunteersdb.salutation;
SELECT * FROM volunteersdb.language;
SELECT * FROM volunteersdb.city;
SELECT * FROM volunteersdb.volunteer;
SELECT * FROM volunteersdb.volunteer_language;
SELECT * FROM volunteersdb.volunteer_hour;

-- Display surname, mobile, city name of each volunteer
SELECT v.surname, v.mobile, c.city_name
FROM volunteer v, city c
WHERE v.city_id = c.id;

-- 'Kroner','020 1234 5678','London'
-- 'Stephen','020 4321 8765','London'
-- 'James','020 5678 1234','Bristol'
-- 'Dexter','020 7654 4321','Hove'

-- Use a JOIN (INNER JOIN) to relate a volunteer and the city lived in
SELECT v.surname, v.mobile, c.city_name
FROM volunteer v JOIN city c
ON v.city_id = c.id;

-- 'Kroner', '020 1234 5678', 'London'
-- 'Stephen', '020 4321 8765', 'London'
-- 'James', '020 5678 1234', 'Bristol'
-- 'Dexter', '020 7654 4321', 'Hove'

-- Display surname, mobile and city name of each volunteer
-- use a JOIN to relate tables volunteer - city
-- use a WHERE clause to set up a condition on only displaying those from "London", "Bristol"
SELECT v.surname, v.mobile, c.city_name
FROM volunteer v JOIN city c
ON v.city_id = c.id
WHERE c.city_name IN ("London", "Bristol");

-- 'Kroner','020 1234 5678','London'
-- 'Stephen','020 4321 8765','London'
-- 'James','020 5678 1234','Bristol'

-- Display volunteers who speaks German
-- where relationship table is involved (volunteer -< volunteer_langauge >- language)
SELECT v.surname, l.language_name
FROM volunteer v
JOIN volunteer_language vl
ON v.id = vl.volunteer_id
JOIN language l
ON l.id = vl.language_id
WHERE l.language_name LIKE "g%";

-- Count the number of volunteers in each city
-- Aggregate function COUNT() is applied
SELECT COUNT(v.city_id) AS "Number of Volunteers", c.city_name
FROM volunteer v JOIN city c
ON v.city_id = c.id
GROUP BY c.city_name
ORDER BY c.city_name DESC; -- DEFAULT IN ASCENDING ORDER

SELECT COUNT(v.city_id) AS `Number of volunteers`, c.city_name
FROM volunteer v JOIN city c 
ON v.city_id = c.id
GROUP BY c.city_name
ORDER BY `Number of volunteers` DESC -- use aliases for sorting (back ticks used)
LIMIT 25;							 -- set the limt on the records to display

-- Display distinct cities that volunteers live in
SELECT COUNT(DISTINCT c.city_name) AS `Number of Cities`
FROM volunteer v JOIN city c
ON c.id = v.city_id;

-- Display all cities amongst volunteers
SELECT DISTINCT(c.city_name) AS `City`
FROM volunteer v JOIN city c
ON v.city_id = c.id;

-- Display languages spoken by volunteers
SELECT DISTINCT(language_name) 
FROM language l JOIN volunteer_language vl
ON l.id = vl.language_id;

-- Insert a new language (but not spoken by those in volunteer table)
INSERT INTO volunteersdb.language(language_name) VALUES("Greek");

-- Display the most spoken language among volunteers
-- TBC: German and English has equal numbers
SELECT MAX(l.language_name) AS `Most Spoken Language`
FROM volunteer_language vl JOIN language l
ON vl.language_id = l.id;

-- Verify the outcome based on the above query
SELECT COUNT(language_name), language_name AS `Language`
FROM language l JOIN volunteer_language vl
ON l.id = vl.language_id
GROUP BY `Language`;

-- Display the least spoken language among volunteers
SELECT MIN(language_name) AS `Least Spoken Language`
FROM volunteer_language vl JOIN language l
ON vl.language_id = l.id;

-- Display the total hours clocked per volunteer
SELECT v.surname AS `Surname`, SUM(vh.hours) AS `Total Volunteered Hours`
FROM volunteer v JOIN volunteer_hour vh
ON v.id = vh.volunteer_id
GROUP BY `Surname`;

-- Display the average hours clocked per volunteer
SELECT 
CONCAT(s.salutation_name, " ", v.surname) AS `Volunteer Name`,
AVG(vh.hours) AS `Average Volunteer Hours`
FROM volunteer_hour vh JOIN volunteer v
ON vh.volunteer_id = v.id
JOIN salutation s
ON s.id = v.salutation_id
GROUP BY `Volunteer Name`;

-- Display most hours clocked per volunteer
SELECT
v.id AS `Volunteer ID`,
v.surname AS `Surname`,
MAX(vh.hours) AS `Most Hours Worked`
FROM volunteer v JOIN volunteer_hour vh
ON v.id = vh.volunteer_id
GROUP BY `Volunteer ID`, `Surname`;

-- Display least hours clocked per volunteer
SELECT
v.id AS `Volunteer ID`,
v.surname AS `Surname`,
MIN(vh.hours) AS `Least Hours Worked`
FROM volunteer v JOIN volunteer_hour vh
ON v.id = vh.volunteer_id
GROUP BY `Volunteer ID`, `Surname`;

-- Using GROUP BY clause with Aliases
-- Back ticks are necessary for the GROUP BY clause
SELECT 
CONCAT(s.salutation_name, " ", v.surname) AS "Full Name",
AVG(hours) AS "Average Volunteer Hours"
FROM volunteer v JOIN volunteer_hour vh
ON v.id = vh.volunteer_id
JOIN salutation s
ON v.salutation_id = s.id
GROUP BY `Full Name`; 


-- SubQuery
-- 1. Write the subquery to retrieve the subset of results
-- 2. Write the outer query to using the subset of results
SELECT SUM(`Total Hours Volunteered`) AS `Cumulative Volunteer Hours`
FROM(
	SELECT SUM(vh.hours) AS `Total Hours Volunteered`
	FROM volunteer v JOIN volunteer_hour vh
	ON v.id = vh.volunteer_id
	GROUP BY v.id
) AS `SubqueryResult`;

-- Subquery 2
-- Find volunteers who had NOT contributed
SELECT v.id, v.surname AS `Volunteer(s) Not Contributed`
FROM volunteer v
WHERE v.id NOT IN (
	SELECT DISTINCT vh.volunteer_id -- returns all volunteers' ids
    FROM volunteer_hour vh			-- found in volunteer_hour table
);


-- Using Case Expressions 
SELECT 
v.surname AS `Surname`,
SUM(CASE WHEN vh.hours > 10 then 1 ELSE 0 END) AS `More than 10 hours worked a visit`
FROM volunteer v JOIN volunteer_hour vh
ON v.id = vh.volunteer_id
GROUP BY `Surname`;

-- Use the HAVING construct to further filter our results after GROUP BY
SELECT 
COUNT(l.language_name) AS `No. of Languages`,
v.surname AS `Surname`
FROM volunteer v JOIN volunteer_language vl
ON v.id = vl.volunteer_id
JOIN language l
ON l.id = vl.language_id
GROUP BY `Surname`
HAVING `No. of Languages` > 1 AND `Surname` LIKE ("Kroner") -- further filter languages spoken > 1
ORDER BY `No. of Languages` DESC; 

-- Using multiple JOINS to relation tables
SELECT v.surname AS `Surname`, l.language_name AS `Language`, c.city_name AS `city`
FROM volunteer v JOIN volunteer_language vl
ON v.id = vl.volunteer_id
JOIN language l
ON l.id = vl.language_id
JOIN city c
ON c.id = v.city_id
WHERE c.city_name IN ("London")		-- filter volunteers who live in "London"
AND l.language_name IN ("German");	-- further filter volunteers who speak "German"
