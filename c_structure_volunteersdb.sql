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
  PRIMARY KEY (volunteer_id, language_id)
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
(2, 32),    -- James, 32 hours
(3, 11),    -- Dexter, 11 hours
(3, 7),     -- Dexter, 7 hours
(3, 5);     -- Dexter, 5 hours
