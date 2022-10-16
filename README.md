# Аналитик данных (dau-homeworks)

## Модуль "Аналитическое мышление" (DFD)

[Работа с Google-формой и Google-таблицами](dfd-01.md)

[Python как инструмент анализа данных](dfd-02.md)

[Откуда берутся данные](dfd-03.md)

[Машинное обучение для жизни](dfd-04.md)

[Итоговое задание DFD](dfd-05.md)

## Модуль "Метрики, гипотезы, точки роста" (AIC)

[Метрики, гипотезы, точки роста](aic.md)

## Модуль "SQL и получение данных" (SQL)

[Работа с базами данных](https://github.com/susanna-susanna/dau-homeworks/blob/main/hw-2-working%20with%20DB.sql)

[Основы SQL](HW-1-3-sql-basw.sql) 

[Углубление в SQL](HW-1-4.sql)

[Работа с PostgreSQL (часть 1)](HW-1-5.sql)

[Работа с PostgreSQL (часть 2)](HW-1-6.sql)

#### Итоговая работа "SQL и получение данных"

[Итоговая работа "SQL и получение данных". Задание](https://docs.google.com/document/d/1DD8Ev3xJUBonR3GC0ZsNSlvsSqgd4zXC3FKHvTd2k4o/edit)

[Итоговая работа "SQL и получение данных". Описание](https://docs.google.com/document/d/1tA7j6HXiHlFGj40lWbKfv8MjyaicUkFzGxo-CAROYvM/edit)

[Итоговая работа "SQL и получение данных". Запросы](summary-35-1.sql)

## BIG DATA с нуля

[Традиционные аналитические подходы](https://docs.google.com/spreadsheets/d/1oBWflhHDhQfsoTX2j5Du7Bm8-07X0OrE20Su2enAKp8/edit#gid=931770124)

На основе данных по фильмам
* Нарисовать круговую диаграмму (pie-chart) с доходами от 5-ти самых прибыльных фильмов за все время
* Получить top 5 самых продаваемых фильмов в первом магазине

[Машинное обучение и Data Science](https://colab.research.google.com/drive/1wuqUPRYzjkLOMqK8DXMn1S9inMAPQuOd?usp=sharing)

Взять датасет homework.csv

Описание датасета доступно [тут](https://www.kaggle.com/prasadperera/the-boston-housing-dataset/data)

* Предсказываем значение столбца MEDV на основе других признаков
* Решить задачу регрессии, используя алгоритм линейной регрессии
* Оценить качество регрессии при помощи метрики MSE

[Мотивация и технологии работы с большими данными](https://docs.google.com/document/d/18uFgtO0qK7fGfyDSHOda2Dg1sW6YfEBbumrediFsn5g/edit)

Проработайте модель данных (основные таблицы и их атрибуты) для ХД (схема звезды) для любого одного кейса (выбрать самостоятельно)

Результат должен содержать:

* Таблицу фактов (описание, что там лежит + столбцы)
* 3-4 таблицы измерений (описание, что там лежит + столбцы)
* Прислать в виде google-документа или ER-диаграммы с комментариями

[Мотивация и технологии работы с большими данными]()
[online терминал mongodb](https://www.mongodb.com/docs/manual/tutorial/getting-started/)

[HADOOP & SPARK](https://docs.google.com/document/d/1j36AuXR8Klassu80DvM7m6WOLTCfVuR3k0Xx9-mdDgw/edit)

* Прочитать про операторы Spark. Прислать ответы на вопросы

* Какие команды отвечают за:

-Сохранение результата в текстовый файл (Это Action или Transformation?)

-Как получить первые n-элементов массива (Это Action или Transformation?)

-Объединить два RDD в один (Это Action или Transformation?)

-В чем разница между Reduce и CoGroup-операторами (Это Action или Transformation?)

* Нарисовать DAG для Spark’а для подсчета количества уникальных слов в файле

[Практика PySpark (часть 1)](https://colab.research.google.com/drive/1mawKoUDZ4TeayejVLtG9wefJgcb0lq-w?usp=sharing#scrollTo=mc57t-wnPvuT)

Скачайте [dataset iris](https://drive.google.com/file/d/18ksAxTxBkp15LToEg46BHhwp3sPIoeUU/view?usp=sharing)

[Практика PySpark (часть 2)](https://colab.research.google.com/drive/1UDdUJJTq047vuLPNXa7SZk4_g2KB3m8E?usp=sharing)

Обучите модель классификации для цветков Iris’а

Примерная последовательность действий:
* Взять [данные](https://drive.google.com/file/d/18ksAxTxBkp15LToEg46BHhwp3sPIoeUU/view?usp=sharing)
* Загрузить в pyspark
* При помощи VectorAssembler преобразовать все колонки с признаками в одну (использовать PipeLine - опционально)
* Разбить данные на train и test
* Создать модель логистической регресии или модель дерева и обучить ее
* Воспользоваться MulticlassClassificationEvaluator для оценки качества на train и test множестве

[Культура сбора и работы с данными](https://docs.google.com/document/d/1t0fKHOxqjCfN0yZyaEUsUuOWWEs8y2b8H1HTNa4LgTQ/edit)

Возьмите свою схему хранилища данных из домашнего задания #3 и предложите 4-5 проверок на качество данных в нем.

Пример проверки:

“В справочнике ‘клиенты’ у каждого человека должен быть заполнен email-адрес. Это должен быть валидный адрес, уникальный в рамках системы”

[Организация команды для работы с данными](https://docs.google.com/document/d/1T6FrnmW563nlh7BRXPl0w9ult7jqmy5qNAnZr6JhpAo/edit#)

Вам необходимо построить модель, предсказывающую оформит ли пользователь заказ, сформированный в корзине интернет магазина.

В качестве источников данных доступно несколько систем, включая:

* Информацию по пользователям и истории их товаров
* Информацию по товарам
* Информацию по корзине
* …

Разложите данную задачу по CrispDM. Для каждого шага сформулируйте (кратко):

* Что планируете на нем делать
* Каких результатов от него ожидаете
* Какие роли специалистов Вам нужны на этом шаге
* Пример - business understanding
На этом шаге планируется выявить основную боль бизнеса. В том числе получить ответы на следующие вопросы:

Вывести метрику конверсии корзины в покупку. Определить типичные значения, проверить наличие сезонности

Определить как заказчик видит использование полученной модели, сформулировать минимально необходимое качество

Оценить ожидаемый эффект от такой модели и сравнить его с ожидаемыми трудозатратами

Для успешного выполнения данного этапа потребуется Аналитик и Владелец продукта

#### Лабораторная работа по курсу "Big Data c нуля"

Дан набор данных по оттоку клиентов. Набор данных содержит всего 5 000 записей (т.е. абонентов). Данные доступны [тут](https://drive.google.com/file/d/1ArslqEEno2hrr5tAs25P0JN0P-coLcFD/view)

Перечень полей:
* state – штат;
* account length – абонентский стаж;
* area code – код региона;
* phone number – номер телефона;
* international plan – тарифный план для международных звонков;
* voice mail plan – тарифный план для голосовой почты;
* number vmail messages – количество сообщений голосовой почты;
* total day minutes – общая длительность звонков в дневное время (мин);
* total day calls – общее количество звонков в дневное время;
* total day charge – общая стоимость звонков в дневное время;
* total eve minutes – общая длительность звонков в вечернее время (мин);
* total eve calls – общее количество звонков в вечернее время;
* total eve charge – общая стоимость звонков в вечернее время;
* total night minutes – общая длительность звонков в ночное время (мин);
* total night calls – общее количество звонков в ночное время;
* total night charge – общая стоимость звонков в ночное время;
* total intl minutes – общая длительность международных звонков (мин);
* total intl calls – общее количество международных звонков;
* total intl charge – общая стоимость международных звонков;
* number customer service calls – количество звонков в службу поддержки.
* churned – покинул ли клиент компанию

Ваша задача используя pandas или pyspark ответить на следующие вопросы:

* Построить гистограмму количества звонков в техническую поддержку
* Рассчитать и построить гистограмму общей длительности звонков клиента (дневных + ночных + вечерних + международны)
* Собственноручно (не используя встроенных функций) рассчитать линейный коэффициент корреляции (https://ru.wikipedia.org/wiki/Корреляция) общего количества минут и количества звонков в техподдержку
* Визуализировать точечный график по общему количеству минут / количеству звонков в поддержку, подкрасив точки в зависимости от оттока абонента
* Вывести top-5 самых много и самых мало говорящих клиентов
* Вывести долю оттока клиентов и среднюю стоимость минуты дневного времени разговора  в зависимости от штата
* перевести штат в one-hot формат при помощи pandas-функции get_dummies или удалите колонку, если вы делаете решение на pyspark
* Разбить данные на множество для обучения и для проверки, отобрав признаки для обучения модели классификации (убрать номер телефона, код региона, признаки планов + все добавленные аттрибуты)
* Обучить какую-нибудь модель классификации и оценить качество (точность) на отложенной выборке

[Решение Pandas.ipynb](https://colab.research.google.com/drive/15o2g9kcKqRF6VSePWGjEI7KcplGtglw_#scrollTo=lPxbwNdRxuAO)

[Решение PySpark.ipynb](https://colab.research.google.com/drive/1PKEhc2Kxle5_LbTAbsM2D2Nhf5PnbTS8#scrollTo=hyqp4QNuxP-S)

#### Итоговая работа "Big Data c нуля"

Итоговое задание доступно по [ссылке](https://docs.google.com/document/d/1lPrLC2oZNVx2BL56EpN_8LWW62NnbSWlAasLd8HruqM/edit#)

[Итоговая_1.1-1.2](https://docs.google.com/spreadsheets/d/1yOfGv5diuYRbHOYZtdlFsKmKg4yC1uWlUTXQGmKluh0/edit#gid=1746463178)

[Итоговая_1.3](https://docs.google.com/spreadsheets/d/1yz235pw0gOuI_E5A9Pxr33sIywROjFxl7_J8FKxxB8w/edit#gid=1858829225)

[ABD-16_Итог.ipynb](https://colab.research.google.com/drive/1wPxv8oOe0RMEAU1QbUIDJXHOiR1-Y0WN#scrollTo=DAl-kPHTD5QO)

[Итоговая_задание_теоретическая_часть](https://docs.google.com/document/d/1G-6zw0lG2CRhb80rAUpReL_MZazF9X1S_ouMl2W4wqQ/edit#)
