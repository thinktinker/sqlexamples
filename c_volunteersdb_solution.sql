-- Active: 1715564057998@@127.0.0.1@3306@volunteersdb
SELECT * FROM salutations;
SELECT * FROM languages;
SELECT * FROM cities;
SELECT * FROM volunteers;
SELECT * FROM volunteers_languages;
SELECT * FROM volunteer_hours;

-- display the surname, mobile and city from volunteers and cities table
SELECT v.surname, v.mobile, c.city
FROM volunteers v, cities c
WHERE v.city_id = c.id;

-- display the surname, mobile and city of each volunteer, using a JOIN
SELECT v.surname, v.mobile, c.city
FROM volunteers v
JOIN cities c
ON v.city_id = c.id;

-- display volunteers who live in London
SELECT v.surname, v.mobile, c.city
FROM volunteers v
JOIN cities c
ON v.city_id = c.id
WHERE c.city = "London";

-- display the surname, mobile and city of each volunteer of those who speak German
-- volunteer + city + langauges (volunteers_langauges)
SELECT v.surname, v.mobile, l.language
FROM volunteers v
JOIN volunteers_languages vl
ON v.id = vl.volunteer_id
JOIN languages l
ON l.id = vl.language_id
WHERE LOWER(l.language) = "german";

-- displaying surname, mobile and city of volunters who speak German
-- using the LIKE keyword with the wildcard character (%)
SELECT v.surname, v.mobile, l.language
FROM volunteers v
JOIN volunteers_languages vl
ON v.id = vl.volunteer_id
JOIN languages l
ON l.id = vl.language_id
WHERE l.language LIKE "%German%";

-- display volunteer number in their specific city
-- using COUNT() aggregate function, GROUP BY must be used
-- using ORDER BY to list the data in ASC or DESC order (default, ASC)
SELECT COUNT(v.city_id) AS "Number of Volunteers", c.city
FROM volunteers v
JOIN cities c
ON v.city_id = c.id
GROUP BY v.city_id
ORDER BY c.city;

-- display the number of distinct cities from volunteers
SELECT COUNT(DISTINCT c.city) AS "Number of Cities"
FROM volunteers v
JOIN cities c
ON v.city_id = c.id;

-- display the distinct languages spoken by volunteers
SELECT DISTINCT(l.language)
FROM volunteers_languages vl
JOIN languages l
ON vl.language_id = l.id;

-- display the volunteer who speaks the most languages
SELECT MAX(l.language) AS "Most Spoken Language"
FROM volunteers_languages vl
JOIN languages l
ON vl.language_id = l.id;

-- display the least spoken langauge amongst volunteers
SELECT MIN(l.language) AS "Least Spoken Language"
FROM volunteers_languages vl
JOIN languages l
ON vl.language_id = l.id;

-- display the total volunteered hours per volunteer
SELECT v.surname, SUM(vh.hours) AS `Volunteered hours`
FROM volunteer_hours vh
JOIN volunteers v
ON vh.volunteer_id = v.id
GROUP BY v.surname
ORDER BY `Volunteered hours` DESC;

-- display the average volunteered hours per volunteer
SELECT AVG(vh.hours) AS `Average Volunteered Hours`, v.surname AS `Surname` 
FROM volunteers v
JOIN volunteer_hours vh
ON v.id = vh.volunteer_id
GROUP BY `Surname`;

-- display the most hours worked by a volunteer
SELECT MAX(vh.hours) as `Most Hours Worked`, v.surname
FROM volunteer_hours vh
JOIN volunteers v
ON v.id = vh.volunteer_id
GROUP BY v.surname;

-- display the least hours worked by a volunteer
SELECT MIN(vh.hours) as `Least Hours Worked`, v.surname
FROM volunteer_hours vh
JOIN volunteers v
ON v.id = vh.volunteer_id
GROUP BY v.surname;

-- display the cumulative volunteer hours from all volunteers
SELECT SUM(`Total Hours Volunteered`) AS "Cumulative Volunteer Hours"
FROM(
    SELECT SUM(vh.hours) as `Total Hours Volunteered`
    FROM volunteers v
    JOIN volunteer_hours vh
    ON v.id = vh.volunteer_id
    GROUP BY vh.volunteer_id
) AS Cumulative;

-- display the occasion each volunteer put up more than 1O hours per visit
SELECT 
v.surname,
SUM(CASE WHEN vh.hours > 10 THEN 1 ELSE 0 END) AS `Occasions volunteered hours > 10`
FROM volunteers v
JOIN volunteer_hours vh
ON v.id = vh.volunteer_id
GROUP BY v.surname;


