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



-- 不是全表的查询 primary key  type = ref 
explain select *from t_primary_key where last_name = 'chenli';


select *from t_primary_key;

--- 全表查询 type = all
explain select *from t_primary_key where dob = '2019-07-21';



-- 删除主键 操作命令
alter table chensong.t_primary_key drop foreign key last_name;
alter table chensong.t_primary_key drop key last_name;



select count(*) from `t_test_case_python`;

show engines;

-- create myisam database

use chensong;

create table t_engines engine = myisam as select *from t_engines;

alter table t_engines engine=innodb;

alter table t_engines engine=archive;

-- 比较三种存储引擎的文件的大小


-- 用户名权限表

use mysql;
select *from user;
select host, user, password from user;


-- unix 上通信

show variables like 'socket';






-- 查询InnoDB存储引擎的版本
show variables like 'innodb_version';

-- InnoDB io threads 数
show variables like 'innodb_%io_threads';

-- show variables like 'myisam_%io_threads';

show engine innodb status;

-- 回收 事务 undo页的数据
show variables like 'innodb_purge_threads';

show variables like 'innodb_buffer_pool_size';


show variables like 'innodb_buffer_pool_instances';
use information_schema;
-- 缓存池使用情况
select POOL_ID, POOL_SIZE, FREE_BUFFERS, DATABASE_PAGES from  INNODB_BUFFER_POOL_STATS;

select *from INNODB_BUFFER_POOL_STATS;


show variables like 'innodb_old_blocks_pct';



-- LRU 
select table_name, space, page_number, page_type from INNODB_BUFFER_PAGE_LRU where SPACE = 1;



-- 查看是否脏数据
select table_name, space, page_number, page_type from INNODB_BUFFER_PAGE_LRU where OLDEST_MODIFICATION > 1;


-- InnoDB的缓存大小
show variables like 'innodb_change_buffer_max_size';







