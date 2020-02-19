/* В базе данных shop и sample присутствуют одни и те же таблицы, учебной базы данных. 
 * Переместите запись id = 1 из таблицы shop.users в таблицу sample.users. Используйте транзакции. */

START TRANSACTION;
INSERT INTO `sample`.`users` SELECT * FROM `shop`.`users` WHERE id = 1;
COMMIT;

/* Создайте представление, которое выводит название name товарной позиции из таблицы products и 
 * соответствующее название каталога name из таблицы catalogs. */

CREATE OR REPLACE VIEW `hard` AS
SELECT `products`.`name`, `catalogs`.`name` AS `type` FROM `shop`.`products` JOIN `shop`.`catalogs`
ON `products`.`catalog_id` = `catalogs`.`id`;

/* Создайте хранимую функцию hello(), которая будет возвращать приветствие, в зависимости от текущего времени суток.
 * С 6:00 до 12:00 функция должна возвращать фразу "Доброе утро", с 12:00 до 18:00 функция должна возвращать фразу 
 * "Добрый день", с 18:00 до 00:00 — "Добрый вечер", с 00:00 до 6:00 — "Доброй ночи". */

DELIMITER //
DROP FUNCTION IF EXISTS `hello`// 
CREATE FUNCTION `hello`()
RETURNS VARCHAR(30) DETERMINISTIC
BEGIN
	SET @t := TIME(NOW());
	IF (@t BETWEEN '00:00' AND '05:59') THEN RETURN 'Доброй ночи';
	ELSEIF (@t BETWEEN'06:00' AND '11:59') THEN RETURN 'Доброе утро';
	ELSEIF (@t BETWEEN '12:00' AND '17:59') THEN RETURN 'Добрый день';
	ELSE RETURN 'Добрый вечер';
	END if;
END// 
DELIMITER ;
SELECT `hello`();

/* В таблице products есть два текстовых поля: name с названием товара и description с его описанием. 
 * Допустимо присутствие обоих полей или одно из них. Ситуация, когда оба поля принимают неопределенное 
 * значение NULL неприемлема. Используя триггеры, добейтесь того, чтобы одно из этих полей или оба поля 
 * были заполнены. При попытке присвоить полям NULL-значение необходимо отменить операцию. */

DELIMITER //
DROP TRIGGER IF EXISTS `dont_delete_all`//
CREATE TRIGGER `dont_delete_all` BEFORE UPDATE ON `products`
FOR EACH ROW 
BEGIN
	IF (ISNULL(NEW.`name`) AND ISNULL(NEW.`description`)) THEN 
	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'поля name и description не могут быть одновременно пустыми';
	END IF;
END//
DELIMITER ;
