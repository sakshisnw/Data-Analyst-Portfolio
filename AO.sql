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
--Output:4332003 --

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
--Output:
--summer	1693738
--autumn	1185173
--spring	987863
--winter	465229
--Grand Total	4332003 --

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

--Output: 
--Casual-Member	Overall Total	4332003
--casual	Spring	334366
--casual	Summer	699052
--casual	Autumn	399336
--casual	Winter	99151
--casual	Overall Total	1531905
--member	Spring	653497
--member	Summer	994686
--member	Autumn	785837
--member	Winter	366078
--member	Overall Total	2800098

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
--Output:
--casual	22
--member	12

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
--Output:
--1	26
--2	22
--3	20
--4	19
--5	20
--6	22
--7	25

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
--Output:
--Spring	22
--Summer	24
--Autumn	21
--Winter	16


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
--Output:
--0	16
--1	16
--2	17
--3	17
--4	14
--5	11
--6	11
--7	11
--8	12
--9	14
--10	17
--11	18
--12	18
--13	17
--14	18
--15	17
--16	16
--17	15
--18	15
--19	15
--20	15
--21	15
--22	15
--23	15


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
--Output:
--0	21
--1	20
--2	21
--3	21
--4	18
--5	14
--6	15
--7	14
--8	16
--9	23
--10	26
--11	27
--12	26
--13	26
--14	26
--15	24
--16	22
--17	21
--18	21
--19	21
--20	20
--21	20
--22	20
--23	20

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
--Output:
--0	11
--1	12
--2	12
--3	12
--4	11
--5	10
--6	10
--7	10
--8	11
--9	11
--10	12
--11	12
--12	12
--13	12
--14	12
--15	12
--16	12
--17	12
--18	12
--19	12
--20	12
--21	12
--22	12
--23	12

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
--Output:
--casual	1	254773
--casual	2	175433
--casual	3	181566
--casual	4	183104
--casual	5	198953
--casual	6	227887
--casual	7	310189
--member	1	307879
--member	2	386725
--member	3	448882
--member	4	452741
--member	5	452685
--member	6	400528
--member	7	350658

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
--Output:
--casual	Streeter Dr & Grand Ave	Streeter Dr & Grand Ave	8653
--casual	DuSable Lake Shore Dr & Monroe St	DuSable Lake Shore Dr & Monroe St	6732
--member	Ellis Ave & 60th St	University Ave & 57th St	5208
--member	Calumet Ave & 33rd St	State St & 33rd St	5202
--member	State St & 33rd St	Calumet Ave & 33rd St	5145
--member	University Ave & 57th St	Ellis Ave & 60th St	4935
--member	Ellis Ave & 60th St	Ellis Ave & 55th St	4929
--casual	DuSable Lake Shore Dr & Monroe St	Streeter Dr & Grand Ave	4626
--member	Ellis Ave & 55th St	Ellis Ave & 60th St	4525
--casual	Michigan Ave & Oak St	Michigan Ave & Oak St	4260


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
--Output:
--member	Ellis Ave & 60th St	University Ave & 57th St	5208
--member	Calumet Ave & 33rd St	State St & 33rd St	5202
--member	State St & 33rd St	Calumet Ave & 33rd St	5145
--member	University Ave & 57th St	Ellis Ave & 60th St	4935
--member	Ellis Ave & 60th St	Ellis Ave & 55th St	4929
--member	Ellis Ave & 55th St	Ellis Ave & 60th St	4525
--member	Loomis St & Lexington St	Morgan St & Polk St	3445
--member	Morgan St & Polk St	Loomis St & Lexington St	3163
--member	MLK Jr Dr & 29th St	State St & 33rd St	2528
--member	State St & 33rd St	MLK Jr Dr & 29th St	2447


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
--Output:
--casual	Streeter Dr & Grand Ave	Streeter Dr & Grand Ave	8653
--casual	DuSable Lake Shore Dr & Monroe St	DuSable Lake Shore Dr & Monroe St	6732
--casual	DuSable Lake Shore Dr & Monroe St	Streeter Dr & Grand Ave	4626
--casual	Michigan Ave & Oak St	Michigan Ave & Oak St	4260
--casual	Millennium Park	Millennium Park	3426
--casual	Dusable Harbor	Dusable Harbor	2799
--casual	Montrose Harbor	Montrose Harbor	2529
--casual	Streeter Dr & Grand Ave	DuSable Lake Shore Dr & Monroe St	2352
--casual	DuSable Lake Shore Dr & North Blvd	DuSable Lake Shore Dr & North Blvd	2043
--casual	Ellis Ave & 60th St	Ellis Ave & 55th St	2037
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
--Output:
--casual	classic_bike	873043
--casual	electric_bike	582622
--casual	docked_bike	76240
--member	classic_bike	1817809
--member	electric_bike	982289

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
--Output:
--Autumn	casual	classic_bike	256463
--Autumn	casual	electric_bike	142873
--Autumn	member	classic_bike	533382
--Autumn	member	electric_bike	252455
--Spring	casual	classic_bike	160402
--Spring	casual	electric_bike	149552
--Spring	casual	docked_bike	24412
--Spring	member	classic_bike	385562
--Spring	member	electric_bike	267935
--Summer	casual	classic_bike	406554
--Summer	casual	electric_bike	244503
--Summer	casual	docked_bike	47995
--Summer	member	classic_bike	664134
--Summer	member	electric_bike	330552
--Winter	casual	classic_bike	49624
--Winter	casual	electric_bike	45694
--Winter	casual	docked_bike	3833
--Winter	member	classic_bike	234731
--Winter	member	electric_bike	131347
-- ----------------------------------------------X----------------------------------------------------- --
