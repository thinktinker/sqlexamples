-- Drop database if exst recipedb
DROP DATABASE IF EXISTS recipedb;

-- Create a database name recipedb
CREATE DATABASE IF NOT EXISTS recipedb;
USE recipedb;


-- Drop tables if exist category
DROP TABLE IF EXISTS recipedb.category;

-- Create table category
CREATE TABLE recipedb.category (
  id INT NOT NULL AUTO_INCREMENT,
  category_name varchar(45) DEFAULT NULL,
  created_at DATETIME ON UPDATE CURRENT_TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id)
);

-- Alter table cateory (modify created_at NOT NULL)
ALTER TABLE recipedb.category
  MODIFY created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP;


-- Insert record(s) to category
INSERT INTO recipedb.category (category_name) VALUES ("breakfast");
INSERT INTO recipedb.category (category_name) VALUES ("lunch");
INSERT INTO recipedb.category (category_name) VALUES ("dinner");
INSERT INTO recipedb.category (category_name) VALUES ("appetiser"),('dessert'), ('main');

-- Select EVERYTHING from the table category
SELECT * FROM recipedb.category;

-- Update record(s) to category
UPDATE recipedb.category
SET category_name = "bkfst"
WHERE category_name="breakfast";

-- Delete record(s)
DELETE FROM category WHERE category_name IN ("breakfast", "lunch", "dinner");

-- Using WHERE and AND clause to retrieve records
DELETE FROM category WHERE category_name IN ("breakfast") AND category_name IN ("lunch") AND category_name IN ("dinner");

-- Using clause and SQL function to retrieve and delete records
DELETE FROM category WHERE LOWER(category_name) IN ("breakfast", "lunch", "dinner");
DELETE FROM category WHERE LOWER(category_name) IN ("appetiser");
DELETE FROM category WHERE UPPER(category_name) IN ("main");

-- Drop table recipe
DROP TABLE IF EXISTS recipedb.recipe;

-- Create table recipe
CREATE TABLE recipedb.recipe (
  id INT NOT NULL AUTO_INCREMENT,
  recipe_name VARCHAR(255) DEFAULT NULL,
  recipe_description LONGTEXT DEFAULT NULL,
  created_at DATETIME ON UPDATE CURRENT_TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  category_id INT DEFAULT NULL,
  PRIMARY KEY (id),
  KEY fk_idcategory (category_id),
  CONSTRAINT fk_idcategory FOREIGN KEY (category_id) REFERENCES category (id)
);

-- Alter table recipe (set created_at NOT NULL)
ALTER TABLE recipedb.recipe
  MODIFY created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP;

-- Alter table recipe (modify category_id NOT NULL)
ALTER TABLE recipedb.recipe
  MODIFY category_id INT NOT NULL;

-- Alter table recipe (add updated_AT)
ALTER TABLE recipedb.recipe 
	ADD updated_at DATETIME NOT NULL ON UPDATE CURRENT_TIMESTAMP DEFAULT CURRENT_TIMESTAMP;

-- Alter table recipe (add attribute author)
ALTER TABLE recipedb.recipe
	ADD author VARCHAR(50);

-- Alter table recipe (change author to written_by VARCHAR(255))
ALTER TABLE recipedb.recipe
	CHANGE author written_by VARCHAR(255);

-- Alter table recipe (drop written_by)
ALTER TABLE recipedb.recipe
	DROP written_by;


-- Insert recipe "Chicken Cordon Bleu" that corresonds to category_id 6 ("main") 
-- NOTE: Use the category_id according to the id generated for table category for "main"
INSERT INTO recipedb.recipe (recipe_name, recipe_description, category_id) VALUES("Chicken Cordon Bleu", "4 boneless skinless chicken, salt to taste, pepper o taste, 1 tablespoon garlic powder, 1 tablespoon onion powder, 16 slices swiss cheese, 1/2 lb ham(225 g)thinly sliced, peanut oil or vegetable oil for frying, 1 cup all-purpose flour(125 g), 4 eggs beaten, 2 cups panko bread crumbs(100 g)", 6);

-- Insert recipe "Tiramisu" that corresonds to category_id 5 ("dessert") 
-- NOTE: Use the category_id according to the id generated for table category for "dessert"
INSERT INTO recipedb.recipe (recipe_name, recipe_description, category_id) VALUES("Tiramisu", "Dutch processed cocoa powder, espresso (2 shots), vanilla extract (1 g), 5 pasteurized eggs, sugar (1/2 cup), kosher salt (2 tspn), Mascarpone cheese (1 cup), Heavy cream (1/2 cup)", 5);

-- Select and display category_name, recipe_name and recipe_description
-- where category.id corresponds to recipe.category_id
-- c and r are abbreviations of the actual table names (aka alias)
SELECT c.category_name, r.recipe_name, r.recipe_description
FROM category c, recipe r
WHERE c.id = r.category_id;

-- Select and display category_name and everything from recipe
-- where category.id corresponds to recipe.category_id
-- c and r are abbreviations of the actual table names (aka alias)
SELECT c.category_name, r.*
FROM category c, recipe r
WHERE c.id = r.category_id;