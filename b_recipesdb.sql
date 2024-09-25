-- Drop database recipedb2;
DROP DATABASE IF EXISTS recipedb2;

-- Create database recipedb2
CREATE DATABASE IF NOT EXISTS recipedb2;

-- Use the database called recipedb2
USE recipedb2;

-- Drop table recipedb2.category first
DROP TABLE IF EXISTS recipedb2.category;

-- Create table recipedb2.category
CREATE TABLE recipedb2.category(
id INT NOT NULL AUTO_INCREMENT,
category_name VARCHAR(45) DEFAULT NULL,
created_at DATETIME ON UPDATE CURRENT_TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
PRIMARY KEY (id)
);

-- Alter table category (modify created_at NOT NULL)
ALTER TABLE recipedb2.category
  MODIFY created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP;

-- Insert record(s) to category
INSERT INTO recipedb2.category (category_name) VALUES ("breakfast");
INSERT INTO recipedb2.category (category_name) VALUES ("lunch");
INSERT INTO recipedb2.category (category_name) VALUES ("dinner");
INSERT INTO recipedb2.category (category_name) VALUES ("appetiser"),("desert"),("main");

-- Update record to category 
UPDATE recipedb2.category
SET category_name = "bkfst"
WHERE category_name = "breakfast"
AND id = 1;

-- Select records from category
SELECT * FROM recipedb2.category;

-- Delete records from category
DELETE FROM recipedb2.category 
WHERE category_name IN ("bkfst", "lunch", "dinner");

-- Delete a record by checking against the uppercase of category_name against the literal string: "MAIN"
DELETE FROM recipedb2.category
WHERE UPPER(category_name) IN ("MAIN");

-- Drop table recipe if it exists
DROP TABLE IF EXISTS recipedb2.recipe;

-- Create table recipe
CREATE TABLE recipedb2.recipe(
id INT NOT NULL AUTO_INCREMENT,
recipe_name VARCHAR(255) DEFAULT NULL,
recipe_description LONGTEXT DEFAULT NULL,
created_at DATETIME ON UPDATE CURRENT_TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
category_id INT DEFAULT NULL,
PRIMARY KEY (id),
KEY fk_idcategory (category_id),
CONSTRAINT fk_idcategory FOREIGN KEY (category_id) REFERENCES recipedb2.category(id)
);

-- Alter table recipe (created_at)
ALTER TABLE recipedb2.recipe
MODIFY created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP;

-- Alter table recipe (modify category_id NOT NULL)
ALTER TABLE recipedb2.recipe
MODIFY category_id INT NOT NULL;

-- Alter table recipe (add attribute author)
-- TBC: max no. of varchar
ALTER TABLE recipedb2.recipe
ADD author VARCHAR(50);

-- Alter table recipe (change attribute name 'author' to 'written_by')
ALTER TABLE recipedb2.recipe
CHANGE author written_by VARCHAR(255);

-- Alter table recipe (drop attribute 'written_by')
ALTER TABLE recipedb2.recipe
DROP written_by;

-- Insert a recipe under the category of desert (id: 5)
INSERT INTO recipedb2.recipe(recipe_name, recipe_description, category_id)
VALUES ("Strawberry Pudding", "TBC", 5);

-- Insert a recipe under the category id: 100
-- The following will NOT work as it infringes on referential integrity (where category_id: 100 does not exist yet)
INSERT INTO recipedb2.recipe(recipe_name, recipe_description, category_id)
VALUES ("Wagyu Steak", "TBC", 100);

-- Challenge Statement: How do I delete the record where recipe_name is "Strawberry Pudding"
DELETE FROM recipedb2.recipe 
WHERE LOWER(recipe_name) IN ("strawberry pudding");

-- Challenge Statement: How do I delete a record after the id of the record has been identified
DELETE FROM recipedb2.recipe
WHERE id IN (8);

-- Challenge Statement: Attempting to delete a record from category which is related to a record in recipe
-- The following will NOT work as it infringes on referential integrity (desert of id:5 is tied to a recipe that uses the category) 
DELETE FROM recipedb2.category
WHERE id IN (5);

-- Insert recipe "Chicken Cordon Bleu" that corresonds to category_id 9 ("main") 
-- NOTE: Use the category_id according to the id generated for table category for "main"
INSERT INTO recipedb2.recipe (recipe_name, recipe_description, category_id) VALUES("Chicken Cordon Bleu", "4 boneless skinless chicken, salt to taste, pepper o taste, 1 tablespoon garlic powder, 1 tablespoon onion powder, 16 slices swiss cheese, 1/2 lb ham(225 g)thinly sliced, peanut oil or vegetable oil for frying, 1 cup all-purpose flour(125 g), 4 eggs beaten, 2 cups panko bread crumbs(100 g)", 9);

-- Insert recipe "Tiramisu" that corresonds to category_id 5 ("dessert") 
-- NOTE: Use the category_id according to the id generated for table category for "dessert"
INSERT INTO recipedb2.recipe (recipe_name, recipe_description, category_id) VALUES("Tiramisu", "Dutch processed cocoa powder, espresso (2 shots), vanilla extract (1 g), 5 pasteurized eggs, sugar (1/2 cup), kosher salt (2 tspn), Mascarpone cheese (1 cup), Heavy cream (1/2 cup)", 5);

-- Select category_name, recipe_name, recipe_description from tables category and recipe
SELECT c.category_name, r.recipe_name, r.recipe_description 
FROM category c, recipe r
WHERE c.id = r.category_id;

-- Select category_name and all the attributes of recipe
SELECT c.category_name, r.*
FROM category c, recipe r
WHERE c.id = r.category_id;
