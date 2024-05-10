--=============== МОДУЛЬ 6. POSTGRESQL =======================================
--= ПОМНИТЕ, ЧТО НЕОБХОДИМО УСТАНОВИТЬ ВЕРНОЕ СОЕДИНЕНИЕ И ВЫБРАТЬ СХЕМУ PUBLIC===========
SET search_path TO public;

--======== ОСНОВНАЯ ЧАСТЬ ==============

--ЗАДАНИЕ №1
--Напишите SQL-запрос, который выводит всю информацию о фильмах 
--со специальным атрибутом "Behind the Scenes".

explain analyze
--Seq Scan on film  (cost=0.00..67.50 rows=538 width=386) (actual time=0.013..0.402 rows=538 loops=1)
--Planning time: 0.091 ms
--Execution time: 0.437 ms
select *
from film
where  array['Behind the Scenes'] <@ special_features 




--ЗАДАНИЕ №2
--Напишите еще 2 варианта поиска фильмов с атрибутом "Behind the Scenes",
--используя другие функции или операторы языка SQL для поиска значения в массиве.

--explain analyze
--Seq Scan on film  (cost=0.00..67.50 rows=538 width=386) (actual time=0.010..0.455 rows=538 loops=1)
--Planning time: 0.091 ms
--Execution time: 0.495 ms
select *
from film 
where special_features && array['Behind the Scenes']


--explain analyze
--Seq Scan on film  (cost=0.00..67.50 rows=995 width=386) (actual time=0.015..0.417 rows=538 loops=1)
--Planning time: 0.089 ms
--Execution time: 0.469 ms
select *
from film 
where  array_position(special_features, 'Behind the Scenes') is not null



--ЗАДАНИЕ №3
--Для каждого покупателя посчитайте сколько он брал в аренду фильмов 
--со специальным атрибутом "Behind the Scenes.

--Обязательное условие для выполнения задания: используйте запрос из задания 1, 
--помещенный в CTE. CTE необходимо использовать для решения задания.

explain analyze 
-- (cost=806.32..807.82 rows=599 width=10) (actual time=8.070..8.097 rows=599 loops=1)
--Planning time: 1.164 ms
--Execution time: 8.308 ms
with cte1 as (
	select *
	from film
	where  array['Behind the Scenes'] <@ special_features 
)
select 
	r.customer_id
	, count(r.rental_id) cnt_rental
from rental r 
join inventory i 
	on r.inventory_id = i.inventory_id 
join cte1
	on cte1.film_id = i.film_id 
group by r.customer_id
order by r.customer_id



--ЗАДАНИЕ №4
--Для каждого покупателя посчитайте сколько он брал в аренду фильмов
-- со специальным атрибутом "Behind the Scenes".

--Обязательное условие для выполнения задания: используйте запрос из задания 1,
--помещенный в подзапрос, который необходимо использовать для решения задания.


explain analyze 
--  (cost=673.96..675.46 rows=599 width=10) (actual time=9.622..9.648 rows=599 loops=1)
--Planning time: 0.463 ms
--Execution time: 9.729 ms
select 
	r.customer_id
	, count(r.rental_id) cnt_rental
from rental r 
join inventory i 
	on r.inventory_id = i.inventory_id 
join (
	select film_id
	from film
	where  array['Behind the Scenes'] <@ special_features 
) tt
	on tt.film_id = i.film_id 
group by r.customer_id
order by r.customer_id



--ЗАДАНИЕ №5
--Создайте материализованное представление с запросом из предыдущего задания
--и напишите запрос для обновления материализованного представления

create materialized view task_5 as 
	select distinct c2.customer_id, count(rental_id) over (partition by customer_id)
	from customer c2 
    left join rental r using (customer_id)
	join inventory i using (inventory_id)
	join film f using (film_id)
	join (select *
		from film f2
		where  array['Behind the Scenes'] <@ f2.special_features) as t on t.film_id = f.film_id
order by customer_id
with no data

refresh materialized view task_5



--ЗАДАНИЕ №6
--С помощью explain analyze проведите анализ стоимости выполнения запросов из предыдущих заданий и ответьте на вопросы:
--1. с каким оператором или функцией языка SQL, используемыми при выполнении домашнего задания: 
--поиск значения в массиве затрачивает меньше ресурсов системы;
--2. какой вариант вычислений затрачивает меньше ресурсов системы: 
--с использованием CTE или с использованием подзапроса.

1/ Возможно, слишком мало данных, но разницы в стоимости запросов и во времени я не вижу.

2/ Использование подзапроса уменьшает использование ресурсов.

--======== ДОПОЛНИТЕЛЬНАЯ ЧАСТЬ ==============

--ЗАДАНИЕ №1
--Выполняйте это задание в форме ответа на сайте Нетологии
/*
Сделайте explain analyze этого запроса.
Основываясь на описании запроса, найдите узкие места и опишите их.
Сравните с вашим запросом из основной части (если ваш запрос изначально укладывается в 15мс — отлично!).
Сделайте построчное описание explain analyze на русском языке оптимизированного запроса. 
Описание строк в explain можно посмотреть по ссылке.
https://use-the-index-luke.com/
 */


explain analyze
select distinct cu.first_name  || ' ' || cu.last_name as name, 
	count(ren.iid) over (partition by cu.customer_id)
from customer cu
full outer join 
	(select *, r.inventory_id as iid, inv.sf_string as sfs, r.customer_id as cid
	from rental r 
	full outer join 
		(select *, unnest(f.special_features) as sf_string
		from inventory i
		full outer join film f on f.film_id = i.film_id) as inv 
		on r.inventory_id = inv.inventory_id) as ren 
	on ren.cid = cu.customer_id 
where ren.sfs like '%Behind the Scenes%'
order by count desc


Основываясь на описании запроса, можно выделить следующие узкие места:
1. Узкое место - это unnest

2. Сортировка и оконные функции:
   - Запрос выполняет сложную сортировку с использованием оконных функций, что занимает значительное время
   Unique  (cost=8599.88..8600.22 rows=46 width=44) (actual time=34.096..35.259 rows=600 loops=1)
   - Это может быть узким местом, особенно если количество строк, требующих сортировки, велико.
3. Вложенные запросы и соединения:
   - Запрос содержит вложенные запросы и сложные соединения таблиц, что может замедлять общее время выполнения.
   - Например, Hash Right Join (cost=8212.07..8582.70 rows=46 width=6) (actual time=6.632..10.948 rows=8632 loops=1)
     и Nested Loop Left Join (cost=8212.35..8596.30 rows=46 width=21) (actual time=6.661..22.642 rows=8632 loops=1)
     дорогостоящие. И могут быть медленными, особенно если таблицы большие или условия соединения неоптимальны.

4. Фильтрация данных:
   - Запрос содержит фильтрацию данных по столбцу `sf_string`, что может быть медленным, если индекс 
     на этом столбце отсутствует или неэффективен.
   - Это может быть узким местом, если фильтрация затрагивает большое количество строк.

5. Использование памяти:
   - Запрос использует значительное количество памяти для сортировки и хеширования, 
     что может быть проблемой на системах с ограниченными ресурсами.
   - Это может быть узким местом, если система не может выделить достаточно памяти для выполнения запроса.


--ЗАДАНИЕ №2
--Используя оконную функцию выведите для каждого сотрудника
--сведения о самой первой продаже этого сотрудника.
with all_sales as (
	select p.staff_id
		, p.rental_id 
		, p.customer_id
		, p.amount 
		, p.payment_date
		--, row_number() over (partition by p.staff_id order by p.payment_date) rn
		, dense_rank() over (partition by p.staff_id order by p.payment_date) dr
		--row_number() не совсем подходит, так как за одну итреацию сотрудник может сделать
		-- несколько продаж. Например rental_id in (3005, 3006)  совершены сотрудником1 в одно и тоже время. 
	from payment p 
)
select 
	p.staff_id
	, p.rental_id 
	, p.customer_id
	, p.amount 
	, p.payment_date
from all_sales p
where dr = 1


--ЗАДАНИЕ №3
--Для каждого магазина определите и выведите одним SQL-запросом следующие аналитические показатели:
-- 1. день, в который арендовали больше всего фильмов (день в формате год-месяц-день)
-- 2. количество фильмов взятых в аренду в этот день
-- 3. день, в который продали фильмов на наименьшую сумму (день в формате год-месяц-день)
-- 4. сумму продажи в этот день


with general_ as (
	select 
		i.store_id 
		, p.payment_date::date
		, count(i.film_id) film_cnt
		, sum(p.amount) amount
	from rental r 
	join inventory i 
		on r.inventory_id = i.inventory_id 
	left join payment p 
		on r.rental_id = p.rental_id 
	group by i.store_id 
		, p.payment_date::date
)
,
find as (
select 
	*
	, first_value (payment_date) over (partition by store_id order by film_cnt desc) max_cnt_rental_date
	, first_value (payment_date) over (partition by store_id order by amount asc) min_sum_rental_date
from general_
)
select 
	find.store_id
	, find.film_cnt
	, find.max_cnt_rental_date
	--
	, mini.amount
	, mini.min_sum_rental_date
from find
join (
	select 
	store_id
	, amount
	, min_sum_rental_date
	from find
	where min_sum_rental_date = payment_date 
) mini
	on find.store_id = mini.store_id
where find.max_cnt_rental_date = find.payment_date



with general_ as (
	select 
		i.store_id 
		, p.payment_date::date
		, count(i.film_id) film_cnt
		, sum(p.amount) amount
	from rental r 
	join inventory i 
		on r.inventory_id = i.inventory_id 
	left join payment p 
		on r.rental_id = p.rental_id 
	group by i.store_id 
		, p.payment_date::date
)
, min_sum as (
	select 
		*
		, dense_rank () over (partition by store_id order by amount asc) dr
	from general_
)
, max_cnt as (
	select 
		*
		, dense_rank () over (partition by store_id order by film_cnt desc) dr
	from general_
)
select
	max_cnt.store_id
	, film_cnt
	, max_cnt.payment_date max_cnt_date
	--
	, min_sum.amount
	, min_sum.payment_date 
from max_cnt 
join ( 
	select 
	min_sum.store_id
	, min_sum.amount
	, min_sum.payment_date 
	from min_sum
	where min_sum.dr = 1
) min_sum
on max_cnt.store_id = min_sum.store_id
where max_cnt.dr = 1
