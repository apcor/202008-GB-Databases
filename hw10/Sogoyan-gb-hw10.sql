/* Задание 1.
 * Проанализировать какие запросы могут выполняться наиболее часто 
в процессе работы приложения и добавить необходимые индексы.
 */

CREATE UNIQUE INDEX users_email_uq ON users(email);

CREATE INDEX messages_created_at_idx ON messages(created_at);

CREATE INDEX media_updated_at_idx ON media(updated_at);

CREATE INDEX posts_updated_at_idx ON posts(updated_at);

 
CREATE INDEX likes_target_id_idx
  ON likes (target_id);

CREATE INDEX media_filename_idx
  ON media (filename);

CREATE INDEX posts_head_idx
  ON posts (head);

CREATE INDEX profiles_birthday_idx
  ON profiles (birthday);
 
CREATE INDEX users_first_name_last_name_idx
  ON users (first_name, last_name);
  
 
/* Задание 2.
 * Построить запрос, который будет выводить следующие столбцы:
имя группы
среднее количество пользователей в группах
самый молодой пользователь в группе
самый старший пользователь в группе
общее количество пользователей в группе
всего пользователей в системе
отношение в процентах (общее количество пользователей в группе / 
всего пользователей в системе) * 100
 */
 		
SELECT DISTINCT 
  c.name,
  COUNT(cu.user_id) OVER () /(SELECT COUNT(c2.id) FROM communities c2) AS avg_users_in_groups,
  MIN(p.birthday) OVER w AS youngest,
  MAX(p.birthday) OVER w AS oldest,
  COUNT(cu.user_id ) OVER w AS users_count,
  (SELECT COUNT(*) FROM users) AS total_users,
  COUNT(cu.user_id ) OVER w / (SELECT COUNT(*) FROM users) * 100 AS '% ratio'
FROM 
  communities_users cu
    RIGHT JOIN communities c
      ON cu.community_id = c.id 
    LEFT JOIN profiles p
      ON cu.user_id = p.user_id
      WINDOW w AS (PARTITION BY cu.community_id)
      ORDER BY users_count;