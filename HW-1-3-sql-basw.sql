--=============== МОДУЛЬ 3. ОСНОВЫ SQL =======================================
--= ПОМНИТЕ, ЧТО НЕОБХОДИМО УСТАНОВИТЬ ВЕРНОЕ СОЕДИНЕНИЕ И ВЫБРАТЬ СХЕМУ PUBLIC===========
SET search_path TO public;

--======== ОСНОВНАЯ ЧАСТЬ ==============

--ЗАДАНИЕ №1
--Выведите для каждого покупателя его адрес проживания, 
--город и страну проживания.
select 
	concat(first_name, ' ', last_name) as "���"
	, a2.address
	, c.city
	, c2.country 
from city c
join address a2 on a2.city_id = c.city_id 
join country c2 on c2.country_id = c.country_id
join customer c4 on c4.address_id = a2.address_id 


--ЗАДАНИЕ №2
--С помощью SQL-запроса посчитайте для каждого магазина количество его покупателей.

select store_id
	, count(c2.customer_id) 
from customer c2 
group by store_id


--Доработайте запрос и выведите только те магазины, 
--у которых количество покупателей больше 300-от.
--Для решения используйте фильтрацию по сгруппированным строкам 
--с использованием функции агрегации.
select store_id
	, count(c2.customer_id)
from customer c2 
group by store_id
having count(c2.customer_id)> 300


-- Доработайте запрос, добавив в него информацию о городе магазина, 
--а также фамилию и имя продавца, который работает в этом магазине.

select 
	s.store_id
	, count(c.customer_id)
	, c2.city
	, concat(s2.first_name, ' ', s2.last_name) as "saler"
from store s 
join customer c on c.store_id = s.store_id 
join address a on s.address_id = a.address_id 
join city c2 on a.city_id = c2.city_id 
join staff s2 on s.manager_staff_id = s2.staff_id 
group by s.store_id
, c2.city_id 
, s2.staff_id 
having count(c.customer_id) > 300



--ЗАДАНИЕ №3
--Выведите ТОП-5 покупателей, 
--которые взяли в аренду за всё время наибольшее количество фильмов

select 
	concat(c.first_name, ' ', c.last_name)
	, t.count
from customer c 
join (
	select customer_id
	, count(rental_id)
	from payment p2 
	group by customer_id 
) as t 
	on t.customer_id = c.customer_id 
order by t.count desc 
limit 5;



--ЗАДАНИЕ №4
--Посчитайте для каждого покупателя 4 аналитических показателя:
--  1. количество фильмов, которые он взял в аренду
--  2. общую стоимость платежей за аренду всех фильмов (значение округлите до целого числа)
--  3. минимальное значение платежа за аренду фильма
--  4. максимальное значение платежа за аренду фильма

select 
	r2.customer_id
	, concat(c2.first_name, ' ', c2.last_name) _name
	, count(inventory_id) cnt
	, round(sum(p2.amount), 0) _sum
	, min(p2.amount) min_paid
	, max(p2.amount) max_paid
from payment p2 
join rental r2 
	on p2.customer_id = r2.customer_id 
	and p2.rental_id = r2.rental_id 
join customer c2 
	on p2.customer_id = c2.customer_id
group by 
	r2.customer_id 


--ЗАДАНИЕ №5
--Используя данные из таблицы городов составьте одним запросом всевозможные пары городов таким образом,
 --чтобы в результате не было пар с одинаковыми названиями городов. 
 --Для решения необходимо использовать декартово произведение.
 
select c.city as "City 1"
	, c2.city as "City 2" 
from city c 
cross join city c2 
where c.city != c2.city 



--ЗАДАНИЕ №6
--Используя данные из таблицы rental о дате выдачи фильма в аренду (поле rental_date)
--и дате возврата фильма (поле return_date), 
--вычислите для каждого покупателя среднее количество дней, за которые покупатель возвращает фильмы.
 select customer_id
	, round(avg(r.return_date::date - r.rental_date::date), 2) as "days" 
 from rental r 
 group by customer_id 
 order by customer_id asc 

------------------------
select *
from (
	select customer_id, array_agg(rental_id) 	
	from (select customer_id, rental_id 
		  FROM rental
		  order by customer_id, rental_date) t 
	group by customer_id ) t
join rental r on r.customer_id = t.customer_id
	and r.rental_id = array_agg[3] 


--======== ДОПОЛНИТЕЛЬНАЯ ЧАСТЬ ==============

--ЗАДАНИЕ №1
--Посчитайте для каждого фильма сколько раз его брали в аренду и значение общей стоимости аренды фильма за всё время.
select 
	f.film_id 
	, f.title 
	, f.release_year 
	, f.rating 
	, c."name" 
	, count(p.rental_id) cnt 
	, sum(p.amount) _sum
from rental r 
join inventory i 
	on r.inventory_id = i.inventory_id 
join payment p  
	on p.rental_id = r.rental_id 
join film f 
	on i.film_id = f.film_id 
join film_category fc 
	on f.film_id = fc.film_id 
join category c 
	on fc.category_id = c.category_id 
group by 
	f.film_id 
	, f.title 
	, f.release_year 
	, f.rating 
	, c."name" 




--ЗАДАНИЕ №2
--Доработайте запрос из предыдущего задания и выведите с помощью запроса фильмы, которые ни разу не брали в аренду.

select 
	f.film_id 
	, f.title 
	, f.release_year 
	, f.rating 
	, c."name" 
	, count(p.rental_id) cnt 
	, sum(p.amount) _sum
from film f 
left join inventory i 
	on f.film_id = i.film_id 
left join rental r 
	on r.inventory_id = i.inventory_id 
left join payment p 
	on p.rental_id = r.rental_id 
join film_category fc 
	on f.film_id = fc.film_id 
join category c 
	on fc.category_id = c.category_id 
where i.inventory_id is null
group by f.film_id 
	, f.title 
	, f.release_year 
	, f.rating 
	, c."name"



--ЗАДАНИЕ №3
--Посчитайте количество продаж, выполненных каждым продавцом. Добавьте вычисляемую колонку "Премия".
--Если количество продаж превышает 7300, то значение в колонке будет "Да", иначе должно быть значение "Нет".
select *
, case 
	when cnt > 7300 then 'Yes'
	else 'No'
end bonus
from (
	select staff_id 
	, count(*) cnt
	from payment p
	group by staff_id 
) t

