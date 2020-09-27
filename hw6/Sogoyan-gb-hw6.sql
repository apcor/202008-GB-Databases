## Task 1

## Создать и заполнить таблицы лайков и постов.

-- Таблица лайков
DROP TABLE IF EXISTS likes;
CREATE TABLE likes (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  user_id INT UNSIGNED NOT NULL,
  target_id INT UNSIGNED NOT NULL,
  target_type_id INT UNSIGNED NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Таблица типов лайков
DROP TABLE IF EXISTS target_types;
CREATE TABLE target_types (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) NOT NULL UNIQUE,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO target_types (name) VALUES 
  ('messages'),
  ('users'),
  ('media'),
  ('posts');
  
-- заполним таблицу лайков
 INSERT INTO likes 
  SELECT 
    id, 
    FLOOR(1 + (RAND() * 100)), 
    FLOOR(1 + (RAND() * 100)),
    FLOOR(1 + (RAND() * 4)),
    CURRENT_TIMESTAMP 
  FROM messages;
 
-- Создадим таблицу постов
DROP table if exists posts;
 CREATE TABLE posts (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  user_id INT UNSIGNED NOT NULL,
  community_id INT UNSIGNED,
  head VARCHAR(255),
  body TEXT NOT NULL,
  media_id INT UNSIGNED,
  is_public BOOLEAN DEFAULT TRUE,
  is_archived BOOLEAN DEFAULT FALSE,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Заполним таблицу постов
INSERT INTO posts
  SELECT 
    id, 
    FLOOR(1 + (RAND() * 100)), 
    FLOOR(1 + (RAND() * 15)),
    CONCAT_WS('_', 'header', id),
    substring(MD5(RAND()),1,20), -- нашёл в интернете способ генерации случ.строки
    FLOOR(1 + (RAND() * 100)),
    ROUND(RAND()),
    ROUND(RAND()),
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP 
  FROM messages;


 
 ## Task2
 
 ## Создать все необходимые внешние ключи и диаграмму отношений.
 
 -- в таблицу profiles:
 ALTER TABLE profiles
  ADD CONSTRAINT profiles_user_id_fk 
    FOREIGN KEY (user_id) REFERENCES users(id)
      ON DELETE CASCADE,
  ADD CONSTRAINT profiles_photo_id_fk
    FOREIGN KEY (photo_id) REFERENCES media(id)
      ON DELETE SET NULL;
      
-- в таблицу friendship:

alter table friendship 
	add constraint friendship_user_id_fk
		foreign key (user_id) references users(id)
			on delete cascade,
	add constraint friendship_friend_id_fk
		foreign key (friend_id) references users(id)
			on delete cascade,
	add constraint friendship_status_id_fk
		foreign key (status_id) references friendship_statuses(id)
			on delete restrict; 

-- в таблицу messages:
		
alter table messages 
	add constraint messages_from_user_id_fk
		foreign key (from_user_id) references users(id)
			on delete no action,
	add constraint messages_to_user_id_fk
		foreign key (to_user_id) references users(id)
			on delete no action;
			
-- в таблицу media:

alter table media 
	add constraint media_user_id_fk
		foreign key (user_id) references users(id)
			on delete no action,
	add constraint media_media_type_id_fk
		foreign key (media_type_id) references media_types(id)
			on delete no action;

-- в таблицу posts:

alter table posts 
	add constraint posts_user_id_fk
		foreign key (user_id) references users(id)
			on delete restrict,
	add constraint posts_community_id_fk
		foreign key (community_id) references communities(id)
			on delete cascade,
	add constraint posts_media_id_fk
		foreign key (media_id) references media(id)
			on delete set NULL;

-- в таблицу likes:
		
select * from likes ;
desc likes ;

alter table likes 
	add constraint likes_user_id_fk
		foreign key (user_id) references users(id)
			on delete cascade,
	add constraint likes_target_type_id_fk
		foreign key (target_type_id) references target_types(id)
			on delete no action;
		
-- Диаграмма отношений в приложенном файле ER Diagram.png


		
## Task 3

## Определить кто больше поставил лайков (всего) - мужчины или женщины?

-- 1 вариант (как два столбца)
select
	(select
	count(*) from likes 
	where user_id in 
		(SELECT user_id from profiles where gender = 'f')
		) as women_likes_number,
	(select
	count(*) from likes 
	where user_id in 
		(SELECT user_id from profiles where gender = 'm')
		) as men_likes_number;

-- 2 вариант (только 1 строка)	
select
	(select gender from profiles
	where profiles.user_id = likes.user_id) as gender_likes,
	count(*) as likes_quantity
from likes
group by gender_likes
order by likes_quantity desc
limit 1
;


## Task 4

/* Подсчитать общее количество лайков 
 * десяти самым молодым пользователям 
 * (сколько лайков получили 10 самых молодых пользователей).
*/

SELECT 
count(*) as likes_quantity
from likes where target_type_id = 2 and target_id IN 
	(select * from 
		(select user_id from profiles
		order by (select timestampdiff(day, birthday, now()))
		limit 10) as youngest_users_sorted);	


## Task 5

/* Найти 10 пользователей, которые проявляют наименьшую активность 
 * в использовании социальной сети
 * (критерии активности необходимо определить самостоятельно).
*/
	
select 
	id,  
	concat_ws(' ', first_name, last_name) as user_name,
	0.5 * (select count(*) from messages where messages.from_user_id = users.id) +
	0.3 * (select count(*) from likes where likes.user_id = users.id) +
	0.2 * (select count(*) from posts where posts.user_id = users.id) as activity_level 
from users
order by activity_level 
limit 10;

