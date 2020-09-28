## Task 1

/*Составьте список пользователей users, 
 * которые осуществили хотя бы один заказ orders в интернет магазине. 
 */

use shop;

/* в таблице users у меня уже есть 6 строчек, 
поэтому создадим некоторым из них заказы в таблице orders*/

insert into orders (user_id)
values
(1),
(5),
(2),
(1);

-- далее запрос, требуемый в задании
select * from orders;

select
		u.id, 
		u.name,
		count(o.id) as 'qty'
from users u
right join orders o
on o.user_id = u.id
group by u.id;


## Task 2

/* Выведите список товаров products и разделов catalogs, 
который соответствует товару. */

select
	p.name as product_name,
	c.name as catalog_name
	from products p
join catalogs c
	on p.catalog_id = c.id; 


## Task 3

/* Пусть имеется таблица рейсов flights (id, from, to) 
 * и таблица городов cities (label, name). 
 * Поля from, to и label содержат английские названия городов, 
 * поле name — русское. Выведите список рейсов flights 
 * с русскими названиями городов.
 */

drop table if exists flights;
create table flights (
	id serial primary key,
	`from` varchar(255),
	`to` varchar(255)
);

insert into flights (`from`, `to`)
values
	('moscow', 'omsk'),
	('novgorod', 'kazan'),
	('irkutsk', 'moscow'),
	('omsk', 'irkutsk'),
	('moscow', 'kazan');

drop table if exists cities;
create table cities (
	`label` varchar(255),
	`name` varchar(255)
);

insert into cities (`label`, `name`)
values
	('moscow', 'Москва'),
	('irkutsk', 'Иркутск'),
	('novgorod', 'Новгород'),
	('kazan', 'Казань'),
	('omsk', 'Омск');

-- запрос, требуемый в задании

select
	f.id as id,
	from_rus.name as `from`,
	to_rus.name as `to`
from cities as from_rus
join
cities as to_rus 
join 
flights as f
on 
f.from = from_rus.label AND
f.to = to_rus.label
order by f.id;

