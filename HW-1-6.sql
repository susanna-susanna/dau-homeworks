--=============== ������ 6. POSTGRESQL =======================================
--= �������, ��� ���������� ���������� ������ ���������� � ������� ����� PUBLIC===========
SET search_path TO public;

--======== �������� ����� ==============

--������� �1
--�������� SQL-������, ������� ������� ��� ���������� � ������� 
--�� ����������� ��������� "Behind the Scenes".

select *
from film 
where  array['Behind the Scenes'] <@ special_features 


--������� �2
--�������� ��� 2 �������� ������ ������� � ��������� "Behind the Scenes",
--��������� ������ ������� ��� ��������� ����� SQL ��� ������ �������� � �������.

select film_id, title, special_features
from film 
where special_features && array['Behind the Scenes']

select film_id, title, special_features
from film 
where  array_position(special_features, 'Behind the Scenes') is not null



--������� �3
--��� ������� ���������� ���������� ������� �� ���� � ������ ������� 
--�� ����������� ��������� "Behind the Scenes.

--������������ ������� ��� ���������� �������: ����������� ������ �� ������� 1, 
--���������� � CTE. CTE ���������� ������������ ��� ������� �������.

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


--������� �4
--��� ������� ���������� ���������� ������� �� ���� � ������ �������
-- �� ����������� ��������� "Behind the Scenes".

--������������ ������� ��� ���������� �������: ����������� ������ �� ������� 1,
--���������� � ���������, ������� ���������� ������������ ��� ������� �������.

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



--������� �5
--�������� ����������������� ������������� � �������� �� ����������� �������
--� �������� ������ ��� ���������� ������������������ �������������

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

--������� �6
--� ������� explain analyze ��������� ������ �������� ���������� ��������
-- �� ���������� ������� � �������� �� �������:

--1. ����� ���������� ��� �������� ����� SQL, ������������ ��� ���������� ��������� �������, 
--   ����� �������� � ������� ���������� �������
--2. ����� ������� ���������� �������� �������: 
--   � �������������� CTE ��� � �������������� ����������

/*
���������!)))
������ � ���
Sort  (cost=893.15..894.65 rows=599 width=16) (actual time=9.690..9.721 rows=599 loops=1)
������ � �����������
Sort  (cost=819.51..821.01 rows=599 width=16) (actual time=14.487..14.533 rows=599 loops=1)

���� � �����-���� ��������� �������, ��: 
������ � ��� ����� ������� ������, �� �� ������� �������� ������� ������� � �����������.
������ � ����������� ���� ������� ������� � � ���, �� �������� � 1,5 ���� ������ �� �������

*/

--======== �������������� ����� ==============

--������� �1
--���������� ��� ������� � ����� ������ �� ����� ���������

--������� �2
--��������� ������� ������� �������� ��� ������� ����������
--�������� � ����� ������ ������� ����� ����������.





--������� �3
--��� ������� �������� ���������� � �������� ����� SQL-�������� ��������� ������������� ����������:
-- 1. ����, � ������� ���������� ������ ����� ������� (���� � ������� ���-�����-����)
-- 2. ���������� ������� ������ � ������ � ���� ����
-- 3. ����, � ������� ������� ������� �� ���������� ����� (���� � ������� ���-�����-����)
-- 4. ����� ������� � ���� ����




