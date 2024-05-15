SELECT * from salutations;
SELECT * from languages;
SELECT * from cities;
SELECT * from volunteers;
SELECT * from volunteers_languages;

-- display the surname, mobile and city of each volunteer
SELECT v.surname, v.mobile, c.city
FROM volunteers v, cities c
WHERE v.city_id = c.id;

-- display the surname, mobile and city of each volunteer; this time using JOIN
SELECT v.surname, v.mobile, c.city
FROM volunteers v
JOIN cities c
ON v.city_id = c.id;

-- display the volunteer(s) who lives in London
SELECT *
FROM volunteers v
JOIN cities c
ON v.city_id = c.id
WHERE c.city = "London";

-- display surname, mobile and language fof those who speak German
SELECT v.surname, v.mobile, l.language
FROM volunteers v
JOIN volunteers_languages vl
ON v.id = vl.volunteer_id
JOIN languages l
ON l.id = vl.language_id
WHERE l.language = "German";

-- display surname, mobile and language fof those who speak German
SELECT v.surname, v.mobile, l.language
FROM volunteers v
JOIN volunteers_languages vl
ON v.id = vl.volunteer_id
JOIN languages l
ON l.id = vl.language_id
WHERE l.language LIKE '%German%';

-- refine the condition, display the count of volunteers from "London"
SELECT COUNT(v.city_id) AS "Number of Volunteers", c.city
FROM volunteers v
JOIN cities c
ON v.city_id = c.id
WHERE c.city LIKE "%London%"
GROUP BY v.city_id
ORDER BY c.city DESC; -- ASC or DESC

-- display the volunteer who speaks more than one language
-- GROUP BY ... HAVING to expand our query's condition
-- https://dev.mysql.com/doc/refman/8.0/en/problems-with-alias.html
SELECT COUNT(l.language) AS `Languages Spoken`, v.surname
FROM volunteers v
JOIN volunteers_languages vl
ON v.id = vl.volunteer_id
JOIN languages l
ON l.id = vl.language_id
GROUP BY v.surname
HAVING COUNT(l.language) > 1
ORDER BY `Languages Spoken` DESC;

-- display the number of distinct cities from volunteers
SELECT COUNT(DISTINCT c.city) AS "Number of Cities"
FROM volunteers v
JOIN cities c
ON v.city_id = c.id;

-- display the distinct languages spoken by volunteers in the database
SELECT DISTINCT(l.language)
FROM volunteers_languages vl
JOIN languages l
ON l.id = vl.language_id;

-- display the most spoken language amongst the volunteers
SELECT MAX(l.language) AS `Most Spoken Language`
FROM volunteers_languages vl
JOIN languages l
ON l.id = vl.language_id;

-- display the least spoken language amongst the volunteers
SELECT MIN(l.language) AS `Least Spoken Language`
FROM volunteers_languages vl
JOIN languages l
ON l.id = vl.language_id;

-- display the total volunteered hours per volunteer
SELECT SUM(vh.hours) as `Volunteered Hours`, v.surname
FROM volunteers v
JOIN volunteer_hours vh
ON v.id = vh.volunteer_id
GROUP BY volunteer_id;

-- display the average volunteered hours per volunteer
SELECT v.id AS `Volunteer ID`, AVG(vh.hours) as `Average Volunteered Hours`, v.surname
FROM volunteers v
JOIN volunteer_hours vh
ON v.id = vh.volunteer_id
GROUP BY volunteer_id;

-- Q: display the most hours worked by a volunteer
-- Q: display the least hours worked by a volunteer

-- display the cumulative volunteer hours from all volunteers
SELECT SUM(`Total Hours Volunteered`) as `Total Hours Volunteered`
FROM (
    SELECT SUM(vh.hours) as `Total Hours Volunteered`, v.surname
    FROM volunteers v
    JOIN volunteer_hours vh
    ON v.id = vh.volunteer_id
    GROUP BY volunteer_id
) AS Cumulative;

-- display the occasion each volunteer put up more than 1O hours per visit
SELECT 
v.surname,
SUM(CASE WHEN vh.hours > 10 THEN 1 ELSE 0 END) AS `Occasions volunteered hours > 10`
FROM volunteers v
JOIN volunteer_hours vh
ON v.id = vh.volunteer_id
GROUP BY v.surname;

