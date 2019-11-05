/* Q1. Find the titles of all movies directed by Steven Spielberg. */
SELECT title
FROM Movie
WHERE director = "Steven Spielberg" ;

/* Q2. Find all years that have a movie that received a rating of 4 or 5, and sort them in increasing order. */
SELECT DISTINCT year
FROM Movie, Rating
WHERE Movie.mID = Rating.mID AND (stars = 4 OR stars = 5)
ORDER BY year ;

/* Q3 Find the titles of all movies that have no ratings. */
SELECT DISTINCT title
FROM Movie
WHERE mID NOT IN (SELECT mID
              FROM Rating);

/* Q4 Some reviewers didn't provide a date with their rating. Find the names of all reviewers who have ratings with a NULL value for the date. */
SELECT DISTINCT name 
FROM Reviewer
WHERE rID IN (SELECT rID
              FROM Rating
              WHERE ratingDate IS NULL);

/* Q5. Write a query to return the ratings data in a more readable format: reviewer name, movie title, stars, and ratingDate. Also, sort the data, first by reviewer name, then by movie title, and lastly by number of stars. */
SELECT name, title, stars, ratingDate
FROM Movie NATURAL JOIN Rating NATURAL JOIN Reviewer
ORDER BY name ASC, title ASC, stars ASC;

/* Q6. For all cases where the same reviewer rated the same movie twice and gave it a higher rating the second time, return the reviewer's name and the title of the movie. */
SELECT name, title
FROM Movie
INNER JOIN Rating R1 USING(mId)
INNER JOIN Rating R2 USING(rId)
INNER JOIN Reviewer USING(rId)
WHERE R1.mId = R2.mId AND R1.ratingDate < R2.ratingDate AND R1.stars < R2.stars;

/* Q7. For each movie that has at least one rating, find the highest number of stars that movie received. Return the movie title and number of stars. Sort by movie title.*/
SELECT title, max(stars)
FROM Movie
NATURAL JOIN Rating
GROUP BY mID
HAVING stars > 1
ORDER BY title;

/* Q8. For each movie, return the title and the 'rating spread', that is, the difference between highest and lowest ratings given to that movie. Sort by rating spread from highest to lowest, then by movie title. */
SELECT title, (max(stars) - min(stars)) AS 'rating spread'
FROM Movie NATURAL JOIN Rating
GROUP BY mID
ORDER BY "rating spread" DESC, title;

/* Q9. Find the difference between the average rating of movies released before 1980 and the average rating of movies released after 1980. (Make sure to calculate the average rating for each movie, then the average of those averages for movies before 1980 and movies after. Don't just calculate the overall average rating before and after 1980.) */
SELECT (avg(avg_before_1980.avg) - avg(avg_after_1980.avg)) as avg_rating
FROM (SELECT avg(stars) AS avg
FROM Movie NATURAL JOIN Rating
WHERE year < 1980
GROUP BY mID) avg_before_1980, (SELECT avg(stars) AS avg
FROM Movie NATURAL JOIN Rating
WHERE year > 1980
GROUP BY mID) avg_after_1980;
