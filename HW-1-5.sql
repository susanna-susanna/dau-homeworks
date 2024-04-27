--=============== МОДУЛЬ 5. РАБОТА С POSTGRESQL =======================================
--= ПОМНИТЕ, ЧТО НЕОБХОДИМО УСТАНОВИТЬ ВЕРНОЕ СОЕДИНЕНИЕ И ВЫБРАТЬ СХЕМУ PUBLIC===========
SET search_path TO public;

--======== ОСНОВНАЯ ЧАСТЬ ==============

--ЗАДАНИЕ №1
--Сделайте запрос к таблице payment и с помощью оконных функций добавьте вычисляемые колонки согласно условиям:
--Пронумеруйте все платежи от 1 до N по дате платежа
--Пронумеруйте платежи для каждого покупателя, сортировка платежей должна быть по дате платежа
--Посчитайте нарастающим итогом сумму всех платежей для каждого покупателя, сортировка должна 
--быть сперва по дате платежа, а затем по размеру платежа от наименьшей к большей
--Пронумеруйте платежи для каждого покупателя по размеру платежа от наибольшего к
--меньшему так, чтобы платежи с одинаковым значением имели одинаковое значение номера.
--Можно составить на каждый пункт отдельный SQL-запрос, а можно объединить все колонки в одном запросе.

select 
	*
	, row_number () over (order by payment_date) rn_payment
	, row_number () over (partition by customer_id order by payment_date) rn_by_customer
	, sum(amount) over (partition by customer_id order by payment_date::date asc, amount desc) cummul_sum
	, dense_rank() over (partition by customer_id order by amount desc)
from payment


--ЗАДАНИЕ №2
--С помощью оконной функции выведите для каждого покупателя стоимость платежа и стоимость 
--платежа из предыдущей строки со значением по умолчанию 0.0 с сортировкой по дате платежа.

select 
	customer_id 
	, amount 
	, lag(amount, 1, 0.) over (partition by customer_id order by payment_date)  previous_amount
from payment p 



--ЗАДАНИЕ №3
--С помощью оконной функции определите, на сколько каждый следующий платеж покупателя больше или меньше текущего.

select 
	customer_id 
	, amount 
	, lead(amount) over (partition by customer_id order by payment_date) next_payment
	, lead(amount) over (partition by customer_id order by payment_date) - amount as differ
from payment p

--если следующее значение отстутствует, то по умолчанию назанчаем 0.0
select 
	customer_id 
	, amount 
	, lead(amount, 1, 0.) over (partition by customer_id order by payment_date) - amount as differ
from payment p 



--ЗАДАНИЕ №4
--С помощью оконной функции для каждого покупателя выведите данные о его последней оплате аренды.
with all_info as (
	select  
	customer_id
	, payment_id
	, payment_date
	, amount
	, last_value(amount) over (partition by customer_id order by payment_date
	rows between unbounded preceding and unbounded following) as last_amount
	, last_value(payment_date) over (partition by customer_id order by payment_date
	rows between unbounded preceding and unbounded following) as last_date
	from payment
)
select  
	customer_id
	, payment_id
	, payment_date
	, amount
from all_info
where payment_date = last_date
	and amount = last_amount




--======== ДОПОЛНИТЕЛЬНАЯ ЧАСТЬ ==============

--ЗАДАНИЕ №1
--С помощью оконной функции выведите для каждого сотрудника сумму продаж за август 2005 года 
--с нарастающим итогом по каждому сотруднику и по каждой дате продажи (без учёта времени) 
--с сортировкой по дате.

select 
distinct 
staff_id 
, payment_date::date 
, sum(amount) over (partition by staff_id order by payment_date::date)
, sum(amount) over (partition by staff_id)
from payment p 
where date_trunc('month', payment_date) = '2005-05-01'


--ЗАДАНИЕ №2
--20 августа 2005 года в магазинах проходила акция: покупатель каждого сотого платежа получал
--дополнительную скидку на следующую аренду. С помощью оконной функции выведите всех покупателей,
--которые в день проведения акции получили скидку

with all_payments as (
	select *
	, row_number () over (order by payment_date) rn
	from payment p 
	where payment_date::date = '2005-08-20'
)
select *
from all_payments
where rn % 100 = 0

--ЗАДАНИЕ №3
--Для каждой страны определите и выведите одним SQL-запросом покупателей, которые попадают под условия:
-- 1. покупатель, арендовавший наибольшее количество фильмов
-- 2. покупатель, арендовавший фильмов на самую большую сумму
-- 3. покупатель, который последним арендовал фильм

with general_ as (
	select 
		c3.country 
		, c3.country_id 
		, concat_ws(' ', c.first_name, c.last_name) customer  
		, count(rental_id) over (partition by c3.country_id, p.customer_id) cnt_rental
		, sum(amount) over (partition by c3.country_id, p.customer_id) sum_rental
		, max(payment_date) over (partition by c3.country_id, p.customer_id) last_rental_date
	from payment p 
	join customer c 
		on p.customer_id = c.customer_id 
	join address a 
		on c.address_id = a.address_id 
	join city c2 
		on a.city_id = c2.city_id 
	join country c3 
		on c2.country_id = c3.country_id 
)
select distinct 
	country 
	, first_value (customer) over (partition by country_id order by cnt_rental desc) max_cnt_rental
	, first_value (customer) over (partition by country_id order by sum_rental desc) max_sum_rental
	, first_value (customer) over (partition by country_id order by last_rental_date desc) last_rental_date
from general_ 
order by country_id 

