
--В каких городах больше одного аэропорта?

SELECT aa.city
 FROM airports aa
 GROUP BY aa.city
 HAVING COUNT(*) > 1 
 
 
--Задача 2. В каких аэропортах есть рейсы, выполняемые самолетом с максимальной дальностью перелета?
select a2.airport_name, a2.city 
from airports a2 
join flights f on f.arrival_airport = a2.airport_code or f.departure_airport = a2.airport_code
join (SELECT * 
		FROM aircrafts
		where "range" in (SELECT max("range") FROM aircrafts)) as t on t.aircraft_code = f.aircraft_code 
group by a2.airport_code 

select a2.airport_name 
from airports a2 
join flights f on f.arrival_airport = a2.airport_code or f.departure_airport = a2.airport_code
join (SELECT * 
		FROM aircrafts
		where "range" in (SELECT max("range") FROM aircrafts)) as t on t.aircraft_code = f.aircraft_code 
group by a2.airport_name 


--Задача 3. Вывести 10 рейсов с максимальным временем задержки вылета

select flight_id, flight_no, scheduled_departure, actual_departure, (actual_departure - scheduled_departure) time_of_delaed
from flights f 
where actual_departure is not null 
order by time_of_delaed desc 
limit 10


-- Задача 4. Были ли брони, по которым не были получены посадочные талоны?

select count(*) 
from bookings b 
left join tickets t on b.book_ref = t.book_ref 
left join boarding_passes bp on bp.ticket_no = t.ticket_no 
where boarding_no is null or seat_no is null


--Задача 5
--Найдите количество свободных мест для каждого рейса, их % отношение к общему количеству мест в самолете.
--Добавьте столбец с накопительным итогом - суммарное накопление количества вывезенных пассажиров из каждого 
--аэропорта на каждый день. Т.е. в этом столбце должна отражаться накопительная сумма - сколько человек 
--уже вылетело из данного аэропорта на этом или более ранних рейсах в течении дня

--explain analyse --WindowAgg  (cost=547501.82..658503.54 rows=2775043 width=108) (actual time=1071.970..1088.419 rows=11478 loops=1)
select a.airport_code, f.flight_id, t1."all", t2."close",
	round(((t1."all" - t2."close")::numeric/ t1."all"::numeric * 100), 2) as "percent_empty",
	sum(t2."close") over(partition by a.airport_code, f.actual_departure::date order by f.actual_departure),
	f.actual_departure,
	status 
from airports a 
join flights f on f.departure_airport = a.airport_code
join (select f.flight_id, count(s.seat_no) "all" 
		from flights f 
		join seats s on s.aircraft_code = f.aircraft_code
		group by f.flight_id) t1 on t1.flight_id = f.flight_id 
join (select f.flight_id, count(bp.seat_no) "close"
		from flights f 
		join boarding_passes bp on bp.flight_id = f.flight_id
		group by f.flight_id) t2 on t2.flight_id = f.flight_id
where status = 'Arrived' or status = 'Departed' 


--Задача 6. Найдите процентное соотношение перелетов по типам самолетов от общего количества.
--SELECT * FROM AIRCRAFTS A 

select distinct a.aircraft_code, 
(count(f.flight_id) over (partition by a.aircraft_code))::numeric as counting, 
round(((count(f.flight_id) over (partition by a.aircraft_code))/ (select count(f2.flight_id) from flights f2 )::numeric * 100), 3) as "percent"
from flights f 
join aircrafts a on a.aircraft_code = f.aircraft_code 

select 3.741+5.894+3.686+1.842+27.997+3.847+27.318+25.676

select 1274+8504+9273+1239+610+1952+9048+1221



--Задача 7. Были ли города, в которые можно  добраться бизнес - классом дешевле, чем эконом-классом в рамках перелета?
select * from seats s 

with econom as (
select a2.city, f2.flight_id, tf.amount economy_class
	from airports a2 
	join flights f2 on f2.arrival_airport = a2.airport_code
	join ticket_flights tf on tf.flight_id = f2.flight_id 
	where f2.status != 'Cancelled'
), 
business as (
select a2.city, f2.flight_id, tf.amount business_class, min(tf.amount) filter (where tf.fare_conditions = 'Business') minBusiness
	from airports a2 
	join flights f2 on f2.arrival_airport = a2.airport_code
	join ticket_flights tf on tf.flight_id = f2.flight_id 
	where f2.status != 'Cancelled' 
	group by a2.city, f2.flight_id, tf.amount
)
select e1.city, e1.flight_id, e1.economy_class, b1.business_class, b1.minBusiness
from econom e1
join business b1 on e1.flight_id = b1.flight_id
where e1.economy_class > b1.minBusiness


--Задача 8. Между какими городами нет прямых рейсов?
--скрин http://joxi.ru/52apOYWcg6Lw0m

create view pairs as
	select distinct a1.city as city1, a2.city as city2
	from airports a1, airports a2
	where a1.city != a2.city   --- всего городов 10100
	
create view about_flights as
	select distinct a1.city as city1, a2.city as city2
	from flights f
	join airports a1 on a1.airport_code = f.departure_airport 
	join airports a2 on a2.airport_code = f.arrival_airport
	where a1.city != a2.city   -- для перелёта 516


select city1, city2 from pairs
except
select city1, city2 from about_flights

	
/*
 Задача 9.
 Вычислите расстояние между аэропортами, связанными прямыми рейсами, сравните с допустимой максимальной дальностью перелетов  в самолетах, обслуживающих эти рейсы  
 	
Кратчайшее расстояние между двумя точками A и B на земной поверхности (если принять ее за сферу) определяется зависимостью:
d = arccos {sin(latitude_a)·sin(latitude_b) + cos(latitude_a)·cos(latitude_b)·cos(longitude_a - longitude_b)}, где latitude_a и latitude_b — широты, longitude_a, longitude_b — долготы данных пунктов, d — расстояние между пунктами измеряется в радианах длиной дуги большого круга земного шара.
Расстояние между пунктами, измеряемое в километрах, определяется по формуле:
L = d·R, где R = 6371 км — средний радиус земного шара.
*/
 
select departure_airport, a1.latitude as x, arrival_airport, a2.longitude as y, 
(acos(sin(radians(a1.latitude))*sin(radians(a2.latitude)) +cos(radians(a1.latitude))*
cos(radians(a2.latitude))*cos(radians(a1.longitude - a2.longitude)))*6371)::integer as "Расстояние", range
from 
	(select distinct departure_airport, arrival_airport, aircraft_code 
	from flights) as foo
join airports a1 on foo.departure_airport = a1.airport_code
join airports a2 on foo.arrival_airport = a2.airport_code
join aircrafts on aircrafts.aircraft_code = foo.aircraft_code
order by arrival_airport

/*******************************************/
--В каких городах больше одного аэропорта?
select city, count (airport_name) 
from airports 
group by city 
having count (airport_name) > 1;

--В каких аэропортах есть рейсы, выполняемые самолетом с максимальной дальностью перелета?
select distinct airport_name as "Аэропорты"
from airports
inner join flights on airports.airport_code = flights.arrival_airport
inner join aircrafts on flights.aircraft_code = aircrafts.aircraft_code
where aircrafts.range = (select max(range) from aircrafts);

--Вывести 10 рейсов с максимальным временем задержки вылета
select flight_id, scheduled_departure, actual_departure, (actual_departure - scheduled_departure) as time
from flights where actual_departure is not null
order by time desc
limit 10;

--Были ли брони, по которым не были получены посадочные талоны?
select count(bookings.book_ref)
from bookings
full outer join tickets on bookings.book_ref = tickets.book_ref
full outer join boarding_passes on boarding_passes.ticket_no = tickets.ticket_no
where boarding_passes.boarding_no is null;

--Найдите свободные места для каждого рейса, их % отношение к общему количеству мест в самолете.
--Добавьте столбец с накопительным итогом - суммарное количество вывезенных пассажиров из аэропорта за день. 
--Т.е. в этом столбце должна отражаться сумма - 
--сколько человек уже вылетело из данного аэропорта на этом или более ранних рейсах за сегодняшний день
--explain analyze --WindowAgg  (cost=12927.96..13121.80 rows=4561 width=104) (actual time=282.727..303.254 rows=11478 loops=1)
select f.flight_id as "id рейса", 
	f.aircraft_code as "Код самолета", 
	f.departure_airport as "Код аэропорта", 
	date(f.actual_departure) as "Дата вылета",
	(s.count_seats - bp.count_bp) as "Свободные места",
	round(((s.count_seats - bp.count_bp) * 100. / s.count_seats), 2) as "% от общего количества мест",
	sum(bp.count_bp) over (partition by date(f.actual_departure), f.departure_airport order by f.actual_departure) as "Накопительная",
	bp.count_bp as "Количество вылетевших пассажиров"
from flights f
left join (
	select bp.flight_id, count(bp.seat_no) as count_bp
	from boarding_passes bp
	group by bp.flight_id
	order by bp.flight_id) as bp on bp.flight_id = f.flight_id 
left join (
	select s.aircraft_code, count(*) as count_seats
	from seats s 
	group by s.aircraft_code) as s on f.aircraft_code = s.aircraft_code
where f.actual_departure is not null and bp.count_bp is not null
order by date(f.actual_departure)

--Найдите процентное соотношение перелетов по типам самолетов от общего количества.
select aircrafts.model as "Модель самолета", aircrafts.aircraft_code, 
round((count(flights.flight_id)::numeric)*100 / (select count(flights.flight_id) from flights)::numeric, 2) as "Доля перелетов"
from aircrafts
join flights on aircrafts.aircraft_code = flights.aircraft_code
group by aircrafts.aircraft_code
order by "Доля перелетов" desc;

вариант 2:
select aircrafts.model as "Модель самолета", aircrafts.aircraft_code, 
round((count(flights.flight_id)::numeric)*100 / sum(count(flights.flight_id)) over (), 2) as "Доля перелетов"
from aircrafts
join flights on aircrafts.aircraft_code = flights.aircraft_code
group by aircrafts.aircraft_code
order by "Доля перелетов" desc;

--Были ли города, в которые можно  добраться бизнес - классом дешевле, чем эконом-классом в рамках перелета?

 with econom as
	(select ticket_flights.flight_id, max(amount)
	from ticket_flights
	where fare_conditions = 'Economy'
	group by ticket_flights.flight_id),
business as
	(select flight_id, min(amount) as min
	from ticket_flights
	where fare_conditions = 'Business' group by flight_id)
select e.flight_id, min, max, a1.city, a2.city
from econom e
join business b on e.flight_id = b.flight_id
left join flights f on e.flight_id = f.flight_id and b.flight_id = f.flight_id
left join airports a1 on a1.airport_code = f.arrival_airport
left join airports a2 on a2.airport_code = f.departure_airport
where max > min;

--Между какими городами нет прямых рейсов?
create view route as 
	select distinct a.city as departure_city , b.city as arrival_city, a.city||'-'||b.city as route 
	from airports as a, (select city from airports) as b
	where a.city != b.city
	--where a.city > b.city если хотим убрать зеркальные варианты
	order by route
	
create view direct_flight as 
	select distinct a.city as departure_city, aa.city as arrival_city, a.city||'-'|| aa.city as route  
	from flights as f
	inner join airports as a on f.departure_airport=a.airport_code
	inner join airports as aa on f.arrival_airport=aa.airport_code
	order by route
	
select r.* 
from route as r
except 
select df.* 
from direct_flight as df


--Вычислите расстояние между аэропортами, связанными прямыми рейсами, сравните с допустимой максимальной дальностью перелетов  в самолетах, обслуживающих эти рейсы

select departure_airport, a1.city as from_city, arrival_airport, a2.city as to_city, 
(acos(sin(radians(a1.latitude))*sin(radians(a2.latitude)) +cos(radians(a1.latitude))*
cos(radians(a2.latitude))*cos(radians(a1.longitude - a2.longitude)))*6371)::integer as "Расстояние", range
from 
	(select distinct departure_airport, arrival_airport, aircraft_code 
	from flights) as foo
join airports a1 on foo.departure_airport = a1.airport_code
join airports a2 on foo.arrival_airport = a2.airport_code
join aircrafts on aircrafts.aircraft_code = foo.aircraft_code
order by arrival_airport