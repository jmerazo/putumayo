/*
SQLyog Ultimate v13.1.1 (64 bit)
MySQL - 8.0.33 : Database - putumayo
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
CREATE DATABASE /*!32312 IF NOT EXISTS*/`putumayo` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `putumayo`;

/*Table structure for table `account_emailaddress` */

DROP TABLE IF EXISTS `account_emailaddress`;

CREATE TABLE `account_emailaddress` (
  `id` int NOT NULL AUTO_INCREMENT,
  `email` varchar(254) NOT NULL,
  `verified` tinyint(1) NOT NULL,
  `primary` tinyint(1) NOT NULL,
  `user_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `account_emailaddress_user_id_email_987c8728_uniq` (`user_id`,`email`),
  KEY `account_emailaddress_email_03be32b2` (`email`),
  CONSTRAINT `account_emailaddress_user_id_2c513194_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `account_emailaddress` */

/*Table structure for table `account_emailconfirmation` */

DROP TABLE IF EXISTS `account_emailconfirmation`;

CREATE TABLE `account_emailconfirmation` (
  `id` int NOT NULL AUTO_INCREMENT,
  `created` datetime(6) NOT NULL,
  `sent` datetime(6) DEFAULT NULL,
  `key` varchar(64) NOT NULL,
  `email_address_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `key` (`key`),
  KEY `account_emailconfirm_email_address_id_5b7f8c58_fk_account_e` (`email_address_id`),
  CONSTRAINT `account_emailconfirm_email_address_id_5b7f8c58_fk_account_e` FOREIGN KEY (`email_address_id`) REFERENCES `account_emailaddress` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `account_emailconfirmation` */

/*Table structure for table `auth` */

DROP TABLE IF EXISTS `auth`;

CREATE TABLE `auth` (
  `id` int NOT NULL AUTO_INCREMENT,
  `a_person_id` int DEFAULT NULL,
  `password` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `a_rol_id` int DEFAULT NULL,
  `a_group_id` int DEFAULT NULL,
  `created` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `persons_id` (`a_person_id`),
  KEY `roles_id` (`a_rol_id`),
  KEY `a_groupid` (`a_group_id`),
  CONSTRAINT `a_groupid` FOREIGN KEY (`a_group_id`) REFERENCES `groups` (`id`),
  CONSTRAINT `persons_id` FOREIGN KEY (`a_person_id`) REFERENCES `person` (`id`),
  CONSTRAINT `roles_id` FOREIGN KEY (`a_rol_id`) REFERENCES `roles` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `auth` */

insert  into `auth`(`id`,`a_person_id`,`password`,`a_rol_id`,`a_group_id`,`created`,`updated`) values 
(1,1,'pbkdf2_sha256$390000$wmgQ5xUrWGem5IbIsmuDtT$kOgq2OOMPTz47OshYK/gX65hz1Ttwj2ycW9ygvE1pvg=',1,NULL,'2024-07-09 14:42:39','2024-07-09 14:42:39'),
(2,2,'$2b$12$mwTrMbh0EVUokxbyVSJaxOVFgy7aYoT7BCFPYZ573jqVMCGr9ygWO',1,NULL,'2024-07-10 17:08:51','2024-07-10 17:09:13');

/*Table structure for table `auth_group` */

DROP TABLE IF EXISTS `auth_group`;

CREATE TABLE `auth_group` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(150) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `auth_group` */

/*Table structure for table `auth_group_permissions` */

DROP TABLE IF EXISTS `auth_group_permissions`;

CREATE TABLE `auth_group_permissions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `group_id` int NOT NULL,
  `permission_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_group_permissions_group_id_permission_id_0cd325b0_uniq` (`group_id`,`permission_id`),
  KEY `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` (`permission_id`),
  CONSTRAINT `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `auth_group_permissions_group_id_b120cbf9_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `auth_group_permissions` */

/*Table structure for table `auth_permission` */

DROP TABLE IF EXISTS `auth_permission`;

CREATE TABLE `auth_permission` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `content_type_id` int NOT NULL,
  `codename` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_permission_content_type_id_codename_01ab375a_uniq` (`content_type_id`,`codename`),
  CONSTRAINT `auth_permission_content_type_id_2f476e4b_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=65 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `auth_permission` */

insert  into `auth_permission`(`id`,`name`,`content_type_id`,`codename`) values 
(1,'Can add log entry',1,'add_logentry'),
(2,'Can change log entry',1,'change_logentry'),
(3,'Can delete log entry',1,'delete_logentry'),
(4,'Can view log entry',1,'view_logentry'),
(5,'Can add permission',2,'add_permission'),
(6,'Can change permission',2,'change_permission'),
(7,'Can delete permission',2,'delete_permission'),
(8,'Can view permission',2,'view_permission'),
(9,'Can add group',3,'add_group'),
(10,'Can change group',3,'change_group'),
(11,'Can delete group',3,'delete_group'),
(12,'Can view group',3,'view_group'),
(13,'Can add user',4,'add_user'),
(14,'Can change user',4,'change_user'),
(15,'Can delete user',4,'delete_user'),
(16,'Can view user',4,'view_user'),
(17,'Can add content type',5,'add_contenttype'),
(18,'Can change content type',5,'change_contenttype'),
(19,'Can delete content type',5,'delete_contenttype'),
(20,'Can view content type',5,'view_contenttype'),
(21,'Can add session',6,'add_session'),
(22,'Can change session',6,'change_session'),
(23,'Can delete session',6,'delete_session'),
(24,'Can view session',6,'view_session'),
(25,'Can add email address',7,'add_emailaddress'),
(26,'Can change email address',7,'change_emailaddress'),
(27,'Can delete email address',7,'delete_emailaddress'),
(28,'Can view email address',7,'view_emailaddress'),
(29,'Can add email confirmation',8,'add_emailconfirmation'),
(30,'Can change email confirmation',8,'change_emailconfirmation'),
(31,'Can delete email confirmation',8,'delete_emailconfirmation'),
(32,'Can view email confirmation',8,'view_emailconfirmation'),
(33,'Can add Token',9,'add_token'),
(34,'Can change Token',9,'change_token'),
(35,'Can delete Token',9,'delete_token'),
(36,'Can view Token',9,'view_token'),
(37,'Can add Token',10,'add_tokenproxy'),
(38,'Can change Token',10,'change_tokenproxy'),
(39,'Can delete Token',10,'delete_tokenproxy'),
(40,'Can view Token',10,'view_tokenproxy'),
(41,'Can add site',11,'add_site'),
(42,'Can change site',11,'change_site'),
(43,'Can delete site',11,'delete_site'),
(44,'Can view site',11,'view_site'),
(45,'Can add social account',12,'add_socialaccount'),
(46,'Can change social account',12,'change_socialaccount'),
(47,'Can delete social account',12,'delete_socialaccount'),
(48,'Can view social account',12,'view_socialaccount'),
(49,'Can add social application',13,'add_socialapp'),
(50,'Can change social application',13,'change_socialapp'),
(51,'Can delete social application',13,'delete_socialapp'),
(52,'Can view social application',13,'view_socialapp'),
(53,'Can add social application token',14,'add_socialtoken'),
(54,'Can change social application token',14,'change_socialtoken'),
(55,'Can delete social application token',14,'delete_socialtoken'),
(56,'Can view social application token',14,'view_socialtoken'),
(57,'Can add blacklisted token',15,'add_blacklistedtoken'),
(58,'Can change blacklisted token',15,'change_blacklistedtoken'),
(59,'Can delete blacklisted token',15,'delete_blacklistedtoken'),
(60,'Can view blacklisted token',15,'view_blacklistedtoken'),
(61,'Can add outstanding token',16,'add_outstandingtoken'),
(62,'Can change outstanding token',16,'change_outstandingtoken'),
(63,'Can delete outstanding token',16,'delete_outstandingtoken'),
(64,'Can view outstanding token',16,'view_outstandingtoken');

/*Table structure for table `auth_user` */

DROP TABLE IF EXISTS `auth_user`;

CREATE TABLE `auth_user` (
  `id` int NOT NULL AUTO_INCREMENT,
  `password` varchar(128) NOT NULL,
  `last_login` datetime(6) DEFAULT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `username` varchar(150) NOT NULL,
  `first_name` varchar(150) NOT NULL,
  `last_name` varchar(150) NOT NULL,
  `email` varchar(254) NOT NULL,
  `is_staff` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `date_joined` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `auth_user` */

insert  into `auth_user`(`id`,`password`,`last_login`,`is_superuser`,`username`,`first_name`,`last_name`,`email`,`is_staff`,`is_active`,`date_joined`) values 
(1,'pbkdf2_sha256$720000$YtqvJekKO3mgFQAdFjqdbe$5uZsuJIknIJkWAtXXqJ0XZftbLKmkggsUH54rEJEoxM=','2024-06-28 17:21:09.000000',1,'favian','Favian Alejandro','Moreno Calderon','sistemas@putumayo.gov.co',1,1,'2024-06-28 16:02:46.000000'),
(2,'pbkdf2_sha256$720000$kVGQiBt2swhKMal67zxC9O$54nCy89by9GMpmAwE9SDS4pnqZXAA5LT6VTvTj3Fpvs=',NULL,1,'yerson','Yerson','Muñoz Erazo','yerson.munoz@putumayo.gov.co',1,1,'2024-06-28 17:23:16.000000');

/*Table structure for table `auth_user_groups` */

DROP TABLE IF EXISTS `auth_user_groups`;

CREATE TABLE `auth_user_groups` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `group_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_user_groups_user_id_group_id_94350c0c_uniq` (`user_id`,`group_id`),
  KEY `auth_user_groups_group_id_97559544_fk_auth_group_id` (`group_id`),
  CONSTRAINT `auth_user_groups_group_id_97559544_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`),
  CONSTRAINT `auth_user_groups_user_id_6a12ed8b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `auth_user_groups` */

/*Table structure for table `auth_user_user_permissions` */

DROP TABLE IF EXISTS `auth_user_user_permissions`;

CREATE TABLE `auth_user_user_permissions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `permission_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_user_user_permissions_user_id_permission_id_14a6b632_uniq` (`user_id`,`permission_id`),
  KEY `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` (`permission_id`),
  CONSTRAINT `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=49 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `auth_user_user_permissions` */

insert  into `auth_user_user_permissions`(`id`,`user_id`,`permission_id`) values 
(25,1,1),
(26,1,2),
(27,1,3),
(28,1,4),
(29,1,5),
(30,1,6),
(31,1,7),
(32,1,8),
(33,1,9),
(34,1,10),
(35,1,11),
(36,1,12),
(37,1,13),
(38,1,14),
(39,1,15),
(40,1,16),
(41,1,17),
(42,1,18),
(43,1,19),
(44,1,20),
(45,1,21),
(46,1,22),
(47,1,23),
(48,1,24),
(1,2,1),
(2,2,2),
(3,2,3),
(4,2,4),
(5,2,5),
(6,2,6),
(7,2,7),
(8,2,8),
(9,2,9),
(10,2,10),
(11,2,11),
(12,2,12),
(13,2,13),
(14,2,14),
(15,2,15),
(16,2,16),
(17,2,17),
(18,2,18),
(19,2,19),
(20,2,20),
(21,2,21),
(22,2,22),
(23,2,23),
(24,2,24);

/*Table structure for table `authtoken_token` */

DROP TABLE IF EXISTS `authtoken_token`;

CREATE TABLE `authtoken_token` (
  `key` varchar(40) NOT NULL,
  `created` datetime(6) NOT NULL,
  `user_id` int NOT NULL,
  PRIMARY KEY (`key`),
  UNIQUE KEY `user_id` (`user_id`),
  CONSTRAINT `authtoken_token_user_id_35299eff_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `authtoken_token` */

/*Table structure for table `cities` */

DROP TABLE IF EXISTS `cities`;

CREATE TABLE `cities` (
  `id` int NOT NULL AUTO_INCREMENT,
  `code` varchar(10) DEFAULT NULL,
  `name` varchar(60) DEFAULT NULL,
  `department_id` int DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1126 DEFAULT CHARSET=utf8mb3;

/*Data for the table `cities` */

insert  into `cities`(`id`,`code`,`name`,`department_id`) values 
(1,'001','Medellín',5),
(2,'002','Abejorral',5),
(3,'004','Abriaquí',5),
(4,'021','Alejandría',5),
(5,'030','Amagá',5),
(6,'031','Amalfi',5),
(7,'034','Andes',5),
(8,'036','Angelópolis',5),
(9,'038','Angostura',5),
(10,'040','Anorí',5),
(11,'832','Tununguá',15),
(12,'044','Anza',5),
(13,'045','Apartadó',5),
(14,'051','Arboletes',5),
(15,'055','Argelia',5),
(16,'059','Armenia',5),
(17,'079','Barbosa',5),
(18,'088','Bello',5),
(19,'091','Betania',5),
(20,'093','Betulia',5),
(21,'101','Ciudad Bolívar',5),
(22,'107','Briceño',5),
(23,'113','Buriticá',5),
(24,'120','Cáceres',5),
(25,'125','Caicedo',5),
(26,'129','Caldas',5),
(27,'134','Campamento',5),
(28,'138','Cañasgordas',5),
(29,'142','Caracolí',5),
(30,'145','Caramanta',5),
(31,'147','Carepa',5),
(32,'476','Motavita',15),
(33,'150','Carolina',5),
(34,'154','Caucasia',5),
(35,'172','Chigorodó',5),
(36,'190','Cisneros',5),
(37,'197','Cocorná',5),
(38,'206','Concepción',5),
(39,'209','Concordia',5),
(40,'212','Copacabana',5),
(41,'234','Dabeiba',5),
(42,'237','Don Matías',5),
(43,'240','Ebéjico',5),
(44,'250','El Bagre',5),
(45,'264','Entrerrios',5),
(46,'266','Envigado',5),
(47,'282','Fredonia',5),
(48,'675','San Bernardo del Viento',23),
(49,'306','Giraldo',5),
(50,'308','Girardota',5),
(51,'310','Gómez Plata',5),
(52,'361','Istmina',27),
(53,'315','Guadalupe',5),
(54,'318','Guarne',5),
(55,'321','Guatapé',5),
(56,'347','Heliconia',5),
(57,'353','Hispania',5),
(58,'360','Itagui',5),
(59,'361','Ituango',5),
(60,'086','Belmira',5),
(61,'368','Jericó',5),
(62,'376','La Ceja',5),
(63,'380','La Estrella',5),
(64,'390','La Pintada',5),
(65,'400','La Unión',5),
(66,'411','Liborina',5),
(67,'425','Maceo',5),
(68,'440','Marinilla',5),
(69,'467','Montebello',5),
(70,'475','Murindó',5),
(71,'480','Mutatá',5),
(72,'483','Nariño',5),
(73,'490','Necoclí',5),
(74,'495','Nechí',5),
(75,'501','Olaya',5),
(76,'541','Peñol',5),
(77,'543','Peque',5),
(78,'576','Pueblorrico',5),
(79,'579','Puerto Berrío',5),
(80,'585','Puerto Nare',5),
(81,'591','Puerto Triunfo',5),
(82,'604','Remedios',5),
(83,'607','Retiro',5),
(84,'615','Rionegro',5),
(85,'628','Sabanalarga',5),
(86,'631','Sabaneta',5),
(87,'642','Salgar',5),
(88,'189','Ciénega',15),
(89,'699','Santacruz',52),
(90,'652','San Francisco',5),
(91,'656','San Jerónimo',5),
(92,'575','Puerto Wilches',68),
(93,'573','Puerto Parra',68),
(94,'660','San Luis',5),
(95,'664','San Pedro',5),
(96,'667','San Rafael',5),
(97,'670','San Roque',5),
(98,'674','San Vicente',5),
(99,'679','Santa Bárbara',5),
(100,'690','Santo Domingo',5),
(101,'697','El Santuario',5),
(102,'736','Segovia',5),
(103,'761','Sopetrán',5),
(104,'370','Uribe',50),
(105,'789','Támesis',5),
(106,'790','Tarazá',5),
(107,'792','Tarso',5),
(108,'809','Titiribí',5),
(109,'819','Toledo',5),
(110,'837','Turbo',5),
(111,'842','Uramita',5),
(112,'847','Urrao',5),
(113,'854','Valdivia',5),
(114,'856','Valparaíso',5),
(115,'858','Vegachí',5),
(116,'861','Venecia',5),
(117,'885','Yalí',5),
(118,'887','Yarumal',5),
(119,'890','Yolombó',5),
(120,'893','Yondó',5),
(121,'895','Zaragoza',5),
(122,'001','Barranquilla',8),
(123,'078','Baranoa',8),
(124,'141','Candelaria',8),
(125,'296','Galapa',8),
(126,'421','Luruaco',8),
(127,'433','Malambo',8),
(128,'436','Manatí',8),
(129,'549','Piojó',8),
(130,'558','Polonuevo',8),
(131,'634','Sabanagrande',8),
(132,'638','Sabanalarga',8),
(133,'675','Santa Lucía',8),
(134,'685','Santo Tomás',8),
(135,'758','Soledad',8),
(136,'770','Suan',8),
(137,'832','Tubará',8),
(138,'849','Usiacurí',8),
(139,'006','Achí',13),
(140,'042','Arenal',13),
(141,'052','Arjona',13),
(142,'062','Arroyohondo',13),
(143,'140','Calamar',13),
(144,'160','Cantagallo',13),
(145,'188','Cicuco',13),
(146,'212','Córdoba',13),
(147,'222','Clemencia',13),
(148,'248','El Guamo',13),
(149,'430','Magangué',13),
(150,'433','Mahates',13),
(151,'440','Margarita',13),
(152,'458','Montecristo',13),
(153,'468','Mompós',13),
(154,'473','Morales',13),
(155,'490','Norosí',13),
(156,'549','Pinillos',13),
(157,'580','Regidor',13),
(158,'600','Río Viejo',13),
(159,'647','San Estanislao',13),
(160,'650','San Fernando',13),
(161,'657','San Juan Nepomuceno',13),
(162,'673','Santa Catalina',13),
(163,'683','Santa Rosa',13),
(164,'744','Simití',13),
(165,'760','Soplaviento',13),
(166,'780','Talaigua Nuevo',13),
(167,'810','Tiquisio',13),
(168,'836','Turbaco',13),
(169,'838','Turbaná',13),
(170,'873','Villanueva',13),
(171,'001','Tunja',15),
(172,'022','Almeida',15),
(173,'047','Aquitania',15),
(174,'051','Arcabuco',15),
(175,'090','Berbeo',15),
(176,'092','Betéitiva',15),
(177,'097','Boavita',15),
(178,'104','Boyacá',15),
(179,'106','Briceño',15),
(180,'109','Buena Vista',15),
(181,'114','Busbanzá',15),
(182,'131','Caldas',15),
(183,'135','Campohermoso',15),
(184,'162','Cerinza',15),
(185,'172','Chinavita',15),
(186,'176','Chiquinquirá',15),
(187,'180','Chiscas',15),
(188,'183','Chita',15),
(189,'185','Chitaraque',15),
(190,'187','Chivatá',15),
(191,'204','Cómbita',15),
(192,'212','Coper',15),
(193,'215','Corrales',15),
(194,'218','Covarachía',15),
(195,'223','Cubará',15),
(196,'224','Cucaita',15),
(197,'226','Cuítiva',15),
(198,'232','Chíquiza',15),
(199,'236','Chivor',15),
(200,'238','Duitama',15),
(201,'244','El Cocuy',15),
(202,'248','El Espino',15),
(203,'272','Firavitoba',15),
(204,'276','Floresta',15),
(205,'293','Gachantivá',15),
(206,'296','Gameza',15),
(207,'299','Garagoa',15),
(208,'317','Guacamayas',15),
(209,'322','Guateque',15),
(210,'325','Guayatá',15),
(211,'332','Güicán',15),
(212,'362','Iza',15),
(213,'367','Jenesano',15),
(214,'368','Jericó',15),
(215,'377','Labranzagrande',15),
(216,'380','La Capilla',15),
(217,'401','La Victoria',15),
(218,'425','Macanal',15),
(219,'442','Maripí',15),
(220,'455','Miraflores',15),
(221,'464','Mongua',15),
(222,'466','Monguí',15),
(223,'469','Moniquirá',15),
(224,'480','Muzo',15),
(225,'491','Nobsa',15),
(226,'494','Nuevo Colón',15),
(227,'500','Oicatá',15),
(228,'507','Otanche',15),
(229,'511','Pachavita',15),
(230,'514','Páez',15),
(231,'516','Paipa',15),
(232,'518','Pajarito',15),
(233,'522','Panqueba',15),
(234,'531','Pauna',15),
(235,'533','Paya',15),
(236,'542','Pesca',15),
(237,'550','Pisba',15),
(238,'572','Puerto Boyacá',15),
(239,'580','Quípama',15),
(240,'599','Ramiriquí',15),
(241,'600','Ráquira',15),
(242,'621','Rondón',15),
(243,'632','Saboyá',15),
(244,'638','Sáchica',15),
(245,'646','Samacá',15),
(246,'660','San Eduardo',15),
(247,'673','San Mateo',15),
(248,'686','Santana',15),
(249,'690','Santa María',15),
(250,'696','Santa Sofía',15),
(251,'720','Sativanorte',15),
(252,'723','Sativasur',15),
(253,'740','Siachoque',15),
(254,'753','Soatá',15),
(255,'755','Socotá',15),
(256,'757','Socha',15),
(257,'759','Sogamoso',15),
(258,'761','Somondoco',15),
(259,'762','Sora',15),
(260,'763','Sotaquirá',15),
(261,'764','Soracá',15),
(262,'774','Susacón',15),
(263,'776','Sutamarchán',15),
(264,'778','Sutatenza',15),
(265,'790','Tasco',15),
(266,'798','Tenza',15),
(267,'804','Tibaná',15),
(268,'808','Tinjacá',15),
(269,'810','Tipacoque',15),
(270,'814','Toca',15),
(271,'820','Tópaga',15),
(272,'822','Tota',15),
(273,'835','Turmequé',15),
(274,'839','Tutazá',15),
(275,'842','Umbita',15),
(276,'861','Ventaquemada',15),
(277,'879','Viracachá',15),
(278,'897','Zetaquira',15),
(279,'001','Manizales',17),
(280,'013','Aguadas',17),
(281,'042','Anserma',17),
(282,'050','Aranzazu',17),
(283,'088','Belalcázar',17),
(284,'174','Chinchiná',17),
(285,'272','Filadelfia',17),
(286,'380','La Dorada',17),
(287,'388','La Merced',17),
(288,'433','Manzanares',17),
(289,'442','Marmato',17),
(290,'446','Marulanda',17),
(291,'486','Neira',17),
(292,'495','Norcasia',17),
(293,'513','Pácora',17),
(294,'524','Palestina',17),
(295,'541','Pensilvania',17),
(296,'614','Riosucio',17),
(297,'616','Risaralda',17),
(298,'653','Salamina',17),
(299,'662','Samaná',17),
(300,'665','San José',17),
(301,'777','Supía',17),
(302,'867','Victoria',17),
(303,'873','Villamaría',17),
(304,'877','Viterbo',17),
(305,'001','Florencia',18),
(306,'029','Albania',18),
(307,'205','Curillo',18),
(308,'247','El Doncello',18),
(309,'256','El Paujil',18),
(310,'479','Morelia',18),
(311,'592','Puerto Rico',18),
(312,'756','Solano',18),
(313,'785','Solita',18),
(314,'860','Valparaíso',18),
(315,'001','Popayán',19),
(316,'022','Almaguer',19),
(317,'050','Argelia',19),
(318,'075','Balboa',19),
(319,'100','Bolívar',19),
(320,'110','Buenos Aires',19),
(321,'130','Cajibío',19),
(322,'137','Caldono',19),
(323,'142','Caloto',19),
(324,'212','Corinto',19),
(325,'256','El Tambo',19),
(326,'290','Florencia',19),
(327,'300','Guachené',19),
(328,'318','Guapi',19),
(329,'355','Inzá',19),
(330,'364','Jambaló',19),
(331,'392','La Sierra',19),
(332,'397','La Vega',19),
(333,'418','López',19),
(334,'450','Mercaderes',19),
(335,'455','Miranda',19),
(336,'473','Morales',19),
(337,'513','Padilla',19),
(338,'532','Patía',19),
(339,'533','Piamonte',19),
(340,'548','Piendamó',19),
(341,'573','Puerto Tejada',19),
(342,'585','Puracé',19),
(343,'622','Rosas',19),
(344,'701','Santa Rosa',19),
(345,'743','Silvia',19),
(346,'760','Sotara',19),
(347,'780','Suárez',19),
(348,'785','Sucre',19),
(349,'807','Timbío',19),
(350,'809','Timbiquí',19),
(351,'821','Toribio',19),
(352,'824','Totoró',19),
(353,'845','Villa Rica',19),
(354,'001','Valledupar',20),
(355,'011','Aguachica',20),
(356,'013','Agustín Codazzi',20),
(357,'032','Astrea',20),
(358,'045','Becerril',20),
(359,'060','Bosconia',20),
(360,'175','Chimichagua',20),
(361,'178','Chiriguaná',20),
(362,'228','Curumaní',20),
(363,'238','El Copey',20),
(364,'250','El Paso',20),
(365,'295','Gamarra',20),
(366,'310','González',20),
(367,'383','La Gloria',20),
(368,'443','Manaure',20),
(369,'517','Pailitas',20),
(370,'550','Pelaya',20),
(371,'570','Pueblo Bello',20),
(372,'621','La Paz',20),
(373,'710','San Alberto',20),
(374,'750','San Diego',20),
(375,'770','San Martín',20),
(376,'787','Tamalameque',20),
(377,'001','Montería',23),
(378,'068','Ayapel',23),
(379,'079','Buenavista',23),
(380,'090','Canalete',23),
(381,'162','Cereté',23),
(382,'168','Chimá',23),
(383,'182','Chinú',23),
(384,'300','Cotorra',23),
(385,'417','Lorica',23),
(386,'419','Los Córdobas',23),
(387,'464','Momil',23),
(388,'500','Moñitos',23),
(389,'555','Planeta Rica',23),
(390,'570','Pueblo Nuevo',23),
(391,'574','Puerto Escondido',23),
(392,'586','Purísima',23),
(393,'660','Sahagún',23),
(394,'670','San Andrés Sotavento',23),
(395,'672','San Antero',23),
(396,'686','San Pelayo',23),
(397,'807','Tierralta',23),
(398,'815','Tuchín',23),
(399,'855','Valencia',23),
(400,'035','Anapoima',25),
(401,'053','Arbeláez',25),
(402,'086','Beltrán',25),
(403,'095','Bituima',25),
(404,'099','Bojacá',25),
(405,'120','Cabrera',25),
(406,'123','Cachipay',25),
(407,'126','Cajicá',25),
(408,'148','Caparrapí',25),
(409,'151','Caqueza',25),
(410,'168','Chaguaní',25),
(411,'178','Chipaque',25),
(412,'181','Choachí',25),
(413,'183','Chocontá',25),
(414,'200','Cogua',25),
(415,'214','Cota',25),
(416,'224','Cucunubá',25),
(417,'245','El Colegio',25),
(418,'260','El Rosal',25),
(419,'279','Fomeque',25),
(420,'281','Fosca',25),
(421,'286','Funza',25),
(422,'288','Fúquene',25),
(423,'293','Gachala',25),
(424,'295','Gachancipá',25),
(425,'297','Gachetá',25),
(426,'307','Girardot',25),
(427,'312','Granada',25),
(428,'317','Guachetá',25),
(429,'320','Guaduas',25),
(430,'322','Guasca',25),
(431,'324','Guataquí',25),
(432,'326','Guatavita',25),
(433,'335','Guayabetal',25),
(434,'339','Gutiérrez',25),
(435,'368','Jerusalén',25),
(436,'372','Junín',25),
(437,'377','La Calera',25),
(438,'386','La Mesa',25),
(439,'394','La Palma',25),
(440,'398','La Peña',25),
(441,'402','La Vega',25),
(442,'407','Lenguazaque',25),
(443,'426','Macheta',25),
(444,'430','Madrid',25),
(445,'436','Manta',25),
(446,'438','Medina',25),
(447,'473','Mosquera',25),
(448,'483','Nariño',25),
(449,'486','Nemocón',25),
(450,'488','Nilo',25),
(451,'489','Nimaima',25),
(452,'491','Nocaima',25),
(453,'506','Venecia',25),
(454,'513','Pacho',25),
(455,'518','Paime',25),
(456,'524','Pandi',25),
(457,'530','Paratebueno',25),
(458,'535','Pasca',25),
(459,'572','Puerto Salgar',25),
(460,'580','Pulí',25),
(461,'592','Quebradanegra',25),
(462,'594','Quetame',25),
(463,'596','Quipile',25),
(464,'599','Apulo',25),
(465,'612','Ricaurte',25),
(466,'649','San Bernardo',25),
(467,'653','San Cayetano',25),
(468,'658','San Francisco',25),
(469,'736','Sesquilé',25),
(470,'740','Sibaté',25),
(471,'743','Silvania',25),
(472,'745','Simijaca',25),
(473,'754','Soacha',25),
(474,'769','Subachoque',25),
(475,'772','Suesca',25),
(476,'777','Supatá',25),
(477,'779','Susa',25),
(478,'781','Sutatausa',25),
(479,'785','Tabio',25),
(480,'793','Tausa',25),
(481,'797','Tena',25),
(482,'799','Tenjo',25),
(483,'805','Tibacuy',25),
(484,'807','Tibirita',25),
(485,'815','Tocaima',25),
(486,'817','Tocancipá',25),
(487,'823','Topaipí',25),
(488,'839','Ubalá',25),
(489,'841','Ubaque',25),
(490,'845','Une',25),
(491,'851','Útica',25),
(492,'867','Vianí',25),
(493,'871','Villagómez',25),
(494,'873','Villapinzón',25),
(495,'875','Villeta',25),
(496,'878','Viotá',25),
(497,'898','Zipacón',25),
(498,'001','Quibdó',27),
(499,'006','Acandí',27),
(500,'025','Alto Baudo',27),
(501,'050','Atrato',27),
(502,'073','Bagadó',27),
(503,'075','Bahía Solano',27),
(504,'077','Bajo Baudó',27),
(505,'099','Bojaya',27),
(506,'160','Cértegui',27),
(507,'205','Condoto',27),
(508,'372','Juradó',27),
(509,'413','Lloró',27),
(510,'425','Medio Atrato',27),
(511,'430','Medio Baudó',27),
(512,'450','Medio San Juan',27),
(513,'491','Nóvita',27),
(514,'495','Nuquí',27),
(515,'580','Río Iro',27),
(516,'600','Río Quito',27),
(517,'615','Riosucio',27),
(518,'745','Sipí',27),
(519,'800','Unguía',27),
(520,'001','Neiva',41),
(521,'006','Acevedo',41),
(522,'013','Agrado',41),
(523,'016','Aipe',41),
(524,'020','Algeciras',41),
(525,'026','Altamira',41),
(526,'078','Baraya',41),
(527,'132','Campoalegre',41),
(528,'206','Colombia',41),
(529,'244','Elías',41),
(530,'298','Garzón',41),
(531,'306','Gigante',41),
(532,'319','Guadalupe',41),
(533,'349','Hobo',41),
(534,'357','Iquira',41),
(535,'359','Isnos',41),
(536,'378','La Argentina',41),
(537,'396','La Plata',41),
(538,'483','Nátaga',41),
(539,'503','Oporapa',41),
(540,'518','Paicol',41),
(541,'524','Palermo',41),
(542,'530','Palestina',41),
(543,'548','Pital',41),
(544,'551','Pitalito',41),
(545,'615','Rivera',41),
(546,'660','Saladoblanco',41),
(547,'676','Santa María',41),
(548,'770','Suaza',41),
(549,'791','Tarqui',41),
(550,'797','Tesalia',41),
(551,'799','Tello',41),
(552,'801','Teruel',41),
(553,'807','Timaná',41),
(554,'872','Villavieja',41),
(555,'885','Yaguará',41),
(556,'001','Riohacha',44),
(557,'035','Albania',44),
(558,'078','Barrancas',44),
(559,'090','Dibula',44),
(560,'098','Distracción',44),
(561,'110','El Molino',44),
(562,'279','Fonseca',44),
(563,'378','Hatonuevo',44),
(564,'430','Maicao',44),
(565,'560','Manaure',44),
(566,'847','Uribia',44),
(567,'855','Urumita',44),
(568,'874','Villanueva',44),
(569,'001','Santa Marta',47),
(570,'030','Algarrobo',47),
(571,'053','Aracataca',47),
(572,'058','Ariguaní',47),
(573,'161','Cerro San Antonio',47),
(574,'170','Chivolo',47),
(575,'205','Concordia',47),
(576,'245','El Banco',47),
(577,'258','El Piñon',47),
(578,'268','El Retén',47),
(579,'288','Fundación',47),
(580,'318','Guamal',47),
(581,'460','Nueva Granada',47),
(582,'541','Pedraza',47),
(583,'551','Pivijay',47),
(584,'555','Plato',47),
(585,'605','Remolino',47),
(586,'675','Salamina',47),
(587,'703','San Zenón',47),
(588,'707','Santa Ana',47),
(589,'745','Sitionuevo',47),
(590,'798','Tenerife',47),
(591,'960','Zapayán',47),
(592,'980','Zona Bananera',47),
(593,'001','Villavicencio',50),
(594,'006','Acacias',50),
(595,'124','Cabuyaro',50),
(596,'223','Cubarral',50),
(597,'226','Cumaral',50),
(598,'245','El Calvario',50),
(599,'251','El Castillo',50),
(600,'270','El Dorado',50),
(601,'313','Granada',50),
(602,'318','Guamal',50),
(603,'325','Mapiripán',50),
(604,'330','Mesetas',50),
(605,'350','La Macarena',50),
(606,'400','Lejanías',50),
(607,'450','Puerto Concordia',50),
(608,'568','Puerto Gaitán',50),
(609,'573','Puerto López',50),
(610,'577','Puerto Lleras',50),
(611,'590','Puerto Rico',50),
(612,'606','Restrepo',50),
(613,'686','San Juanito',50),
(614,'689','San Martín',50),
(615,'711','Vista Hermosa',50),
(616,'001','Pasto',52),
(617,'019','Albán',52),
(618,'022','Aldana',52),
(619,'036','Ancuyá',52),
(620,'079','Barbacoas',52),
(621,'203','Colón',52),
(622,'207','Consaca',52),
(623,'210','Contadero',52),
(624,'215','Córdoba',52),
(625,'224','Cuaspud',52),
(626,'227','Cumbal',52),
(627,'233','Cumbitara',52),
(628,'250','El Charco',52),
(629,'254','El Peñol',52),
(630,'256','El Rosario',52),
(631,'260','El Tambo',52),
(632,'287','Funes',52),
(633,'317','Guachucal',52),
(634,'320','Guaitarilla',52),
(635,'323','Gualmatán',52),
(636,'352','Iles',52),
(637,'354','Imués',52),
(638,'356','Ipiales',52),
(639,'378','La Cruz',52),
(640,'381','La Florida',52),
(641,'385','La Llanada',52),
(642,'390','La Tola',52),
(643,'399','La Unión',52),
(644,'405','Leiva',52),
(645,'411','Linares',52),
(646,'418','Los Andes',52),
(647,'427','Magüí',52),
(648,'435','Mallama',52),
(649,'473','Mosquera',52),
(650,'480','Nariño',52),
(651,'490','Olaya Herrera',52),
(652,'506','Ospina',52),
(653,'520','Francisco Pizarro',52),
(654,'540','Policarpa',52),
(655,'560','Potosí',52),
(656,'565','Providencia',52),
(657,'573','Puerres',52),
(658,'585','Pupiales',52),
(659,'612','Ricaurte',52),
(660,'621','Roberto Payán',52),
(661,'678','Samaniego',52),
(662,'683','Sandoná',52),
(663,'685','San Bernardo',52),
(664,'687','San Lorenzo',52),
(665,'693','San Pablo',52),
(666,'696','Santa Bárbara',52),
(667,'720','Sapuyes',52),
(668,'786','Taminango',52),
(669,'788','Tangua',52),
(670,'838','Túquerres',52),
(671,'885','Yacuanquer',52),
(672,'001','Armenia',63),
(673,'111','Buenavista',63),
(674,'190','Circasia',63),
(675,'212','Córdoba',63),
(676,'272','Filandia',63),
(677,'401','La Tebaida',63),
(678,'470','Montenegro',63),
(679,'548','Pijao',63),
(680,'594','Quimbaya',63),
(681,'690','Salento',63),
(682,'001','Pereira',66),
(683,'045','Apía',66),
(684,'075','Balboa',66),
(685,'170','Dosquebradas',66),
(686,'318','Guática',66),
(687,'383','La Celia',66),
(688,'400','La Virginia',66),
(689,'440','Marsella',66),
(690,'456','Mistrató',66),
(691,'572','Pueblo Rico',66),
(692,'594','Quinchía',66),
(693,'687','Santuario',66),
(694,'001','Bucaramanga',68),
(695,'013','Aguada',68),
(696,'020','Albania',68),
(697,'051','Aratoca',68),
(698,'077','Barbosa',68),
(699,'079','Barichara',68),
(700,'081','Barrancabermeja',68),
(701,'092','Betulia',68),
(702,'101','Bolívar',68),
(703,'121','Cabrera',68),
(704,'132','California',68),
(705,'152','Carcasí',68),
(706,'160','Cepitá',68),
(707,'162','Cerrito',68),
(708,'167','Charalá',68),
(709,'169','Charta',68),
(710,'179','Chipatá',68),
(711,'190','Cimitarra',68),
(712,'207','Concepción',68),
(713,'209','Confines',68),
(714,'211','Contratación',68),
(715,'217','Coromoro',68),
(716,'229','Curití',68),
(717,'245','El Guacamayo',68),
(718,'255','El Playón',68),
(719,'264','Encino',68),
(720,'266','Enciso',68),
(721,'271','Florián',68),
(722,'276','Floridablanca',68),
(723,'296','Galán',68),
(724,'298','Gambita',68),
(725,'307','Girón',68),
(726,'318','Guaca',68),
(727,'320','Guadalupe',68),
(728,'322','Guapotá',68),
(729,'324','Guavatá',68),
(730,'327','Güepsa',68),
(731,'368','Jesús María',68),
(732,'370','Jordán',68),
(733,'377','La Belleza',68),
(734,'385','Landázuri',68),
(735,'397','La Paz',68),
(736,'406','Lebríja',68),
(737,'418','Los Santos',68),
(738,'425','Macaravita',68),
(739,'432','Málaga',68),
(740,'444','Matanza',68),
(741,'464','Mogotes',68),
(742,'468','Molagavita',68),
(743,'498','Ocamonte',68),
(744,'500','Oiba',68),
(745,'502','Onzaga',68),
(746,'522','Palmar',68),
(747,'533','Páramo',68),
(748,'547','Piedecuesta',68),
(749,'549','Pinchote',68),
(750,'572','Puente Nacional',68),
(751,'615','Rionegro',68),
(752,'669','San Andrés',68),
(753,'679','San Gil',68),
(754,'682','San Joaquín',68),
(755,'686','San Miguel',68),
(756,'705','Santa Bárbara',68),
(757,'745','Simacota',68),
(758,'755','Socorro',68),
(759,'770','Suaita',68),
(760,'773','Sucre',68),
(761,'780','Suratá',68),
(762,'820','Tona',68),
(763,'861','Vélez',68),
(764,'867','Vetas',68),
(765,'872','Villanueva',68),
(766,'895','Zapatoca',68),
(767,'001','Sincelejo',70),
(768,'110','Buenavista',70),
(769,'124','Caimito',70),
(770,'204','Coloso',70),
(771,'221','Coveñas',70),
(772,'230','Chalán',70),
(773,'233','El Roble',70),
(774,'235','Galeras',70),
(775,'265','Guaranda',70),
(776,'400','La Unión',70),
(777,'418','Los Palmitos',70),
(778,'429','Majagual',70),
(779,'473','Morroa',70),
(780,'508','Ovejas',70),
(781,'523','Palmito',70),
(782,'678','San Benito Abad',70),
(783,'708','San Marcos',70),
(784,'713','San Onofre',70),
(785,'717','San Pedro',70),
(786,'771','Sucre',70),
(787,'823','Tolú Viejo',70),
(788,'024','Alpujarra',73),
(789,'026','Alvarado',73),
(790,'030','Ambalema',73),
(791,'055','Armero',73),
(792,'067','Ataco',73),
(793,'124','Cajamarca',73),
(794,'168','Chaparral',73),
(795,'200','Coello',73),
(796,'217','Coyaima',73),
(797,'226','Cunday',73),
(798,'236','Dolores',73),
(799,'268','Espinal',73),
(800,'270','Falan',73),
(801,'275','Flandes',73),
(802,'283','Fresno',73),
(803,'319','Guamo',73),
(804,'347','Herveo',73),
(805,'349','Honda',73),
(806,'352','Icononzo',73),
(807,'443','Mariquita',73),
(808,'449','Melgar',73),
(809,'461','Murillo',73),
(810,'483','Natagaima',73),
(811,'504','Ortega',73),
(812,'520','Palocabildo',73),
(813,'547','Piedras',73),
(814,'555','Planadas',73),
(815,'563','Prado',73),
(816,'585','Purificación',73),
(817,'616','Rio Blanco',73),
(818,'622','Roncesvalles',73),
(819,'624','Rovira',73),
(820,'671','Saldaña',73),
(821,'686','Santa Isabel',73),
(822,'861','Venadillo',73),
(823,'870','Villahermosa',73),
(824,'873','Villarrica',73),
(825,'065','Arauquita',81),
(826,'220','Cravo Norte',81),
(827,'300','Fortul',81),
(828,'591','Puerto Rondón',81),
(829,'736','Saravena',81),
(830,'794','Tame',81),
(831,'001','Arauca',81),
(832,'001','Yopal',85),
(833,'010','Aguazul',85),
(834,'015','Chámeza',85),
(835,'125','Hato Corozal',85),
(836,'136','La Salina',85),
(837,'162','Monterrey',85),
(838,'263','Pore',85),
(839,'279','Recetor',85),
(840,'300','Sabanalarga',85),
(841,'315','Sácama',85),
(842,'410','Tauramena',85),
(843,'430','Trinidad',85),
(844,'440','Villanueva',85),
(845,'001','Mocoa',86),
(846,'219','Colón',86),
(847,'320','Orito',86),
(848,'569','Puerto Caicedo',86),
(849,'571','Puerto Guzmán',86),
(850,'573','Leguízamo',86),
(851,'749','Sibundoy',86),
(852,'755','San Francisco',86),
(853,'757','San Miguel',86),
(854,'760','Santiago',86),
(855,'001','Leticia',91),
(856,'263','El Encanto',91),
(857,'405','La Chorrera',91),
(858,'407','La Pedrera',91),
(859,'430','La Victoria',91),
(860,'536','Puerto Arica',91),
(861,'540','Puerto Nariño',91),
(862,'669','Puerto Santander',91),
(863,'798','Tarapacá',91),
(864,'001','Inírida',94),
(865,'343','Barranco Minas',94),
(866,'663','Mapiripana',94),
(867,'883','San Felipe',94),
(868,'884','Puerto Colombia',94),
(869,'885','La Guadalupe',94),
(870,'886','Cacahual',94),
(871,'887','Pana Pana',94),
(872,'001','Mitú',97),
(873,'161','Carurú',97),
(874,'666','Taraira',97),
(875,'777','Papunahua',97),
(876,'889','Yavaraté',97),
(877,'511','Pacoa',97),
(878,'888','Morichal',94),
(879,'001','Puerto Carreño',99),
(880,'524','La Primavera',99),
(881,'624','Santa Rosalía',99),
(882,'773','Cumaribo',99),
(883,'610','San José del Fragua',18),
(884,'110','Barranca de Upía',50),
(885,'524','Palmas del Socorro',68),
(886,'662','San Juan de Río Seco',25),
(887,'372','Juan de Acosta',8),
(888,'287','Fuente de Oro',50),
(889,'325','San Luis de Gaceno',85),
(890,'250','El Litoral del San Juan',27),
(891,'843','Villa de San Diego de Ubate',25),
(892,'074','Barranco de Loba',13),
(893,'816','Togüí',15),
(894,'688','Santa Rosa del Sur',13),
(895,'135','El Cantón del San Pablo',27),
(896,'407','Villa de Leyva',15),
(897,'692','San Sebastián de Buenavista',47),
(898,'537','Paz de Río',15),
(899,'300','Hatillo de Loba',13),
(900,'660','Sabanas de San Angel',47),
(901,'015','Calamar',95),
(902,'614','Río de Oro',20),
(903,'665','San Pedro de Uraba',5),
(904,'001','San José del Guaviare',95),
(905,'693','Santa Rosa de Viterbo',15),
(906,'698','Santander de Quilichao',19),
(907,'200','Miraflores',95),
(908,'042','Santafé de Antioquia',5),
(909,'680','San Carlos de Guaroa',50),
(910,'520','Palmar de Varela',8),
(911,'686','Santa Rosa de Osos',5),
(912,'647','San Andrés de Cuerquía',5),
(913,'854','Valle de San Juan',73),
(914,'689','San Vicente de Chucurí',68),
(915,'684','San José de Miranda',68),
(916,'564','Providencia',88),
(917,'682','Santa Rosa de Cabal',66),
(918,'328','Guayabal de Siquima',25),
(919,'094','Belén de Los Andaquies',18),
(920,'250','Paz de Ariporo',85),
(921,'720','Santa Helena del Opón',68),
(922,'681','San Pablo de Borbur',15),
(923,'420','La Jagua del Pilar',44),
(924,'400','La Jagua de Ibirico',20),
(925,'742','San Luis de Sincé',70),
(926,'667','San Luis de Gaceno',15),
(927,'244','El Carmen de Bolívar',13),
(928,'245','El Carmen de Atrato',27),
(929,'702','San Juan de Betulia',70),
(930,'545','Pijiño del Carmen',47),
(931,'873','Vigía del Fuerte',5),
(932,'667','San Martín de Loba',13),
(933,'030','Altos del Rosario',13),
(934,'148','Carmen de Apicala',73),
(935,'645','San Antonio del Tequendama',25),
(936,'655','Sabana de Torres',68),
(937,'025','El Retorno',95),
(938,'682','San José de Uré',23),
(939,'694','San Pedro de Cartago',52),
(940,'137','Campo de La Cruz',8),
(941,'683','San Juan de Arama',50),
(942,'658','San José de La Montaña',5),
(943,'150','Cartagena del Chairá',18),
(944,'660','San José del Palmar',27),
(945,'001','Agua de Dios',25),
(946,'655','San Jacinto del Cauca',13),
(947,'668','San Agustín',41),
(948,'258','El Tablón de Gómez',52),
(949,'001','San Andrés',88),
(950,'664','San José de Pare',15),
(951,'865','Valle de Guamez',86),
(952,'670','San Pablo de Borbur',13),
(953,'820','Santiago de Tolú',70),
(954,'001','Bogotá D.C.',11),
(955,'154','Carmen de Carupa',25),
(956,'189','Ciénaga de Oro',23),
(957,'659','San Juan de Urabá',5),
(958,'650','San Juan del Cesar',44),
(959,'235','El Carmen de Chucurí',68),
(960,'148','El Carmen de Viboral',5),
(961,'088','Belén de Umbría',66),
(962,'086','Belén de Bajira',27),
(963,'855','Valle de San José',68),
(964,'678','San Luis',73),
(965,'676','San Miguel de Sema',15),
(966,'675','San Antonio',73),
(967,'673','San Benito',68),
(968,'862','Vergara',25),
(969,'678','San Carlos',23),
(970,'530','Puerto Alegría',91),
(971,'344','Hato',68),
(972,'654','San Jacinto',13),
(973,'693','San Sebastián',19),
(974,'649','San Carlos',5),
(975,'837','Tuta',15),
(976,'743','Silos',54),
(977,'125','Cácota',54),
(978,'250','El Dovio',76),
(979,'820','Toledo',54),
(980,'622','Roldanillo',76),
(981,'480','Mutiscua',54),
(982,'054','Argelia',76),
(983,'261','El Zulia',54),
(984,'660','Salazar',54),
(985,'736','Sevilla',76),
(986,'895','Zarzal',76),
(987,'223','Cucutilla',54),
(988,'248','El Cerrito',76),
(989,'147','Cartago',76),
(990,'122','Caicedonia',76),
(991,'553','Puerto Santander',54),
(992,'313','Gramalote',54),
(993,'246','El Cairo',76),
(994,'250','El Tarra',54),
(995,'400','La Unión',76),
(996,'606','Restrepo',76),
(997,'800','Teorama',54),
(998,'233','Dagua',76),
(999,'051','Arboledas',54),
(1000,'318','Guacarí',76),
(1001,'610','Villagarzón',86),
(1002,'568','Puerto Asis',86),
(1124,'610','Villagarzón',86),
(1125,'568','Puerto Asis',86);

/*Table structure for table `departments` */

DROP TABLE IF EXISTS `departments`;

CREATE TABLE `departments` (
  `id` int NOT NULL AUTO_INCREMENT,
  `code` int NOT NULL,
  `name` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `pcode` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=utf8mb3;

/*Data for the table `departments` */

insert  into `departments`(`id`,`code`,`name`) values 
(1,5,'Antioquia'),
(2,8,'Atlántico'),
(3,11,'Bogotá D.C'),
(4,13,'Bolivar'),
(5,15,'Boyacá'),
(6,17,'Caldas'),
(7,18,'Caquetá'),
(8,19,'Cauca'),
(9,20,'Cesar'),
(10,23,'Córdoba'),
(11,25,'Cundinamarca'),
(12,27,'Chocó'),
(13,41,'Huila'),
(14,44,'La Guajira'),
(15,47,'Magdalena'),
(16,50,'Meta'),
(17,52,'Nariño'),
(18,54,'Norte de Santander'),
(19,63,'Quindio'),
(20,66,'Risaralda'),
(21,68,'Santander'),
(22,70,'Sucre'),
(23,73,'Tolima'),
(24,76,'Valle del Cauca'),
(25,81,'Arauca'),
(26,85,'Casanare'),
(27,86,'Putumayo'),
(28,88,'Archipiélago de San Andrés, Providencia y Santa Catalina'),
(29,91,'Amazonas'),
(30,94,'Guainía'),
(31,95,'Guaviare'),
(32,97,'Vaupés'),
(33,99,'Vichada');

/*Table structure for table `dependencies` */

DROP TABLE IF EXISTS `dependencies`;

CREATE TABLE `dependencies` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(80) DEFAULT NULL,
  `user_id` int DEFAULT NULL,
  `acronym` varchar(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `d_user_id` (`user_id`),
  CONSTRAINT `d_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `dependencies` */

/*Table structure for table `django_admin_log` */

DROP TABLE IF EXISTS `django_admin_log`;

CREATE TABLE `django_admin_log` (
  `id` int NOT NULL AUTO_INCREMENT,
  `action_time` datetime(6) NOT NULL,
  `object_id` longtext,
  `object_repr` varchar(200) NOT NULL,
  `action_flag` smallint unsigned NOT NULL,
  `change_message` longtext NOT NULL,
  `content_type_id` int DEFAULT NULL,
  `user_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `django_admin_log_content_type_id_c4bce8eb_fk_django_co` (`content_type_id`),
  KEY `django_admin_log_user_id_c564eba6_fk_auth_user_id` (`user_id`),
  CONSTRAINT `django_admin_log_content_type_id_c4bce8eb_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`),
  CONSTRAINT `django_admin_log_user_id_c564eba6_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`),
  CONSTRAINT `django_admin_log_chk_1` CHECK ((`action_flag` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `django_admin_log` */

insert  into `django_admin_log`(`id`,`action_time`,`object_id`,`object_repr`,`action_flag`,`change_message`,`content_type_id`,`user_id`) values 
(1,'2024-06-28 17:23:16.690635','2','yerson',1,'[{\"added\": {}}]',4,1),
(2,'2024-06-28 17:24:04.177735','2','yerson',2,'[{\"changed\": {\"fields\": [\"First name\", \"Last name\", \"Email address\", \"Staff status\", \"Superuser status\", \"User permissions\"]}}]',4,1),
(3,'2024-06-28 17:24:33.356987','1','favian',2,'[{\"changed\": {\"fields\": [\"First name\", \"Last name\", \"User permissions\"]}}]',4,1);

/*Table structure for table `django_content_type` */

DROP TABLE IF EXISTS `django_content_type`;

CREATE TABLE `django_content_type` (
  `id` int NOT NULL AUTO_INCREMENT,
  `app_label` varchar(100) NOT NULL,
  `model` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `django_content_type_app_label_model_76bd3d3b_uniq` (`app_label`,`model`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `django_content_type` */

insert  into `django_content_type`(`id`,`app_label`,`model`) values 
(7,'account','emailaddress'),
(8,'account','emailconfirmation'),
(1,'admin','logentry'),
(3,'auth','group'),
(2,'auth','permission'),
(4,'auth','user'),
(9,'authtoken','token'),
(10,'authtoken','tokenproxy'),
(5,'contenttypes','contenttype'),
(6,'sessions','session'),
(11,'sites','site'),
(12,'socialaccount','socialaccount'),
(13,'socialaccount','socialapp'),
(14,'socialaccount','socialtoken'),
(15,'token_blacklist','blacklistedtoken'),
(16,'token_blacklist','outstandingtoken');

/*Table structure for table `django_migrations` */

DROP TABLE IF EXISTS `django_migrations`;

CREATE TABLE `django_migrations` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `app` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `applied` datetime(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=52 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `django_migrations` */

insert  into `django_migrations`(`id`,`app`,`name`,`applied`) values 
(1,'contenttypes','0001_initial','2024-06-28 16:00:49.616297'),
(2,'auth','0001_initial','2024-06-28 16:00:50.175804'),
(3,'admin','0001_initial','2024-06-28 16:00:50.317459'),
(4,'admin','0002_logentry_remove_auto_add','2024-06-28 16:00:50.324492'),
(5,'admin','0003_logentry_add_action_flag_choices','2024-06-28 16:00:50.331471'),
(6,'contenttypes','0002_remove_content_type_name','2024-06-28 16:00:50.414895'),
(7,'auth','0002_alter_permission_name_max_length','2024-06-28 16:00:50.477511'),
(8,'auth','0003_alter_user_email_max_length','2024-06-28 16:00:50.509497'),
(9,'auth','0004_alter_user_username_opts','2024-06-28 16:00:50.516501'),
(10,'auth','0005_alter_user_last_login_null','2024-06-28 16:00:50.584758'),
(11,'auth','0006_require_contenttypes_0002','2024-06-28 16:00:50.587516'),
(12,'auth','0007_alter_validators_add_error_messages','2024-06-28 16:00:50.594507'),
(13,'auth','0008_alter_user_username_max_length','2024-06-28 16:00:50.655314'),
(14,'auth','0009_alter_user_last_name_max_length','2024-06-28 16:00:50.722007'),
(15,'auth','0010_alter_group_name_max_length','2024-06-28 16:00:50.741846'),
(16,'auth','0011_update_proxy_permissions','2024-06-28 16:00:50.749864'),
(17,'auth','0012_alter_user_first_name_max_length','2024-06-28 16:00:50.808058'),
(18,'sessions','0001_initial','2024-06-28 16:00:50.843808'),
(19,'account','0001_initial','2024-07-16 15:51:47.486250'),
(20,'account','0002_email_max_length','2024-07-16 15:51:47.517046'),
(21,'account','0003_alter_emailaddress_create_unique_verified_email','2024-07-16 15:51:47.550105'),
(22,'account','0004_alter_emailaddress_drop_unique_email','2024-07-16 15:51:47.585078'),
(23,'account','0005_emailaddress_idx_upper_email','2024-07-16 15:51:47.614661'),
(24,'account','0006_emailaddress_lower','2024-07-16 15:51:47.627719'),
(25,'account','0007_emailaddress_idx_email','2024-07-16 15:51:47.696748'),
(26,'account','0008_emailaddress_unique_primary_email_fixup','2024-07-16 15:51:47.708343'),
(27,'account','0009_emailaddress_unique_primary_email','2024-07-16 15:51:47.714951'),
(28,'authtoken','0001_initial','2024-07-16 15:51:47.783269'),
(29,'authtoken','0002_auto_20160226_1747','2024-07-16 15:51:47.807674'),
(30,'authtoken','0003_tokenproxy','2024-07-16 15:51:47.810132'),
(31,'authtoken','0004_alter_tokenproxy_options','2024-07-16 15:51:47.814164'),
(32,'general','0001_initial','2024-07-16 15:58:13.962252'),
(33,'sites','0001_initial','2024-07-16 16:03:45.162962'),
(34,'sites','0002_alter_domain_unique','2024-07-16 16:03:45.181593'),
(35,'socialaccount','0001_initial','2024-07-16 16:03:45.492101'),
(36,'socialaccount','0002_token_max_lengths','2024-07-16 16:03:45.537386'),
(37,'socialaccount','0003_extra_data_default_dict','2024-07-16 16:03:45.545586'),
(38,'socialaccount','0004_app_provider_id_settings','2024-07-16 16:03:45.647590'),
(39,'socialaccount','0005_socialtoken_nullable_app','2024-07-16 16:03:45.762681'),
(40,'socialaccount','0006_alter_socialaccount_extra_data','2024-07-16 16:03:45.811794'),
(41,'token_blacklist','0001_initial','2024-07-16 16:03:45.930597'),
(42,'token_blacklist','0002_outstandingtoken_jti_hex','2024-07-16 16:03:45.950909'),
(43,'token_blacklist','0003_auto_20171017_2007','2024-07-16 16:03:45.970600'),
(44,'token_blacklist','0004_auto_20171017_2013','2024-07-16 16:03:46.027952'),
(45,'token_blacklist','0005_remove_outstandingtoken_jti','2024-07-16 16:03:46.065381'),
(46,'token_blacklist','0006_auto_20171017_2113','2024-07-16 16:03:46.091004'),
(47,'token_blacklist','0007_auto_20171017_2214','2024-07-16 16:03:46.232928'),
(48,'token_blacklist','0008_migrate_to_bigautofield','2024-07-16 16:03:46.390397'),
(49,'token_blacklist','0010_fix_migrate_to_bigautofield','2024-07-16 16:03:46.409517'),
(50,'token_blacklist','0011_linearizes_history','2024-07-16 16:03:46.411524'),
(51,'token_blacklist','0012_alter_outstandingtoken_user','2024-07-16 16:03:46.423250');

/*Table structure for table `django_session` */

DROP TABLE IF EXISTS `django_session`;

CREATE TABLE `django_session` (
  `session_key` varchar(40) NOT NULL,
  `session_data` longtext NOT NULL,
  `expire_date` datetime(6) NOT NULL,
  PRIMARY KEY (`session_key`),
  KEY `django_session_expire_date_a5c62663` (`expire_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `django_session` */

insert  into `django_session`(`session_key`,`session_data`,`expire_date`) values 
('84lxdpxdvi8t9xi81knyiaa500cyk7g7','.eJxVjM0OwiAQhN-FsyGVn2Xr0bvPQJYFpGogKe3J-O62SQ96nPm-mbfwtC7Frz3NforiIs7i9NsF4meqO4gPqvcmudVlnoLcFXnQLm8tptf1cP8OCvWyrZ0BckjOaBgz6zE4hSYShgzAAzLkhNpaRyYoHhgNoNUqch4g8hbE5wvUdDeT:1sNE4I:x2zRP54NhEytTzJwuXpNfZlQkPxJ9YmwYJ8iAfHiGro','2024-07-12 16:03:22.721264'),
('lwhcplknifhdimeq7ts6w8hnwap46qw5','.eJxVjM0OwiAQhN-FsyGVn2Xr0bvPQJYFpGogKe3J-O62SQ96nPm-mbfwtC7Frz3NforiIs7i9NsF4meqO4gPqvcmudVlnoLcFXnQLm8tptf1cP8OCvWyrZ0BckjOaBgz6zE4hSYShgzAAzLkhNpaRyYoHhgNoNUqch4g8hbE5wvUdDeT:1sNFHZ:MGcgu3ylonU9COCm_2YHxI6Ef1EyqBYiZmoggIyq9Qg','2024-07-12 17:21:09.507558');

/*Table structure for table `django_site` */

DROP TABLE IF EXISTS `django_site`;

CREATE TABLE `django_site` (
  `id` int NOT NULL AUTO_INCREMENT,
  `domain` varchar(100) NOT NULL,
  `name` varchar(50) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `django_site_domain_a2e37b91_uniq` (`domain`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `django_site` */

insert  into `django_site`(`id`,`domain`,`name`) values 
(1,'example.com','example.com');

/*Table structure for table `group_roles` */

DROP TABLE IF EXISTS `group_roles`;

CREATE TABLE `group_roles` (
  `id` int NOT NULL AUTO_INCREMENT,
  `gr_group_id` int DEFAULT NULL,
  `gr_role_id` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `gr_groupid` (`gr_group_id`),
  KEY `gr_roleid` (`gr_role_id`),
  CONSTRAINT `gr_groupid` FOREIGN KEY (`gr_group_id`) REFERENCES `groups` (`id`),
  CONSTRAINT `gr_roleid` FOREIGN KEY (`gr_role_id`) REFERENCES `roles` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `group_roles` */

insert  into `group_roles`(`id`,`gr_group_id`,`gr_role_id`) values 
(1,1,1);

/*Table structure for table `groups` */

DROP TABLE IF EXISTS `groups`;

CREATE TABLE `groups` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `groups` */

insert  into `groups`(`id`,`name`) values 
(1,'Administradores');

/*Table structure for table `modules` */

DROP TABLE IF EXISTS `modules`;

CREATE TABLE `modules` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT NULL,
  `route` varchar(50) DEFAULT NULL,
  `icon` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `modules` */

insert  into `modules`(`id`,`name`,`route`,`icon`) values 
(1,'Dashboard','dashboard','/icons/icon_home.png'),
(2,'Administrator','admin','/icons/icon_admin.svg'),
(3,'Gesdoc','gesdoc','/icons/icon_gesdoc.svg');

/*Table structure for table `permissions` */

DROP TABLE IF EXISTS `permissions`;

CREATE TABLE `permissions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `permissions` */

insert  into `permissions`(`id`,`name`) values 
(1,'Edit'),
(2,'Delete'),
(3,'Print'),
(4,'View'),
(5,'Create');

/*Table structure for table `person` */

DROP TABLE IF EXISTS `person`;

CREATE TABLE `person` (
  `id` int NOT NULL AUTO_INCREMENT,
  `p_doc_type_id` int DEFAULT NULL,
  `doc_number` varchar(30) DEFAULT NULL,
  `first_name` varchar(60) DEFAULT NULL,
  `last_name` varchar(60) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `cellphone` varchar(20) DEFAULT NULL,
  `address` varchar(100) DEFAULT NULL,
  `p_department_id` int DEFAULT NULL,
  `p_city_id` int DEFAULT NULL,
  `picture` varchar(250) DEFAULT NULL,
  `created` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `td_id` (`p_doc_type_id`),
  KEY `pd_id` (`p_department_id`),
  KEY `pc_id` (`p_city_id`),
  CONSTRAINT `pc_id` FOREIGN KEY (`p_city_id`) REFERENCES `cities` (`id`),
  CONSTRAINT `pd_id` FOREIGN KEY (`p_department_id`) REFERENCES `departments` (`code`),
  CONSTRAINT `td_id` FOREIGN KEY (`p_doc_type_id`) REFERENCES `type_documents` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `person` */

insert  into `person`(`id`,`p_doc_type_id`,`doc_number`,`first_name`,`last_name`,`email`,`cellphone`,`address`,`p_department_id`,`p_city_id`,`picture`,`created`,`updated`) values 
(1,1,'1124863320','Jeff','Salzmann Baeza','yerson.munoz@putumyo.gov.co','3173769615','Br La Unión',27,845,NULL,'2024-07-09 14:40:08','2024-07-10 17:42:59'),
(2,1,'123456789','Jeff','Baeza','yerson.munoz@putumayo.gov.co','3113111123','NA',27,845,'71e3e2bcf995db0c1b4a059448f47b89.jpg','2024-07-10 17:08:51','2024-07-10 17:08:51');

/*Table structure for table `role_permissions` */

DROP TABLE IF EXISTS `role_permissions`;

CREATE TABLE `role_permissions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `rp_role_id` int DEFAULT NULL,
  `rp_permission_id` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `rp_roleid` (`rp_role_id`),
  KEY `rp_permid` (`rp_permission_id`),
  CONSTRAINT `rp_permid` FOREIGN KEY (`rp_permission_id`) REFERENCES `permissions` (`id`),
  CONSTRAINT `rp_roleid` FOREIGN KEY (`rp_role_id`) REFERENCES `roles` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `role_permissions` */

insert  into `role_permissions`(`id`,`rp_role_id`,`rp_permission_id`) values 
(1,1,1),
(2,1,2),
(3,1,3),
(4,1,4),
(5,1,5);

/*Table structure for table `roles` */

DROP TABLE IF EXISTS `roles`;

CREATE TABLE `roles` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `roles` */

insert  into `roles`(`id`,`name`) values 
(1,'Administrator');

/*Table structure for table `socialaccount_socialaccount` */

DROP TABLE IF EXISTS `socialaccount_socialaccount`;

CREATE TABLE `socialaccount_socialaccount` (
  `id` int NOT NULL AUTO_INCREMENT,
  `provider` varchar(200) NOT NULL,
  `uid` varchar(191) NOT NULL,
  `last_login` datetime(6) NOT NULL,
  `date_joined` datetime(6) NOT NULL,
  `extra_data` json NOT NULL,
  `user_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `socialaccount_socialaccount_provider_uid_fc810c6e_uniq` (`provider`,`uid`),
  KEY `socialaccount_socialaccount_user_id_8146e70c_fk_auth_user_id` (`user_id`),
  CONSTRAINT `socialaccount_socialaccount_user_id_8146e70c_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `socialaccount_socialaccount` */

/*Table structure for table `socialaccount_socialapp` */

DROP TABLE IF EXISTS `socialaccount_socialapp`;

CREATE TABLE `socialaccount_socialapp` (
  `id` int NOT NULL AUTO_INCREMENT,
  `provider` varchar(30) NOT NULL,
  `name` varchar(40) NOT NULL,
  `client_id` varchar(191) NOT NULL,
  `secret` varchar(191) NOT NULL,
  `key` varchar(191) NOT NULL,
  `provider_id` varchar(200) NOT NULL,
  `settings` json NOT NULL DEFAULT (_utf8mb3'{}'),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `socialaccount_socialapp` */

/*Table structure for table `socialaccount_socialapp_sites` */

DROP TABLE IF EXISTS `socialaccount_socialapp_sites`;

CREATE TABLE `socialaccount_socialapp_sites` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `socialapp_id` int NOT NULL,
  `site_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `socialaccount_socialapp_sites_socialapp_id_site_id_71a9a768_uniq` (`socialapp_id`,`site_id`),
  KEY `socialaccount_socialapp_sites_site_id_2579dee5_fk_django_site_id` (`site_id`),
  CONSTRAINT `socialaccount_social_socialapp_id_97fb6e7d_fk_socialacc` FOREIGN KEY (`socialapp_id`) REFERENCES `socialaccount_socialapp` (`id`),
  CONSTRAINT `socialaccount_socialapp_sites_site_id_2579dee5_fk_django_site_id` FOREIGN KEY (`site_id`) REFERENCES `django_site` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `socialaccount_socialapp_sites` */

/*Table structure for table `socialaccount_socialtoken` */

DROP TABLE IF EXISTS `socialaccount_socialtoken`;

CREATE TABLE `socialaccount_socialtoken` (
  `id` int NOT NULL AUTO_INCREMENT,
  `token` longtext NOT NULL,
  `token_secret` longtext NOT NULL,
  `expires_at` datetime(6) DEFAULT NULL,
  `account_id` int NOT NULL,
  `app_id` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `socialaccount_socialtoken_app_id_account_id_fca4e0ac_uniq` (`app_id`,`account_id`),
  KEY `socialaccount_social_account_id_951f210e_fk_socialacc` (`account_id`),
  CONSTRAINT `socialaccount_social_account_id_951f210e_fk_socialacc` FOREIGN KEY (`account_id`) REFERENCES `socialaccount_socialaccount` (`id`),
  CONSTRAINT `socialaccount_social_app_id_636a42d7_fk_socialacc` FOREIGN KEY (`app_id`) REFERENCES `socialaccount_socialapp` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `socialaccount_socialtoken` */

/*Table structure for table `subdependencies` */

DROP TABLE IF EXISTS `subdependencies`;

CREATE TABLE `subdependencies` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(80) DEFAULT NULL,
  `dependencie_id` int DEFAULT NULL,
  `acronym` varchar(5) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `d_subdep_id` (`dependencie_id`),
  CONSTRAINT `d_subdep_id` FOREIGN KEY (`dependencie_id`) REFERENCES `dependencies` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `subdependencies` */

/*Table structure for table `submodules` */

DROP TABLE IF EXISTS `submodules`;

CREATE TABLE `submodules` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT NULL,
  `route` varchar(100) DEFAULT NULL,
  `icon` varchar(50) DEFAULT NULL,
  `sm_module_id` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `sm_moduleid` (`sm_module_id`),
  CONSTRAINT `sm_moduleid` FOREIGN KEY (`sm_module_id`) REFERENCES `modules` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `submodules` */

insert  into `submodules`(`id`,`name`,`route`,`icon`,`sm_module_id`) values 
(1,'Users','users','/icons/icon_users.png',2),
(2,'Dependencies','dependencies','/icons/icon_dependencies.svg',2),
(3,'Subdependencies','subdependencies','/icons/icon_subdependencies.svg',2);

/*Table structure for table `token_blacklist_blacklistedtoken` */

DROP TABLE IF EXISTS `token_blacklist_blacklistedtoken`;

CREATE TABLE `token_blacklist_blacklistedtoken` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `blacklisted_at` datetime(6) NOT NULL,
  `token_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `token_id` (`token_id`),
  CONSTRAINT `token_blacklist_blacklistedtoken_token_id_3cc7fe56_fk` FOREIGN KEY (`token_id`) REFERENCES `token_blacklist_outstandingtoken` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `token_blacklist_blacklistedtoken` */

/*Table structure for table `token_blacklist_outstandingtoken` */

DROP TABLE IF EXISTS `token_blacklist_outstandingtoken`;

CREATE TABLE `token_blacklist_outstandingtoken` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `token` longtext NOT NULL,
  `created_at` datetime(6) DEFAULT NULL,
  `expires_at` datetime(6) NOT NULL,
  `user_id` int DEFAULT NULL,
  `jti` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `token_blacklist_outstandingtoken_jti_hex_d9bdf6f7_uniq` (`jti`),
  KEY `token_blacklist_outs_user_id_83bc629a_fk_auth_user` (`user_id`),
  CONSTRAINT `token_blacklist_outs_user_id_83bc629a_fk_auth_user` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `token_blacklist_outstandingtoken` */

insert  into `token_blacklist_outstandingtoken`(`id`,`token`,`created_at`,`expires_at`,`user_id`,`jti`) values 
(1,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTcyMTIzMjI1NiwiaWF0IjoxNzIxMTQ1ODU2LCJqdGkiOiIwZTZjYTAxM2JhNGE0Y2IzOTQ2MTZmN2M1YjU0NzI2OCIsInVzZXJfaWQiOjJ9.tjdqV2hi97d4tBp89lrgFqjJtmF3O9bzmRgPHBUC0hY','2024-07-16 16:04:16.791194','2024-07-17 16:04:16.000000',2,'0e6ca013ba4a4cb394616f7c5b547268'),
(2,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTcyMTIzMzk0NiwiaWF0IjoxNzIxMTQ3NTQ2LCJqdGkiOiJlNzAzZmRiZGI2M2Y0MjFkOTY1NjJmZjEzZDE3MmFmMSIsInVzZXJfaWQiOjJ9.snsYb872uQiOQ1gNQfgWQAXUpvomClyiK1Hr5_XnM-M','2024-07-16 16:32:26.320342','2024-07-17 16:32:26.000000',2,'e703fdbdb63f421d96562ff13d172af1'),
(3,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTcyMTI0NDUyMCwiaWF0IjoxNzIxMTU4MTIwLCJqdGkiOiIxZDFhNTI5Y2ViOGI0OGY5YTdkZTJkZjQ4ZTUzNWVmZCIsInVzZXJfaWQiOjJ9.pyUU_rtOyldVo9VqQ6KyyFP0K3BONXebfao4GWOTHag','2024-07-16 19:28:40.126934','2024-07-17 19:28:40.000000',2,'1d1a529ceb8b48f9a7de2df48e535efd'),
(4,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTcyMTI0NDc5OSwiaWF0IjoxNzIxMTU4Mzk5LCJqdGkiOiI1ZjkzM2RhMWU5OTE0ZjMzYjkyZjQ5MjVlM2VhY2ZiMyIsInVzZXJfaWQiOjJ9.qfFIat-f4DIpBp1xDcQ8e0cz2ths7xY_A4pvJ2DUaFE','2024-07-16 19:33:19.967288','2024-07-17 19:33:19.000000',2,'5f933da1e9914f33b92f4925e3eacfb3'),
(5,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTcyMTI0NTMwOCwiaWF0IjoxNzIxMTU4OTA4LCJqdGkiOiIxM2I5NGIxNGNjYWM0YTRiYmUwZTdjNzlkZDBjYjEzMyIsInVzZXJfaWQiOjJ9.K48iWjAG9VZ2FWsFIAiy0NTD-H1bZ0_uR_eRF7SRt0U','2024-07-16 19:41:48.372187','2024-07-17 19:41:48.000000',2,'13b94b14ccac4a4bbe0e7c79dd0cb133'),
(6,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTcyMTI0NTM1MywiaWF0IjoxNzIxMTU4OTUzLCJqdGkiOiI3NmZjYmJiMzhmNTM0YmY0ODQyZmUyMzFmN2U3ZGI5OCIsInVzZXJfaWQiOjJ9.Z54PklAUSDWK2bBp5eBP3_Pk9syDT-2pb9OF4O2cwwc','2024-07-16 19:42:33.770397','2024-07-17 19:42:33.000000',2,'76fcbbb38f534bf4842fe231f7e7db98'),
(7,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTcyMTI0NTg0MiwiaWF0IjoxNzIxMTU5NDQyLCJqdGkiOiJmZWI2MjUyZTM4M2Y0ZGNmYjkyNjNmYjk0M2M2MzJjYyIsInVzZXJfaWQiOjJ9.1m0lMQTMw8Atjzk3zXcibGBwW3IfVgKEQBbfQmw_y7k','2024-07-16 19:50:42.359782','2024-07-17 19:50:42.000000',2,'feb6252e383f4dcfb9263fb943c632cc'),
(8,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTcyMTI0NTkxNiwiaWF0IjoxNzIxMTU5NTE2LCJqdGkiOiI5M2U4OTE5ZTRmN2Q0N2QxOGQyOWUyYzI2ZmNmNTEzYiIsInVzZXJfaWQiOjJ9.cFkoN_ScBSdutL-Yt5vptumyHL1DFgCsl1PSph_mWVc','2024-07-16 19:51:56.045136','2024-07-17 19:51:56.000000',2,'93e8919e4f7d47d18d29e2c26fcf513b'),
(9,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTcyMTI0NjAwNSwiaWF0IjoxNzIxMTU5NjA1LCJqdGkiOiIxMTg5MmMyMzI1YWI0NDg0YWVjN2UxOTA1YTcxZjQzMCIsInVzZXJfaWQiOjJ9.MRooEdvUBY3Z10990nB_daHptZ55mcqv72pxdz0OCLE','2024-07-16 19:53:25.508947','2024-07-17 19:53:25.000000',2,'11892c2325ab4484aec7e1905a71f430'),
(10,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTcyMTI0NjE1NCwiaWF0IjoxNzIxMTU5NzU0LCJqdGkiOiJhMGU1MjcxNGFlNWM0MjQ4YmJhYjc4MDFkNjgxNTFiOCIsInVzZXJfaWQiOjJ9.Ms63dBU3rdeuEEqrpUaET5zP4E44qhKVAhWMb8qOfCc','2024-07-16 19:55:54.196332','2024-07-17 19:55:54.000000',2,'a0e52714ae5c4248bbab7801d68151b8'),
(11,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTcyMTI0NjIyMSwiaWF0IjoxNzIxMTU5ODIxLCJqdGkiOiIzMWU3NzUyOTc2NmQ0YWM4Yjk4NjQxZDEzYzI5NGQ2MiIsInVzZXJfaWQiOjJ9.JE90nGvvk9wTN40ysK6ZtESRSXdMKj4y_MMtxRHtFRI','2024-07-16 19:57:01.500258','2024-07-17 19:57:01.000000',2,'31e77529766d4ac8b98641d13c294d62');

/*Table structure for table `type_documents` */

DROP TABLE IF EXISTS `type_documents`;

CREATE TABLE `type_documents` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(60) DEFAULT NULL,
  `acronym` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `type_documents` */

insert  into `type_documents`(`id`,`name`,`acronym`) values 
(1,'Cédula de Ciudadanía','CC'),
(2,'Número de Identificación Tributaria','NIT'),
(3,'Tarjeta de identidad','TI'),
(4,'Registro Civil','RC'),
(5,'Cédula de Extranjería','CE'),
(6,'Carné de Identidad','CI'),
(7,'Documento Nacional de Identidad','DNI');

/*Table structure for table `user_groups` */

DROP TABLE IF EXISTS `user_groups`;

CREATE TABLE `user_groups` (
  `int` int NOT NULL AUTO_INCREMENT,
  `ug_auth_id` int DEFAULT NULL,
  `ug_group_id` int DEFAULT NULL,
  PRIMARY KEY (`int`),
  KEY `ug_authid` (`ug_auth_id`),
  KEY `ug_groupid` (`ug_group_id`),
  CONSTRAINT `ug_authid` FOREIGN KEY (`ug_auth_id`) REFERENCES `auth` (`id`),
  CONSTRAINT `ug_groupid` FOREIGN KEY (`ug_group_id`) REFERENCES `groups` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `user_groups` */

insert  into `user_groups`(`int`,`ug_auth_id`,`ug_group_id`) values 
(1,2,1);

/*Table structure for table `user_module_permission` */

DROP TABLE IF EXISTS `user_module_permission`;

CREATE TABLE `user_module_permission` (
  `id` int NOT NULL AUTO_INCREMENT,
  `ump_auth_id` int DEFAULT NULL,
  `ump_module_id` int DEFAULT NULL,
  `ump_permission_id` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `ump_authid` (`ump_auth_id`),
  KEY `ump_moduleid` (`ump_module_id`),
  KEY `ump_permissionid` (`ump_permission_id`),
  CONSTRAINT `ump_authid` FOREIGN KEY (`ump_auth_id`) REFERENCES `auth` (`id`),
  CONSTRAINT `ump_moduleid` FOREIGN KEY (`ump_module_id`) REFERENCES `modules` (`id`),
  CONSTRAINT `ump_permissionid` FOREIGN KEY (`ump_permission_id`) REFERENCES `permissions` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `user_module_permission` */

insert  into `user_module_permission`(`id`,`ump_auth_id`,`ump_module_id`,`ump_permission_id`) values 
(1,2,1,1),
(2,2,1,2),
(3,2,1,3),
(4,2,1,4),
(5,2,1,5),
(6,2,2,1),
(7,2,2,2),
(8,2,2,3),
(9,2,2,4),
(10,2,2,5),
(11,2,3,1),
(12,2,3,2),
(13,2,3,3),
(14,2,3,4),
(15,2,3,5);

/*Table structure for table `user_modules` */

DROP TABLE IF EXISTS `user_modules`;

CREATE TABLE `user_modules` (
  `id` int NOT NULL AUTO_INCREMENT,
  `um_auth_id` int DEFAULT NULL,
  `um_module_id` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `um_authid` (`um_auth_id`),
  KEY `um_moduleid` (`um_module_id`),
  CONSTRAINT `um_authid` FOREIGN KEY (`um_auth_id`) REFERENCES `auth` (`id`),
  CONSTRAINT `um_moduleid` FOREIGN KEY (`um_module_id`) REFERENCES `modules` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `user_modules` */

insert  into `user_modules`(`id`,`um_auth_id`,`um_module_id`) values 
(1,2,1),
(2,2,2),
(3,2,3);

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
