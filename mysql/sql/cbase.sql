-- sql 基础复习
--查询
--SQL 语句不区分大小写，但是数据库表名、列名和值是否区分依赖于具体的 DBMS 以及配置。

-- 1. DISTINCT 相同值只会出现一次。它作用于所有列，也就是说所有列的值都相同才算相同。

-- 两种不同结果
SELECT DISTINCT user_id, user_permission_id
from t_test_tables;

SELECT DISTINCT user_id
from t_test_tables;


-- 2. LIMIT 限制返回的行数。可以有两个参数，第一个参数为起始行，从 0 开始；第二个参数为返回的总行数。
--返回前 5 行的 SQL：

SELECT *
FROM t_test_tables
LIMIT 5;


SELECT *
FROM t_test_tables
LIMIT 0, 5;

--返回第 3 ~ 5 行：

SELECT *
FROM t_test_tables
LIMIT 2, 3;




-- 排序
--ASC：升序（默认）DESC：降序

--1. 可以按多个列进行排序：

SELECT *
FROM t_test_tables
ORDER BY user_id DESC, user_permission_id ASC;






--分组
--分组就是把相同的数据放在同一组中。
--可以对每组数据使用汇总函数进行处理，例如求每组数的平均值等。
--按 col 排序并分组数据：

SELECT col, COUNT(*) AS num
FROM mytable
GROUP BY col;
WHERE 过滤行，HAVING 过滤分组，行过滤应当先与分组过滤；

SELECT col, COUNT(*) AS num
FROM mytable
WHERE col > 2
GROUP BY col
HAVING COUNT(*) >= 2;
GROUP BY 的排序结果为分组字段，而 ORDER BY 也可以以聚集字段来进行排序。

SELECT col, COUNT(*) AS num
FROM mytable
GROUP BY col
ORDER BY num;
分组规定：

GROUP BY 子句出现在 WHERE 子句之后，ORDER BY 子句之前；
除了汇总计算语句之外，SELECT 语句中的每一列都必须在 GROUP BY 子句中给出；
NULL 的行会单独分为一组；
大多数 SQL 实现不支持 GROUP BY 列具有可变长度的数据类型。
子查询
子查询中只能返回一个列。

可以将子查询的结果作为 WHRER 语句的过滤条件：

SELECT *
FROM mytable1
WHERE col1 IN (SELECT col2
                 FROM mytable2);
下面的语句可以检索出客户的订单数量。子查询语句会对检索出的每个客户执行一次：

SELECT cust_name, (SELECT COUNT(*)
                   FROM Orders
                   WHERE Orders.cust_id = Customers.cust_id)
                   AS orders_num
FROM Customers
ORDER BY cust_name;
连接
连接用于连接多个表，使用 JOIN 关键字，并且条件语句使用 ON。

连接可以替换子查询，并且比子查询的效率一般会更快。

可以用 AS 给列名、计算字段和表名取别名，给表名取别名是为了简化 SQL 语句以及连接相同表。

内连接
内连接又称等值连接，使用 INNER JOIN 关键字。

select a, b, c
from A inner join B
on A.key = B.key
可以不明确使用 INNER JOIN，而使用普通查询并在 WHERE 中将两个表中要连接的列用等值方法连接起来。

select a, b, c
from A, B
where A.key = B.key
在没有条件语句的情况下返回笛卡尔积。

自连接
自连接可以看成内连接的一种，只是连接的表是自身而已。

一张员工表，包含员工姓名和员工所属部门，要找出与 Jim 处在同一部门的所有员工姓名。

子查询版本

select name
from employee
where department = (
      select department
      from employee
      where name = "Jim");
自连接版本

select name
from employee as e1, employee as e2
where e1.department = e2.department
      and e1.name = "Jim";
连接一般比子查询的效率高。

自然连接
自然连接是把同名列通过等值测试连接起来的，同名列可以有多个。

内连接和自然连接的区别：内连接提供连接的列，而自然连接自动连接所有同名列；内连接属于自然连接。

select *
from employee natural join department;
外连接
外连接保留了没有关联的那些行。分为左外连接，右外连接以及全外连接，左外连接就是保留左表的所有行。

检索所有顾客的订单信息，包括还没有订单信息的顾客。

select Customers.cust_id, Orders.order_num
   from Customers left outer join Orders
   on Customers.cust_id = Orders.curt_id
如果需要统计顾客的订单数，使用聚集函数。

select Customers.cust_id,
       COUNT(Orders.order_num) as num_ord
from Customers left outer join Orders
on Customers.cust_id = Orders.curt_id
group by Customers.cust_id
组合查询
使用 UNION 来连接两个查询，每个查询必须包含相同的列、表达式或者聚集函数。

默认会去除相同行，如果需要保留相同行，使用 UNION ALL 。

只能包含一个 ORDER BY 子句，并且必须位于语句的最后。

SELECT col
FROM mytable
WHERE col = 1
UNION
SELECT col
FROM mytable
WHERE col =2;
插入
普通插入

INSERT INTO mytable(col1, col2)
VALUES(val1, val2);
插入检索出来的数据

INSERT INTO mytable1(col1, col2)
SELECT col1, col2
FROM mytable2;
将一个表的内容复制到一个新表

CREATE TABLE newtable AS
SELECT * FROM mytable;
更新
UPDATE mytable
SET col = val
WHERE id = 1;
删除
DELETE FROM mytable
WHERE id = 1;
TRUNCATE TABLE 可以清空表，也就是删除所有行。

使用更新和删除操作时一定要用 WHERE 子句，不然会把整张表的数据都破坏。可以先用 SELECT 语句进行测试，防止错误删除。

创建表
CREATE TABLE mytable (
  id INT NOT NULL AUTO_INCREMENT,
  col1 INT NOT NULL DEFAULT 1,
  col2 VARCHAR(45) NULL,
  col3 DATE NULL,
  PRIMARY KEY (`id`));
修改表
添加列

ALTER TABLE mytable
ADD col CHAR(20);
删除列

ALTER TABLE mytable
DROP COLUMN col;
删除表

DROP TABLE mytable;
视图
视图是虚拟的表，本身不包含数据，也就不能对其进行索引操作。对视图的操作和对普通表的操作一样。

视图具有如下好处：

简化复杂的 SQL 操作，比如复杂的联结；
只使用实际表的一部分数据；
通过只给用户访问视图的权限，保证数据的安全性；
更改数据格式和表示。
CREATE VIEW myview AS
SELECT Concat(col1, col2) AS concat_col, col3*col4 AS count_col
FROM mytable
WHERE col5 = val;
存储过程
存储过程可以看成是对一系列 SQL 操作的批处理；

使用存储过程的好处

把实现封装在了存储过程中，不仅简单，也保证了安全性；
可以复用代码；
由于是预先编译，因此具有很高的性能。
创建存储过程

命令行中创建存储过程需要自定义分隔符，因为命令行是以 ; 为结束符，而存储过程中也包含了分号，因此会错误把这部分分号当成是结束符，造成语法错误。

包含 in、out 和 inout 三种参数。

给变量赋值都需要用 select into 语句。

每次只能给一个变量赋值，不支持集合的操作。

delimiter //

create procedure myprocedure( out ret int )
    begin
        declare y int;
        select sum(col1)
        from mytable
        into y;
        select y*y into ret;
    end //
delimiter ;
call myprocedure(@ret);
select @ret;
游标
在存储过程中使用游标可以对一个结果集进行移动遍历。

游标主要用于交互式应用，其中用户需要对数据集中的任意行进行浏览和修改。

使用游标的四个步骤：

声明游标，这个过程没有实际检索出数据；
打开游标；
取出数据；
关闭游标；
delimiter //
create procedure myprocedure(out ret int)
    begin
        declare done boolean default 0;

        declare mycursor cursor for
        select col1 from mytable;
        # 定义了一个continue handler，当 sqlstate '02000' 这个条件出现时，会执行 set done = 1
        declare continue handler for sqlstate '02000' set done = 1;

        open mycursor;

        repeat
            fetch mycursor into ret;
            select ret;
        until done end repeat;

        close mycursor;
    end //
 delimiter ;
触发器
触发器会在某个表执行以下语句时而自动执行：DELETE、INSERT、UPDATE

触发器必须指定在语句执行之前还是之后自动执行，之前执行使用 BEFORE 关键字，之后执行使用 AFTER 关键字。BEFORE 用于数据验证和净化。

INSERT 触发器包含一个名为 NEW 的虚拟表。

CREATE TRIGGER mytrigger AFTER INSERT ON mytable
FOR EACH ROW SELECT NEW.col;
DELETE 触发器包含一个名为 OLD 的虚拟表，并且是只读的。

UPDATE 触发器包含一个名为 NEW 和一个名为 OLD 的虚拟表，其中 NEW 是可以被修改地，而 OLD 是只读的。

可以使用触发器来进行审计跟踪，把修改记录到另外一张表中。

MySQL 不允许在触发器中使用 CALL 语句 ，也就是不能调用存储过程。

事务处理
基本术语

事务（transaction）指一组 SQL 语句；
回退（rollback）指撤销指定 SQL 语句的过程；
提交（commit）指将未存储的 SQL 语句结果写入数据库表；
保留点（savepoint）指事务处理中设置的临时占位符（placeholder），你可以对它发布回退（与回退整个事务处理不同）。
不能回退 SELECT 语句，回退 SELECT 语句也没意义；也不能回退 CRETE 和 DROP 语句。

MySQL 的事务提交默认是隐式提交，也就是每执行一条语句就会提交一次。当出现 START TRANSACTION 语句时，会关闭隐式提交；当 COMMIT 或 ROLLBACK 语句执行后，事务会自动关闭，重新恢复隐式提交。

通过设置 autocommit 为 0 可以取消自动提交，直到 autocommit 被设置为 1 才会提交；autocommit 标记是针对每个连接而不是针对服务器的。

如果没有设置保留点，ROLLBACK 会回退到 START TRANSACTION 语句处；如果设置了保留点，并且在 ROLLBACK 中指定该保留点，则会回退到该保留点。

START TRANSACTION
// ...
SAVEPOINT delete1
// ...
ROLLBACK TO delete1
// ...
COMMIT
字符集
基本术语

字符集为字母和符号的集合；
编码为某个字符集成员的内部表示；
校对字符指定如何比较，主要用于排序和分组。
除了给表指定字符集和校对外，也可以给列指定：

CREATE TABLE mytable
(col VARCHAR(10) CHARACTER SET latin COLLATE latin1_general_ci )
DEFAULT CHARACTER SET hebrew COLLATE hebrew_general_ci;
可以在排序、分组时指定校对：

SELECT *
FROM mytable
ORDER BY col COLLATE latin1_general_ci;
权限管理
MySQL 的账户信息保存在 mysql 这个数据库中。

USE mysql;
SELECT user FROM user;
创建账户

CREATE USER myuser IDENTIFIED BY 'mypassword';
新创建的账户没有任何权限。

修改账户名

RENAME myuser TO newuser;
删除账户

DROP USER myuser;
查看权限

SHOW GRANTS FOR myuser;


账户用 username@host 的形式定义，username@% 使用的是默认主机名。

授予权限

GRANT SELECT, INSERT ON mydatabase.* TO myuser;
删除权限

REVOKE SELECT, INSERT ON mydatabase.* FROM myuser;
GRANT 和 REVOKE 可在几个层次上控制访问权限：

整个服务器，使用 GRANT ALL和 REVOKE ALL；
整个数据库，使用 ON database.*；
特定的表，使用 ON database.table；
特定的列；
特定的存储过程。
更改密码

必须使用 Password() 函数

SET PASSWROD FOR myuser = Password('newpassword');
