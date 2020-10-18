/*
Транзакции, переменные, представления
Задание 1

В базе данных shop и sample присутствуют одни и те же таблицы
 учебной базы данных. Переместите запись id = 1 из
 таблицы shop.users в таблицу sample.users. Используйте транзакции.
*/

-- Для начала создал sample - копию без данных БД shop - с помощью mysqldump --no-data

start transaction;
insert into sample.users
select * from shop.users where id = 1;
delete from shop.users where id =1 limit 1;
commit;


/*
Задание 2

Создайте представление, которое выводит
название name товарной позиции из таблицы products и
соответствующее название каталога name из таблицы catalogs.
*/

create or replace view prcat as
select p.name as p_name, c.name as c_name from products p
left join catalogs c
on c.id = p.catalog_id
;

select * from prcat;




/*
Задание 3

(по желанию) Пусть имеется таблица с календарным полем created_at.
В ней размещены разряженые календарные записи за август 2018 года
'2018-08-01', '2016-08-04', '2018-08-16' и 2018-08-17.
Составьте запрос, который выводит полный список дат за август,
выставляя в соседнем поле значение 1, если дата присутствует
в исходном таблице и 0, если она отсутствует.
*/


-- Создадим такую таблицу
drop table if exists dates;
create table dates(
id serial,
days date
)
;

insert into dates(days)
values
('2018-08-01'),
('2018-08-04'),
('2018-08-16'),
('2018-08-17');

-- создадим таблицу со всеми днями августа 2018 года

drop table if exists aug_dates;
create table aug_dates (
aug_date date not null
);

insert into aug_dates(aug_date)
values ('2018-08-01'), ('2018-08-02'), ('2018-08-03'), ('2018-08-04'),
    ('2018-08-05'), ('2018-08-06'), ('2018-08-07'), ('2018-08-08'),
    ('2018-08-09'), ('2018-08-10'), ('2018-08-11'), ('2018-08-12'),
    ('2018-08-13'), ('2018-08-14'), ('2018-08-15'), ('2018-08-16'),
    ('2018-08-17'), ('2018-08-18'), ('2018-08-19'), ('2018-08-20'),
    ('2018-08-21'), ('2018-08-22'), ('2018-08-23'), ('2018-08-24'),
    ('2018-08-25'), ('2018-08-26'), ('2018-08-27'), ('2018-08-28'),
    ('2018-08-29'), ('2018-08-30'), ('2018-08-31');

-- создаём представление, требуемое в задании

create or replace view aug_posts as
select
a.aug_date as dates_of_august,
not isnull(d.days) as exist
from aug_dates a
left join
shop.dates d
on a.aug_date = d.days
order by a.aug_date;

select * from aug_posts;



/*
Задание 4

(по желанию) Пусть имеется любая таблица с календарным полем created_at.
Создайте запрос, который удаляет устаревшие записи из таблицы,
оставляя только 5 самых свежих записей.
*/

-- Будем использовать таблицу aug_dates из предыдущего задания. Составим транзакцию

start transaction;
delete aug_dates
from aug_dates
join (select * from aug_dates order by aug_date desc limit 5, 1) as tmp_ad
on aug_dates.aug_date <= tmp_ad.aug_date;
commit;

/*
Хранимые процедуры и функции, триггеры
Задание 1

Создайте хранимую функцию hello(), которая будет возвращать приветствие, 
в зависимости от текущего времени суток. 
С 6:00 до 12:00 функция должна возвращать фразу "Доброе утро", 
с 12:00 до 18:00 функция должна возвращать фразу "Добрый день", 
с 18:00 до 00:00 — "Добрый вечер", 
с 00:00 до 6:00 — "Доброй ночи".
*/

DROP PROCEDURE IF EXISTS hello;
delimiter //
CREATE PROCEDURE hello()
BEGIN
  IF(CURTIME() BETWEEN "06:00:00" AND "12:00:00") THEN
    SELECT "Доброе утро";
  ELSEIF(CURTIME() BETWEEN "12:00:00" AND "18:00:00") THEN
    SELECT "Добрый день";
  ELSEIF(CURTIME() BETWEEN "18:00:00" AND "23:59:59") THEN
    SELECT "Добрый вечер";
  ELSE
    SELECT "Доброй ночи";
  END IF;
END //
delimiter ;

CALL hello();


/*
Задание 2

В таблице products есть два текстовых поля: 
name с названием товара и description с его описанием. 
Допустимо присутствие обоих полей или одно из них. 
Ситуация, когда оба поля принимают неопределенное значение NULL неприемлема. 
Используя триггеры, добейтесь того, чтобы одно из этих полей 
или оба поля были заполнены. 
При попытке присвоить полям NULL-значение необходимо отменить операцию.
*/

DROP TRIGGER IF EXISTS NameDescNullTrigger;
delimiter //
CREATE TRIGGER NameDescNullTrigger BEFORE INSERT ON products
FOR EACH ROW
BEGIN
  IF(ISNULL(NEW.name) AND ISNULL(NEW.description)) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Trigger Warning! NULL in both fields!';
  END IF;
END //
delimiter ;

INSERT INTO products (name, description, price, catalog_id)
VALUES (NULL, NULL, 5000, 2); 
-- ошибка
