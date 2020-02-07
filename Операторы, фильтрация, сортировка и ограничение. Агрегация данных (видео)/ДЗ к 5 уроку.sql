-- Практическое задание по теме “Операторы, фильтрация, сортировка и ограничение”

/* Задание 1. Пусть в таблице users поля created_at и updated_at 
 * оказались незаполненными. Заполните их текущими датой и временем. */

UPDATE `users` SET `created_at` = NOW(), `updated_at` = NOW();

/* Задание 2. Таблица users была неудачно спроектирована. 
 * Записи created_at и updated_at были заданы типом VARCHAR и в них 
 * долгое время помещались значения в формате "20.10.2017 8:10". 
 * Необходимо преобразовать поля к типу DATETIME, сохранив введеные ранее значения. */

DROP TABLE IF EXISTS users;
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Имя покупателя',
  birthday_at DATE COMMENT 'Дата рождения',
  created_at VARCHAR(20),
  updated_at VARCHAR(20)
) COMMENT = 'Покупатели';

INSERT INTO users (`name`, `birthday_at`, `created_at`, `updated_at`) VALUES
  ('Геннадий', '1990-10-05', '02.02.2020 20:02', '03.02.2020 20:02'),
  ('Наталья', '1984-11-12', '30.01.2020 18:13', '01.02.2020 16:30'),
  ('Александр', '1985-05-20', '31.12.2019 23:59', '01.01.2020 00:00'),
  ('Сергей', '1988-02-14', '27.04.2009 23:59', '15.01.2020 23:16'),
  ('Иван', '1998-01-12', '30.07.2012 15:16', '04.02.2020 23:37'),
  ('Мария', '1992-08-29', '30.09.2016 13:02', '13.12.2019 12:12');

/* UPDATE `users` SET `created_at` = DATE_FORMAT(STR_TO_DATE(`created_at`, "%d.%m.%Y %H:%i"), "%d.%m.%Y %H:%i") 
 * позволяет сохранить дату в изначальном виде, но преобразовать тип столбца в этом случае не выходит */
UPDATE `users` SET `created_at` = STR_TO_DATE(`created_at`, "%d.%m.%Y %H:%i");
ALTER TABLE `users` MODIFY `created_at` DATETIME;
UPDATE `users` SET `updated_at` = STR_TO_DATE(`updated_at`, "%d.%m.%Y %H:%i");
ALTER TABLE `users` MODIFY `updated_at` DATETIME;

/* Задание 3. В таблице складских запасов storehouses_products в поле value могут 
 * встречаться самые разные цифры: 0, если товар закончился и выше нуля, если на 
 * складе имеются запасы. Необходимо отсортировать записи таким образом, чтобы они 
 * выводились в порядке увеличения значения value. Однако, нулевые запасы должны 
 * выводиться в конце, после всех записей. 
 *
 * не посетила меня светлая мысль, как быстро заполнить N-десят строк без повторения выражения. 
 * можно было воспользоваться сайтом, но тогда были бы неменяющиеся значения. */

INSERT INTO `storehouses_products`(`value`)
VALUES (FLOOR((RAND() * 10))), (FLOOR((RAND() * 10))), (FLOOR((RAND() * 10))), (FLOOR((RAND() * 10))), (FLOOR((RAND() * 10))),
	   (FLOOR((RAND() * 10))), (FLOOR((RAND() * 10))), (FLOOR((RAND() * 10))), (FLOOR((RAND() * 10))), (FLOOR((RAND() * 10))),
	   (FLOOR((RAND() * 10))), (FLOOR((RAND() * 10))), (FLOOR((RAND() * 10))), (FLOOR((RAND() * 10))), (FLOOR((RAND() * 10))),
	   (FLOOR((RAND() * 10))), (FLOOR((RAND() * 10))), (FLOOR((RAND() * 10))), (FLOOR((RAND() * 10))), (FLOOR((RAND() * 10))),
	   (FLOOR((RAND() * 10))), (FLOOR((RAND() * 10))), (FLOOR((RAND() * 10))), (FLOOR((RAND() * 10))), (FLOOR((RAND() * 10))),
	   (FLOOR((RAND() * 10))), (FLOOR((RAND() * 10))), (FLOOR((RAND() * 10))), (FLOOR((RAND() * 10))), (FLOOR((RAND() * 10))),
	   (FLOOR((RAND() * 10))), (FLOOR((RAND() * 10))), (FLOOR((RAND() * 10))), (FLOOR((RAND() * 10))), (FLOOR((RAND() * 10))),
	   (FLOOR((RAND() * 10))), (FLOOR((RAND() * 10))), (FLOOR((RAND() * 10))), (FLOOR((RAND() * 10))), (FLOOR((RAND() * 10))),
	   (FLOOR((RAND() * 10))), (FLOOR((RAND() * 10))), (FLOOR((RAND() * 10))), (FLOOR((RAND() * 10))), (FLOOR((RAND() * 10))),
	   (FLOOR((RAND() * 10))), (FLOOR((RAND() * 10))), (FLOOR((RAND() * 10))), (FLOOR((RAND() * 10))), (FLOOR((RAND() * 10))); 

-- не я догадался, кто-то на форумах хабра уже интересовался именно этой задачей. я немного со скрипом, но вроде понял.
SELECT * FROM `storehouses_products`
  ORDER BY CASE WHEN `value` = 0 THEN 11 ELSE `value` END;
  
 /* Задание 4.  Из таблицы users необходимо извлечь пользователей, родившихся в августе и мае. 
  * Месяцы заданы в виде списка английских названий ('may', 'august') */
 
SELECT `name` FROM `users` WHERE MONTHNAME(`birthday_at`) IN ('may', 'august');
  
 /* Задание 5. Из таблицы catalogs извлекаются записи при помощи запроса. 
  * SELECT * FROM catalogs WHERE id IN (5, 1, 2); 
  * Отсортируйте записи в порядке, заданном в списке IN. */

SELECT * FROM `catalogs` WHERE `id` IN (5, 1, 2)
ORDER BY CASE WHEN `id` = 5 THEN 0 ELSE `id` END;

-- Практическое задание теме “Агрегация данных”
  
 /* Задание 1. Подсчитайте средний возраст пользователей в таблице users */

SELECT ROUND(AVG(TIMESTAMPDIFF(YEAR, `birthday_at`, CURDATE()))) AS `avg_age` FROM `users`;

 /* Задание 2. Подсчитайте количество дней рождения, которые приходятся на каждый из дней недели. 
  * Следует учесть, что необходимы дни недели текущего года, а не года рождения. */

INSERT INTO `users` (`name`, `birthday_at`) VALUES
  ('Глеб', '1991-07-30'),
  ('Вероника', '1990-11-08'),
  ('Александр', '1991-02-24'),
  ('Елена', '1990-09-18');

SELECT
	COUNT(*) AS `total`,
	DAYNAME(CONCAT(YEAR(NOW()), SUBSTRING(`birthday_at`, 5, 6))) AS `birtday_this_year`
FROM `users`
GROUP BY `birtday_this_year`;

 /* Задание 3. Подсчитайте произведение чисел в столбце таблицы 
  * 
  * и снова спасибо интернету, об этих свойствах экспоненты/натуральнго логарифма я уже давно забыл*/

DROP TABLE IF EXISTS `some_tbl`;
CREATE TABLE `some_tbl` (
	`value` INT
);

INSERT INTO `some_tbl` (`value`)
VALUES (1), (2), (3), (4), (5);

SELECT exp(SUM(log(`value`))) AS `multiplication` FROM `some_tbl`;
