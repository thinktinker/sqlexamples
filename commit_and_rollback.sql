USE testdb;

CREATE TABLE users(
	id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    email VARCHAR(255) UNIQUE
);

INSERT INTO users (first_name, last_name, email)
VALUES ("John", "Doe", "johndoe@gmail.com");

SET AUTOCOMMIT = 0;						-- turns off auto commit (so that one can roll back accidental changes)

DELETE FROM users						-- Scenario 1: I may have accidentally deleted a user
WHERE id = 1;

ROLLBACK;							-- I decided to perform a rollback to undo the 'deletion'

SELECT * FROM users;						-- Check the users is re-instated

UPDATE users
SET email = "johndoh@gmail.com"	-- Scenario 2: The email of the user is updated erroneously
WHERE id = 1;

ROLLBACK;							-- Rollback to undo the changes

UPDATE users
SET email = "johndoe@yahoo.com"					-- Scenario 3: The email of the user is finally established correctly
WHERE id = 1;

COMMIT;								-- The change in scenario 3 is committed (permanent)

ROLLBACK;							-- ONCE A COMMIT IS EXECUTED, any rollback is FULTILE

								-- HOW MANY ROLLBACKS CAN TAKE PLACE?

UPDATE users							-- Change #1
SET last_name = "doh"
WHERE id = 1;

UPDATE users							-- Change #2
SET email = "johndoh@yahoo.com"
WHERE id = 1;

ROLLBACK;							-- The ROLLBACK here will undo all previous changes unless a COMMIT is executed.

SET AUTOCOMMIT = 1;						-- turn back on auto commit (so that changes are permanent)

