
Drop table payments_fact
Select payment_id, r.rider_id, date, amount, FLOOR(DATEDIFF(year, birthday, account_start_date)) as age, month(date) as mnth, year(date) as yr, is_member
into payments_fact  
from staging_rider r 
join staging_payment p on r.rider_id=p.rider_id 

Drop table trips_fact
select trip_id, t.rider_id, rideable_type, start_station_id, end_station_id, 
DATEPART (HOUR , start_at) as hr, DATEPART (dw , start_at) as wkdy, 
FLOOR(DATEDIFF(year, birthday, start_at)) as age_at_trip, FLOOR(DATEDIFF(second, start_at, ended_at)) as trip_duration ,
start_at, ended_at
into trips_fact
from staging_trip t 
join staging_rider r on t.rider_id= r.rider_id 
join staging_station o on t.start_station_id= o.station_id 
join staging_station d on t.end_station_id = d.station_id 

Drop table riders_dim
select * into riders_dim from staging_rider

Drop table stations_dim
select * into stations_dim from staging_station

Drop table dates_dim
Select distinct convert(datetime,times) times, DATEPART (HOUR , times) as hr, DATEPART (dw , times) as wkdy
into dates_dim
FROM
(
Select distinct start_at as times from trips_fact
union
Select distinct ended_at from trips_fact
union
select distinct date from payments_fact
) a