--=============== ������ 2. ������ � ������ ������ =======================================
--= �������, ��� ���������� ���������� ������ ���������� � ������� ����� PUBLIC===========
SET search_path TO public;

--======== �������� ����� ==============

--������� �1
--�������� ���������� �������� ������� �� ������� �������.

select distinct city 
from city ci 
order by city;

select distinct city 
from city c;


--������� �2
--����������� ������ �� ����������� �������, ����� ������ ������� ������ �� ������,
--�������� ������� ���������� �� �L� � ������������� �� �a�, � �������� �� �������� ��������.

select distinct city 
from city c
where city ilike 'l_%_a' and city not like '% %';



--������� �3
--�������� �� ������� �������� �� ������ ������� ���������� �� ��������, ������� ����������� 
--� ���������� � 17 ���� 2005 ���� �� 19 ���� 2005 ���� ������������, 
--� ��������� ������� ��������� 1.00.
--������� ����� ������������� �� ���� �������.

--select * from payment p

select payment_id, payment_date, amount 
from payment p 
where payment_date between '2005-06-17' and '2005-06-19'::date + interval '1 day' and amount > 1.00
order by payment_date;



--������� �4
-- �������� ���������� � 10-�� ��������� �������� �� ������ �������.
select payment_id, payment_date, amount 
from payment p 
where payment_date between '2005-06-17' and '2005-06-19'::date + interval '1 day' and amount > 1.00
order by payment_date desc 
limit 10;


--������� �5
--�������� ��������� ���������� �� �����������:
--  1. ������� � ��� (� ����� ������� ����� ������)
--  2. ����������� �����
--  3. ����� �������� ���� email
--  4. ���� ���������� ���������� ������ � ���������� (��� �������)
--������ ������� ������� ������������ �� ������� �����.

--select * from customer c 

select concat(first_name, ' ', last_name) as "���", email as "�����", character_length(email) as "�����", (last_update::date) as "����"  
from customer c;



--������� �6
--�������� ����� �������� ������ �������� �����������, ����� ������� KELLY ��� WILLIE.
--��� ����� � ������� � ����� �� �������� �������� ������ ���� ���������� � ������ �������.

select lower(last_name), lower(first_name)
from customer c 
where (first_name = 'KELLY' or first_name = 'WILLIE') and active = 1;



--======== �������������� ����� ==============

--������� �1
--�������� ����� �������� ���������� � �������, � ������� ������� "R" 
--� ��������� ������ ������� �� 0.00 �� 3.00 ������������, 
--� ����� ������ c ��������� "PG-13" � ���������� ������ ������ ��� ������ 4.00.

select title, description, rental_rate, rating 
from film f
where (rating = 'R' and rental_rate >=0.00 and rental_rate <=3.00) or (rating = 'PG-13' and rental_rate >= 4.00);



--������� �2
--�������� ���������� � ��� ������� � ����� ������� ��������� ������.

select film_id, title, character_length(description) 
from film f 
order by character_length(description) desc
limit 3;


--������� �3
-- �������� Email ������� ����������, �������� �������� Email �� 2 ��������� �������:
--� ������ ������� ������ ���� ��������, ��������� �� @, 
--�� ������ ������� ������ ���� ��������, ��������� ����� @.

select customer_id, email 
from customer c  






--������� �4
--����������� ������ �� ����������� �������, �������������� �������� � ����� ��������: 
--������ ����� ������ ���� ���������, ��������� ���������.