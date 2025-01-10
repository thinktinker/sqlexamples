-- Working with volunteersDB
CREATE DATABASE volunteersdb;

USE volunteersdb;

-- 1. Unnormalised Form

-- Normalisation
-- Normalisation gets rid of repeated data from an existing table(s)
-- Reason: repeated data takes up space on the system, and difficult to update
-- Imagine you have to update all fields where city = 'London' (by the multiples or millions)
-- Ref: https://www.freecodecamp.org/news/database-normalization-1nf-2nf-3nf-table-examples/

-- a)
-- In the FIRST NORMAL, we create separate tables for columns cities and languages 
-- that are not functionally dependent to the each volunteer record

USE volunteersdb;

-- Create the cities table
-- volunteers table will separately refer to this table via city.id to obtain name of the city
CREATE TABLE IF NOT EXISTS volunteersdb.city (
  id INT NOT NULL AUTO_INCREMENT,
  city_name VARCHAR(100) NOT NULL,
  PRIMARY KEY (id)
);

-- Insert values to city table
INSERT INTO volunteersdb.city (id, city_name) VALUES
(1, "London"),
(2, "Bristol"),
(3, "Hove");

-- Create the language table
CREATE TABLE IF NOT EXISTS volunteersdb.language (
    id INT NOT NULL AUTO_INCREMENT,
    language_name VARCHAR(255) NOT NULL,
    PRIMARY KEY (id)
);

-- Insert values to language table
INSERT INTO volunteersdb.language (id, language_name) VALUES
(1, "German"),
(2, "English"),
(3, "Dutch");

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

-- Insert values of salutation_id to each volunteer
UPDATE volunteersdb.volunteer SET salutation_id = 1 WHERE id = 1; -- Mr Kroner
UPDATE volunteersdb.volunteer SET salutation_id = 2 WHERE id = 3; -- Ms James
UPDATE volunteersdb.volunteer SET salutation_id = 3 WHERE id = 2; -- Mrs Dexter
UPDATE volunteersdb.volunteer SET salutation_id = 1 WHERE id = 4; -- Mr Stephen

-- Add constrain, where volunteer table saluation_id reference salutation table's id
ALTER TABLE volunteersdb.volunteer
ADD CONSTRAINT fk_salutation_id FOREIGN KEY (salutation_id) 
REFERENCES volunteersdb.salutation(id);

-- Create a relationship table between volunteers and languages 
CREATE TABLE IF NOT EXISTS volunteersdb.volunteer_language (
  volunteer_id INT NOT NULL,
  language_id INT NOT NULL,
  CONSTRAINT fk_volunteer_id FOREIGN KEY (volunteer_id) REFERENCES volunteersdb.volunteer(id), 
  CONSTRAINT fk_language_id FOREIGN KEY (language_id) REFERENCES volunteersdb.language(id),
  PRIMARY KEY (volunteer_id, language_id) -- Composite Primary Key
);

-- Insert values to volunteer_language table
INSERT INTO volunteersdb.volunteer_language (volunteer_id, language_id) VALUES
(1, 1), -- Kroner, German
(1, 2), -- James, English
(2, 2), -- James, English
(3, 1), -- Dexter, German
(3, 2), -- Dexter, English
(3, 3), -- Dexter, Dutch
(4, 1); -- Stephen, German


-- Create the table that records the hours put in by each volunteer
CREATE TABLE IF NOT EXISTS volunteersdb.volunteer_hour(
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    volunteer_id INT NOT NULL,
    hours INT NOT NULL,
    created_at DATETIME ON UPDATE CURRENT_TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_volunteer_hour_id FOREIGN KEY (volunteer_id) REFERENCES volunteer(id)
);

-- Insert values to volunteer_hour table
INSERT INTO volunteersdb.volunteer_hour (volunteer_id, hours) VALUES
(1, 15),    -- Kroner, 15 hours
(1, 12),    -- Kroner, 15 hours
(2, 32),    -- James,  32 hours
(3, 11),    -- Dexter, 11 hours
(3, 7),     -- Dexter, 7 hours
(3, 5);     -- Dexter, 5 hours

SELECT * FROM volunteersdb.salutation;
SELECT * FROM volunteersdb.language;
SELECT * FROM volunteersdb.city;
SELECT * FROM volunteersdb.volunteer;
SELECT * FROM volunteersdb.volunteer_language;
SELECT * FROM volunteersdb.volunteer_hour;


-- Display the surname, mobile and city the volunteer lives in
SELECT v.surname, v.mobile, c.city_name
FROM volunteer v, city c
WHERE v.city_id = c.id;

-- Display the surname, mobile and city the volunteer lives in (using a Join)
SELECT v.surname, v.mobile, c.city_name
FROM volunteer v JOIN city c -- a JOIN == INNER JOIN
ON v.city_id = c.id;

-- Display volunteers who live in london
SELECT v.surname, v.mobile, c.city_name
FROM volunteer v JOIN city c
ON v.city_id = c.id
WHERE c.city_name IN ("London", "Bristol");


-- Display the surname, mobile and city of each volunteer of those who speak German
-- volunteer + city + langauges (volunteers_langauges)
SELECT v.surname, l.language_name
FROM volunteer v 
JOIN volunteer_language vl
ON v.id = vl.volunteer_id
JOIN language l
ON l.id = vl.language_id
WHERE l.language_name = "german";

-- Display the volunteer who speak a language ending with 'ish'
-- Wild card character (%) CAN only be used with LIKE keyword
SELECT v.surname, l.language_name
FROM volunteer v 
JOIN volunteer_language vl
ON v.id = vl.volunteer_id
JOIN language l
ON l.id = vl.language_id
WHERE l.language_name LIKE "g%";

-- Display the number of volunteers based on the city they live in
-- Group by the city_name, sort by city_name (DEFAULT: ASC)
SELECT COUNT(v.city_id) AS "Number of Volunteers", c.city_name
FROM volunteer v JOIN city c
ON v.city_id = c.id
GROUP BY c.city_name
ORDER BY c.city_name DESC;

-- Display the distinct cities that the volunteers live in
SELECT COUNT(DISTINCT c.city_name) AS "Number of Cities"
FROM volunteer v JOIN city c
ON v.city_id = c.id;

-- Display the distinct languages spoken by volunteers
SELECT DISTINCT(language_name)
FROM language l
JOIN volunteer_language vl
ON l.id = vl.language_id;

-- display the language that is most spoken
SELECT MAX(l.language_name) AS "Most spoken language"
FROM volunteer_language vl
JOIN language l
ON vl.language_id = l.id;

-- display the language that is least spoken
SELECT MIN(l.language_name) AS "Least spoken language"
FROM volunteer_language vl
JOIN language l
ON vl.language_id = l.id;

-- display the total volunteered hours per volunteer
SELECT v.surname, SUM(vh.hours) AS "Volunteer Hours"
FROM volunteer_hour vh JOIN volunteer v
ON vh.volunteer_id = v.id
GROUP BY v.surname WITH ROLLUP
ORDER BY `Volunteer Hours` ASC;

-- display the average hours performed by EACH volunteer
SELECT v.surname, AVG(hours) AS "Average Volunteer Hours"
FROM volunteer_hour vh JOIN volunteer v
ON vh.volunteer_id = v.id
GROUP BY volunteer_id;

-- display the average hours performed by EACH volunteer
-- CHALLENGE: display the saluation along-side each name in a single column
SELECT 
CONCAT(s.salutation_name, " ", v.surname) AS "Volunteer Name",
AVG(hours) AS "Average Volunteer Hours"
FROM volunteer_hour vh JOIN volunteer v
ON vh.volunteer_id = v.id
JOIN salutation s
ON s.id = v.salutation_id
GROUP BY v.id;

-- display the most hours worked by each volunteer
SELECT v.surname, MAX(vh.hours) AS "Most Hours Worked"
FROM volunteer_hour vh
JOIN volunteer v
ON vh.volunteer_id = v.id
GROUP BY v.surname
ORDER BY `Most Hours Worked` DESC;

-- display the least hours worked by each volunteer
SELECT v.surname, MIN(vh.hours) AS "Least Hours Worked"
FROM volunteer_hour vh
JOIN volunteer v
ON vh.volunteer_id = v.id
GROUP BY v.surname
ORDER BY `Least Hours Worked`;

-- One can also use a Group By clause with an Alias --
SELECT CONCAT(s.salutation_name, " ", v.surname) AS "Full Name", AVG(hours) AS "Average Volunteer Hours"
FROM volunteer v JOIN volunteer_hour vh
ON v.id = vh.volunteer_id
JOIN salutation s
ON s.id = v.salutation_id
GROUP BY `Full Name`;

-- Subquery come in two parts
-- 1st objective is to derive the subset dataset
-- obtain the subtotal of hours per volunteer
-- 2nd objective is to write the outer query that uses the subset of data 

SELECT SUM(`Total Hours Volunteered`) AS "Cumulative Volunteer Hours"
FROM(
    SELECT SUM(vh.hours) AS "Total Hours Volunteered"
    FROM volunteer v JOIN volunteer_hour vh
    ON v.id = vh.volunteer_id
    GROUP BY v.id -- 27, 32, 23
) AS Cumulative;

-- 1. Find the volunteers by id
-- 2. Find the volunteers by id who have clocked in hours
-- 3. The below is very tedious (eye-ball the data)
select id, surname from volunteer ORDER BY id ASC;
SELECT DISTINCT vh.volunteer_id
FROM volunteer_hour vh; 

-- 4. SOLUTION: Use a subquery to find out which volunteer has not contributed

SELECT v.id, v.surname AS "Volunteer(s) Not Contributed"
FROM volunteer v
WHERE v.id NOT IN(
    SELECT DISTINCT vh.volunteer_id
    FROM volunteer_hour vh -- 1, 2, 3 who contributed
);

-- display the occasion(s) each volunteer put in more than 10 hours per volunteer-visit
SELECT v.surname, SUM(CASE WHEN vh.hours > 10 THEN 1 ELSE 0 END) AS "More than 10 hours a visit"
FROM volunteer v
JOIN volunteer_hour vh
ON v.id = vh.volunteer_id
GROUP BY v.surname;

-- display volunteers who speak more than one language
SELECT COUNT(l.language_name) AS "No. of Languages", v.surname
FROM volunteer v JOIN volunteer_language vl
ON v.id = vl.volunteer_id
JOIN language l
ON l.id = vl.language_id
GROUP BY v.surname
HAVING COUNT(l.language_name) > 1;

-- Display the volunteers who speak German AND lives in London
Select v.surname, l.language_name, c.city_name
FROM volunteer v JOIN volunteer_language vl
ON v.id = vl.volunteer_id
JOIN language l
ON l.id = vl.language_id
JOIN city c
ON v.city_id = c.id
WHERE c.city_name = "London"
AND l.language_name = "German";
