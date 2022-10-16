--=============== ������ 4. ���������� � SQL =======================================
--= �������, ��� ���������� ���������� ������ ���������� � ������� ����� PUBLIC===========
SET search_path TO public;

--======== �������� ����� ==============

--������� �1
--���� ������: ���� ����������� � �������� ����, �� ������� ����� ����� � ��������� � --���� �������, �������� ������ ���� �� �������� � ������ �������� � ������� �������� --� ���� ����� �����, ���� ����������� � ���������� �������, �� ������� ����� ����� � --� ��� ������� �������.

create schema alieva_lecture_4;
set search_path to alieva_lecture_4;

--������������� ���� ������, ���������� ��� �����������:
--� ���� (����������, ����������� � �. �.);
--� ���������� (�������, ���������� � �. �.);
--� ������ (������, �������� � �. �.).
--��� ������� �� �������: ����-���������� � ����������-������, ��������� ������ �� ������. ������ ������� �� ������� � film_actor.
--���������� � ��������-������������:
--� ������� ����������� ��������� ������.
--� �������������� �������� ������ ������������� ���������������;
--� ������������ ��������� �� ������ ��������� null-��������, �� ������ ����������� --��������� � ��������� ���������.
--���������� � �������� �� �������:
--� ������� ����������� ��������� � ������� ������.

--� �������� ������ �� ������� �������� ������� �������� ������ � ������� �� --���������� � ������ ������� �� 5 ����� � �������.
 
--�������� ������� �����
create table alieva_languages (
lang_id serial primary key,
language_name varchar(255) not null unique
);

update pg_attribute set atttypmod = 50+4
where attrelid = 'alieva_language'::regclass and attname = 'language_id';

--�������� ������ � ������� �����
insert into a_languages(language_name)
values ('��������'), ('����������'), ('����������'), ('���������'), ('�������');

insert into a_languages(language_name)
values ('����������'), ('��������'), ('�������'), ('�����������');

select * from a_languages al 

alter table a_languages rename to a_languages

--�������� ������� ����������
create table a_populations (
population_id serial primary key,
population_name varchar(50) not null unique
);

--�������� ������ � ������� ����������
insert into a_populations (population_name)
values ('�����'), ('�������'), ('������'), ('�����'), ('�������');

insert into a_populations (population_name)
values ('����������'), ('�����������'), ('��������');

insert into a_populations (population_name)
values ('����������'), ('�������');

select * from a_populations


--�������� ������� ������
create table a_country (
country_id serial primary key,
country_name varchar(50) not null unique,
);


--�������� ������ � ������� ������
insert into a_country (country_name)
values ('������'), ('��������'), ('�������'), ('������'), ('�����');

insert into a_country (country_name)
values ('���'), ('���'), ('����������'), ('������'), ('UK');


select * from a_country


--�������� ������ ������� �� �������
create table a_lang_populations (
lang_id int2 not null references a_languages(lang_id),
population_id int2 not null references a_populations(population_id),
last_update timestamp not null default now(),
primary key (lang_id, population_id)
);


--�������� ������ � ������� �� �������

insert into a_lang_populations(lang_id, population_id)
values (1, 1), (2, 2),(3,3), (4, 4), (5, 5), (8, 8), (8,9), (8, 10), (8, 11), (9, 12), (10, 12), (11, 12);

select * from a_lang_populations

--�������� ������ ������� �� �������

create table a_popul_country (
population_id int2 not null references a_populations(population_id),
country_id int2 not null references country(country_id),
last_update timestamp not null default now(),
primary key (population_id, country_id)
);

--�������� ������ � ������� �� �������

insert into a_popul_country(population_id, country_id)
values (1, 1), (2, 2),(3,3), (4, 4), (5, 5), (1, 7), (8,8), (11, 8), (10,8), (9, 9), (10, 11), (11, 11), (1, 10), (12, 2);


--======== �������������� ����� ==============


--������� �1 
--�������� ����� ������� film_new �� ���������� ������:
--�   	film_name - �������� ������ - ��� ������ varchar(255) � ����������� not null
--�   	film_year - ��� ������� ������ - ��� ������ integer, �������, ��� �������� ������ ���� ������ 0
--�   	film_rental_rate - ��������� ������ ������ - ��� ������ numeric(4,2), �������� �� ��������� 0.99
--�   	film_duration - ������������ ������ � ������� - ��� ������ integer, ����������� not null � �������, ��� �������� ������ ���� ������ 0
--���� ��������� � �������� ����, �� ����� ��������� ������� ������� ������������ ����� �����.



--������� �2 
--��������� ������� film_new ������� � ������� SQL-�������, ��� �������� ������������� ������� ������:
--�       film_name - array['The Shawshank Redemption', 'The Green Mile', 'Back to the Future', 'Forrest Gump', 'Schindlers List']
--�       film_year - array[1994, 1999, 1985, 1994, 1993]
--�       film_rental_rate - array[2.99, 0.99, 1.99, 2.99, 3.99]
--�   	  film_duration - array[142, 189, 116, 142, 195]



--������� �3
--�������� ��������� ������ ������� � ������� film_new � ������ ����������, 
--��� ��������� ������ ���� ������� ��������� �� 1.41



--������� �4
--����� � ��������� "Back to the Future" ��� ���� � ������, 
--������� ������ � ���� ������� �� ������� film_new



--������� �5
--�������� � ������� film_new ������ � ����� ������ ����� ������



--������� �6
--�������� SQL-������, ������� ������� ��� ������� �� ������� film_new, 
--� ����� ����� ����������� ������� "������������ ������ � �����", ���������� �� �������



--������� �7 
--������� ������� film_new