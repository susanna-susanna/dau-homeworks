--=============== МОДУЛЬ 4. УГЛУБЛЕНИЕ В SQL =======================================
--= ПОМНИТЕ, ЧТО НЕОБХОДИМО УСТАНОВИТЬ ВЕРНОЕ СОЕДИНЕНИЕ И ВЫБРАТЬ СХЕМУ PUBLIC===========
SET search_path TO public;

--======== ОСНОВНАЯ ЧАСТЬ ==============

--ЗАДАНИЕ №1
--База данных: если подключение к облачной базе, то создаёте новую схему с префиксом в --виде фамилии, название должно быть на латинице в нижнем регистре и таблицы создаете --в этой новой схеме, если подключение к локальному серверу, то создаёте новую схему и --в ней создаёте таблицы.

create schema alieva_lecture_4;
set search_path to alieva_lecture_4;

--Спроектируйте базу данных, содержащую три справочника:
--· язык (английский, французский и т. п.);
--· народность (славяне, англосаксы и т. п.);
--· страны (Россия, Германия и т. п.).
--Две таблицы со связями: язык-народность и народность-страна, отношения многие ко многим. Пример таблицы со связями — film_actor.
--Требования к таблицам-справочникам:
--· наличие ограничений первичных ключей.
--· идентификатору сущности должен присваиваться автоинкрементом;
--· наименования сущностей не должны содержать null-значения, не должны допускаться --дубликаты в названиях сущностей.
--Требования к таблицам со связями:
--· наличие ограничений первичных и внешних ключей.

--В качестве ответа на задание пришлите запросы создания таблиц и запросы по --добавлению в каждую таблицу по 5 строк с данными.
 
--СОЗДАНИЕ ТАБЛИЦЫ ЯЗЫКИ
create table alieva_languages (
lang_id serial primary key,
language_name varchar(255) not null unique
);

update pg_attribute set atttypmod = 50+4
where attrelid = 'alieva_language'::regclass and attname = 'language_id';

--ВНЕСЕНИЕ ДАННЫХ В ТАБЛИЦУ ЯЗЫКИ
insert into a_languages(language_name)
values ('Арабский'), ('Болгарский'), ('Венгерский'), ('Греческий'), ('Датский');

insert into a_languages(language_name)
values ('Английский'), ('Сербский'), ('Русский'), ('Белорусский');

select * from a_languages al 

alter table a_languages rename to a_languages

--СОЗДАНИЕ ТАБЛИЦЫ НАРОДНОСТИ
create table a_populations (
population_id serial primary key,
population_name varchar(50) not null unique
);

--ВНЕСЕНИЕ ДАННЫХ В ТАБЛИЦУ НАРОДНОСТИ
insert into a_populations (population_name)
values ('Арабы'), ('Болгары'), ('Венгры'), ('Греки'), ('Датчане');

insert into a_populations (population_name)
values ('Американцы'), ('Австралийцы'), ('Шотланцы');

insert into a_populations (population_name)
values ('Англосаксы'), ('Словяне');

select * from a_populations


--СОЗДАНИЕ ТАБЛИЦЫ СТРАНЫ
create table a_country (
country_id serial primary key,
country_name varchar(50) not null unique,
);


--ВНЕСЕНИЕ ДАННЫХ В ТАБЛИЦУ СТРАНЫ
insert into a_country (country_name)
values ('Саудия'), ('Болгария'), ('Венгрия'), ('Греция'), ('Дания');

insert into a_country (country_name)
values ('ОАЭ'), ('США'), ('Автсмралия'), ('Египет'), ('UK');


select * from a_country


--СОЗДАНИЕ ПЕРВОЙ ТАБЛИЦЫ СО СВЯЗЯМИ
create table a_lang_populations (
lang_id int2 not null references a_languages(lang_id),
population_id int2 not null references a_populations(population_id),
last_update timestamp not null default now(),
primary key (lang_id, population_id)
);


--ВНЕСЕНИЕ ДАННЫХ В ТАБЛИЦУ СО СВЯЗЯМИ

insert into a_lang_populations(lang_id, population_id)
values (1, 1), (2, 2),(3,3), (4, 4), (5, 5), (8, 8), (8,9), (8, 10), (8, 11), (9, 12), (10, 12), (11, 12);

select * from a_lang_populations

--СОЗДАНИЕ ВТОРОЙ ТАБЛИЦЫ СО СВЯЗЯМИ

create table a_popul_country (
population_id int2 not null references a_populations(population_id),
country_id int2 not null references country(country_id),
last_update timestamp not null default now(),
primary key (population_id, country_id)
);

--ВНЕСЕНИЕ ДАННЫХ В ТАБЛИЦУ СО СВЯЗЯМИ

insert into a_popul_country(population_id, country_id)
values (1, 1), (2, 2),(3,3), (4, 4), (5, 5), (1, 7), (8,8), (11, 8), (10,8), (9, 9), (10, 11), (11, 11), (1, 10), (12, 2);


--======== ДОПОЛНИТЕЛЬНАЯ ЧАСТЬ ==============


--ЗАДАНИЕ №1 
--Создайте новую таблицу film_new со следующими полями:
--·   	film_name - название фильма - тип данных varchar(255) и ограничение not null
--·   	film_year - год выпуска фильма - тип данных integer, условие, что значение должно быть больше 0
--·   	film_rental_rate - стоимость аренды фильма - тип данных numeric(4,2), значение по умолчанию 0.99
--·   	film_duration - длительность фильма в минутах - тип данных integer, ограничение not null и условие, что значение должно быть больше 0
--Если работаете в облачной базе, то перед названием таблицы задайте наименование вашей схемы.



--ЗАДАНИЕ №2 
--Заполните таблицу film_new данными с помощью SQL-запроса, где колонкам соответствуют массивы данных:
--·       film_name - array['The Shawshank Redemption', 'The Green Mile', 'Back to the Future', 'Forrest Gump', 'Schindlers List']
--·       film_year - array[1994, 1999, 1985, 1994, 1993]
--·       film_rental_rate - array[2.99, 0.99, 1.99, 2.99, 3.99]
--·   	  film_duration - array[142, 189, 116, 142, 195]



--ЗАДАНИЕ №3
--Обновите стоимость аренды фильмов в таблице film_new с учетом информации, 
--что стоимость аренды всех фильмов поднялась на 1.41



--ЗАДАНИЕ №4
--Фильм с названием "Back to the Future" был снят с аренды, 
--удалите строку с этим фильмом из таблицы film_new



--ЗАДАНИЕ №5
--Добавьте в таблицу film_new запись о любом другом новом фильме



--ЗАДАНИЕ №6
--Напишите SQL-запрос, который выведет все колонки из таблицы film_new, 
--а также новую вычисляемую колонку "длительность фильма в часах", округлённую до десятых



--ЗАДАНИЕ №7 
--Удалите таблицу film_new