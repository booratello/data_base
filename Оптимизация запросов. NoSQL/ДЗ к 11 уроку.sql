/* Создайте таблицу logs типа Archive. Пусть при каждом создании записи в таблицах 
 * users, catalogs и products в таблицу logs помещается время и дата создания записи, 
 * название таблицы, идентификатор первичного ключа и содержимое поля name. */

DROP TABLE IF EXISTS `logs`;
CREATE TABLE `logs` (
	`table` VARCHAR(10),
	`primary_key` BIGINT UNSIGNED,
	`name`VARCHAR(255),
	`created_at` DATETIME	
) ENGINE=Archive; 

DELIMITER //
DROP TRIGGER IF EXISTS `users_to_logs`//
CREATE TRIGGER `users_to_logs` AFTER INSERT ON `users`
FOR EACH ROW 
BEGIN
	INSERT INTO `logs` VALUES ('users', NEW.id, NEW.name, NOW());
END//

DROP TRIGGER IF EXISTS `catalogs_to_logs`//
CREATE TRIGGER `catalogs_to_logs` AFTER INSERT ON `catalogs`
FOR EACH ROW 
BEGIN
	INSERT INTO `logs` VALUES ('catalogs', NEW.id, NEW.name, NOW());
END//

DROP TRIGGER IF EXISTS `products_to_logs`//
CREATE TRIGGER `products_to_logs` AFTER INSERT ON `products`
FOR EACH ROW 
BEGIN
	INSERT INTO `logs` VALUES ('products', NEW.id, NEW.name, NOW());
END//
DELIMITER ;

/*Создайте SQL-запрос, который помещает в таблицу users миллион записей.*/
DELIMITER //
CREATE PROCEDURE insert_million_users (IN iteration INT)
BEGIN
	DECLARE i INT DEFAULT 0;
	WHILE i < iteration DO
		INSERT INTO `users` (`name`) VALUES ((SELECT LEFT(UUID(), 10))); -- способ генерации рандомного имени позаимствовал в интернете
		SET i = i + 1;
	END WHILE;
END//
DELIMITER ;

CALL insert_million_users(1000000);