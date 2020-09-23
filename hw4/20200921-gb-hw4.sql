## Task 1
-- Посмотрим на первые 10 записей в таблице users
select * from users limit 10;
-- Исправим дату обновления на текущую там, где она предшествовала дате создания
update users set updated_at = now() where created_at > updated_at;

select * from profiles limit 10;

-- создадим временную табличку с полами
create temporary table genders (name char(1));
insert into genders(name) values ('m'), ('f');

update profiles 
set gender = (
select name from genders 
order by rand() 
limit 1);

update profiles set updated_at = now() where created_at > updated_at;

-- по сообщениям предлагаю исключить возможность отправки сообщения самому себе
-- для этого в таких случаях назначаем получателю id с номером 101 - id отправителя 

update messages set to_user_id = 101 - from_user_id where from_user_id = to_user_id;

-- работаем с типами медиа
truncate media_types;
insert into media_types (name) values 
('image'),
('video'),
('audio')
;

select * from media;
update media set media_type_id = floor (1 + rand() * 3);
update media set user_id = floor(1 + rand() * 100);
update media set updated_at = now() where created_at > updated_at;

-- создаём вспомогательную табличку с расширениями файлов

create temporary table formats (name varchar(50));
insert into formats (name) values
('avi'),
('jpg'),
('mp3');

update media set filename = CONCAT(
'/',
'user_',
user_id,
'/file_',
id,
'.',
(select name from formats order by rand() limit 1)
); 

update media set size = 1000 + floor(rand() * 100000) where size < 1000;

alter table media modify column metadata JSON;
update media set metadata = concat('{"uploaded by":"', 
  (select concat(first_name, '_', last_name) from users where id = user_id),
  '"}');

-- исключаем дружбу с самим собой
update friendship set friend_id = 100 - user_id where user_id = friend_id;

update friendship set updated_at = now() where updated_at < created_at;

select * from friendship;
truncate friendship_statuses;

insert into friendship_statuses (name) values
('requested'),
('approved'),
('declined');

-- обновляем ссылки на статус дружбы
update friendship set status_id = 1 + floor(rand() * 3);


select * from communities;	
-- сокращаем количество групп
delete from communities where id > 15;

select * from communities_users;
update communities_users set community_id = 1 + floor(rand() * 15);







## Task2

/* Попробую обобщенно описать сервис стриминга музыки - Яндекс.Музыку или Spotify.
 * Тут большой простор для творчества - альбомы, плейлисты, чарты и т.д.
 */


## Task3

create table posts (
id serial, 
user_id INT, 
content varchar(500), 
created_at datetime not null default now(),
updated_at datetime default now() on update now()
);

/* Есть предположение, что для реализации постов
 * нужно брать отношение "многие ко многим", т.к.
 * один и тот же пост может быть размещён в разных группах, также как и
 * в одной группе может быть множество постов
 */

create table communities_posts (
community_id int unsigned not null,
post_id int unsigned not null,
primary key (community_id, post_id)
);

/* Для реализации лайков, мне кажется, надо добавить
 * столбец like_id во все таблицы, описывающие сущности,
 * которые можно лайкнуть в принципе: 
 * сообщения, юзеров, группы, посты, файлы и т.д.
 * При этом создать отдельную таблицу, привязывающую like_id 
 * к конкретному лайкнувшему юзеру в конкретное время
 * (насчет реализации "снятия лайка" надо отдельно подумать).
 * 
 * 
 * Таким образом, для всех таблиц кроме communities_users, media_types, 
 * communities_posts, genders выполнить команду:
 * 
 * alter table [...] add column like_id int unsigned unique;
 * 
 * и создать новую таблицу для лайков:
 */

create table likes (
id serial,
liking_user_id int unsigned not null,
created_at datetime not null default now()
);



