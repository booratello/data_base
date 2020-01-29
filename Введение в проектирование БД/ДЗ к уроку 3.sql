/* Задание: написать скрипт, добавляющий в БД vk, которую создали на занятии, 
 * 3 новые таблицы (с перечнем полей, указанием индексов и внешних ключей).
 * 
 * Соцсетями я пользуюсь ограниченно и большую часть из того, чем я, собственно, 
 * пользуюсь и о чём есть представление, мы рассмотрели на вебинаре. Поэтому тут 
 * скорее додумки и рассуждения, нежели адекватное представление. */

DROP TABLE IF EXISTS `users_interests`;
/* с одной стороны, это всё вполне можно разметить в таблице profiles, 
 * с другой - это неосновные данные, которые занимают много памяти и требуют 
 * долгой обработки, поэтому имеет смысл выводить эти данные по отдельному запросу*/
CREATE TABLE `users_interests` (
	profile_id SERIAL PRIMARY KEY,
	favourite_books TEXT,
	favourite_movies TEXT,
	favourite_games TEXT,
	hobby TEXT,	
    FOREIGN KEY (profile_id) REFERENCES `profiles`(user_id)
);

DROP TABLE IF EXISTS `education_and_career`;
/* по аналогии с users_interests, это всё вполне можно разметить в таблице profiles,
 * но, во-первых, это не является основными данными о пользователе, а во-вторых - тут
 * много индексируемых данных, которые, как мне кажется, имеет смысл держать отдельно 
 * 
 * тут будет лайт-версия с одной школой, местом службы, универом и местом работы */
CREATE TABLE `education_and_career` (
	profile_id SERIAL PRIMARY KEY,
	school VARCHAR(100),
	class CHAR(1),
	school_started_at DATETIME,
	school_ended_at DATETIME,
	university VARCHAR(100),
	faculty VARCHAR(100),
	profession VARCHAR(100),
	university_started_at DATETIME,
	university_ended_at DATETIME,
	army_service VARCHAR(100),
	army_part VARCHAR(100),
	army_service_started_at DATETIME,
	army_service_ended_at DATETIME,
	job VARCHAR(100),
	department VARCHAR(100),
	`position` VARCHAR(100),
	job_started_at DATETIME,
	job_ended_at DATETIME,
	
	-- тут я расписал те поисковые запросы, которые, на мой взгляд, будут наиболее популярными
	INDEX (school, class, school_ended_at),
	INDEX (school, school_ended_at),
	INDEX (university, university_started_at),
	INDEX (university, university_ended_at),
	INDEX (university, faculty, university_started_at),
	INDEX (university, profession, university_started_at),
	INDEX (university, profession, university_ended_at),
	INDEX (army_service, army_service_started_at),
	INDEX (army_service, army_service_ended_at),
	INDEX (army_service, army_part, army_service_started_at),
	INDEX (army_service, army_part, army_service_ended_at),
	INDEX (job),
	INDEX (job, department),
	FOREIGN KEY (profile_id) REFERENCES `profiles`(user_id)
);


DROP TABLE IF EXISTS `relationship_requests`;
/* как вариант, это можно не выносить в отдельную таблицу, 
 * а сделать дополнительные запросы в таблицу friend_requests,
 * копиркой с которой это всё и является */
CREATE TABLE `relationship_requests` (
	initiator_user_id BIGINT UNSIGNED NOT NULL,
    target_user_id BIGINT UNSIGNED NOT NULL,
    `status` ENUM('requested', 'married', 'dating', 'parent-child', 'grandparent-grandchild', 'brothers/sisters/brother-sister', 'enemies'),
	requested_at DATETIME DEFAULT NOW(),
	confirmed_at DATETIME,
	
    PRIMARY KEY (initiator_user_id, target_user_id),
	INDEX (initiator_user_id),
    INDEX (target_user_id),
    FOREIGN KEY (initiator_user_id) REFERENCES users(id),
    FOREIGN KEY (target_user_id) REFERENCES users(id)
);
