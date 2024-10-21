--Total Number of Rides Across All Seasons--
SELECT COUNT(ride_id) AS total_rides
FROM (
    SELECT ride_id FROM [cyclistic_bike_share].[dbo].[spring]
    UNION ALL
    SELECT ride_id FROM [cyclistic_bike_share].[dbo].[summer]
    UNION ALL
    SELECT ride_id FROM [cyclistic_bike_share].[dbo].[autumn]
    UNION ALL
    SELECT ride_id FROM [cyclistic_bike_share].[dbo].[winter]
) AS combined_rides;

-- Total Number of Rides by Season and Overall Total (Descending Order)
SELECT 
    COALESCE(season, 'Grand Total') AS season,  
    COUNT(ride_id) AS total_rides
FROM (
    SELECT 'spring' AS season, ride_id FROM [cyclistic_bike_share].[dbo].[spring]
    UNION ALL
    SELECT 'summer' AS season, ride_id FROM [cyclistic_bike_share].[dbo].[summer]
    UNION ALL
    SELECT 'autumn' AS season, ride_id FROM [cyclistic_bike_share].[dbo].[autumn]
    UNION ALL
    SELECT 'winter' AS season, ride_id FROM [cyclistic_bike_share].[dbo].[winter]
) AS combined_rides
GROUP BY season
WITH ROLLUP
ORDER BY 
    CASE WHEN season IS NULL THEN 1 ELSE 0 END,  
    total_rides DESC;  

-- ----------------------------------------------X----------------------------------------------------- --
--Ride frequency --
SELECT 
    COALESCE(member_casual,'Casual-Member') AS "Member Type",
    COALESCE(season, 'Overall Total') AS "Season",
    COUNT(ride_id) AS "Total Rides"
FROM (
    SELECT member_casual, 'Spring' AS season, ride_id FROM [cyclistic_bike_share].[dbo].[spring]
    UNION ALL
    SELECT member_casual, 'Summer' AS season, ride_id FROM [cyclistic_bike_share].[dbo].[summer]
    UNION ALL
    SELECT member_casual, 'Autumn' AS season, ride_id FROM [cyclistic_bike_share].[dbo].[autumn]
    UNION ALL
    SELECT member_casual, 'Winter' AS season, ride_id FROM [cyclistic_bike_share].[dbo].[winter]
) AS combined_rides
GROUP BY member_casual, season
WITH ROLLUP
ORDER BY 
    member_casual,
    CASE 
        WHEN season = 'Spring' THEN 1
        WHEN season = 'Summer' THEN 2
        WHEN season = 'Autumn' THEN 3
        WHEN season = 'Winter' THEN 4
        ELSE 5  
    END;

--Average ride length for annual members versus casual riders across all seasons? 
SELECT 
    member_casual AS "Member Type",
    AVG(ride_length) AS "Average Ride Length (minutes)"
FROM (
    SELECT member_casual, ride_length FROM [cyclistic_bike_share].[dbo].[spring]
    UNION ALL
    SELECT member_casual, ride_length FROM [cyclistic_bike_share].[dbo].[summer]
    UNION ALL
    SELECT member_casual, ride_length FROM [cyclistic_bike_share].[dbo].[autumn]
    UNION ALL
    SELECT member_casual, ride_length FROM [cyclistic_bike_share].[dbo].[winter]
) AS combined_rides
GROUP BY member_casual;

--The average ride lengths for casual riders vary by day of the week
SELECT 
    DATEPART(WEEKDAY, started_at) AS day_of_week,
    AVG(ride_length) AS average_ride_length
FROM (
    SELECT ride_length, started_at 
    FROM [cyclistic_bike_share].[dbo].[spring] 
    WHERE member_casual = 'casual'
    UNION ALL
    SELECT ride_length, started_at 
    FROM [cyclistic_bike_share].[dbo].[summer] 
    WHERE member_casual = 'casual'
    UNION ALL
    SELECT ride_length, started_at 
    FROM [cyclistic_bike_share].[dbo].[autumn] 
    WHERE member_casual = 'casual'
    UNION ALL
    SELECT ride_length, started_at 
    FROM [cyclistic_bike_share].[dbo].[winter] 
    WHERE member_casual = 'casual'
) AS combined_casual_rides
GROUP BY DATEPART(WEEKDAY, started_at)
ORDER BY day_of_week;

--Are there specific seasons where casual riders' ride lengths are even longer?
SELECT 
    season,
    AVG(ride_length) AS average_ride_length
FROM (
    SELECT 'Spring' AS season, ride_length 
    FROM [cyclistic_bike_share].[dbo].[spring] 
    WHERE member_casual = 'casual'
    UNION ALL
    SELECT 'Summer' AS season, ride_length 
    FROM [cyclistic_bike_share].[dbo].[summer] 
    WHERE member_casual = 'casual'
    UNION ALL
    SELECT 'Autumn' AS season, ride_length 
    FROM [cyclistic_bike_share].[dbo].[autumn] 
    WHERE member_casual = 'casual'
    UNION ALL
    SELECT 'Winter' AS season, ride_length 
    FROM [cyclistic_bike_share].[dbo].[winter] 
    WHERE member_casual = 'casual'
) AS casual_rides
GROUP BY season
ORDER BY 
    CASE 
        WHEN season = 'Spring' THEN 1
        WHEN season = 'Summer' THEN 2
        WHEN season = 'Autumn' THEN 3
        WHEN season = 'Winter' THEN 4
    END;


--how ride lengths correlate with the time of day, we can group the ride data by hour and calculate the average ride length for each hour. 
	SELECT 
    DATEPART(HOUR, started_at) AS Ride_Hour,
    AVG(ride_length) AS Avg_Ride_Length
FROM (
    SELECT started_at, ride_length FROM [cyclistic_bike_share].[dbo].[spring]
    UNION ALL
    SELECT started_at, ride_length FROM [cyclistic_bike_share].[dbo].[summer]
    UNION ALL
    SELECT started_at, ride_length FROM [cyclistic_bike_share].[dbo].[autumn]
    UNION ALL
    SELECT started_at, ride_length FROM [cyclistic_bike_share].[dbo].[winter]
) AS combined_data
GROUP BY DATEPART(HOUR, started_at)
ORDER BY Ride_Hour;


--How do the patterns of ride lengths at different times of the day differ between casual riders and annual members?
-- Casual Riders by Hour
SELECT 
    DATEPART(HOUR, started_at) AS hour,
    AVG(ride_length) AS avg_ride_length
FROM (
    SELECT ride_length, started_at FROM [cyclistic_bike_share].[dbo].[spring] WHERE member_casual = 'casual'
    UNION ALL
    SELECT ride_length, started_at FROM [cyclistic_bike_share].[dbo].[summer] WHERE member_casual = 'casual'
    UNION ALL
    SELECT ride_length, started_at FROM [cyclistic_bike_share].[dbo].[autumn] WHERE member_casual = 'casual'
    UNION ALL
    SELECT ride_length, started_at FROM [cyclistic_bike_share].[dbo].[winter] WHERE member_casual = 'casual'
) AS casual_rides
GROUP BY DATEPART(HOUR, started_at)
ORDER BY hour;

--Annual Members by Hour
SELECT 
    DATEPART(HOUR, started_at) AS hour,
    AVG(ride_length) AS avg_ride_length
FROM (
    SELECT ride_length, started_at FROM [cyclistic_bike_share].[dbo].[spring] WHERE member_casual = 'member'
    UNION ALL
    SELECT ride_length, started_at FROM [cyclistic_bike_share].[dbo].[summer] WHERE member_casual = 'member'
    UNION ALL
    SELECT ride_length, started_at FROM [cyclistic_bike_share].[dbo].[autumn] WHERE member_casual = 'member'
    UNION ALL
    SELECT ride_length, started_at FROM [cyclistic_bike_share].[dbo].[winter] WHERE member_casual = 'member'
) AS member_rides
GROUP BY DATEPART(HOUR, started_at)
ORDER BY hour;


-- ----------------------------------------------X----------------------------------------------------- --
-- Peak Usage Times:
-- During which days of the week do annual members and casual riders tend to ride the most? Are there differences in peak usage times (e.g., weekdays vs. weekends)?
SELECT 
    member_casual AS "Member Type",
    DATEPART(WEEKDAY, started_at) AS "Day of Week",  
    COUNT(ride_id) AS "Total Rides"
FROM (
    SELECT member_casual, ride_id, started_at FROM [cyclistic_bike_share].[dbo].[spring]
    UNION ALL
    SELECT member_casual, ride_id, started_at FROM [cyclistic_bike_share].[dbo].[summer]
    UNION ALL
    SELECT member_casual, ride_id, started_at FROM [cyclistic_bike_share].[dbo].[autumn]
    U
UNION ALL
    SELECT member_casual, ride_id, started_at FROM [cyclistic_bike_share].[dbo].[winter]
) AS combined_rides
GROUP BY member_casual, DATEPART(WEEKDAY, started_at)
ORDER BY member_casual, "Day of Week";

-- ----------------------------------------------X----------------------------------------------------- --
--Start and End Station Preferences
--Most popular start and end stations for both annual members and casual riders
SELECT  TOP 10
	member_casual AS "Rider Type",
	start_station_name AS "Start Station",
	end_station_name AS "End Station",
	COUNT(ride_id) AS "Total Rides"
FROM (
	SELECT member_casual, start_station_name, end_station_name, ride_id FROM [cyclistic_bike_share].[dbo].[spring]
	UNION ALL
	SELECT member_casual, start_station_name, end_station_name, ride_id FROM [cyclistic_bike_share].[dbo].[summer]
	UNION ALL
	SELECT member_casual, start_station_name, end_station_name, ride_id FROM [cyclistic_bike_share].[dbo].[autumn]
	UNION ALL
	SELECT member_casual, start_station_name, end_station_name, ride_id FROM [cyclistic_bike_share].[dbo].[winter]
) AS combined_rides
GROUP BY 
	member_casual, 
	start_station_name, 
	end_station_name
ORDER BY 
	"Total Rides" DESC;


-- Annual Member --
SELECT TOP 10
    member_casual AS "Rider Type",
    start_station_name AS "Start Station",
    end_station_name AS "End Station",
    COUNT(ride_id) AS "Total Rides"
FROM (
    SELECT member_casual, start_station_name, end_station_name, ride_id FROM [cyclistic_bike_share].[dbo].[spring]
    UNION ALL
    SELECT member_casual, start_station_name, end_station_name, ride_id FROM [cyclistic_bike_share].[dbo].[summer]
    UNION ALL
    SELECT member_casual, start_station_name, end_station_name, ride_id FROM [cyclistic_bike_share].[dbo].[autumn]
    UNION ALL
    SELECT member_casual, start_station_name, end_station_name, ride_id FROM [cyclistic_bike_share].[dbo].[winter]
) AS combined_rides
WHERE member_casual = 'member'
GROUP BY 
    member_casual, 
    start_station_name, 
    end_station_name
ORDER BY 
    "Total Rides" DESC;


-- Casual Rider --
SELECT TOP 10
    member_casual AS "Rider Type",
    start_station_name AS "Start Station",
    end_station_name AS "End Station",
    COUNT(ride_id) AS "Total Rides"
FROM (
    SELECT member_casual, start_station_name, end_station_name, ride_id FROM [cyclistic_bike_share].[dbo].[spring]
    UNION ALL
    SELECT member_casual, start_station_name, end_station_name, ride_id FROM [cyclistic_bike_share].[dbo].[summer]
    UNION ALL
    SELECT member_casual, start_station_name, end_station_name, ride_id FROM [cyclistic_bike_share].[dbo].[autumn]
    UNION ALL
    SELECT member_casual, start_station_name, end_station_name, ride_id FROM [cyclistic_bike_share].[dbo].[winter]
) AS combined_rides
WHERE member_casual = 'casual'
GROUP BY 
    member_casual, 
    start_station_name, 
    end_station_name
ORDER BY 
    "Total Rides" DESC;
-- ----------------------------------------------X----------------------------------------------------- --
--  Rideable Type Differences:
--  Analyze the distribution of different rideable types (e.g., electric bikes, classic bikes, docked bikes) between annual members and casual riders.
SELECT 
    member_casual AS "Rider Type", 
    rideable_type AS "Rideable Type", 
    COUNT(ride_id) AS "Total Rides"
FROM (
    SELECT member_casual, rideable_type, ride_id FROM [cyclistic_bike_share].[dbo].[spring]
    UNION ALL
    SELECT member_casual, rideable_type, ride_id FROM [cyclistic_bike_share].[dbo].[summer]
    UNION ALL
    SELECT member_casual, rideable_type, ride_id FROM [cyclistic_bike_share].[dbo].[autumn]
    UNION ALL
    SELECT member_casual, rideable_type, ride_id FROM [cyclistic_bike_share].[dbo].[winter]
) AS combined_rides
GROUP BY 
    member_casual, 
    rideable_type
ORDER BY 
    "Rider Type", 
    "Total Rides" DESC;

-- Seasonal Rideable Type Usage:
-- Do casual riders and annual members prefer different rideable types based on the season?
SELECT 
    season,
    member_casual,
    rideable_type,
    COUNT(ride_id) AS total_rides
FROM (
    SELECT member_casual, rideable_type, ride_id, 'Spring' AS season FROM [cyclistic_bike_share].[dbo].[spring]
    UNION ALL
    SELECT member_casual, rideable_type, ride_id, 'Summer' AS season FROM [cyclistic_bike_share].[dbo].[summer]
    UNION ALL
    SELECT member_casual, rideable_type, ride_id, 'Autumn' AS season FROM [cyclistic_bike_share].[dbo].[autumn]
    UNION ALL
    SELECT member_casual, rideable_type, ride_id, 'Winter' AS season FROM [cyclistic_bike_share].[dbo].[winter]
) AS combined_rides
GROUP BY 
    season,
    member_casual,
    rideable_type
ORDER BY 
    season,
    member_casual,
    total_rides DESC;
-- ----------------------------------------------X----------------------------------------------------- --
