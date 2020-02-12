USE `example`

-- Составьте список пользователей users, которые осуществили хотя бы один заказ orders в интернет магазине.
SELECT `name` FROM `users`
WHERE `id` IN (SELECT DISTINCT `user_id` FROM `orders`)

-- Выведите список товаров products и разделов catalogs, который соответствует товару.
SELECT `products`.`name`, `catalogs`.`name` FROM `products` JOIN `catalogs`
ON `products`.`catalog_id` = `catalogs`.`id`

/* Пусть имеется таблица рейсов flights (id, from, to) и таблица городов cities (label, name).
 * Поля from, to и label содержат английские названия городов, поле name — русское.
 * Выведите список рейсов flights с русскими названиями городов. */
DROP TABLE IF EXISTS `flights`;
CREATE TABLE `flights` (
	`id` SERIAL,
	`from` VARCHAR(10),
	`to` VARCHAR(10)
);

INSERT INTO `flights`
	(`from`, `to`)
VALUES
	('moscow', 'omsk'),
	('novgorod', 'kazan'),
	('irkutsk', 'moscow'),
	('omsk', 'irkutsk'),
	('moscow', 'kazan');

DROP TABLE IF EXISTS `cities`;
CREATE TABLE `cities` (
	`label` VARCHAR(10),
	`name` VARCHAR(10)
);

INSERT INTO `cities`
	(`label`, `name`)
VALUES
	('moscow', 'Москва'),
	('novgorod', 'Новгород'),
	('irkutsk', 'Иркутск'),
	('omsk', 'Омск'),
	('kazan', 'Казань');

/* всё работает, но почему-то задваивает результат, я так и не понял, откуда у этого ноги растут. 
 * пришлось использовать DISTINCT */
SELECT DISTINCT `fst`.`name`, `snd`.`name` FROM `flights` JOIN `cities` AS `fst` JOIN `cities` AS `snd`
ON  `fst`.`label` = `flights`.`from` AND `snd`.`label` = `flights`.`to`
ORDER BY `flights`.`id`;

