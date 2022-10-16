--=============== МОДУЛЬ 5. РАБОТА С POSTGRESQL =======================================
--= ПОМНИТЕ, ЧТО НЕОБХОДИМО УСТАНОВИТЬ ВЕРНОЕ СОЕДИНЕНИЕ И ВЫБРАТЬ СХЕМУ PUBLIC===========
SET search_path TO public;

--======== ОСНОВНАЯ ЧАСТЬ ==============

--ЗАДАНИЕ №1
--Сделайте запрос к таблице payment и с помощью оконных функций добавьте вычисляемые колонки согласно условиям:
--Пронумеруйте все платежи от 1 до N по дате
--Пронумеруйте платежи для каждого покупателя, сортировка платежей должна быть по дате
--Посчитайте нарастающим итогом сумму всех платежей для каждого покупателя, сортировка должна 
--быть сперва по дате платежа, а затем по сумме платежа от наименьшей к большей
--Пронумеруйте платежи для каждого покупателя по стоимости платежа от наибольших к меньшим 
--так, чтобы платежи с одинаковым значением имели одинаковое значение номера.
--Можно составить на каждый пункт отдельный SQL-запрос, а можно объединить все колонки в одном запросе.

select * from payment p 

select customer_id, payment_id, payment_date, row_number() over (partition by customer_id order by payment_date)
from payment p 

with cte1 as (
	select customer_id, payment_id, payment_date, row_number() over () as "нумеруем всё"
	from payment p 
), cte2 as (
	select p.customer_id, p.payment_id, p.payment_date, "нумеруем всё", row_number() over (partition by p.customer_id order by p.payment_date) as "по юзеру"
	from payment p 
	left join cte1 on cte1.payment_id = p.payment_id
), c3 as (
	select 
	p.customer_id, p.payment_id,  p.payment_date, "нумеруем всё", "по юзеру", p.amount, 
	sum(p.amount) over (partition by p.customer_id order by p.payment_date) 
	--sum(p.amount) over (partition by p.customer_id order by p.amount) as "по сумме"
	from payment p
	left join cte2 on cte2.payment_id = p.payment_id
)
select *,
	dense_rank () over (partition by c3.customer_id order by c3.amount desc) as "ранг платежа"
from c3



--ЗАДАНИЕ №2
--С помощью оконной функции выведите для каждого покупателя стоимость платежа и стоимость 
--платежа из предыдущей строки со значением по умолчанию 0.0 с сортировкой по дате.

select
	customer_id, payment_id,  payment_date, amount, lag (amount, 1, 0.) over (partition by customer_id order by payment_date)
from payment p 



--ЗАДАНИЕ №3
--С помощью оконной функции определите, на сколько каждый следующий платеж покупателя больше или меньше текущего.

select
	customer_id, payment_id,  payment_date, amount, lead (amount, 1, 0.) over (partition by customer_id order by payment_date) - amount "разница"
from payment p 



--ЗАДАНИЕ №4
--С помощью оконной функции для каждого покупателя выведите данные о его последней оплате аренды.

select 
	distinct customer_id, payment_id, payment_date, amount,
	last_value(amount) over (partition by customer_id order by payment_date
	rows between unbounded preceding and unbounded following) as "last amount",
	last_value(payment_date) over (partition by customer_id order by payment_date
	rows between unbounded preceding and unbounded following) as "last date"
from payment
group by customer_id, payment_id
order by customer_id

	
select customer_id, payment_id, payment_date, amount 
from (
	select *, 
		row_number() over (partition by customer_id order by payment_date desc)
	from payment) t
where row_number = 1	

--======== ДОПОЛНИТЕЛЬНАЯ ЧАСТЬ ==============

--ЗАДАНИЕ №1
--С помощью оконной функции выведите для каждого сотрудника сумму продаж за август 2005 года 
--с нарастающим итогом по каждому сотруднику и по каждой дате продажи (без учёта времени) 
--с сортировкой по дате.

select staff_id, payment_date::date, sum(amount), sum(sum(amount)) over (partition by staff_id order by payment_date::date) 
from payment p 
where date_trunc('Month', p.payment_date) = '2005-08-01 00:00:00'
group by staff_id, payment_date::date


select staff_id, payment_date::date, sum(amount), sum(sum(amount)) over (partition by staff_id order by payment_date::date) 
from payment p 
where date_trunc('Month', p.payment_date) = '2005-08-01 00:00:00'
group by staff_id, payment_date::date
--ЗАДАНИЕ №2
--20 августа 2005 года в магазинах проходила акция: покупатель каждого сотого платежа получал
--дополнительную скидку на следующую аренду. С помощью оконной функции выведите всех покупателей,
--которые в день проведения акции получили скидку

select customer_id 
from (
	select *, row_number() over (order by p.payment_date)
	from payment p 
	where date_trunc('Day', p.payment_date) = '2005-08-20 00:00:00'
	order by p.payment_date ) pr
where row_number % 100 = 0

select customer_id 
from (
	select *, row_number() over (order by p.payment_date)
	from payment p 
	where p.payment_date::date = '2005-08-20') t 
where row_number % 100 = 0


--ЗАДАНИЕ №3
--Для каждой страны определите и выведите одним SQL-запросом покупателей, которые попадают под условия:
-- 1. покупатель, арендовавший наибольшее количество фильмов
-- 2. покупатель, арендовавший фильмов на самую большую сумму
-- 3. покупатель, который последним арендовал фильм






