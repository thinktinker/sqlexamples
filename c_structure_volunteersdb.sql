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

-- Active: 1715564057998@@127.0.0.1@3306
CREATE DATABASE volunteersdb
    DEFAULT CHARACTER SET = 'utf8mb4';

USE volunteersdb;

-- Create the cities table
-- volunteers table will separately refer to this table via city.id to obtain name of the city
CREATE TABLE IF NOT EXISTS cities (
  id INT NOT NULL AUTO_INCREMENT,
  city VARCHAR(100) NOT NULL,
  PRIMARY KEY (id)
);

-- Insert values to cities tables
INSERT INTO cities (id, city) VALUES
(1, "London"),
(2, "Bristol"),
(3, "Hove");

-- Create the languages table
CREATE TABLE IF NOT EXISTS languages (
    id INT NOT NULL AUTO_INCREMENT,
    language VARCHAR(30) NOT NULL,
    PRIMARY KEY (id)
);

-- Insert values to languages table
INSERT INTO LANGUAGES (id, language) VALUES
(1, "German"),
(2, "English"),
(3, "Dutch");

-- Create the volunteers table
CREATE TABLE IF NOT EXISTS volunteers (
    id INT NOT NULL AUTO_INCREMENT,
    surname VARCHAR(50) NOT NULL,
    mobile VARCHAR(15) NOT NULL,
    city_id INT NOT NULL,
    PRIMARY KEY (id),
    CONSTRAINT fk_volunteercity FOREIGN KEY (city_id) REFERENCES cities(id)
);

-- Insert values to volunteers table
INSERT INTO volunteers (surname, mobile, city_id) VALUES
('Kroner', '020 1234 5678',  1),    -- London
('James', '020 5678 1234', 2),      -- Bristol
('Dexter', '020 7654 4321', 3),     -- Hove
('Stephen', '020 4321 8765', 1);    -- London

-- Create the salutations table
CREATE TABLE salutations (
    id INT NOT NULL AUTO_INCREMENT,
    salutation VARCHAR(10) NOT NULL,
    PRIMARY KEY(id)
);

-- Insert values to salutations table
INSERT INTO salutations (id, salutation) VALUES
(1, 'Mr'),
(2, 'Miss'),
(3, 'Mrs');

-- Alter table volunteers to include salutation_id
ALTER TABLE volunteers ADD COLUMN salutation_id INT NOT NULL AFTER id;

-- Insert values of salutation_id to each volunteer
UPDATE volunteers SET salutation_id = 1 WHERE (id = 1);
UPDATE volunteers SET salutation_id = 3 WHERE (id = 2);
UPDATE volunteers SET salutation_id = 2 WHERE (id = 3);
UPDATE volunteers SET salutation_id = 1 WHERE (id = 4);

-- Add constrain, where volunteers table saluation_id reference salutations table's id
ALTER TABLE volunteers
ADD CONSTRAINT fk_volunteerssalutations FOREIGN KEY (salutation_id) 
REFERENCES salutations(id);

-- Create a relationship table between volunteers and languages 
CREATE TABLE IF NOT EXISTS volunteers_languages (
  volunteer_id INT NOT NULL,
  language_id INT NOT NULL,
  CONSTRAINT fk_volunteerlang FOREIGN KEY (volunteer_id) REFERENCES volunteers(id), 
  CONSTRAINT fk_langvolunteer FOREIGN KEY (language_id) REFERENCES languages(id),
  PRIMARY KEY (volunteer_id, language_id)
);

INSERT INTO volunteers_languages (volunteer_id, language_id) VALUES
(1, 1), -- Kroner, German
(1, 2), -- James, English
(2, 2), -- James, English
(3, 1), -- Dexter, German
(3, 2), -- Dexter, English
(3, 3), -- Dexter, Dutch
(4, 1); -- Stephen, German


-- Creat the table that records the hourse put in by each volunteer
CREATE TABLE IF NOT EXISTS volunteer_hours(
    id INT NOT NULL AUTO_INCREMENT,
    volunteer_id INT NOT NULL,
    hours INT NOT NULL,
    created_at DATETIME ON UPDATE CURRENT_TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_volunteer FOREIGN KEY (volunteer_id) REFERENCES volunteers(id),
    PRIMARY KEY (id)
);

INSERT INTO volunteer_hours (volunteer_id, hours) VALUES
(1, 15),    -- Kroner, 15 hours
(1, 12),    -- Kroner, 15 hours
(2, 32),    -- James, 32 hours
(3, 11),    -- Dexter, 11 hours
(3, 7),     -- Dexter, 7 hours
(3, 5);     -- Dexter, 5 hours
