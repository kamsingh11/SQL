
/* Q1. Find the names of all reviewers who rated Gone with the Wind. */
SELECT DISTINCT name
FROM Movie, Rating, Reviewer
WHERE Movie.mID = Rating.mID AND Rating.rID = Reviewer.rID AND title = "Gone with the Wind" ;

/* Q2. For any rating where the reviewer is the same as the director of the movie, return the reviewer name, movie title, and number of stars. */
SELECT name, title, stars
FROM Movie, Rating, Reviewer
WHERE Movie.mID = Rating.mID AND Rating.rID = Reviewer.rID AND name = director ;

/* Q3. Return all reviewer names and movie names together in a single list, alphabetized. (Sorting by the first name of the reviewer and first word in the title is fine; no need for special processing on last names or removing "The".) */
SELECT name
FROM Reviewer
UNION
SELECT title as name
FROM Movie
ORDER BY name, title ASC;

/* Q4. Find the titles of all movies not reviewed by Chris Jackson. */
SELECT title
FROM Movie
WHERE mID NOT IN (SELECT mID 
                  FROM Rating 
                  WHERE rID IN (SELECT rID 
                                FROM Reviewer
                                WHERE name = "Chris Jackson"));

/* Q6 For each rating that is the lowest (fewest stars) currently in the database, return the reviewer name, movie title, and number of stars. */
SELECT name, title, stars
FROM Movie NATURAL JOIN Rating NATURAL JOIN Reviewer 
WHERE stars = (SELECT MIN(stars) FROM Rating);

/* Q7 List movie titles and average ratings, from highest-rated to lowest-rated. If two or more movies have the same average rating, list them in alphabetical order. */
SELECT title, AVG(stars) AS avg_rating
FROM Movie NATURAL JOIN Rating
GROUP BY title
ORDER BY avg_rating DESC, title;

/* Q8 Find the names of all reviewers who have contributed three or more ratings. (As an extra challenge, try writing the query without HAVING or without COUNT.) */
SELECT name
FROM Reviewer NATURAL JOIN Rating
GROUP BY name
HAVING COUNT(*) >= 3; 

/* OR */

SELECT name
FROM Reviewer
WHERE (SELECT COUNT(*) 
       FROM Rating
       WHERE Rating.rID = Reviewer.rID) >= 3;

/* Q9 Some directors directed more than one movie. For all such directors, return the titles of all movies directed by them, along with the director name. Sort by director name, then movie title. (As an extra challenge, try writing the query both with and without COUNT.)*/
SELECT M1.title, director
FROM Movie M1
INNER JOIN Movie M2 USING(director)
GROUP BY M1.mId
HAVING COUNT(*) > 1
ORDER BY director, M1.title;

/* Q11 Find the movie(s) with the lowest average rating. Return the movie title(s) and average rating. (Hint: This query may be more difficult to write in SQLite than other systems; you might think of it as finding the lowest average rating and then choosing the movie(s) with that average rating.) */
SELECT title, avg(stars)
FROM Movie  
NATURAL JOIN Rating
GROUP BY mID
HAVING avg(stars) IS (SELECT avg(stars) a
                             FROM Rating
                             GROUP BY mID
                             ORDER BY a  ASC
                             LIMIT 1);
