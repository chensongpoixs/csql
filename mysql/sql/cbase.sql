-- sql ������ϰ
--��ѯ
--SQL ��䲻���ִ�Сд���������ݿ������������ֵ�Ƿ����������ھ���� DBMS �Լ����á�

-- 1. DISTINCT ��ֵֻͬ�����һ�Ρ��������������У�Ҳ����˵�����е�ֵ����ͬ������ͬ��

-- ���ֲ�ͬ���
SELECT DISTINCT user_id, user_permission_id
from t_test_tables;

SELECT DISTINCT user_id
from t_test_tables;


-- 2. LIMIT ���Ʒ��ص�������������������������һ������Ϊ��ʼ�У��� 0 ��ʼ���ڶ�������Ϊ���ص���������
--����ǰ 5 �е� SQL��

SELECT *
FROM t_test_tables
LIMIT 5;


SELECT *
FROM t_test_tables
LIMIT 0, 5;

--���ص� 3 ~ 5 �У�

SELECT *
FROM t_test_tables
LIMIT 2, 3;




-- ����
--ASC������Ĭ�ϣ�DESC������

--1. ���԰�����н�������

SELECT *
FROM t_test_tables
ORDER BY user_id DESC, user_permission_id ASC;






--����
--������ǰ���ͬ�����ݷ���ͬһ���С�
--���Զ�ÿ������ʹ�û��ܺ������д���������ÿ������ƽ��ֵ�ȡ�
--�� col ���򲢷������ݣ�

SELECT col, COUNT(*) AS num
FROM mytable
GROUP BY col;
WHERE �����У�HAVING ���˷��飬�й���Ӧ�����������ˣ�

SELECT col, COUNT(*) AS num
FROM mytable
WHERE col > 2
GROUP BY col
HAVING COUNT(*) >= 2;
GROUP BY ��������Ϊ�����ֶΣ��� ORDER BY Ҳ�����Ծۼ��ֶ�����������

SELECT col, COUNT(*) AS num
FROM mytable
GROUP BY col
ORDER BY num;
����涨��

GROUP BY �Ӿ������ WHERE �Ӿ�֮��ORDER BY �Ӿ�֮ǰ��
���˻��ܼ������֮�⣬SELECT ����е�ÿһ�ж������� GROUP BY �Ӿ��и�����
NULL ���лᵥ����Ϊһ�飻
����� SQL ʵ�ֲ�֧�� GROUP BY �о��пɱ䳤�ȵ��������͡�
�Ӳ�ѯ
�Ӳ�ѯ��ֻ�ܷ���һ���С�

���Խ��Ӳ�ѯ�Ľ����Ϊ WHRER ���Ĺ���������

SELECT *
FROM mytable1
WHERE col1 IN (SELECT col2
                 FROM mytable2);
����������Լ������ͻ��Ķ����������Ӳ�ѯ����Լ�������ÿ���ͻ�ִ��һ�Σ�

SELECT cust_name, (SELECT COUNT(*)
                   FROM Orders
                   WHERE Orders.cust_id = Customers.cust_id)
                   AS orders_num
FROM Customers
ORDER BY cust_name;
����
�����������Ӷ����ʹ�� JOIN �ؼ��֣������������ʹ�� ON��

���ӿ����滻�Ӳ�ѯ�����ұ��Ӳ�ѯ��Ч��һ�����졣

������ AS �������������ֶκͱ���ȡ������������ȡ������Ϊ�˼� SQL ����Լ�������ͬ��

������
�������ֳƵ�ֵ���ӣ�ʹ�� INNER JOIN �ؼ��֡�

select a, b, c
from A inner join B
on A.key = B.key
���Բ���ȷʹ�� INNER JOIN����ʹ����ͨ��ѯ���� WHERE �н���������Ҫ���ӵ����õ�ֵ��������������

select a, b, c
from A, B
where A.key = B.key
��û��������������·��صѿ�������

������
�����ӿ��Կ��������ӵ�һ�֣�ֻ�����ӵı���������ѡ�

һ��Ա��������Ա��������Ա���������ţ�Ҫ�ҳ��� Jim ����ͬһ���ŵ�����Ա��������

�Ӳ�ѯ�汾

select name
from employee
where department = (
      select department
      from employee
      where name = "Jim");
�����Ӱ汾

select name
from employee as e1, employee as e2
where e1.department = e2.department
      and e1.name = "Jim";
����һ����Ӳ�ѯ��Ч�ʸߡ�

��Ȼ����
��Ȼ�����ǰ�ͬ����ͨ����ֵ�������������ģ�ͬ���п����ж����

�����Ӻ���Ȼ���ӵ������������ṩ���ӵ��У�����Ȼ�����Զ���������ͬ���У�������������Ȼ���ӡ�

select *
from employee natural join department;
������
�����ӱ�����û�й�������Щ�С���Ϊ�������ӣ����������Լ�ȫ�����ӣ��������Ӿ��Ǳ������������С�

�������й˿͵Ķ�����Ϣ��������û�ж�����Ϣ�Ĺ˿͡�

select Customers.cust_id, Orders.order_num
   from Customers left outer join Orders
   on Customers.cust_id = Orders.curt_id
�����Ҫͳ�ƹ˿͵Ķ�������ʹ�þۼ�������

select Customers.cust_id,
       COUNT(Orders.order_num) as num_ord
from Customers left outer join Orders
on Customers.cust_id = Orders.curt_id
group by Customers.cust_id
��ϲ�ѯ
ʹ�� UNION ������������ѯ��ÿ����ѯ���������ͬ���С����ʽ���߾ۼ�������

Ĭ�ϻ�ȥ����ͬ�У������Ҫ������ͬ�У�ʹ�� UNION ALL ��

ֻ�ܰ���һ�� ORDER BY �Ӿ䣬���ұ���λ���������

SELECT col
FROM mytable
WHERE col = 1
UNION
SELECT col
FROM mytable
WHERE col =2;
����
��ͨ����

INSERT INTO mytable(col1, col2)
VALUES(val1, val2);
�����������������

INSERT INTO mytable1(col1, col2)
SELECT col1, col2
FROM mytable2;
��һ��������ݸ��Ƶ�һ���±�

CREATE TABLE newtable AS
SELECT * FROM mytable;
����
UPDATE mytable
SET col = val
WHERE id = 1;
ɾ��
DELETE FROM mytable
WHERE id = 1;
TRUNCATE TABLE ������ձ�Ҳ����ɾ�������С�

ʹ�ø��º�ɾ������ʱһ��Ҫ�� WHERE �Ӿ䣬��Ȼ������ű�����ݶ��ƻ����������� SELECT �����в��ԣ���ֹ����ɾ����

������
CREATE TABLE mytable (
  id INT NOT NULL AUTO_INCREMENT,
  col1 INT NOT NULL DEFAULT 1,
  col2 VARCHAR(45) NULL,
  col3 DATE NULL,
  PRIMARY KEY (`id`));
�޸ı�
�����

ALTER TABLE mytable
ADD col CHAR(20);
ɾ����

ALTER TABLE mytable
DROP COLUMN col;
ɾ����

DROP TABLE mytable;
��ͼ
��ͼ������ı������������ݣ�Ҳ�Ͳ��ܶ��������������������ͼ�Ĳ����Ͷ���ͨ��Ĳ���һ����

��ͼ�������ºô���

�򻯸��ӵ� SQL ���������縴�ӵ����᣻
ֻʹ��ʵ�ʱ��һ�������ݣ�
ͨ��ֻ���û�������ͼ��Ȩ�ޣ���֤���ݵİ�ȫ�ԣ�
�������ݸ�ʽ�ͱ�ʾ��
CREATE VIEW myview AS
SELECT Concat(col1, col2) AS concat_col, col3*col4 AS count_col
FROM mytable
WHERE col5 = val;
�洢����
�洢���̿��Կ����Ƕ�һϵ�� SQL ������������

ʹ�ô洢���̵ĺô�

��ʵ�ַ�װ���˴洢�����У������򵥣�Ҳ��֤�˰�ȫ�ԣ�
���Ը��ô��룻
������Ԥ�ȱ��룬��˾��кܸߵ����ܡ�
�����洢����

�������д����洢������Ҫ�Զ���ָ�������Ϊ���������� ; Ϊ�����������洢������Ҳ�����˷ֺţ���˻������ⲿ�ַֺŵ����ǽ�����������﷨����

���� in��out �� inout ���ֲ�����

��������ֵ����Ҫ�� select into ��䡣

ÿ��ֻ�ܸ�һ��������ֵ����֧�ּ��ϵĲ�����

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
�α�
�ڴ洢������ʹ���α���Զ�һ������������ƶ�������

�α���Ҫ���ڽ���ʽӦ�ã������û���Ҫ�����ݼ��е������н���������޸ġ�

ʹ���α���ĸ����裺

�����α꣬�������û��ʵ�ʼ��������ݣ�
���αꣻ
ȡ�����ݣ�
�ر��αꣻ
delimiter //
create procedure myprocedure(out ret int)
    begin
        declare done boolean default 0;

        declare mycursor cursor for
        select col1 from mytable;
        # ������һ��continue handler���� sqlstate '02000' �����������ʱ����ִ�� set done = 1
        declare continue handler for sqlstate '02000' set done = 1;

        open mycursor;

        repeat
            fetch mycursor into ret;
            select ret;
        until done end repeat;

        close mycursor;
    end //
 delimiter ;
������
����������ĳ����ִ���������ʱ���Զ�ִ�У�DELETE��INSERT��UPDATE

����������ָ�������ִ��֮ǰ����֮���Զ�ִ�У�֮ǰִ��ʹ�� BEFORE �ؼ��֣�֮��ִ��ʹ�� AFTER �ؼ��֡�BEFORE ����������֤�;�����

INSERT ����������һ����Ϊ NEW �������

CREATE TRIGGER mytrigger AFTER INSERT ON mytable
FOR EACH ROW SELECT NEW.col;
DELETE ����������һ����Ϊ OLD �������������ֻ���ġ�

UPDATE ����������һ����Ϊ NEW ��һ����Ϊ OLD ����������� NEW �ǿ��Ա��޸ĵأ��� OLD ��ֻ���ġ�

����ʹ�ô�������������Ƹ��٣����޸ļ�¼������һ�ű��С�

MySQL �������ڴ�������ʹ�� CALL ��� ��Ҳ���ǲ��ܵ��ô洢���̡�

������
��������

����transaction��ָһ�� SQL ��䣻
���ˣ�rollback��ָ����ָ�� SQL ���Ĺ��̣�
�ύ��commit��ָ��δ�洢�� SQL �����д�����ݿ��
�����㣨savepoint��ָ�����������õ���ʱռλ����placeholder��������Զ����������ˣ����������������ͬ����
���ܻ��� SELECT ��䣬���� SELECT ���Ҳû���壻Ҳ���ܻ��� CRETE �� DROP ��䡣

MySQL �������ύĬ������ʽ�ύ��Ҳ����ÿִ��һ�����ͻ��ύһ�Ρ������� START TRANSACTION ���ʱ����ر���ʽ�ύ���� COMMIT �� ROLLBACK ���ִ�к�������Զ��رգ����»ָ���ʽ�ύ��

ͨ������ autocommit Ϊ 0 ����ȡ���Զ��ύ��ֱ�� autocommit ������Ϊ 1 �Ż��ύ��autocommit ��������ÿ�����Ӷ�������Է������ġ�

���û�����ñ����㣬ROLLBACK ����˵� START TRANSACTION ��䴦����������˱����㣬������ ROLLBACK ��ָ���ñ����㣬�����˵��ñ����㡣

START TRANSACTION
// ...
SAVEPOINT delete1
// ...
ROLLBACK TO delete1
// ...
COMMIT
�ַ���
��������

�ַ���Ϊ��ĸ�ͷ��ŵļ��ϣ�
����Ϊĳ���ַ�����Ա���ڲ���ʾ��
У���ַ�ָ����αȽϣ���Ҫ��������ͷ��顣
���˸���ָ���ַ�����У���⣬Ҳ���Ը���ָ����

CREATE TABLE mytable
(col VARCHAR(10) CHARACTER SET latin COLLATE latin1_general_ci )
DEFAULT CHARACTER SET hebrew COLLATE hebrew_general_ci;
���������򡢷���ʱָ��У�ԣ�

SELECT *
FROM mytable
ORDER BY col COLLATE latin1_general_ci;
Ȩ�޹���
MySQL ���˻���Ϣ������ mysql ������ݿ��С�

USE mysql;
SELECT user FROM user;
�����˻�

CREATE USER myuser IDENTIFIED BY 'mypassword';
�´������˻�û���κ�Ȩ�ޡ�

�޸��˻���

RENAME myuser TO newuser;
ɾ���˻�

DROP USER myuser;
�鿴Ȩ��

SHOW GRANTS FOR myuser;


�˻��� username@host ����ʽ���壬username@% ʹ�õ���Ĭ����������

����Ȩ��

GRANT SELECT, INSERT ON mydatabase.* TO myuser;
ɾ��Ȩ��

REVOKE SELECT, INSERT ON mydatabase.* FROM myuser;
GRANT �� REVOKE ���ڼ�������Ͽ��Ʒ���Ȩ�ޣ�

������������ʹ�� GRANT ALL�� REVOKE ALL��
�������ݿ⣬ʹ�� ON database.*��
�ض��ı�ʹ�� ON database.table��
�ض����У�
�ض��Ĵ洢���̡�
��������

����ʹ�� Password() ����

SET PASSWROD FOR myuser = Password('newpassword');
