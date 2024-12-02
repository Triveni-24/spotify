-- create table
DROP TABLE IF EXISTS spotify;
CREATE TABLE spotify (
    artist VARCHAR(255),
    track VARCHAR(255),
    album VARCHAR(255),
    album_type VARCHAR(50),
    danceability FLOAT,
    energy FLOAT,
    loudness FLOAT,
    speechiness FLOAT,
    acousticness FLOAT,
    instrumentalness FLOAT,
    liveness FLOAT,
    valence FLOAT,
    tempo FLOAT,
    duration_min FLOAT,
    title VARCHAR(255),
    channel VARCHAR(255),
    views FLOAT,
    likes BIGINT,
    comments BIGINT,
    licensed BOOLEAN,
    official_video BOOLEAN,
    stream BIGINT,
    energy_liveness FLOAT,
    most_played_on VARCHAR(50)
);

--EDA
SELECT COUNT (*) FROM spotify;

SELECT COUNT (DISTINCT artist) FROM spotify;

SELECT DISTINCT album_type FROM spotify;

SELECT MAX(duration_min) FROM spotify;

SELECT MIN(duration_min) FROM spotify;

SELECT * FROM spotify
WHERE duration_min = 0

DELETE FROM spotify
WHERE duration_min = 0

SELECT * FROM spotify
WHERE duration_min = 0

SELECT COUNT (*) FROM spotify;

SELECT DISTINCT channel FROM spotify;

SELECT DISTINCT most_played_on FROM spotify;


--Data Analysis - Easy category


-- Retrive the names of all tracks that have more than 1 billion streams
-- List all albums along with their respective artists.
-- Get the total number of comments for tracks where licensed = TRUE.
-- Find all tracks that belong to the album type single.
-- Count the total number of tracks by each artist.
*/ 

-- 1st Retrive the names of all tracks that have more than 1 billion streams.
SELECT * FROM spotify
WHERE stream > 1000000000;

-- 2nd List all albums along with their respective artists.

SELECT 
	DISTINCT album, artist
FROM spotify
ORDER BY 1;

SELECT 
	DISTINCT album
FROM spotify
ORDER BY 1;

-- Get the total number of comments for tracks where licensed = TRUE.
SELECT DISTINCT licensed FROM spotify
SELECT * FROM spotify
WHERE licensed = 'true';


SELECT
	SUM(comments) as total_comments
FROM spotify
WHERE licensed = 'true';

-- Find all tracks that belong to the album type single.
SELECT * FROM spotify
WHERE album_type = 'single';

-- Count the total number of tracks by each artist.
SELECT 
	artist,
	COUNT(*) as total_no_songs
FROM spotify
GROUP BY artist
ORDER BY 2 DESC

-- Calculate the average dancability of tracks in each album
-- Find the top 5 tracks with the highest energy values
-- list all the track along with their views and likes where official_video = True.
-- for each album, calculate the total views of all associates tracks.
-- retrive the track names that have been streamed on spotify more than youtube.

-- Calculate the average dancability of tracks in each album.

SELECT 
	album,
	avg(danceability) as avg_danceability
FROM spotify
GROUP BY 1
ORDER BY 2 DESC

-- Find the top 5 tracks with the highest energy values

SELECT 
	track,
	AVG(energy)
FROM spotify
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5

-- list all the tracks along with their views and likes where official_video = True.

SELECT
	track,
	SUM(views) as total_views,
	SUM(likes) as total_views
	
FROM spotify
WHERE official_video = 'true'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5

-- for each album, calculate the total views of all associates tracks.

SELECT
	album,
	track,
	Sum(views)
FROM spotify
GROUP BY 1,2
ORDER BY 3 DESC

-- retrive the track names that have been streamed on spotify more than youtube.

SELECT * FROM
(SELECT 
	track,
	--most_played_on,
	COALESCE(SUM(CASE WHEN most_played_on = 'Youtube' THEN stream END),0) as streamed_on_youtube,
	COALESCE(SUM(CASE WHEN most_played_on = 'Spotify' THEN stream END),0) as streamed_on_spotify
FROM spotify
GROUP BY 1
) as t1
WHERE streamed_on_spotify > streamed_on_youtube
AND
streamed_on_youtube <>0

--ADVANCED PROBLEMS
-- FIND THE TOP 3 MOST - VIEWED TRACKS FOR EACH ARTISTS USING WINDOW FUNCTIONS.
WITH ranking_artist
AS
(
SELECT 
	artist,
	track, 
	SUM(views) as total_view,
	DENSE_RANK() OVER(PARTITION BY artist ORDER BY SUM(views) DESC) as rank
FROM spotify

Group BY 1,2
ORDER BY 1, 3 DESC
)
SELECT * FROM ranking_artist
WHERE rank <=3

-- write a query to find tracks where the liveness score is above the average.

SELECT 
	track,
	artist,
	liveness
FROM spotify
WHERE liveness > (SELECT AVG(liveness) FROM spotify)

-- use a with clause to calc. the difference between the highest and the lowest energy 
-- values for tracks in each album
WITH cte
AS
(SELECT
	album,
	MAX(energy) as highest_energy,
	MIN(energy) as lowest_energy
	

FROM spotify
GROUP BY 1
)
SELECT 
	album,
	highest_energy - lowest_energy as energy_diff
	FROM cte
