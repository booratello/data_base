DROP DATABASE IF EXISTS `space_rangers`;
CREATE DATABASE `space_rangers`;
USE `space_rangers`;

/* Т.к. большая часть данных запрашивается/подтягивается по полю 'id', являющееся PRIMARY KEY,
 * а сама БД небольшая, я решил не добавлять дополнительные индексы.*/

DROP TABLE IF EXISTS `races`;
CREATE TABLE `races` (
	`id` SERIAL PRIMARY KEY,
	`name` VARCHAR(10),
	`description` TEXT
);
			
DROP TABLE IF EXISTS `corpus`;
CREATE TABLE `corpus` (
	`id` SERIAL PRIMARY KEY,
	`tech_lvl` CHAR(1),
	`name` VARCHAR(30),
	`armor` INT
);

DROP TABLE IF EXISTS `engine`;
CREATE TABLE `engine` (
	`id` SERIAL PRIMARY KEY,
	`tech_lvl` CHAR(1),
	`name` VARCHAR(30),
	`speed` INT,
	`jump_range` INT
);

DROP TABLE IF EXISTS `fuel_tank`;
CREATE TABLE `fuel_tank` (
	`id` SERIAL PRIMARY KEY,
	`tech_lvl` CHAR(1),
	`name` VARCHAR(30),
	`base_volume` INT
);

DROP TABLE IF EXISTS `radar`;
CREATE TABLE `radar` (
	`id` SERIAL PRIMARY KEY,
	`tech_lvl` CHAR(1),
	`name` VARCHAR(30),
	`range` INT
);
	
DROP TABLE IF EXISTS `scanner`;
CREATE TABLE `scanner` (
	`id` SERIAL PRIMARY KEY,
	`tech_lvl` CHAR(1),
	`name` VARCHAR(30),
	`power` INT
);

DROP TABLE IF EXISTS `repair_droid`;
CREATE TABLE `repair_droid` (
	`id` SERIAL PRIMARY KEY,
	`tech_lvl` CHAR(1),
	`name` VARCHAR(30),
	`repair_volume` INT
);

DROP TABLE IF EXISTS `cargo_attractor`;
CREATE TABLE `cargo_attractor` (
	`id` SERIAL PRIMARY KEY,
	`tech_lvl` CHAR(1),
	`name` VARCHAR(30),
	`payload` INT
);
	
DROP TABLE IF EXISTS `protective_field_generator`;
CREATE TABLE `protective_field_generator` (
	`id` SERIAL PRIMARY KEY,
	`tech_lvl` CHAR(1),
	`name` VARCHAR(30),
	`power` INT
);

CREATE OR REPLACE VIEW `equipment_info` AS
SELECT `corpus`.`id` AS `id`,
	`corpus`.`tech_lvl` AS `Технический уровень`,
	`corpus`.`name` AS `Виды корпусов`,
	`corpus`.`armor` AS `Броня`,
	`engine`.`name` AS `Виды двигателей`,
	`engine`.`speed` AS `Скорость`,
	`engine`.`jump_range` AS `Дальность прыжка`,
	`fuel_tank`.`name` AS `Виды баков`,
	`fuel_tank`.`base_volume` AS `Базовый объём`,
	`radar`.`name` AS `Виды радаров`,
	`radar`.`range` AS `Дистанция радара`,
	`scanner`.`name` AS `Виды сканеров`,
	`scanner`.`power` AS `Мощьность сканера`,
	`repair_droid`.`name` AS `Виды ремонтных дроидов`,
	`repair_droid`.`repair_volume` AS `Ремонтируемый объём`,
	`cargo_attractor`.`name` AS `Виды захватов`,
	`cargo_attractor`.`payload` AS `Мощность захвата`,
	`protective_field_generator`.`name` AS `Виды генераторов защитного поля`,
	`protective_field_generator`.`power` AS `Мощность генератора защитного поля`
FROM `corpus` JOIN `engine` JOIN `fuel_tank` JOIN `radar` JOIN `scanner` JOIN `repair_droid` JOIN `cargo_attractor` JOIN `protective_field_generator`
ON `corpus`.`id` = `engine`.`id` AND `corpus`.`id` = `fuel_tank`.`id` AND `corpus`.`id`+1 = `radar`.`id` AND `corpus`.`id`+1 = `scanner`.`id` AND
	`corpus`.`id`+1 = `repair_droid`.`id` AND `corpus`.`id`+1 = `cargo_attractor`.`id` AND `corpus`.`id`+1 = `protective_field_generator`.`id`;

DROP TABLE IF EXISTS `weapon`;
CREATE TABLE `weapon` (
	`id` SERIAL PRIMARY KEY,
	`name` VARCHAR(30),
	`type_of_impact` VARCHAR(50),
	`impacts_measure` VARCHAR(3),
	`additional_property` VARCHAR(70)
);

DROP TABLE IF EXISTS `weapon_characteristic`;
CREATE TABLE `weapon_characteristic` (
	`id` SERIAL PRIMARY KEY,
	`weapon_id` BIGINT UNSIGNED NOT NULL,
	`tech_lvl` CHAR(1),
	`min_impact` INT,
	`max_impact` INT,
	`distance` INT,
	FOREIGN KEY (`weapon_id`) REFERENCES `weapon` (`id`)
);


DROP TABLE IF EXISTS `artefacts_info`;
CREATE TABLE `artefacts_info` (
	`id` SERIAL PRIMARY KEY,
	`name` VARCHAR(50),
	`feature` TEXT
);

DROP TABLE IF EXISTS `players_spaceship`;
CREATE TABLE `players_spaceship` (
	`id` SERIAL PRIMARY KEY,
	`name` VARCHAR(20) NOT NULL,
	`pilots_race` BIGINT UNSIGNED NOT NULL,
	`type_of_corpus` BIGINT UNSIGNED NOT NULL,
	`armor_upgrade` INT UNSIGNED NOT NULL DEFAULT 0,
	`cargo_hold` INT UNSIGNED NOT NULL,
	`engine_slot` BIGINT UNSIGNED NOT NULL,
	`engine_speed_upgrade` INT UNSIGNED NOT NULL DEFAULT 0,
	`engine_jump_range_upgrade` INT UNSIGNED NOT NULL DEFAULT 0,
	`engine_weight` INT UNSIGNED NOT NULL,
	`fuel_tank_slot` BIGINT UNSIGNED NOT NULL,
	`fuel_tank_volume_upgrade` INT UNSIGNED NOT NULL DEFAULT 0,
	`fuel_tank_weight` INT UNSIGNED NOT NULL,
	`radar_slot` BIGINT UNSIGNED NOT NULL DEFAULT 1,
	`radar_range_upgrade` INT UNSIGNED NOT NULL DEFAULT 0,
	`radar_weight` INT UNSIGNED NOT NULL DEFAULT 0,
	`scanner_slot` BIGINT UNSIGNED NOT NULL DEFAULT 1,
	`scanner_power_upgrade` INT UNSIGNED NOT NULL DEFAULT 0,
	`scanner_weight` INT UNSIGNED NOT NULL DEFAULT 0,
	`repair_droid_slot` BIGINT UNSIGNED NOT NULL DEFAULT 1,
	`repair_droid_repair_volume_upgrade` INT UNSIGNED NOT NULL DEFAULT 0,
	`repair_droid_weight` INT UNSIGNED NOT NULL DEFAULT 0,	
	`cargo_attractor_slot` BIGINT UNSIGNED NOT NULL DEFAULT 1,
	`cargo_attractor_payload_upgrade` INT UNSIGNED NOT NULL DEFAULT 0,
	`cargo_attractor_weight` INT UNSIGNED NOT NULL DEFAULT 0,	
	`protective_field_generator_slot` BIGINT UNSIGNED NOT NULL DEFAULT 1,
	`protective_field_generator_power_upgrade` INT UNSIGNED NOT NULL DEFAULT 0,
	`protective_field_generator_weight` INT UNSIGNED NOT NULL DEFAULT 0,	
	`weapon_slot_1` BIGINT UNSIGNED NOT NULL DEFAULT 1,
	`weapon1_impact_upgrade` INT UNSIGNED NOT NULL DEFAULT 0,
	`weapon1_distance_upgrade` INT UNSIGNED NOT NULL DEFAULT 0,
	`weapon_1_weight` INT UNSIGNED NOT NULL DEFAULT 0,	
	`weapon_slot_2` BIGINT UNSIGNED NOT NULL DEFAULT 1,
	`weapon2_impact_upgrade` INT UNSIGNED NOT NULL DEFAULT 0,
	`weapon2_distance_upgrade` INT UNSIGNED NOT NULL DEFAULT 0,
	`weapon_2_weight` INT UNSIGNED NOT NULL DEFAULT 0,	
	`weapon_slot_3` BIGINT UNSIGNED NOT NULL DEFAULT 1,
	`weapon3_impact_upgrade` INT UNSIGNED NOT NULL DEFAULT 0,
	`weapon3_distance_upgrade` INT UNSIGNED NOT NULL DEFAULT 0,
	`weapon_3_weight` INT UNSIGNED NOT NULL DEFAULT 0,	
	`weapon_slot_4` BIGINT UNSIGNED NOT NULL DEFAULT 1,
	`weapon4_impact_upgrade` INT UNSIGNED NOT NULL DEFAULT 0,
	`weapon4_distance_upgrade` INT UNSIGNED NOT NULL DEFAULT 0,
	`weapon_4_weight` INT UNSIGNED NOT NULL DEFAULT 0,	
	`weapon_slot_5` BIGINT UNSIGNED NOT NULL DEFAULT 1,
	`weapon5_impact_upgrade` INT UNSIGNED NOT NULL DEFAULT 0,
	`weapon5_distance_upgrade` INT UNSIGNED NOT NULL DEFAULT 0,
	`weapon_5_weight` INT UNSIGNED NOT NULL DEFAULT 0,	
	`antigravity_thing_slot` BIT NOT NULL DEFAULT 0,
	`antigravity_thing_weight` INT UNSIGNED NOT NULL DEFAULT 0,	
	`probability_analysator_slot` BIT NOT NULL DEFAULT 0,
	`probability_analysator_weight` INT UNSIGNED NOT NULL DEFAULT 0,
	`droid_jr_slot`BIT NOT NULL DEFAULT 0,
	`droid_jr_weight` INT UNSIGNED NOT NULL DEFAULT 0,
	`iron_zhupi_slot` BIT NOT NULL DEFAULT 0,
	`iron_zhupi_weight` INT UNSIGNED NOT NULL DEFAULT 0,
	`local_of_blast_wave_slot` BIT NOT NULL DEFAULT 0,
	`local_of_blast_wave_weight` INT UNSIGNED NOT NULL DEFAULT 0,
	`nanitoids_slot` BIT NOT NULL DEFAULT 0,
	`nanitoids_weight` INT UNSIGNED NOT NULL DEFAULT 0,
	`freezers_slot` BIT NOT NULL DEFAULT 0,
	`freezers_weight` INT UNSIGNED NOT NULL DEFAULT 0,
	`polarizer_slot` BIT NOT NULL DEFAULT 0,
	`polarizer_weight` INT UNSIGNED NOT NULL DEFAULT 0,
	`prolonger_slot` BIT NOT NULL DEFAULT 0,
	`prolonger_weight` INT UNSIGNED NOT NULL DEFAULT 0,
	`psi-accelerator_slot` BIT NOT NULL DEFAULT 0,
	`psi-accelerator_weight` INT UNSIGNED NOT NULL DEFAULT 0,
	`scan_cache_slot` BIT NOT NULL DEFAULT 0,
	`scan_cache_weight` INT UNSIGNED NOT NULL DEFAULT 0,
	`black_slime_slot` BIT NOT NULL DEFAULT 0,
	`black_slime_weight` INT UNSIGNED NOT NULL DEFAULT 0,
	`erimeter_slot` BIT NOT NULL DEFAULT 0,
	`erimeter_weight` INT UNSIGNED NOT NULL DEFAULT 0,
	FOREIGN KEY (`pilots_race`) REFERENCES `races` (`id`),
	FOREIGN KEY (`type_of_corpus`) REFERENCES `corpus`(`id`),
	FOREIGN KEY (`engine_slot`) REFERENCES `engine`(`id`),
	FOREIGN KEY (`fuel_tank_slot`) REFERENCES `fuel_tank`(`id`),
	FOREIGN KEY (`radar_slot`) REFERENCES `radar`(`id`),
	FOREIGN KEY (`scanner_slot`) REFERENCES `scanner`(`id`),
	FOREIGN KEY (`repair_droid_slot`) REFERENCES `repair_droid`(`id`),
	FOREIGN KEY (`cargo_attractor_slot`) REFERENCES `cargo_attractor`(`id`),
	FOREIGN KEY (`protective_field_generator_slot`) REFERENCES `protective_field_generator`(`id`),
	FOREIGN KEY (`weapon_slot_1`) REFERENCES `weapon_characteristic`(`id`),
	FOREIGN KEY (`weapon_slot_2`) REFERENCES `weapon_characteristic`(`id`),
	FOREIGN KEY (`weapon_slot_3`) REFERENCES `weapon_characteristic`(`id`),
	FOREIGN KEY (`weapon_slot_4`) REFERENCES `weapon_characteristic`(`id`),
	FOREIGN KEY (`weapon_slot_5`) REFERENCES `weapon_characteristic`(`id`)
);

CREATE OR REPLACE VIEW `all_weapon_info` AS
SELECT  `weapon_characteristic`.`id`, 
		`weapon`.`name` AS `Название`,
		`weapon_characteristic`.`tech_lvl` AS `Технический уровень`,
		`weapon`.`type_of_impact` AS `Тип воздействия`, 
		`weapon_characteristic`.`min_impact` AS `Мин. воздействие`, 
		`weapon_characteristic`.`max_impact` AS `Макс. воздействие`,
		`weapon`.`impacts_measure` AS `Единицы измерения`,
		`weapon_characteristic`.`distance` AS `Дистанция`,
		`weapon`.`additional_property` AS `Доп. свойство` 
FROM `weapon` JOIN `weapon_characteristic`
ON `weapon`.`id` = `weapon_characteristic`.`weapon_id`;

DELIMITER //

DROP FUNCTION IF EXISTS `total_armor`//
CREATE FUNCTION `total_armor`(`armor` INT, `zhupi` BIT, `upgrade` INT)
RETURNS INT DETERMINISTIC
BEGIN
	IF (`zhupi`=1) THEN RETURN `armor`+5+`upgrade`;
	ELSE RETURN `armor`+`upgrade`;
	END IF;
END//

DROP FUNCTION IF EXISTS `total_protective_field`//
CREATE FUNCTION `total_protective_field`(`protective_field` INT, `polarizer` BIT, `upgrade` INT)
RETURNS INT DETERMINISTIC
BEGIN
	IF (`protective_field`=0) THEN RETURN 0;
	END IF;
	IF (`polarizer`=1) THEN RETURN `protective_field`+10+`upgrade`;
	ELSE RETURN `protective_field`+`upgrade`;
	END IF;
END//

DROP FUNCTION IF EXISTS `total_speed`//
CREATE FUNCTION `total_speed`(`engine_speed` INT, `total_weight` INT, `antigravity_thing` BIT, `psi-accelerator` BIT, `upgrade` INT, `cargo_hold` INT)
RETURNS INT DETERMINISTIC
BEGIN
	DECLARE `high_load_coeff` FLOAT;
    -- Ошибка out of range в представлении main_player_info в случае перегруза, не нашёл, как её победить.
	IF (2*`cargo_hold`-`total_weight`<0) THEN RETURN 0;
	END IF;
	IF (`antigravity_thing`=1) THEN SET `total_weight`=CEIL(`total_weight`*0.75);
	END IF;
	IF (`total_weight`>=1980) THEN SET `high_load_coeff`=0.333;
	ELSE SET `high_load_coeff`= ROUND((122.333-0.045*`total_weight`)/100, 2);
	END IF;
	IF (`high_load_coeff`>1) THEN SET `high_load_coeff`=1;
	END IF;
	IF (`psi-accelerator`=0) THEN RETURN CEIL(`engine_speed`*`high_load_coeff`)+`upgrade`;
	ELSE RETURN CEIL(`engine_speed`*`high_load_coeff`)+100+`upgrade`;
	END IF;
END//

DROP FUNCTION IF EXISTS `total_fuel_tank_volume`//
CREATE FUNCTION `total_fuel_tank_volume`(`fuel_tank_base_volume` INT, `fuel_tank_weight` INT, `upgrade` INT)
RETURNS INT DETERMINISTIC
BEGIN
	RETURN `fuel_tank_base_volume`+CEIL(`fuel_tank_weight`/2)+`upgrade`;
END//

DROP FUNCTION IF EXISTS `total_jump_range`//
CREATE FUNCTION `total_jump_range`(`engine_jump_range` INT, `total_fuel` INT, `upgrade` INT)
RETURNS INT DETERMINISTIC
BEGIN
	IF (`total_fuel`-(`engine_jump_range`+`upgrade`)>=0) THEN RETURN `engine_jump_range`+`upgrade`;
	ELSE RETURN `total_fuel`;
	END IF;
END//

DROP FUNCTION IF EXISTS `total_repair_volume`//
CREATE FUNCTION `total_repair_volume`(`repair_droid_repair_volume` INT, `droid_jr` BIT, `upgrade` INT)
RETURNS INT DETERMINISTIC
BEGIN
	IF (`repair_droid_repair_volume`=0) THEN RETURN 0;
	END IF;	
	IF (`droid_jr`=1) THEN RETURN `repair_droid_repair_volume`+10+`upgrade`;
	ELSE RETURN `repair_droid_repair_volume`+`upgrade`;
	END IF;
END//

DROP FUNCTION IF EXISTS `total_cargo_attractor_payload`//
CREATE FUNCTION `total_cargo_attractor_payload`(`cargo_attractor_payload` INT, `erimeter` BIT, `upgrade` INT)
RETURNS INT DETERMINISTIC
BEGIN
	IF (`cargo_attractor_payload`=0) THEN RETURN 0;
	END IF;	
	IF (`erimeter`=1) THEN RETURN `cargo_attractor_payload`+30+`upgrade`;
	ELSE RETURN `cargo_attractor_payload`+`upgrade`;
	END IF;
END//

DROP FUNCTION IF EXISTS `total_radar_range`//
CREATE FUNCTION `total_radar_range`(`radar_range` INT, `prolonger` BIT, `upgrade` INT)
RETURNS INT DETERMINISTIC
BEGIN
	IF (`radar_range`=0) THEN RETURN 0;
	END IF;	
	IF (`prolonger`=1) THEN RETURN `radar_range`+600+`upgrade`;
	ELSE RETURN `radar_range`+`upgrade`;
	END IF;
END//

DROP FUNCTION IF EXISTS `total_scanner_power`//
CREATE FUNCTION `total_scanner_power`(`scanner_power` INT, `scan_cache` BIT, `upgrade` INT)
RETURNS INT DETERMINISTIC
BEGIN
	IF (`scanner_power`=0) THEN RETURN 0;
	END IF;	
	IF (`scan_cache`=1) THEN RETURN `scanner_power`+10+`upgrade`;
	ELSE RETURN `scanner_power`+`upgrade`;
	END IF;
END//

DROP FUNCTION IF EXISTS `total_min_damage`//
CREATE FUNCTION `total_min_damage`(`wp1_min_impact` INT, `wp1_impacts_measure` VARCHAR(3), `wp1_impact_upgrade` INT,
									`wp2_min_impact` INT, `wp2_impacts_measure` VARCHAR(3), `wp2_impact_upgrade` INT,
									`wp3_min_impact` INT, `wp3_impacts_measure` VARCHAR(3), `wp3_impact_upgrade` INT,
									`wp4_min_impact` INT, `wp4_impacts_measure` VARCHAR(3), `wp4_impact_upgrade` INT,
									`wp5_min_impact` INT, `wp5_impacts_measure` VARCHAR(3), `wp5_impact_upgrade` INT)
RETURNS INT DETERMINISTIC
BEGIN
	DECLARE `min_damage` INT;
	SET `min_damage`=0;
	IF (`wp1_impacts_measure`='ед.') THEN SET `min_damage`=`min_damage`+`wp1_min_impact`+`wp1_impact_upgrade`;
	END IF;
	IF (`wp2_impacts_measure`='ед.') THEN SET `min_damage`=`min_damage`+`wp2_min_impact`+`wp2_impact_upgrade`;
	END IF;
	IF (`wp3_impacts_measure`='ед.') THEN SET `min_damage`=`min_damage`+`wp3_min_impact`+`wp3_impact_upgrade`;
	END IF;
	IF (`wp4_impacts_measure`='ед.') THEN SET `min_damage`=`min_damage`+`wp4_min_impact`+`wp4_impact_upgrade`;
	END IF;
	IF (`wp5_impacts_measure`='ед.') THEN SET `min_damage`=`min_damage`+`wp5_min_impact`+`wp5_impact_upgrade`;
	END IF;
	RETURN `min_damage`;
END//

DROP FUNCTION IF EXISTS `total_max_damage`//
CREATE FUNCTION `total_max_damage`(`wp1_max_impact` INT, `wp1_impacts_measure` VARCHAR(3), `wp1_impact_upgrade` INT,
									`wp2_max_impact` INT, `wp2_impacts_measure` VARCHAR(3), `wp2_impact_upgrade` INT,
									`wp3_max_impact` INT, `wp3_impacts_measure` VARCHAR(3), `wp3_impact_upgrade` INT,
									`wp4_max_impact` INT, `wp4_impacts_measure` VARCHAR(3), `wp4_impact_upgrade` INT,
									`wp5_max_impact` INT, `wp5_impacts_measure` VARCHAR(3), `wp5_impact_upgrade` INT)
RETURNS INT DETERMINISTIC
BEGIN
	DECLARE `max_damage` INT;
	SET `max_damage`=0;
	IF (`wp1_impacts_measure`='ед.') THEN SET `max_damage`=`max_damage`+`wp1_max_impact`+`wp1_impact_upgrade`;
	END IF;
	IF (`wp2_impacts_measure`='ед.') THEN SET `max_damage`=`max_damage`+`wp2_max_impact`+`wp2_impact_upgrade`;
	END IF;
	IF (`wp3_impacts_measure`='ед.') THEN SET `max_damage`=`max_damage`+`wp3_max_impact`+`wp3_impact_upgrade`;
	END IF;
	IF (`wp4_impacts_measure`='ед.') THEN SET `max_damage`=`max_damage`+`wp4_max_impact`+`wp4_impact_upgrade`;
	END IF;
	IF (`wp5_impacts_measure`='ед.') THEN SET `max_damage`=`max_damage`+`wp5_max_impact`+`wp5_impact_upgrade`;
	END IF;
	RETURN `max_damage`;
END//

DROP FUNCTION IF EXISTS `weapon_features`//
CREATE FUNCTION `weapon_features`(`wp1_min_impact` INT, `wp1_max_impact` INT, `wp1_type_of_impact` VARCHAR(50), `wp1_add_property` VARCHAR(70), `wp1_impact_upgrade` INT,
									`wp2_min_impact` INT, `wp2_max_impact` INT, `wp2_type_of_impact` VARCHAR(50), `wp2_add_property` VARCHAR(70), `wp2_impact_upgrade` INT,
									`wp3_min_impact` INT, `wp3_max_impact` INT, `wp3_type_of_impact` VARCHAR(50), `wp3_add_property` VARCHAR(70), `wp3_impact_upgrade` INT,
									`wp4_min_impact` INT, `wp4_max_impact` INT, `wp4_type_of_impact` VARCHAR(50), `wp4_add_property` VARCHAR(70), `wp4_impact_upgrade` INT,
									`wp5_min_impact` INT, `wp5_max_impact` INT, `wp5_type_of_impact` VARCHAR(50), `wp5_add_property` VARCHAR(70), `wp5_impact_upgrade` INT)
RETURNS TEXT DETERMINISTIC
BEGIN
	DECLARE `features` TEXT;
	SET `features` = '';
	-- В этом блоке уникальность не нужна, оружие с процентным эффектом стреляет поочерёдно и каждое наносит своё воздействие.
	IF (`wp1_type_of_impact`!='Урон') THEN SET `features` =  CONCAT(`features`, `wp1_type_of_impact`, ' на ', `wp1_min_impact`+`wp1_impact_upgrade`, ' - ', `wp1_max_impact`+`wp1_impact_upgrade`, ' %. ');
	END IF;
	IF (`wp2_type_of_impact`!='Урон') THEN SET `features` =  CONCAT(`features`, `wp2_type_of_impact`, ' на ', `wp2_min_impact`+`wp2_impact_upgrade`, ' - ', `wp2_max_impact`+`wp2_impact_upgrade`, ' %. ');
	END IF;
	IF (`wp3_type_of_impact`!='Урон') THEN SET `features` =  CONCAT(`features`, `wp3_type_of_impact`, ' на ', `wp3_min_impact`+`wp3_impact_upgrade`, ' - ', `wp3_max_impact`+`wp3_impact_upgrade`, ' %. ');
	END IF;
	IF (`wp4_type_of_impact`!='Урон') THEN SET `features` =  CONCAT(`features`, `wp4_type_of_impact`, ' на ', `wp4_min_impact`+`wp4_impact_upgrade`, ' - ', `wp4_max_impact`+`wp4_impact_upgrade`, ' %. ');
	END IF;
	IF (`wp5_type_of_impact`!='Урон') THEN SET `features` =  CONCAT(`features`, `wp5_type_of_impact`, ' на ', `wp5_min_impact`+`wp5_impact_upgrade`, ' - ', `wp5_max_impact`+`wp5_impact_upgrade`, ' %. ');
	END IF;
	-- Здесь нужна уникальность, т.к. несколько орудий могут иметь одинаковый доп.эффект. DISTINCT и GROUP BY применить не удалось, пришлось изощряться.
	IF `wp1_add_property` IN (`wp2_add_property`, `wp3_add_property`, `wp4_add_property`, `wp5_add_property`) THEN SET `wp1_add_property`=NULL;
	END IF;
	IF `wp2_add_property` IN (`wp3_add_property`, `wp4_add_property`, `wp5_add_property`) THEN SET `wp2_add_property`=NULL;
	END IF;
	IF `wp3_add_property` IN (`wp4_add_property`, `wp5_add_property`) THEN SET `wp3_add_property`=NULL;
	END IF;
	IF `wp4_add_property`=`wp5_add_property` THEN SET `wp4_add_property`=NULL;
	END IF;
	SET `features` = CONCAT(`features`, IFNULL(`wp1_add_property`, ''), IFNULL(`wp2_add_property`, ''), IFNULL(`wp3_add_property`, ''), IFNULL(`wp4_add_property`, ''), IFNULL(`wp5_add_property`, ''));
	RETURN `features`;
END//

DROP FUNCTION IF EXISTS `add_features`//
CREATE FUNCTION `add_features`(`probability_analysator` BIT, `probability_analysator_feature` TEXT,
								`local_of_blast_wave` BIT, `local_of_blast_wave_feature` TEXT,
								`nanitoids` BIT, `nanitoids_feature` TEXT,
								`freezers` BIT, `freezers_feature` TEXT,
								`black_slime` BIT, `black_slime_feature` TEXT,
								`weapon_features` TEXT, `scanner` BIGINT, `damage` INT)
RETURNS TEXT DETERMINISTIC
BEGIN
	DECLARE `features` TEXT;
	SET `features` = `weapon_features`;
	IF (`probability_analysator`=1 AND `scanner`!=0) THEN SET `features` =  CONCAT(`features`, `probability_analysator_feature`);
	END IF;
	IF (`local_of_blast_wave`=1 AND `damage`!=0) THEN SET `features` =  CONCAT(`features`, `local_of_blast_wave_feature`);
	END IF;
	IF (`nanitoids`=1) THEN SET `features` =  CONCAT(`features`, `nanitoids_feature`);
	END IF;
	IF (`freezers`=1) THEN SET `features` =  CONCAT(`features`, `freezers_feature`);
	END IF;
	IF (`black_slime`=1) THEN SET `features` =  CONCAT(`features`, `black_slime_feature`);
	END IF;
	RETURN `features`;
END//

DROP FUNCTION IF EXISTS `effective_distance`//
CREATE FUNCTION `effective_distance`(`wp1_dist_impact` INT, `wp1_dict_upgrade` INT,
									 `wp2_dist_impact` INT, `wp2_dict_upgrade` INT,
									 `wp3_dist_impact` INT, `wp3_dict_upgrade` INT,
									 `wp4_dist_impact` INT, `wp4_dict_upgrade` INT,
									 `wp5_dist_impact` INT, `wp5_dict_upgrade` INT)
RETURNS INT DETERMINISTIC
BEGIN
	DECLARE `distance` INT;
	-- Наверняка можно было намного проще, через MIN например, но меня не озарило.
	SET `distance`=0;
	IF (`wp1_dist_impact`>0) THEN SET `distance`=`wp1_dist_impact`+`wp1_dict_upgrade`;
	END IF;
	IF ((`wp2_dist_impact`>0 AND `distance`=0) OR (`wp2_dist_impact`>0 AND `distance`>0 AND `wp2_dist_impact`+`wp2_dict_upgrade`<`distance`)) THEN SET `distance`=`wp2_dist_impact`+`wp2_dict_upgrade`;
	END IF;
	IF ((`wp3_dist_impact`>0 AND `distance`=0) OR (`wp3_dist_impact`>0 AND `distance`>0 AND `wp3_dist_impact`+`wp3_dict_upgrade`<`distance`)) THEN SET `distance`=`wp3_dist_impact`+`wp3_dict_upgrade`;
	END IF;
	IF ((`wp4_dist_impact`>0 AND `distance`=0) OR (`wp4_dist_impact`>0 AND `distance`>0 AND `wp4_dist_impact`+`wp4_dict_upgrade`<`distance`)) THEN SET `distance`=`wp4_dist_impact`+`wp4_dict_upgrade`;
	END IF;
	IF ((`wp5_dist_impact`>0 AND `distance`=0) OR (`wp5_dist_impact`>0 AND `distance`>0 AND `wp5_dist_impact`+`wp5_dict_upgrade`<`distance`)) THEN SET `distance`=`wp5_dist_impact`+`wp5_dict_upgrade`;
	END IF;
	RETURN `distance`;
END//
DELIMITER ;

CREATE OR REPLACE VIEW `main_player_info` AS
SELECT DISTINCT `ps`.`name` AS `Имя персонажа`, /* Тут возможен, пусть и очень небольшой, шанс того, что состояние корабля полностью повторится, и в этом случае DISTINCT может навредить.
												 Но шанс низкий, а без DISTINCT я не нашёл способа избавиться от перемножения кол-ва полей в этой таблице на кол-во в таблцие `artefacts_info`.*/
		`races`.`name` AS `Раса персонажа`,
		`ps`.`cargo_hold` AS `Прочность`,
		`ps`.`cargo_hold`-(`ps`.`engine_weight`+`ps`.`fuel_tank_weight`+`ps`.`radar_weight`+
										`ps`.`scanner_weight`+`ps`.`repair_droid_weight`+`ps`.`cargo_attractor_weight`+
										`ps`.`protective_field_generator_weight`+`ps`.`weapon_1_weight`+`ps`.`weapon_2_weight`+
										`ps`.`weapon_3_weight`+`ps`.`weapon_4_weight`+`ps`.`weapon_5_weight`+
										`ps`.`antigravity_thing_weight`+`ps`.`probability_analysator_weight`+`ps`.`droid_jr_weight`+
										`ps`.`iron_zhupi_weight`+`ps`.`local_of_blast_wave_weight`+`ps`.`nanitoids_weight`+
										`ps`.`freezers_weight`+`ps`.`polarizer_weight`+`ps`.`prolonger_weight`+
										`ps`.`psi-accelerator_weight`+`ps`.`scan_cache_weight`+`ps`.`black_slime_weight`+
										`ps`.`erimeter_weight`) AS `Свободное место`,
		`total_armor`(`corpus`.`armor`, `ps`.`iron_zhupi_slot`, `ps`.`armor_upgrade`) AS `Броня (ед.)`,
		`total_protective_field`(`protective_field_generator`.`power`, `ps`.`polarizer_slot`, `ps`.`protective_field_generator_power_upgrade`) AS `Защита (%)`,
		`total_repair_volume`(`repair_droid`.`repair_volume`, `ps`.`droid_jr_slot`, `ps`.`repair_droid_repair_volume_upgrade`) AS `Ремонт за день`,
		`total_speed`(`engine`.`speed`, (`ps`.`engine_weight`+`ps`.`fuel_tank_weight`+`ps`.`radar_weight`+`ps`.`scanner_weight`+
										`ps`.`repair_droid_weight`+`ps`.`cargo_attractor_weight`+`ps`.`protective_field_generator_weight`+
										`ps`.`weapon_1_weight`+`ps`.`weapon_2_weight`+`ps`.`weapon_3_weight`+`ps`.`weapon_4_weight`+
										`ps`.`weapon_5_weight`+`ps`.`antigravity_thing_weight`+`ps`.`probability_analysator_weight`+
										`ps`.`droid_jr_weight`+`ps`.`iron_zhupi_weight`+`ps`.`local_of_blast_wave_weight`+
										`ps`.`nanitoids_weight`+`ps`.`freezers_weight`+`ps`.`polarizer_weight`+`ps`.`prolonger_weight`+
										`ps`.`psi-accelerator_weight`+`ps`.`scan_cache_weight`+`ps`.`black_slime_weight`+
										`ps`.`erimeter_weight`+`ps`.`cargo_hold`), 
						`ps`.`antigravity_thing_slot`, `ps`.`psi-accelerator_slot`, `ps`.`engine_speed_upgrade`, `ps`.`cargo_hold`) AS `Скорость`,
		`total_jump_range`(`engine`.`jump_range`, `total_fuel_tank_volume`(`fuel_tank`.`base_volume`, `ps`.`fuel_tank_weight`, `ps`.`fuel_tank_volume_upgrade`), `ps`.`engine_jump_range_upgrade`) AS `Доступная дальность прыжка`,
		`total_fuel_tank_volume`(`fuel_tank`.`base_volume`, `ps`.`fuel_tank_weight`, `ps`.`fuel_tank_volume_upgrade`) AS `Объём бака`,
		`total_radar_range`(`radar`.`range`, `ps`.`prolonger_slot`, `ps`.`radar_range_upgrade`) AS `Дальность радара`,
		`total_scanner_power`(`scanner`.`power`, `ps`.`scan_cache_slot`, `ps`.`scanner_power_upgrade`) AS `Мощность сканера`,
		`total_cargo_attractor_payload`(`cargo_attractor`.`payload`, `ps`.`erimeter_slot`, `ps`.`cargo_attractor_payload_upgrade`) AS `Мощность захвата`,
		`total_min_damage`( `wp1`.`Мин. воздействие`, `wp1`.`Единицы измерения`, `ps`.`weapon1_impact_upgrade`,
							`wp2`.`Мин. воздействие`, `wp2`.`Единицы измерения`, `ps`.`weapon2_impact_upgrade`,
							`wp3`.`Мин. воздействие`, `wp3`.`Единицы измерения`, `ps`.`weapon3_impact_upgrade`,
							`wp4`.`Мин. воздействие`, `wp4`.`Единицы измерения`, `ps`.`weapon4_impact_upgrade`,
							`wp5`.`Мин. воздействие`, `wp5`.`Единицы измерения`, `ps`.`weapon5_impact_upgrade`) AS `Мин. урон за ход`,
		`total_max_damage`( `wp1`.`Макс. воздействие`, `wp1`.`Единицы измерения`, `ps`.`weapon1_impact_upgrade`,
							`wp2`.`Макс. воздействие`, `wp2`.`Единицы измерения`, `ps`.`weapon2_impact_upgrade`,
							`wp3`.`Макс. воздействие`, `wp3`.`Единицы измерения`, `ps`.`weapon3_impact_upgrade`,
							`wp4`.`Макс. воздействие`, `wp4`.`Единицы измерения`, `ps`.`weapon4_impact_upgrade`,
							`wp5`.`Макс. воздействие`, `wp5`.`Единицы измерения`, `ps`.`weapon5_impact_upgrade`) AS `Макс. урон за ход`,
		`effective_distance`(`wp1`.`Дистанция`, `weapon1_distance_upgrade`,
							 `wp2`.`Дистанция`, `weapon2_distance_upgrade`,
							 `wp3`.`Дистанция`, `weapon3_distance_upgrade`,
							 `wp4`.`Дистанция`, `weapon4_distance_upgrade`,
							 `wp5`.`Дистанция`, `weapon5_distance_upgrade`) AS `Эффективная дистанция`,
		`add_features`(`ps`.`probability_analysator_slot`, (SELECT `feature` FROM `artefacts_info` WHERE `id` = 2),
						`ps`.`local_of_blast_wave_slot`, (SELECT `feature` FROM `artefacts_info` WHERE `id` = 5),
						`ps`.`nanitoids_slot`, (SELECT `feature` FROM `artefacts_info` WHERE `id` = 6),
						`ps`.`freezers_slot`, (SELECT `feature` FROM `artefacts_info` WHERE `id` = 7),
						`ps`.`black_slime_slot`, (SELECT `feature` FROM `artefacts_info` WHERE `id` = 12),
						`weapon_features`(  `wp1`.`Мин. воздействие`, `wp1`.`Макс. воздействие`, `wp1`.`Тип воздействия`, `wp1`.`Доп. свойство`, `ps`.`weapon1_impact_upgrade`,
											`wp2`.`Мин. воздействие`, `wp2`.`Макс. воздействие`, `wp2`.`Тип воздействия`, `wp2`.`Доп. свойство`, `ps`.`weapon2_impact_upgrade`,
											`wp3`.`Мин. воздействие`, `wp3`.`Макс. воздействие`, `wp3`.`Тип воздействия`, `wp3`.`Доп. свойство`, `ps`.`weapon3_impact_upgrade`,
											`wp4`.`Мин. воздействие`, `wp4`.`Макс. воздействие`, `wp4`.`Тип воздействия`, `wp4`.`Доп. свойство`, `ps`.`weapon4_impact_upgrade`,
											`wp5`.`Мин. воздействие`, `wp5`.`Макс. воздействие`, `wp5`.`Тип воздействия`, `wp5`.`Доп. свойство`, `ps`.`weapon5_impact_upgrade`),
											`scanner`.`power`, 
											`wp1`.`Мин. воздействие`+`wp2`.`Мин. воздействие`+`wp3`.`Мин. воздействие`+`wp4`.`Мин. воздействие`+`wp5`.`Мин. воздействие`) AS `Доп. свойства`
FROM `players_spaceship` AS `ps` JOIN `races` JOIN `corpus` JOIN `protective_field_generator` JOIN `repair_droid` JOIN `engine` JOIN 
		`radar` JOIN `scanner` JOIN `cargo_attractor` JOIN `fuel_tank` JOIN `all_weapon_info` AS `wp1` JOIN `all_weapon_info` AS `wp2` JOIN
		`all_weapon_info` AS `wp3` JOIN `all_weapon_info` AS `wp4` JOIN `all_weapon_info` AS `wp5` JOIN `artefacts_info`
ON  `ps`.`pilots_race` = `races`.`id` AND 
	`ps`.`type_of_corpus` = `corpus`.`id` AND
	`ps`.`protective_field_generator_slot` = `protective_field_generator`.`id` AND 
	`ps`.`repair_droid_slot` = `repair_droid`.`id` AND
	`ps`.`engine_slot` IN (`engine`.`id`, NULL) AND
	`ps`.`radar_slot` = `radar`.`id` AND
	`ps`.`scanner_slot` = `scanner`.`id` AND
	`ps`.`cargo_attractor_slot` = `cargo_attractor`.`id` AND
	`ps`.`fuel_tank_slot` = `fuel_tank`.`id` AND
	`ps`.`weapon_slot_1` = `wp1`.`id` AND
	`ps`.`weapon_slot_2` = `wp2`.`id` AND
	`ps`.`weapon_slot_3` = `wp3`.`id` AND
	`ps`.`weapon_slot_4` = `wp4`.`id` AND
	`ps`.`weapon_slot_5` = `wp5`.`id`;