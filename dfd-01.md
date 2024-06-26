## Работа с Google-формой и Google-таблицей

Создайте Google-форму, которая позволит собрать информацию по тратам в нашу бухгалтерию. Каждый ответ на форму будет добавлять одну трату.

Форма должна собрать следующую информацию:

Месяц операции (выбор одного из 12-ти значений)
Название операции (строка)
Сумма (число)
Категория (выбор одного из нескольких предопределенных значений: еда, одежда, авто, другое. Определите сами, какие категории нужно добавить)

Добавьте отдельный лист в вашу google-таблицу. Скопируйте на этот лист названия операций, которые считаете регулярными (например, «утренний кофе»).
ВАЖНО! Копируйте только название операции. Копировать месяц операции, сумму и категорию не нужно.

Рядом с каждой ячейкой из полученного справочника добавьте еще один столбец со значением «ИСТИНА» («TRUE»).

В итоге должен получится справочник следующего вида:

| название операции | регулярная трата |
| утренний кофе | ИСТИНА |
| бензин | ИСТИНА |
…

Добавьте в свою основную таблицу новую колонку с названием «Регулярная трата». Заполните ее при помощи функций IFERROR, VLOOKUP по следующему правилу: Если название операции содержится в справочнике, значение в столбце должно быть ИСТИНА (TRUE), иначе — ЛОЖЬ (FALSE).

Сделайте отдельный лист для построения визуального отчета. Добавьте на него:
а) круговую диаграмму (pie chart) с затратами по категориям;
б) линейчатую диаграмму (bar chart) с затратами по месяцам;
в) глобальный фильтр (slicer), позволяющий фильтровать наши данные по признаку регулярность трат.

#### Основы статистики

Сначала доработайте свою таблицу так, чтобы в категориях по тратам было не меньше 5 трат в каждой категории.
Например: категория — «еда», трата — «400р»

Для каждой категории трат вычислите среднее значение, медианное значение и стандартное отклонение. Для этого постройте сводную таблицу, либо воспользуйтесь соответствующими формулами.

Выберите категорию трат с наиболее близкими друг к другу значениями. Можно ориентироваться на наименьшее значение стандартного отклонения из предыдущего пункта.

Сформулируйте гипотезу о размере средней траты в данной категории.

При помощи статистического критерия проверьте, соответствует ли ваше предположение фактическому значению, аналогично приведенному примеру в лекции.

Для выполнения данного задания будут полезны функции «=AVERAGE()», «=STDEV()» и «=TINV()»

Пример:

Выбрали категорию трат «обед». Выдвигаем гипотезу: «В среднем я трачу на обед 500 рублей». Хотим проверить, верно ли это утверждение. Для этого:

Формулируем нулевую гипотезу H0 (средняя трата в категории обед = 500 рублей) и альтернативную H1 (средняя трата в категории обед != 500 рублей).
Отбираем из нашей таблицы траты, которые относятся к категории «обед».
Считаем значение статистического критерия и критическое значение (в соответствии с материалом лекции).
Делаем вывод: отвергаем или нет нулевую гипотезу.

#### Продвинутая визуализация данных

В этом задании мы создадим дашборд в BI-системе, позволяющий анализировать данные нашей бухгалтерии.

Задание:

Подключите google-таблицу с домашней бухгалтерией в качестве источника данных к Google Data Studio.

Выведите следующие визуализации:
a. Общая потраченная сумма денег
b. Линейчатую гистограмму или круговую диаграмму, упорядоченную по суммарному значению трат в каждой категории
c. Столбчатую диаграмму или график, показывающую динамику трат по месяцам

Примечание: чтобы упорядочить месяцы, сделайте в Google-таблице новый столбец и в начало каждого месяца добавьте его номер. Например, 01 Январь, 02 Февраль и тд и тп. Ноль в начале нужен для месяцев, чей номер состоит из одной цифры, чтобы сортировка работала корректно.
Добавить на дашборд глобальные фильтры:
a. Месяцы трат
b. Категории трат

---

[Google-форма](https://docs.google.com/forms/d/e/1FAIpQLSelI6S_8mgSGIp7qRiGyquulbRdPtP4lLg71Gx0Ji8gSrpsMA/viewform)

[Google-таблица](https://docs.google.com/spreadsheets/d/1W7HBbZy8PUpl9fNxwKXGzhVTLPr-AKfW9agJnJ15vtg/edit#gid=2003434644)

[Google-форма.ред](https://docs.google.com/forms/d/1-NECg5ouA_stR_NZ5vHcYnbJHycksgvolNkoTKmvZ9I/edit)

[Дашборд "Детализация трат"]() (добавить ссылку)

