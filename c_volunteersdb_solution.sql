-- Active: 1715564057998@@127.0.0.1@3306@volunteersdb
SELECT * FROM salutation;
SELECT * FROM language;
SELECT * FROM city;
SELECT * FROM volunteer;
SELECT * FROM volunteer_language;
SELECT * FROM volunteer_hour;


-- display the surname, mobile and city from volunteers and cities table
SELECT v.surname, v.mobile, c.city_name
FROM volunteer v, city c
WHERE v.city_id = c.id;

-- display the surname, mobile and city of each volunteer, using a JOIN
SELECT v.surname, v.mobile, c.city_name
FROM volunteer v
JOIN city c
ON v.city_id = c.id;

-- display volunteers who live in London
SELECT v.surname, v.mobile, c.city_name
FROM volunteer v
JOIN city c
ON v.city_id = c.id
WHERE c.city_name = "London";

-- display the surname, mobile and city of each volunteer of those who speak German
-- volunteer + city + langauges (volunteers_langauges)
SELECT v.surname, v.mobile, l.language_name
FROM volunteer v
JOIN volunteer_language vl
ON v.id = vl.volunteer_id
JOIN language l
ON l.id = vl.language_id
WHERE LOWER(l.language_name) = "german";

-- displaying surname, mobile and city of volunters who speak German
-- using the LIKE keyword with the wildcard character (%)
SELECT v.surname, v.mobile, l.language_name
FROM volunteer v
JOIN volunteer_language vl
ON v.id = vl.volunteer_id
JOIN language l
ON l.id = vl.language_id
WHERE l.language_name LIKE "%Ger%";

-- display volunteer number in their specific city
-- using COUNT() aggregate function, GROUP BY must be used
-- using ORDER BY to list the data in ASC or DESC order (default, ASC)
SELECT COUNT(v.city_id) AS "Number of Volunteers", c.city_name
FROM volunteer v
JOIN city c
ON v.city_id = c.id
GROUP BY v.city_id
ORDER BY c.city_name;


-- display the number of distinct cities from volunteers
SELECT COUNT(DISTINCT c.city_name) AS "Number of Cities"
FROM volunteer v
JOIN city c
ON v.city_id = c.id;

-- display the distinct languages spoken by volunteers
SELECT DISTINCT(l.language_name)
FROM volunteer_language vl
JOIN language l
ON vl.language_id = l.id;

-- display the language that is most spoken
SELECT MAX(l.language_name) AS "Most Spoken Language"
FROM volunteer_language vl
JOIN language l
ON vl.language_id = l.id;

-- display the least spoken langauge amongst volunteers
SELECT MIN(l.language_name) AS "Least Spoken Language"
FROM volunteer_language vl
JOIN language l
ON vl.language_id = l.id;


-- ***********************************************

-- display the total volunteered hours per volunteer
SELECT v.surname, SUM(vh.hours) AS "Volunteer hours"
FROM volunteer_hour vh
JOIN volunteer v
ON vh.volunteer_id = v.id
GROUP BY v.surname
ORDER BY `Volunteer hours` ASC;

-- display the avg hours performed by each volunteer
SELECT AVG(vh.hours) AS "Average Volunteer Hours", v.surname AS "Surname"
FROM volunteer v
JOIN volunteer_hour vh
ON v.id = vh.volunteer_id
GROUP BY `Surname`
ORDER BY `Average Volunteer Hours` DESC;

-- display the most hours worked by each volunteer
SELECT v.surname, MAX(vh.hours) AS "Most Hours Worked"
FROM volunteer_hour vh
JOIN volunteer v
ON vh.volunteer_id = v.id
GROUP BY v.surname
ORDER BY `Most Hours Worked` DESC;

-- display the least hours worked by each volunteer
SELECT v.surname, MIN(vh.hours) AS "Least Hours Worked"
FROM volunteer_hour vh
JOIN volunteer v
ON vh.volunteer_id = v.id
GROUP BY v.surname
ORDER BY `Least Hours Worked`;

-- display the culmulative hours worked from all volunteers
-- using a subquery
SELECT SUM(`Total Hours Volunteered`) AS "Cumulative Volunteer Hours"
FROM(
    SELECT SUM(vh.hours) AS "Total Hours Volunteered"
    FROM volunteer v
    JOIN volunteer_hour vh
    ON v.id = vh.volunteer_id
    GROUP BY vh.volunteer_id
) AS Cumulative;

SELECT SUM(hours) AS "Cumulative Volunteer Hours"
FROM volunteer_hour;

-- display the occasion each volunteer puts up more than 10 hours per visit
SELECT v.surname,
SUM(CASE WHEN vh.hours > 10 THEN 1 ELSE 0 END) AS "Occasions volunteered > 10 hours"
FROM volunteer v
JOIN volunteer_hour vh
ON v.id = vh.volunteer_id
GROUP BY v.surname;

-- Display volunteers who speak MORE THAN ONE language
SELECT COUNT(l.language_name) AS "Languages Spoken", v.surname
FROM volunteer v 
JOIN volunteer_language vl
ON v.id = vl.volunteer_id
JOIN language l
ON l.id = vl.language_id
GROUP BY v.surname
HAVING COUNT(l.language_name) > 1
ORDER BY COUNT(v.salutation_id) ASC
LIMIT 10;
