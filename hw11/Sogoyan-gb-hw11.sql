/* Задание 1.
 * 
 * Создайте таблицу logs типа Archive. 
 * Пусть при каждом создании записи в таблицах users, catalogs и products 
 * в таблицу logs помещается время и дата создания записи, 
 * название таблицы, идентификатор первичного ключа и содержимое поля name.
 */


-- Создаем таблицу для хранения логов типа Archive
DROP TABLE IF EXISTS logs;
CREATE TABLE logs (
  id serial,
  created_at DATETIME COMMENT 'Время и дата создания записи' default current_timestamp,
  table_name VARCHAR(255) COMMENT 'Название таблицы',
  id_record VARCHAR(255) COMMENT 'Идентификатор записи таблицы',
  name VARCHAR(255) COMMENT 'Название записи'
) COMMENT = 'Таблица логов' ENGINE=Archive;

-- Создание триггеров в таблицах после создания записей в них

delimiter //
drop trigger if exists log_users_ins//
create trigger log_users_ins after insert on users
for each row
begin 
	insert into logs(table_name, id_record, name)
	values ('users', new.id, new.name);
end//

delimiter //
drop trigger if exists log_catalogs_ins//
create trigger log_catalogs_ins after insert on catalogs
for each row
begin 
	insert into logs(table_name, id_record, name)
	values ('catalogs', new.id, new.name);
end//


delimiter //
drop trigger if exists log_products_ins//
create trigger log_products_ins after insert on products
for each row
begin 
	insert into logs(table_name, id_record, name)
	values ('products', new.id, new.name);
end//



/*Задание 2.
 * 
 *(по желанию) Создайте SQL-запрос, который помещает в таблицу users миллион записей.
 */


delimiter //
drop procedure if exists fill_db//
create procedure fill_db( in num int )
begin
	declare i int default 0;
		
	while i <= num do
		insert into users (name, birthday_at) values ('DUMMY USER', now() );
		set i = i + 1;
	end while;
end//

call fill_db(1000000);


-- Тему NoSQL изучу отдельно, не успел толком разобраться