-- Drop database recipedb
DROP DATABASE IF EXISTS recipedb;

-- Create database recipedb
CREATE DATABASE IF NOT EXISTS recipedb;

-- Use the database called recipedb
USE recipedb;

-- Drop table recipedb.category first
DROP TABLE IF EXISTS recipedb.category;

-- Create table recipedb.category
CREATE TABLE recipedb2.category(
id INT NOT NULL AUTO_INCREMENT,
category_name VARCHAR(45) DEFAULT NULL,
created_at DATETIME ON UPDATE CURRENT_TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
PRIMARY KEY (id)
);

-- Alter table category (modify created_at NOT NULL)
ALTER TABLE recipedb.category
  MODIFY created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP;

-- Insert record(s) to category
INSERT INTO recipedb.category (category_name) VALUES ("breakfast");
INSERT INTO recipedb.category (category_name) VALUES ("lunch");
INSERT INTO recipedb.category (category_name) VALUES ("dinner");
INSERT INTO recipedb.category (category_name) VALUES ("appetiser"),("desert"),("main");

-- Update record to category 
UPDATE recipedb.category
SET category_name = "bkfst"
WHERE category_name = "breakfast"
AND id = 1;

-- Select records from category
SELECT * FROM recipedb.category;

-- Delete records from category
DELETE FROM recipedb.category 
WHERE category_name IN ("bkfst", "lunch", "dinner");

-- Delete a record by checking against the uppercase of category_name against the literal string: "MAIN"
DELETE FROM recipedb.category
WHERE UPPER(category_name) IN ("MAIN");

-- Drop table recipe if it exists
DROP TABLE IF EXISTS recipedb.recipe;

-- Create table recipe
CREATE TABLE recipedb.recipe(
	id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	recipe_name VARCHAR(255) DEFAULT NULL,
	recipe_description LONGTEXT DEFAULT NULL,
	created_at DATETIME ON UPDATE CURRENT_TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	category_id INT DEFAULT NULL,
	CONSTRAINT fk_category_id FOREIGN KEY (category_id) REFERENCES recipedb.category(id)
);

-- Alter table recipe (created_at)
ALTER TABLE recipedb.recipe
MODIFY created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP;

-- Alter table recipe (modify category_id NOT NULL)
ALTER TABLE recipedb.recipe
MODIFY category_id INT NOT NULL;

-- Alter table recipe (add attribute author)
ALTER TABLE recipedb.recipe
ADD author VARCHAR(50);

-- Alter table recipe (change attribute name 'author' to 'written_by')
ALTER TABLE recipedb.recipe
CHANGE author written_by VARCHAR(255);

-- Alter table recipe (drop attribute 'written_by')
ALTER TABLE recipedb.recipe
DROP written_by;

-- Insert a recipe under the category of desert (id: 5)
INSERT INTO recipedb.recipe(recipe_name, recipe_description, category_id)
VALUES ("Strawberry Pudding", "TBC", 5);

-- Insert a recipe under the category id: 100
-- The following will NOT work as it infringes on referential integrity (where category_id: 100 does not exist yet)
INSERT INTO recipedb.recipe(recipe_name, recipe_description, category_id)
VALUES ("Wagyu Steak", "TBC", 100);

-- Challenge Statement: How do I delete the record where recipe_name is "Strawberry Pudding"


-- Challenge Statement: How do I delete a record after the id of the record has been identified

