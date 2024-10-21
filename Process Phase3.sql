-- Process Phase for Autumn--

SELECT
*
FROM [cyclistic_bike_share].[dbo].[autumn]

-- Identify and Remove Null values --
SELECT 
start_station_name,
end_station_name
FROM  [cyclistic_bike_share].[dbo].[autumn]
WHERE
start_station_name = 'NULL' OR
end_station_name = 'NULL';

--affected rows 3,80,788--

DELETE FROM [cyclistic_bike_share].[dbo].[autumn]
WHERE 
start_station_name = 'NULL' OR
end_station_name = 'NULL';



--Identify and Remove Duplicate values --
--Returns the total number of ride_id(1185214)--
SELECT
COUNT (ride_id) as ride_id
FROM [cyclistic_bike_share].[dbo].[autumn]

--Checks for duplicate ride_id(No Duplicates) 
SELECT
COUNT (DISTINCT(ride_id)) as ride_id
FROM [cyclistic_bike_share].[dbo].[autumn]

--Returns results where the ended_at data is less than the started_at date 
SELECT
  ended_at,
  started_at
 FROM [cyclistic_bike_share].[dbo].[autumn]
 WHERE ended_at < started_at;


 DELETE
 FROM [cyclistic_bike_share].[dbo].[autumn]
 WHERE ended_at < started_at;


-- Add the new columns to the existing table
ALTER TABLE [cyclistic_bike_share].[dbo].[autumn]
ADD 
    ride_length INT,  -- Ride length in seconds (adjust the type as needed)
    day_of_week VARCHAR(10),  -- Day of the week (e.g., Monday, Tuesday)
    day INT,  -- Day of the month
    month INT,  -- Month number
    year INT;  -- Year

-- Populate the newly added columns with calculated values
UPDATE [cyclistic_bike_share].[dbo].[autumn]
SET 
    ride_length = DATEDIFF(MINUTE, started_at, ended_at),  -- Calculating ride length in minute
    day_of_week = DATENAME(WEEKDAY, started_at),  -- Extracting the day of the week
    day = DAY(started_at),  -- Extracting the day of the month
    month = MONTH(started_at),  -- Extracting the month
    year = YEAR(started_at)  -- Extracting the year
WHERE ended_at >= started_at;  -- Only update for valid records

