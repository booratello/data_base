-- ii. Написать скрипт, возвращающий список имен (только firstname) пользователей без повторений в алфавитном порядке
SELECT distinct firstname
FROM users
ORDER BY firstname ASC;
-- iii. Написать скрипт, отмечающий несовершеннолетних пользователей как неактивных (поле is_active = false). Предварительно добавить такое поле в таблицу profiles со значением по умолчанию = true (или 1)
UPDATE profiles
SET
	is_active = 'false'
WHERE 
	(TIMESTAMPDIFF(YEAR, birthday, CURDATE())) < 18
-- iv. Написать скрипт, удаляющий сообщения «из будущего» (дата позже сегодняшней)
DELETE
FROM messages 
WHERE
	(NOW() - created_at) < 0
