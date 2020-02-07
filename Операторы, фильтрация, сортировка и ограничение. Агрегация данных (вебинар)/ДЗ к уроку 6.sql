/* Пусть задан некоторый пользователь. Из всех друзей этого пользователя 
 * найдите человека, который больше всех общался с нашим пользователем. 
 * 
 * Сначала делал через UNION на UNION'е, но так группировка отказывалась работать.
 * Сделал вариант вообще без них. Хотел применить функцию MAX - не вышло.
 * Поэтому сортировка по убыванию кол-ва сообщений от пользователя и вывод 1 строки. */

SELECT COUNT(*) AS `total_from_user`,
	CASE
         WHEN `from_user_id` = 1 THEN `to_user_id`
         WHEN `to_user_id` = 1 THEN `from_user_id`
    END AS `friends_msg`
FROM 
	`messages`
WHERE 
	(`from_user_id` IN 
		(
		SELECT 
			CASE
         		WHEN `target_user_id` = 1 THEN `initiator_user_id`
         		WHEN `initiator_user_id` = 1 THEN `target_user_id`
    		END AS `friends`
		FROM 
			`friend_requests`
		WHERE 
			(`target_user_id` = 1 OR `initiator_user_id` = 1) 
			AND `status` = 'approved'
		) 
		AND `to_user_id` = 1
	) 
	OR 
	(`to_user_id` IN 
		(
		SELECT 
			CASE
		         WHEN `target_user_id` = 1 THEN `initiator_user_id`
		         WHEN `initiator_user_id` = 1 THEN `target_user_id`
		    END AS `friends`
		FROM 
			`friend_requests`
		WHERE 
			(`target_user_id` = 1 OR `initiator_user_id` = 1) 
			AND `status` = 'approved'
		) 
		AND `from_user_id` = 1
	) 
GROUP BY `friends_msg` 
ORDER BY `total_from_user` DESC
LIMIT 1;


-- Подсчитать общее количество лайков, которые получили пользователи младше 10 лет.

SELECT 
	COUNT(*) as `likes_for_younger_10`
FROM
	`likes`
WHERE
	`media_id` IN (
		SELECT 
			`id`
		FROM 
			`media` 
		WHERE 
			`user_id` IN (
				SELECT 
					`user_id` 
				FROM 
					`profiles` 
				WHERE 
					TIMESTAMPDIFF(YEAR, `birthday`, NOW()) < 10
						)
					); 

			
-- Определить кто больше поставил лайков (всего) - мужчины или женщины?

SELECT
	CASE (`gender`)
         WHEN 'm' THEN 'male'
         WHEN 'f' THEN 'female'
    END AS `gender`,
    COUNT(*) AS `total_likes`
FROM
	`profiles`
WHERE 
	`user_id` IN(
		SELECT
			`user_id`
		FROM
			`likes`
				) 
GROUP BY `gender`
ORDER BY `total_likes` DESC;
