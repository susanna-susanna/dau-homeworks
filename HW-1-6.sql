--=============== МОДУЛЬ 6. POSTGRESQL =======================================
--= ПОМНИТЕ, ЧТО НЕОБХОДИМО УСТАНОВИТЬ ВЕРНОЕ СОЕДИНЕНИЕ И ВЫБРАТЬ СХЕМУ PUBLIC===========
SET search_path TO public;

--======== ОСНОВНАЯ ЧАСТЬ ==============

--ЗАДАНИЕ №1
--Напишите SQL-запрос, который выводит всю информацию о фильмах 
--со специальным атрибутом "Behind the Scenes".

select *
from film 
where  array['Behind the Scenes'] <@ special_features 


--ЗАДАНИЕ №2
--Напишите еще 2 варианта поиска фильмов с атрибутом "Behind the Scenes",
--используя другие функции или операторы языка SQL для поиска значения в массиве.

select film_id, title, special_features
from film 
where special_features && array['Behind the Scenes']

select film_id, title, special_features
from film 
where  array_position(special_features, 'Behind the Scenes') is not null



--ЗАДАНИЕ №3
--Для каждого покупателя посчитайте сколько он брал в аренду фильмов 
--со специальным атрибутом "Behind the Scenes.

--Обязательное условие для выполнения задания: используйте запрос из задания 1, 
--помещенный в CTE. CTE необходимо использовать для решения задания.

explain analyze /*Sort  (cost=893.15..894.65 rows=599 width=16) (actual time=9.690..9.721 rows=599 loops=1)*/
with c1 as (
	select *
	from film f2
	where  array['Behind the Scenes'] <@ f2.special_features
)
select c2.customer_id, count(rental_id) 
from customer c2 
    left join rental r using (customer_id)
	join inventory i using (inventory_id)
	join film f using (film_id)
	join c1 on c1.film_id = f.film_id
group by customer_id
order by customer_id


--ЗАДАНИЕ №4
--Для каждого покупателя посчитайте сколько он брал в аренду фильмов
-- со специальным атрибутом "Behind the Scenes".

--Обязательное условие для выполнения задания: используйте запрос из задания 1,
--помещенный в подзапрос, который необходимо использовать для решения задания.

explain analyze /*Sort  (cost=819.51..821.01 rows=599 width=16) (actual time=14.487..14.533 rows=599 loops=1)*/
select c2.customer_id, count(rental_id) 
from customer c2 
    left join rental r using (customer_id)
	join inventory i using (inventory_id)
	join film f using (film_id)
	join (select *
		from film f2
		where  array['Behind the Scenes'] <@ f2.special_features) as t on t.film_id = f.film_id
group by customer_id
order by customer_id



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
--С помощью explain analyze проведите анализ скорости выполнения запросов
-- из предыдущих заданий и ответьте на вопросы:

--1. Каким оператором или функцией языка SQL, используемых при выполнении домашнего задания, 
--   поиск значения в массиве происходит быстрее
--2. какой вариант вычислений работает быстрее: 
--   с использованием CTE или с использованием подзапроса

/*
Доработка!)))
запрос с сте
Sort  (cost=893.15..894.65 rows=599 width=16) (actual time=9.690..9.721 rows=599 loops=1)
запрос с подзапросом
Sort  (cost=819.51..821.01 rows=599 width=16) (actual time=14.487..14.533 rows=599 loops=1)

Если я опять-таки правильно понимаю, то: 
запрос с сте стоит немного дороже, но по времени работает быстрее запроса с подзапросом.
запрос с подзапросом чуть дешевле запроса с с сте, но примерно в 1,5 раза больше по времени

*/

--======== ДОПОЛНИТЕЛЬНАЯ ЧАСТЬ ==============

--ЗАДАНИЕ №1
--Выполняйте это задание в форме ответа на сайте Нетологии

--ЗАДАНИЕ №2
--Используя оконную функцию выведите для каждого сотрудника
--сведения о самой первой продаже этого сотрудника.





--ЗАДАНИЕ №3
--Для каждого магазина определите и выведите одним SQL-запросом следующие аналитические показатели:
-- 1. день, в который арендовали больше всего фильмов (день в формате год-месяц-день)
-- 2. количество фильмов взятых в аренду в этот день
-- 3. день, в который продали фильмов на наименьшую сумму (день в формате год-месяц-день)
-- 4. сумму продажи в этот день




