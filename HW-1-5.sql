--=============== ������ 5. ������ � POSTGRESQL =======================================
--= �������, ��� ���������� ���������� ������ ���������� � ������� ����� PUBLIC===========
SET search_path TO public;

--======== �������� ����� ==============

--������� �1
--�������� ������ � ������� payment � � ������� ������� ������� �������� ����������� ������� �������� ��������:
--������������ ��� ������� �� 1 �� N �� ����
--������������ ������� ��� ������� ����������, ���������� �������� ������ ���� �� ����
--���������� ����������� ������ ����� ���� �������� ��� ������� ����������, ���������� ������ 
--���� ������ �� ���� �������, � ����� �� ����� ������� �� ���������� � �������
--������������ ������� ��� ������� ���������� �� ��������� ������� �� ���������� � ������� 
--���, ����� ������� � ���������� ��������� ����� ���������� �������� ������.
--����� ��������� �� ������ ����� ��������� SQL-������, � ����� ���������� ��� ������� � ����� �������.

select * from payment p 

select customer_id, payment_id, payment_date, row_number() over (partition by customer_id order by payment_date)
from payment p 

with cte1 as (
	select customer_id, payment_id, payment_date, row_number() over () as "�������� ��"
	from payment p 
), cte2 as (
	select p.customer_id, p.payment_id, p.payment_date, "�������� ��", row_number() over (partition by p.customer_id order by p.payment_date) as "�� �����"
	from payment p 
	left join cte1 on cte1.payment_id = p.payment_id
), c3 as (
	select 
	p.customer_id, p.payment_id,  p.payment_date, "�������� ��", "�� �����", p.amount, 
	sum(p.amount) over (partition by p.customer_id order by p.payment_date) 
	--sum(p.amount) over (partition by p.customer_id order by p.amount) as "�� �����"
	from payment p
	left join cte2 on cte2.payment_id = p.payment_id
)
select *,
	dense_rank () over (partition by c3.customer_id order by c3.amount desc) as "���� �������"
from c3



--������� �2
--� ������� ������� ������� �������� ��� ������� ���������� ��������� ������� � ��������� 
--������� �� ���������� ������ �� ��������� �� ��������� 0.0 � ����������� �� ����.

select
	customer_id, payment_id,  payment_date, amount, lag (amount, 1, 0.) over (partition by customer_id order by payment_date)
from payment p 



--������� �3
--� ������� ������� ������� ����������, �� ������� ������ ��������� ������ ���������� ������ ��� ������ ��������.

select
	customer_id, payment_id,  payment_date, amount, lead (amount, 1, 0.) over (partition by customer_id order by payment_date) - amount "�������"
from payment p 



--������� �4
--� ������� ������� ������� ��� ������� ���������� �������� ������ � ��� ��������� ������ ������.

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

--======== �������������� ����� ==============

--������� �1
--� ������� ������� ������� �������� ��� ������� ���������� ����� ������ �� ������ 2005 ���� 
--� ����������� ������ �� ������� ���������� � �� ������ ���� ������� (��� ����� �������) 
--� ����������� �� ����.

select staff_id, payment_date::date, sum(amount), sum(sum(amount)) over (partition by staff_id order by payment_date::date) 
from payment p 
where date_trunc('Month', p.payment_date) = '2005-08-01 00:00:00'
group by staff_id, payment_date::date


select staff_id, payment_date::date, sum(amount), sum(sum(amount)) over (partition by staff_id order by payment_date::date) 
from payment p 
where date_trunc('Month', p.payment_date) = '2005-08-01 00:00:00'
group by staff_id, payment_date::date
--������� �2
--20 ������� 2005 ���� � ��������� ��������� �����: ���������� ������� ������ ������� �������
--�������������� ������ �� ��������� ������. � ������� ������� ������� �������� ���� �����������,
--������� � ���� ���������� ����� �������� ������

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


--������� �3
--��� ������ ������ ���������� � �������� ����� SQL-�������� �����������, ������� �������� ��� �������:
-- 1. ����������, ������������ ���������� ���������� �������
-- 2. ����������, ������������ ������� �� ����� ������� �����
-- 3. ����������, ������� ��������� ��������� �����






