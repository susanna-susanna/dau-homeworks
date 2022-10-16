--=============== ������ 3. ������ SQL =======================================
--= �������, ��� ���������� ���������� ������ ���������� � ������� ����� PUBLIC===========
SET search_path TO public;

--======== �������� ����� ==============

--������� �1
--�������� ��� ������� ���������� ��� ����� ����������, 
--����� � ������ ����������.
select concat(first_name, ' ', last_name) as "���", a2.address, c.city, c2.country 
from city c
join address a2 on a2.city_id = c.city_id 
join country c2 on c2.country_id = c.country_id
join customer c4 on c4.address_id = a2.address_id 



--������� �2
--� ������� SQL-������� ���������� ��� ������� �������� ���������� ��� �����������.

select store_id, count(c2.customer_id) 
from customer c2 
group by store_id


--����������� ������ � �������� ������ �� ��������, 
--� ������� ���������� ����������� ������ 300-��.
--��� ������� ����������� ���������� �� ��������������� ������� 
--� �������������� ������� ���������.
select store_id, count(c2.customer_id)
from customer c2 
group by store_id
having count(c2.customer_id)> 300


-- ����������� ������, ������� � ���� ���������� � ������ ��������, 
--� ����� ������� � ��� ��������, ������� �������� � ���� ��������.

select s.store_id, count(c.customer_id), c2.city, concat(s2.first_name, ' ', s2.last_name) as "saler"
from store s 
join customer c on c.store_id = s.store_id 
join address a on s.address_id = a.address_id 
join city c2 on a.city_id = c2.city_id 
join staff s2 on s.manager_staff_id = s2.staff_id 
group by s.store_id, c2.city, concat(s2.first_name, ' ', s2.last_name)
having count(c.customer_id) > 300



--������� �3
--�������� ���-5 �����������, 
--������� ����� � ������ �� �� ����� ���������� ���������� �������

select concat(c.first_name, ' ', c.last_name), t.count
from customer c 
join
(select customer_id, count(rental_id)
from payment p2 
group by customer_id ) as t on t.customer_id = c.customer_id 
order by t.count desc 
limit 5;



--������� �4
--���������� ��� ������� ���������� 4 ������������� ����������:
--  1. ���������� �������, ������� �� ���� � ������
--  2. ����� ��������� �������� �� ������ ���� ������� (�������� ��������� �� ������ �����)
--  3. ����������� �������� ������� �� ������ ������
--  4. ������������ �������� ������� �� ������ ������

select concat(c.first_name, ' ', c.last_name), t.count, t.sum, t.min, t.max
from customer c 
	join
	(select customer_id, count(inventory_id), sum(r2.rental_id), min(r2.rental_id), max(r2.rental_id) 
	from payment p2 
		join rental r2 using (customer_id)
		group by customer_id ) as t on t.customer_id = c.customer_id 



--������� �5
--��������� ������ �� ������� ������� ��������� ����� �������� ������������ ���� ������� ����� �������,
 --����� � ���������� �� ���� ��� � ����������� ���������� �������. 
 --��� ������� ���������� ������������ ��������� ������������.
 
select c.city as "City 1", c2.city as "City 2" 
from city c 
cross join city c2 
where c.city != c2.city 



--������� �6
--��������� ������ �� ������� rental � ���� ������ ������ � ������ (���� rental_date)
--� ���� �������� ������ (���� return_date), 
--��������� ��� ������� ���������� ������� ���������� ����, �� ������� ���������� ���������� ������.
 select customer_id, round(avg(r.return_date::date - r.rental_date::date), 2) as "days" 
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


--======== �������������� ����� ==============

--������� �1
--���������� ��� ������� ������ ������� ��� ��� ����� � ������ � �������� ����� ��������� ������ ������ �� �� �����.





--������� �2
--����������� ������ �� ����������� ������� � �������� � ������� ������� ������, ������� �� ���� �� ����� � ������.





--������� �3
--���������� ���������� ������, ����������� ������ ���������. �������� ����������� ������� "������".
--���� ���������� ������ ��������� 7300, �� �������� � ������� ����� "��", ����� ������ ���� �������� "���".