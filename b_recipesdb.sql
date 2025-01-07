-- Drop database recipedb
DROP DATABASE IF EXISTS recipedb;

-- Create database recipedb
CREATE DATABASE IF NOT EXISTS recipedb;

-- Use the database called recipedb
USE recipedb;

-- Drop table recipedb.category first
DROP TABLE IF EXISTS recipedb.category;

-- Create table recipedb.category
CREATE TABLE recipedb.category(
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
	category_id INT,
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
-- Solution: Use WildCard(s) to render the condition
    -- Option 1: % (reps. start and or end of a series of characters)
    -- Option 2: _ (single wildcard character)
DELETE from recipedb.recipe WHERE recipe_name LIKE "Strawberry%"; 

-- Challenge Statement(s):

-- 1. Ensure category table contains category names "appetiser", "main" and "dessert";
-- 2. For any not found, insert these category names to the category table.
-- 3. Insert the following into recipe table:

Select * from recipedb.category;
INSERT INTO recipedb.category (category_name) VALUES ("main");

-- recipe_name: "Chicken Cordon Bleu"
-- recipe_description: "4 boneless skinless chicken, salt to taste, pepper o taste, 1 tablespoon garlic powder, 1 tablespoon onion powder, 16 slices swiss cheese, 1/2 lb ham(225 g)thinly sliced, peanut oil or vegetable oil for frying, 1 cup all-purpose flour(125 g), 4 eggs beaten, 2 cups panko bread crumbs(100 g)"
-- category: main

-- recipe_name: "Tiramisu"
-- description: "Dutch processed cocoa powder, espresso (2 shots), vanilla extract (1 g), 5 pasteurized eggs, sugar (1/2 cup), kosher salt (2 tspn), Mascarpone cheese (1 cup), Heavy cream (1/2 cup)"
-- category: dessert

INSERT INTO recipedb.recipe (recipe_name, recipe_description, category_id) 
VALUES 
("Chicken Cordon Bleu", 
"4 boneless skinless chicken, salt to taste, pepper o taste, 1 tablespoon garlic powder, 1 tablespoon onion powder, 16 slices swiss cheese, 1/2 lb ham(225 g)thinly sliced, peanut oil or vegetable oil for frying, 1 cup all-purpose flour(125 g), 4 eggs beaten, 2 cups panko bread crumbs(100 g)",
11),
("Tiramisu",
"Dutch processed cocoa powder, espresso (2 shots), vanilla extract (1 g), 5 pasteurized eggs, sugar (1/2 cup), kosher salt (2 tspn), Mascarpone cheese (1 cup), Heavy cream (1/2 cup)",
5);

SELECT * FROM recipedb.recipe;

-- Display the category_name, recipe_name and recipe_description from recipedb

SELECT c.category_name, r.recipe_name, r.recipe_description
FROM category c, recipe r
WHERE c.id = r.category_id;  -- condition to match the id between the category and the category_id found in recipe

-- JOIN, INNER JOIN, LEFT JOIN, RIGHT JOIN


