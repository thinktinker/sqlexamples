CREATE DATABASE enrolmentdb;

USE enrolmentdb;

CREATE TABLE student(
    student_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    course_id INT
);

CREATE TABLE course(
    course_id INT PRIMARY KEY,
    course_code VARCHAR(5) UNIQUE,
    title VARCHAR(200),
    student_id INT
);

ALTER TABLE course
MODIFY COLUMN course_id NOT NULL AUTO_INCREMENT;

ALTER TABLE student 										# Add referential integrity for student table (foreign key ref. course table)
ADD CONSTRAINT fk_course_id
FOREIGN KEY (course_id) REFERENCES course(course_id);

ALTER TABLE course											# Add referential integrity for student table (foreign key ref. student table)
ADD CONSTRAINT fk_student_id
FOREIGN KEY (student_id) REFERENCES student(student_id);

ALTER TABLE student											# Remove constraint for student table
DROP FOREIGN KEY fk_course_id;

ALTER TABLE course											# Remove constraint for course table
DROP FOREIGN KEY fk_student_id;	

CREATE TABLE enrolment(										# Create the relationship table that manages student <-> course
	enrolment_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    student_id INT,
    course_id INT,
    CONSTRAINT fk_student_id FOREIGN KEY (student_id) REFERENCES student (student_id),
    CONSTRAINT fk_course_id FOREIGN KEY (course_id) REFERENCES course (course_id)
);
