--NETFLIX PROJECTS 

DROP TABLE netflix;
CREATE TABLE netflix
(
	sow_id VARCHAR(10),
	type VARCHAR(10),
	title VARCHAR(150),
	director VARCHAR(250),
	casts VARCHAR(1000),
	country VARCHAR(150),
	date_added VARCHAR(50),
	release_year INT,
	rating VARCHAR(50),
	duration VARCHAR(50),
	listed_in VARCHAR(100),
	description VARCHAR(2000)
);

SELECT * FROM netflix;

SELECT DISTINCT type FROM netflix;
SELECT DISTINCT title FROM netflix;


SELECT 
	COUNT(*) AS total_contant  
FROM netflix;

SELECT null FROM netflix;

-- 15 BUSINESS PROBLEMS & SOLUTIONS

--1. COUNT THE NUMBER OF MOVIES VS TV SHOWS

SELECT 
	type,
	COUNT(*) as total_content 
FROM netflix 
GROUP BY TYPE;

-- 2. FIND THE MOST COMMON RATING FOR MOVIES AND TV SHOWS 

SELECT 
	type,
	rating
FROM
(
SELECT 
	type,
	rating,
	COUNT(*),
	RANK() OVER(PARTITION BY type ORDER BY COUNT(*) DESC) as ranking 
FROM netflix
GROUP BY 1, 2) AS t1
WHERE
	ranking = 1

--3. LIST ALL MOVIES RELEASED IN A SPECIFIC YEAR(2020)

SELECT * FROM netflix
WHERE 
	type = 'Movie'
	AND
	release_year = 2020

--4. FIND ALL THE TOP 5 COUNTRIES WITH THE MOST CONTENT ON NETFLIX

SELECT 
	UNNEST(STRING_TO_ARRAY(country, ',')) AS new_country,
	COUNT(sow_id) as total_content
FROM netflix
GROUP BY 1 
ORDER BY 2 DESC
LIMIT 5

--5. IDENTIFY THE LONGEST MOVIE OR TV SHOW DURATION

SELECT * FROM netflix
WHERE
	type = 'Movie'
	AND 
	duration = (SELECT MAX(duration) FROM netflix)
	
--6. FIND CONTENT ADDED IN THE LAST 5 YEARS 

SELECT 
	*
FROM netflix
WHERE
	TO_DATE(date_added,'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years'

SELECT CURRENT_DATE - INTERVAL '5 years'

--7. FIND ALL THE MOVIES/TV SHOWS BY DIRECTOR 'Toshiya Shinohara'

SELECT * FROM netflix
WHERE director ILIKE '%Toshiya Shinohara%'

--8. LIST ALL TV SHOWS WITH MORE THAN 5 SEASON 

SELECT
	*
FROM netflix
WHERE 
	type = 'TV Show'
	AND
	SPLIT_PART(duration, ' ', 1):: NUMERIC > 5 


--9. COUNT THE NUMBER OF CONTENT ITEMS IN EACH GENRE

SELECT 
	UNNEST(STRING_TO_ARRAY(listed_in, ',')) AS genere,
	COUNT(sow_id) AS total_content
FROM netflix
GROUP BY 1

--10. FIND THE AVERAGE RELEASE YEAR OF CONTENT PRODUCED IN A SPECIFIC COUNTRY

total Content 333/972

SELECT 
	EXTRACT(YEAR FROM TO_DATE(date_added, 'Month DD, YYYY')) as year,
	COUNT(*) as yearly_content,
	ROUND(
	COUNT(*):: numeric/(SELECT COUNT(*) FROM netflix WHERE country = 'India'):: numeric * 100
	,2)as avg_per_year
FROM netflix
WHERE country = 'India'
GROUP BY 1

--11. LIST ALL MOVIES THAT ARE DOCUMENTARIES

SELECT * FROM netflix
WHERE
	listed_in ILIKE '%documentaries%'
	
--12. FIND ALL CONTENT WITHOUT DIRECTOR

SELECT * FROM netflix
WHERE
	director IS NULL

--13. FIND HOW MANY MOVIES ACTOR 'SALMAN KHAN' APPEARED IN LAST 10 YEARS!

SELECT * FROM netflix
WHERE
	casts ILIKE '%Salman Khan%'
	AND 
	release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10
	
--14. FIND THE TOP 10 ACTORS WHO HAVE APPEARED IN THE HIGHEST NUMBER OF MOVIES PRODUCED IN INDIA

SELECT
--sow_id,
--casts,
UNNEST(STRING_TO_ARRAY(casts, ',')) as actors,
COUNT(*) as total_content
FROM netflix
WHERE country ILIKE '%India%'
GROUP BY 1
ORDER BY 2 DESC 
LIMIT 10

--15. CATEGORIZE THE CONTENT BASED ON THE PRESENCE OF THE KEYWORDS 'KIL' AND 'VIOLANCE' IN
--THE DESCRIPTION FIELD, LABEL CONTENT CONTAINING THESE KEYWORDS AS 'BAD' AND ALL THE OTHER 
--CONTENT AS 'GOOD', COUNT HOW MANY ITEM FALL INTO EACH CATEGORY.

WITH new_table
AS
(
SELECT 
* ,
	CASE
	WHEN description ILIKE '%Kill%' OR 
		description ILIKE '%Violance%' THEN 'Bad_Content'
		ELSE 'Good_Content'
	END category
FROM netflix
)

SELECT 
	category,
	COUNT(*) as total_content
FROM new_table
GROUP BY 1
