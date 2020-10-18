## Task 1

## Определить кто больше поставил лайков (всего) - мужчины или женщины?

use vk;

SELECT 
	if (p.gender = 'f', 'female', 'male') as gender,
	count(l.created_at) as num_likes
	from likes l
    join profiles p 
	on p.user_id = l.user_id 
	group by gender 
	order by num_likes desc
	limit 1;
	

## Task 2

/* Подсчитать общее количество лайков 
 * десяти самым молодым пользователям 
 * (сколько лайков получили 10 самых молодых пользователей).
*/


SELECT 
'10 youngest received',
sum(likes_qty) as lsum from 
	(SELECT 
		p.user_id as youngest_ids,
		count(l.created_at) as likes_qty
	from profiles p
	left join likes l
		on p.user_id = l.target_id and l.target_type_id = 2
		group by youngest_ids
		order by p.birthday DESC 
		limit 10) as tbl
;



## Task 3

/* Найти 10 пользователей, которые проявляют наименьшую активность 
 * в использовании социальной сети
 * (критерии активности необходимо определить самостоятельно).
*/

select * from posts;

select * from users;

select 
	u.id,  
	concat_ws(' ', u.first_name, u.last_name) as user_name,
	count(distinct m.from_user_id) as num_messages,
	count(distinct l.user_id) as num_likes,
	count(distinct p.user_id) as num_posts
	-- 0.5*num_messages+0.2*num_posts+0.3*num_likes as overall_activity
from users u
	left join messages m 
on m.from_user_id = u.id
	left join likes l 
on l.user_id = u.id
	left join posts p 
on p.user_id = u.id
	group by u.id
	order by 0.5 * num_messages + 0.2 * num_posts + 0.3 * num_likes, u.id
	limit 10;
