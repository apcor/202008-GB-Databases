use vk;

-- Task 1.1

/* Пусть в таблице users поля created_at и updated_at оказались незаполненными. 
 * Заполните их текущими датой и временем.
 */

-- сымитируем ситуацию, требуемую в задании

update users set created_at = NULL, updated_at = NULL;


-- заполним пустые столбцы текущей датой и временем

update users set created_at = NOW(), updated_at = NOW();


-- Task 1.2

/* Таблица users была неудачно спроектирована. 
 * Записи created_at и updated_at были заданы типом VARCHAR и 
 * в них долгое время помещались значения в формате 20.10.2017 8:10. 
 * Необходимо преобразовать поля к типу DATETIME, 
 * сохранив введённые ранее значения.
 */

-- сымитируем ситуацию, требуемую в задании

update users set created_at = NULL, updated_at = NULL;
alter table users change created_at created_at varchar(255);
alter table users change updated_at updated_at varchar(255);


update users
set
created_at = "20.10.2017 8:10",
updated_at = "22.04.2017 12:10"
WHERE 
u.id = 1;

update users
set
created_at = "04.01.2013 17:18",
updated_at = "29.05.2012 16:01"
WHERE 
u.id = 2;

# Вопрос: можно ли две одинаковые операции выше объединить в один запрос? Спасибо!

-- заменим строковые данные на формат даты
update users
set
created_at = STR_TO_DATE(created_at, '%d.%m.%Y %H:%i'),
updated_at = STR_TO_DATE(updated_at, '%d.%m.%Y %H:%i')
WHERE id in (1,2);

-- заменим формат двух столбцов

alter table users 
change 
created_at created_at datetime default now();

alter table users 
change 
updated_at updated_at datetime default now() on update now();


## Task 1.3

-- Воспроизведем таблицу из задания

create table warehouse_products (
id serial,
value bigint unsigned
);

insert into warehouse_products 
values
(NULL, 0),
(NULL, 2500),
(NULL, 0),
(NULL, 30),
(NULL, 500),
(NULL, 1);

select * from warehouse_products;

select 
id, 
value,
(select if (value > 0, 0, 1)) as flag
from warehouse_products
order by flag, value;


## Task 1.4

SELECT 
(select id from users where profiles.user_id = users.id) as id,
(select first_name from users where profiles.user_id = users.id) as first_name,
(select last_name from users where profiles.user_id = users.id) as last_name,
birthday
FROM 
profiles
where 
date_format(birthday, '%M') in ('may', 'august') 
;


## Task 2.1

-- Подсчитайте средний возраст пользователей в таблице users.

select 
round(avg(timestampdiff(year, birthday, now()))) as average_age
from profiles;


## Task 2.2

/* Подсчитайте количество дней рождения, 
 * которые приходятся на каждый из дней недели. 
 * Следует учесть, что необходимы дни недели текущего года, 
 * а не года рождения.
 */

select 
date_format(str_to_date(
CONCAT_WS('-', day(birthday), month(birthday), year(now())), '%d-%m-%Y') ,'%W') as dow2020,
count(*) as quantity
from profiles
group by dow2020;


## Task 2.3

/* Подсчитайте произведение чисел в столбце таблицы.
 */

create table multiplication (
value bigint unsigned
);

insert into multiplication 
values
(1), (2), (3), (4), (5);

-- произведение можно найти как экспонента суммы натур. логарифмов значений

SELECT 
exp(sum(log(value))) as product
from multiplication;
