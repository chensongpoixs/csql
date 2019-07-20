------------------------------------------------------------------------------------
--	created: 		2019-07-20                                                   ---
--	                                                                             ---
--	author:			chensong                                                     ---
--					                                                             ---
--	purpose:		test_case                                                    ---
--					1.                                                           ---
------------------------------------------------------------------------------------

------------------------------------------------------------------------------------
------------------------------------------------------------------------------------


-- USE chensong;


-- creat table
DROP TABLE IF EXISTS `t_webservicecalls`;
CREATE TABLE `t_webservicecalls` (
	`day` 		date 					NOT NULL 				COMMENT '日期',
	`account` int unsigned zerofill 	NOT NULL DEFAULT '0' 	COMMENT '连接',
	`service` varchar(10) 				NOT NULL 				COMMENT '服务',
	`method` 	varchar(50) 			NOT NULL 				COMMENT '月份',
	`calls` 	int 					NOT NULL 				COMMENT 'call',
	`items` 	int 					NOT NULL 				COMMENT '物品',
	`time` 		float 					NOT NULL 				COMMENT '时间',
	`cost` 		decimal(9, 5) 			NOT NULL 				COMMENT '消费',
	`updated` datetime 											COMMENT '更新时间',
	PRIMARY KEY (`account`, `service`, `method`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


insert INTO `t_webservicecalls` VALUES('2019-06-20', 1, '1', '7', 1, 1, 1.1, 6, '2019-07-21');

select *from t_webservicecalls;

select max(t_webservicecalls.account) from t_webservicecalls;





--- copy table 
-- create table `t_webservicecalls_enum` (
-- 	`day` 		date 					NOT NULL 				COMMENT '日期',
-- 	`account` 	int unsigned zerofill 	NOT NULL DEFAULT '0' 	COMMENT '连接',
-- 	`service` 	varchar(10) 			NOT NULL 				COMMENT '服务',
-- 	`method` 	varchar(50) 			NOT NULL 				COMMENT '月份',
-- 	`calls` 	int 					NOT NULL 				COMMENT 'call',
-- 	`items` 	int 					NOT NULL 				COMMENT '物品',
-- 	`time` 		float 					NOT NULL 				COMMENT '时间',
-- 	`cost` 		decimal(9, 5) 			NOT NULL 				COMMENT '消费',
-- 	`updated` datetime 											COMMENT '更新时间',
-- 	PRIMARY KEY (`account`, `service`, `method`)
-- ) ENGINE=InnoDB;




-- mysql ip to 

-- 1. INET_ATON() 
-- 2. INET_NTOA() 
-- 两个函数转换
