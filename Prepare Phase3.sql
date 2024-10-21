-- Prepare Phase for Autumn --

SELECT
ride_id,
rideable_type,
started_at,
ended_at,
start_station_name,
end_station_name,
member_casual
FROM dbo.[202309]
UNION ALL

SELECT
ride_id,
rideable_type,
started_at,
ended_at,
start_station_name,
end_station_name,
member_casual
FROM dbo.[202310]
UNION ALL

SELECT
ride_id,
rideable_type,
started_at,
ended_at,
start_station_name,
end_station_name,
member_casual
FROM dbo.[202311]


