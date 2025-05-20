-- create database enrolmentdb
CREATE DATABASE enrolmentdb;

-- use database enrolmentdb
USE enrolmentdb;

-- create table student
CREATE TABLE student(
	student_id INT NOT NULL PRIMARY KEY,
    first_name VARCHAR(100),
    last_name VARCHAR(100)
);

-- TODO: alter table ADD COLUMN course_id INT
ALTER TABLE student
ADD COLUMN course_id INT;

-- create table course
CREATE TABLE course(
	course_id INT PRIMARY KEY,
    course_code VARCHAR(5) UNIQUE,
    title VARCHAR(200),
    student_id INT
);

-- TODO: set auto increment for table course's course_id
ALTER TABLE course
MODIFY COLUMN course_id INT NOT NULL AUTO_INCREMENT;

-- TODO: alter the tables to set the references
-- alter table student (set reference to foreign key)
ALTER TABLE student
ADD CONSTRAINT fk_course_id
FOREIGN KEY (course_id) REFERENCES course(course_id);

-- CHALLENGE: error found referencing the foreign key
-- TODO:
-- step 1: DROP CONSTRAINT 
ALTER TABLE student
DROP FOREIGN KEY fk_course_id;

-- step 2: RECREATE THE CONSTRAINT

-- alter table course (set reference to foreign key)
ALTER TABLE course
ADD CONSTRAINT fk_student_id
FOREIGN KEY (student_id) REFERENCES student(student_id);

-- Having seen the EER diagram
-- which is NOT IDEAL; transitive dependencies (normalisation)
-- step 1: drop all foreign keys first
-- step 2: re-create the constraints managed by a relationship table

ALTER TABLE student DROP FOREIGN KEY fk_course_id;
ALTER TABLE course 	DROP FOREIGN KEY fk_student_id;

CREATE TABLE enrolment(
	enrolment_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
	student_id INT,
    course_id INT,
    CONSTRAINT fk_student_id FOREIGN KEY (student_id) REFERENCES student(student_id),
    CONSTRAINT fk_course_id FOREIGN KEY (course_id) REFERENCES course(course_id)
);

-- alternative scenario where student_id and course_id are used TOGETHER as primary key
-- step 1: drop the enrolment table first
-- step 2: re-create the enrolment able using the alternative scenario
DROP TABLE enrolment;

-- notice in this altenative example, 2 attributes are used as primary key
-- composite key
CREATE TABLE enrolment(
	student_id INT NOT NULL,
    course_id INT NOT NULL,
    CONSTRAINT fk_student_id FOREIGN KEY (student_id) REFERENCES student(student_id),
    CONSTRAINT fk_course_id FOREIGN KEY (course_id) REFERENCES course(course_id),
	PRIMARY KEY (student_id, course_id)
);


