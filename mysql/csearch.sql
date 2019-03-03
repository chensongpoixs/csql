---------------------------------------------------------------------------------------------------------------------
--	created: 		2019-03-03                                                                                    ---
--	                                                                                                              ---
--	author:			chensong                                                                                      ---
--					                                                                                              ---
--	purpose:		sql                                                                                           ---
--					1.                                                                                            ---
---------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------
-- 一, order by desc 排序, LIMIT 关键字使用
--- 1. 查询最晚入职员工的所有信息
-- 员工入职信息表
CREATE TABLE `employees` (
	`emp_no` 		INT ( 11 )	 	NOT NULL COMMENT '员工编号',
	`birth_data` 	date 			NOT NULL COMMENT '出生日期',
	`first_name` 	VARCHAR ( 14 ) 	NOT NULL COMMENT '第一个名字',
	`last_name` 	VARCHAR ( 14 ) 	NOT NULL COMMENT '最后名字',
	`gender` 		CHAR ( 1 ) 		NOT NULL COMMENT '性别',
	`hire_date` 	date 			NOT NULL COMMENT '雇用日期',
PRIMARY KEY ( `emp_no` ) 
) ENGINE = InnoDB DEFAULT CHARSET=utf8;

-- 插入数据
INSERT INTO `employees` VALUES (1, '1998-03-13', 'chenli', 'chenli', '0', '2018-05-05');
INSERT INTO `employees` VALUES (2, '1998-03-05', 'wangrong', 'wangrong', '0', '2018-07-05');
INSERT INTO `employees` VALUES (3, '1994-03-05', 'chensong', 'chensong', '1', '2018-05-05');
INSERT INTO `employees` VALUES (4, '1992-03-05', 'yangyan', 'yangyan', '0', '2018-03-05');
INSERT INTO `employees` VALUES (5, '1997-03-05', 'wangpanpan', 'wangpanpan', '0', '2018-04-05');

-- 查询sql语句 [ERROR]

SELECT
	t1.emp_no,
	t1.birth_data,
	t1.first_name,
	t1.last_name,
	t1.gender,
	t1.hire_date 
FROM
	employees t1,
	( SELECT emp_no, MAX( hire_date ) FROM employees ) t2 
WHERE
	t1.emp_no = t2.emp_no;
	
-- 上面sql语句是有问题的 如果一天内有多人入职呢 就会错误了 所以正确的sql是 [OK]
SELECT
	t1.emp_no,
	t1.birth_data,
	t1.first_name,
	t1.last_name,
	t1.gender,
	t1.hire_date 
FROM
	employees t1 
WHERE
	t1.hire_date = ( SELECT MAX( hire_date ) FROM employees );    -- 临时表所以 

--- 2.  查找入职员工时间排名倒数第三的员工所有的信息
-- 关键字 LIMIT 的使用 
-- ① LIMIT m,n; 表示从第m+1条开始，取n条数据
-- ② LIMIT n; 表示从第n条开始，取n条数据, 是limit(0, n)的缩写
-- sql语句 [OK]

SELECT
	* 
FROM
	employees 
ORDER BY
	hire_date DESC 
	LIMIT 2, 1;
	
---------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------
-- 二, inner join on 
-- 部门表
create table `dept_mananger`(
`dept_no`	char(4)		NOT NULL	COMMENT '部门编号',
`emp_no`	int(11)		NOT NULL	COMMENT '员工编号',
`from_date`	date		NOT NULL	COMMENT '',
`to_date`	date 		NOT NULL	COMMENT '到达的时间',
PRIMARY KEY(`emp_no`, `dept_no`)
) ENGINE = InnoDB DEFAULT CHARSET=utf8;

-- 员工表
create table `salaries` (
`emp_no`	int(11)		NOT NULL	COMMENT '员工编号',
`salary`	int(11)		NOT NULL	COMMENT '薪水',
`from_date`	date		NOT NULL	COMMENT '',
`to_date`	date		NOT NULL	COMMENT '到达的时间',
PRIMARY KEY(`emp_no`, `from_date`)
) ENGINE = InnoDB DEFAULT CHARSET=utf8;

--- insert
INSERT INTO `dept_mananger` VALUES ('1001', 1, '2019-03-03', '9999-01-01');
INSERT INTO `dept_mananger` VALUES ('1002', 2, '2019-03-03', '9999-01-01');
INSERT INTO `dept_mananger` VALUES ('1003', 3, '2019-03-03', '9999-01-01');
INSERT INTO `salaries` VALUES (1, 23000, '2019-03-03', '9999-01-01');
INSERT INTO `salaries` VALUES (2, 23000, '2019-03-03', '9999-01-01');
INSERT INTO `salaries` VALUES (3, 23000, '2019-03-03', '9999-01-01');
INSERT INTO `salaries` VALUES (4, 23000, '2019-03-03', '9999-01-01');


--- 1. 查找各个部门当前(to_date = '9999-01-01')领导当前新水详细以及对应部门编号dept_no 
--  inner join ON 的使用 
--
-- sql语句

SELECT
	salaries.emp_no,
	salaries.salary,
	salaries.from_date,
	salaries.to_date,
	dept_mananger.dept_no 
FROM
	salaries
	INNER JOIN dept_mananger ON salaries.emp_no = dept_mananger.emp_no 
	AND salaries.to_date = '9999-01-01' 
	AND dept_mananger.to_date = '9999-01-01';
	
---------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------
-- 三, left join
-- 部门表
create table `dept_emp`(
`emp_no`	int(11)		NOT NULL COMMENT '员工编号',
`dept_no`	char(4)		NOT NULL COMMENT '部门编号',
`from_date`	date 		NOT NULL COMMENT '',
`to_date`	date		NOT NULL COMMENT '',
PRIMARY KEY('emp_no', 'dept_no')
)ENGINE = InnoDB DEFAULT CHARSET=utf8;

-- 员工表
create table `employees`(
`emp_no`		int(11)		NOT NULL COMMNET '员工编号',
`birth_date`	date 		NOT NULL COMMNET '出生日期',
`first_name`	varchar(14)	NOT NULL COMMNET '',
`last_name`		varchar(16) NOT NULL COMMNET '',
`gender`		char(1)		NOT NULL COMMNET '性别',
`hire_date`		date		NOT NULL COMMNET '入职日期',
PRIMARY KEY ('emp_no')
);


--- 1. 查找所有已经分配部门的员工的last_name和first_name

-- sql语句
-- ① 答案
SELECT
	last_name,
	first_name,
	dept_no 
FROM
	employees e
	JOIN dept_emp d ON e.emp_no = d.emp_no;

-- ② 答案:
-- 只有一列是公有, 用自然连接

SELECT
	e.last_name,
	e.first_name,
	d.dept_no 
FROM
	dept_emp d
	NATURAL JOIN employees e;


--- 2. 查找所有员工的last_name和first_name以及对应部门编号dept_no,也包含展示没有分配具体部门的员工
--注意on与where有什么区别, 两个表连接时使用on, 在所以left join时, on和where条件的区别如下:
--  ① on条件是在生成临时使用的条件, 它不管on中的条件十分为真, 都返回左边表中记录。
--  ② where条件是在临时表生成好后, 再对临时表进行过滤的条件。这时已经没有left join的含义(必须返回左边表的记录)了, 条件不为真的就全部过滤
--sql语句

SELECT
	last_name,
	first_name,
	dept_no 
FROM
	employees m
	LEFT JOIN dept_emp d ON m.emp_no = d.emp_no;
	


	