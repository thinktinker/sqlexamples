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

