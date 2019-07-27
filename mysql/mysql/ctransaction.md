###  一, 索引

#### 1, B-Tree 索引的限制

##### ① 如果不是按照索引的最左列开始查找, 则无法使用索引。

##### ② 不能跳过索引中列。

##### ③ 如果查询中有某个列的范围查询，则其右边所有列都无法使用索引优化查找。


#### 2, 哈希索引的限制

##### ① 哈希索引只包含哈希值和行指针, 而不存储字段值, 所有不能使用索引中的值来避免读取行。不过, 访问内存中的行的速度很快, 所以大部分情况下这一点对性能的影响并不明显。

##### ② 哈希索引数据并不是按照索引只顺序存储的, 所以也就无法用于排序。

##### ③ 哈希索引也不支持部分索引列匹配查找， 因为哈希索引始终是使用索引列的全部内容计算哈希值的。

例如：

在数据列(A, B) 上建立哈希索引， 如果查询只有数据列A，则无法使用该索引

##### ④ 哈希索引只支持等值比较查询， 包括=，IN(), <=>(注意<> 和<=>是不同的操作)。也不支持任何范围查询，例如 WHERE price > 100;.

##### ⑤ 访问哈希索引的数据非常快, 除非有很多哈希冲突(不同的索引列值却有相同的哈希值)。当出现哈希冲突的时候，存储引擎必须遍历链表中所有的行指针，逐行进行比较， 直到直到所有符合条件的行。

##### ⑥ 如果哈希冲突很多的话，一些索引维护操作的代价也会很高。

例如:

如果在某个选择性很低(哈希冲突很多)的列上建立哈希索引，那么当从表中删除一行时，存储引擎需要遍历对应哈希值的链表中的每一行，找到并删除对应行的引用，冲突越多，代价越大



md5和sha1都是强加密的， 加密的速度会比较慢， 使用crc64哈希值加密 这个加密速度相比md5和sha1块一点但是会有哈希冲突， 所以在查询的时候要多一个条件 where 


#### 3, 索引的优点

##### ① 索引大大减少了服务器需要扫描的数据量。

##### ② 索引开源帮助服务器避免排序和临时表。

##### ③ 索引开源将随机I/O变为顺序I/O。



### 二, Mysql查询优化

#### 1, Mysql查询流程

![](https://github.com/chensongpoixs/chensongpoixs.github.io/blob/master/img/2019-07-21/mysql_search.png?raw=true)


1. 客户端发送一条查询给服务器。
2. 服务器先检查查询缓存，如果命中了缓存，则立即返回存储中的结果。否则进入下一阶段。
3. 服务器端进入SQL解析，预处理，再由优化器生成对应的执行计划。
4. Mysql根据优化器生成的执行计划，调用存储引擎的API来执行查询。
5. 将结果返回给客户端。



#### 2, mysql 不支持同时查询同时修改 但是可以使用临时表

```
update tb1 as outer_tb1
	set cnt = ( 
		select count(*) from tb1 as inner_tb1
		where inner_tb1.type = outer_tb1.type
	);
// error 1093
```

ok

```
update tb1 
	inner join(
		select type, count(*) as cnt
		from tb1
		grop by type
	) as der using(type)
set tb1.cnt = der.cnt;

```


#### 3, MySql的存储引擎介绍

##### ① InnoDB存储引擎

InnoDB存储引擎支持事务，主要面向在线事务处理(OLTP)方面的应用。其特点是行锁设计，支持外健，并支持类类于Oracle的非锁定读，即默认情况下读取存储不会产生锁。MySQL在Windows版本小的InnoDB是默认的存储引擎，同时InnoDB默认地包含在所有的MySQL二进制发布版本。

InnoDB存储引擎将数据放到一个逻辑的表空间中，这个表空间就像黑盒一样由InnoDB自身进行管理。从MySQL4.1版本开始，它可以将每个InnoDB存储引擎的表单独存放到一个独立的ibd文件中。与Oracle类似，InnoDB存储引擎同样可以使用设备(row disk)来建立其表空间。

InnoDb通过使用多版本并发控制(MVCC)来获取高并发性，并且实现了SQL标准的4中隔离级别，默认为REPEATABLE级别。同时使用一种被称为next-key locking的策略了避免幻读(phantom)现象的产生。除此之外，InnoDB存储引擎还提供了插入缓存(insert buffer),二次写(double write),自适应哈希索引(adaptive hash index)，预读取(read ahead)等高性能和高可用的功能。

对于表中数据的存储，InnoDB存储引擎采用了聚集(clustered)的方式，这种方法类似于Oracle的索引聚集表(index organized table, IOT)。 每张表的存储都按主键的顺序存放，如果没有显式地在表定义时指定主键，InnoDB存储引擎为每一行生成一个6字节的ROWID，并以此作为主键。

##### ② MyISAM存储引擎

MyISAM存储引擎s MySQL官方提供的存储引擎。其特点是不支持事务，表锁和全文索引，对于一些OLAP(Online Analytical Processing, 在线分析处理)操作速度快。除Windows版本外，是所有MySQL版本默认的存储引擎。

MySQL存储引擎表由MYD和MYI组成，MYD原理存放数据文件，MYI用来存放索引文件，可以通过myisampack工具来进一步压缩数据文件，因为myisampack工具使用哈夫曼(Huffan)编码静态算法来压缩数据，因此使用myisampack工具压缩后的表是只读的，当然你也可以通过myisampack来解压数据文件。

在MySQL5.0版本之前，MyISAM默认支持的表大小为4G，如果需要支持大于4G的MyISAM表时，则需要制定MAX_ROWS和AVG_ROW_LENGTH的属性。从MyISAM5.0版本开始，MYIASM默认支持256T的单表数据，这足够一般应用的需求。

##### ③ NDB存储索引

2003年，MySQL AB公司从






