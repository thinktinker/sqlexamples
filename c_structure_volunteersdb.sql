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

-- Drop the cities table if it exists
DROP TABLE IF EXISTS cities;

-- Create the cities table
-- volunteers table will separately refer to this table via city.id to obtain name of the city
CREATE TABLE cities (
  id INT NOT NULL AUTO_INCREMENT,
  city VARCHAR(100) NOT NULL,
  PRIMARY KEY (id)
);

-- Insert values to the cities table
INSERT INTO cities (id, city) VALUES
(1, 'London'),
(2, 'Bristol'),
(3, 'Hove');

-- Drop the languages table if it exists
DROP TABLE IF EXISTS languages;

-- Create the languages table
-- The volunteers table will refer to a pivot table (volunteers_languages, below) via volunteer_id 
-- As one volunteer may speak one or more languages
-- And one language may be spoken by one or more volunteer
CREATE TABLE languages (
  id int NOT NULL AUTO_INCREMENT,
  language varchar(30) NOT NULL,
  PRIMARY KEY (id)
);

-- Insert values to the languages table
INSERT INTO languages (id, language) VALUES
(1, 'German'),
(2, 'English'),
(3, 'Dutch');

-- Drop the volunteers table if it exists
DROP TABLE IF EXISTS volunteers;

-- b) 
-- Create the volunteers table in its FIRST AND SECOND normal form
-- TO BE UPDATED
CREATE TABLE volunteers (
  id INT NOT NULL AUTO_INCREMENT,
  surname VARCHAR(50) NOT NULL,
  mobile VARCHAR(15) NOT NULL,
  city_id INT NOT NULL,
  PRIMARY KEY (id)
);

INSERT INTO volunteers (surname, mobile, city_id) VALUES
('Kroner', '020 1234 5678',  1),
('James', '020 5678 1234', 2),
('Dexter', '020 7654 4321', 3),
('Stephen', '020 4321 8765', 1);

ALTER TABLE volunteers 
ADD CONSTRAINT fk_volunteerscity FOREIGN KEY (city_id) REFERENCES cities(id);


-- Saluation is also not functionally dependent of the columns in volunteers
DROP TABLE IF EXISTS salutations;

CREATE TABLE salutations (
    id INT NOT NULL AUTO_INCREMENT,
    salutation VARCHAR(10) NOT NULL,
    PRIMARY KEY(id)
);

INSERT INTO salutations (id, salutation) VALUES
(1, 'Mr'),
(2, 'Miss'),
(3, 'Mrs');

ALTER TABLE volunteers ADD COLUMN salutation_id INT NOT NULL AFTER id;

UPDATE volunteers SET salutation_id = 1 WHERE (id = 1);
UPDATE volunteers SET salutation_id = 3 WHERE (id = 2);
UPDATE volunteers SET salutation_id = 2 WHERE (id = 3);
UPDATE volunteers SET salutation_id = 1 WHERE (id = 4);

ALTER TABLE volunteers ADD CONSTRAINT fk_volunteerssalutations FOREIGN KEY (salutation_id) REFERENCES salutations(id);

-- Create a relationship table (many-many) between volunteers and the language(s) they speak 
DROP TABLE IF EXISTS volunteers_languages;

CREATE TABLE volunteers_languages (
  volunteer_id INT NOT NULL,
  language_id INT NOT NULL,
  CONSTRAINT fk_volunteerlang FOREIGN KEY (volunteer_id) REFERENCES volunteers(id), 
  CONSTRAINT fk_langvolunteer FOREIGN KEY (language_id) REFERENCES languages(id),
  PRIMARY KEY (volunteer_id, language_id)
);

INSERT INTO volunteers_languages (volunteer_id, language_id) VALUES
(1, 1),
(1, 2),
(2, 2),
(3, 1),
(3, 2),
(3, 3),
(4, 1);

-- Create a table that records the hours put in by each volunteer 
DROP TABLE IF EXISTS volunteer_hours;

CREATE TABLE volunteer_hours (
id INT NOT NULL AUTO_INCREMENT,
volunteer_id INT NOT NULL,
hours INT NOT NULL,
created_at DATETIME ON UPDATE CURRENT_TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
CONSTRAINT fk_volunteer FOREIGN KEY (volunteer_id) REFERENCES volunteers(id),
PRIMARY KEY (id)
);

INSERT INTO volunteer_hours (volunteer_id, hours) VALUES
(1, 15),
(1, 12),
(2, 32),
(3, 11),
(3, 7),
(3, 5);
