### 一, 


#### 1, InnoDB行记录格式

InnoDB存储引擎和大多数据库一样，记录是以行的形式存储的。 这意味着页中保存着表中一行行的数据。到MySQL5.1时，InnoDB存储引擎提供了Compact和Redundant两种格式来存放行记录数据，Redundant是为兼容之前版本而保留的，如果你阅读过InnoDB的源代码，会发现源代码张红是用PHYSICAL RECORD（NEW STYLE）和PHYSICAL RECORD （OLD STYLE）来区分两种格式的。MySQL5.1默认保存为Compact行格式。你可以通过命令SHOW TABLE STATUS LIKE 'table_name';来查看当前表使用的行格式，其中row_format就代表了当前使用的行记录结构类型。

```
mysql> show table status like 't_test%';
+--------+--------+---------+------------+------+----------------+-------------+-----------------+--------------+-----------+----------------+---------------------+---------------------+------------+-------------------+----------+--------------------+---------+
| Name   | Engine | Version | Row_format | Rows | Avg_row_length | Data_length | Max_data_length | Index_length | Data_free | Auto_increment | Create_time         | Update_time         | Check_time | Collation         | Checksum | Create_options     | Comment |
+--------+--------+---------+------------+------+----------------+-------------+-----------------+--------------+-----------+----------------+---------------------+---------------------+------------+-------------------+----------+--------------------+---------+
| t_test | InnoDB |      10 | Compact    |    8 |           2048 |       16384 |               0 |            0 |         0 | NULL           | 2019-07-30 11:14:24 | 2019-07-30 13:21:51 | NULL       | latin1_swedish_ci | NULL     | row_format=COMPACT |         |
+--------+--------+---------+------------+------+----------------+-------------+-----------------+--------------+-----------+----------------+---------------------+---------------------+------------+-------------------+----------+--------------------+---------+
1 row in set
```

可以看到，这里t_test表是Compact的行格式。

##### ① Compact行记录格式

Compact行记录是在MySQL 5.0时被引入的，其设计目标是能高效存放数据。简单来说，如果一个页中存放的行数据越多，其性能就越高。Compact行记录以如下发送进行存储。

|变长字段长度列表|NULL标志位|记录头信息|列1数据|列2数据|...|
|:--:|:--:|:--:|:--:|

从上表格中可以看到，Compact行格式的首部是一个非NULL变长字段长度列表，而且是按照列的顺序逆序放置的。当列的长度小于255字节，用1字节表示，若大于255个字节，用2个字节表示，变长字段的长度最大不可以超过2个字节（这也很好地解析了为什么MySQL中varchar的最大长度为65535，因为2个字节为16位，即2的16次方=65534）。第二个部分是NULL标志位，该位指示了该行数据中是否有NULL值，用1表示。该部分所占的字节应该为bytes。接下去的部分是为记录头信息（record head），固定占用5个字节（40位）。最后的部分就是时间匆匆的目光列的数据了，需要特别注意的是，NULL不占该部分如果数据，即NULL除了占有NULL标志位，实际存储不占有任何空间。另外有一点需要注意的是，每行数据除了用户定义的列外，还有两个隐藏列，事务ID列和回滚指针列，分别为6个字节和7个字节的大小。若InnoDB表没有定义primary key， 每行还会增加一个6字节的RowID列。

1. 变长字段长度列表 

默认都插入数据 默认是 01 01 01


Compact页格式

|名称|大小（bit）|描述|
|:--:|:--:|:--:|
|（）|1|未知|
|（）|1|未知|
|deleted_flag|1|该行是否移交被删除|
|min_rec_flag|1|为1，如果该记录是预先被定义为最小的记录|
|n_owned|4|该记录拥有的记录数|
|heap_no|13|索引堆中该记录的排序记录|
|record_type|3|记录类型000=普通 001=B+树节点指针 010=Infimum 011=Supremum 1xx=保留|
|next_recorder|16|页中下一条记录的相对位置|


分析图

[]

##### ① Redundant行记录格式

Redundant是MySQL 5.0版本之前InnoDB的行记录存储方式，MySQL5.0支持Redundant是为了向前兼容性。Redundant行记录以如下发送存储：

|字段长度偏移列表|记录头信息|列1数据|列2数据|...|
|:--:|:--:|:--:|:--:|

从上图看到， 不同于Compact行记录格式，Redundant行格式的首部是一个字段长度偏移列表，同样是按照的顺序逆序放置的。当列的长度小于255字节，用1字节表示，若大于255个字节，用2个字节表示。第二个部分为记录头信息（record header），不同于Compact行格式， Redundant行格式固定占用6个字节（48位），每位的见小标，从表中可以看到，n_fields值代表一行中列的数量，占用10位，这也很好地解释了为什么MySQL一个行支持最多的列为1023.另一个需要注意的值为1byte_offs_flags，该值定义了偏移列表占用1个字节还是2个字节。最后的部分就是实际存储的目光列的数据了。

Redundant页格式

|名称|大小（bit）|描述|
|:--:|:--:|:--:|
|（）|1|未知|
|（）|1|未知|
|deleted_flag|1|该行是否已经被删除|
|min_rec_flag|1|为1，如果该记录是预先被定义为最小的记录|
|n_owned|4|该记录拥有的记录数|
|heap_no|13|索引堆中该条记录的排序记录|
|n_fields|10|记录中列的数量|
|1byte_offs_flag|1|偏移列表位1个字节还是2个字节|
|next_record|16|页中下一条记录的相对位置|

23 20 16 14 13 0c 06，逆序为06, 0c, 13, 14, 16, 20, 23。分别代表第一列长度6，第二列长度6（6+6=0x0c），第三列长度为7（6+6+7=0x13），第四列长度1（6+6+7+1=0x14）,第五列长度2（6+6+7+1+2=0x16），第六列长度10（6+6+7+1+2+10=0x20），第七列长度3（6+6+7+1+2+10+3=0x23）。

接着的记录头头信息中应该注意48位中22~32位，位0000000111，表示表共有7个列（包含了隐藏的3列），接下去的33位为1，代表偏移列表为应该字节。


#### 2, InnoDB数据页结构

InnoDB数据页由以下7个部分组成，

1. File Header（文件头）
2. Page Header （页头）
3. Infimun 和 Supremum Recoreds
4. User Record（用户记录，即行记录）
5. Free Space（空闲空间）
6. Page Directory（页目录）
7. File Trailer （文件结尾信息）

其中File Header， Page Header， File Tailer的大小是固定的，分别为38,56,8字节，这些空间用来标记该页的一些信息，如Checksum，数据页所在B+树索引的层数等，User Records， Free Space， Page Directory这些部分为实际的行记录存储空间，因此大小是动态的。在接下来的各小小结中即将具体分析各组成部分。

##### ① File Header 

File Header用来记录页的一些头信息，由如下8个部分组成，共占用38个字节。

FIle Header组成部分

|名称|大小（字节）|
|:--:|:--:|
|FIL_PAGE_SPACE_OR_CHKSUM|4|
|FIL_PAGE_OFFSET|4|
|FIL_PAGE_PREV|4|
|FIL_PAGE_NEXT|4|
|FIL_PAGE_LST|8|
|FIL_PAGE_TYPE|2|
|FIL_PAGE_FILE_FLUSH_LSN|8|
|FIL_PAGE_ARCH_LOG_NO_OR_SPACE_ID|4|

1. FIL_PAGE_SPACE_OR_CHKSUM: 当MySQL版本小MySQL-4.0.14，该值代表该页属于哪个表空间，因为如果我们没有开启innodb_file_per_table，共享表空间中可能存放许多页，不去这些也属于不同的表的空间。之后版本的MySQL，该值代表页的checksum值（一种新的checksum值）。
2. FIL_PAGE_OFFSET: 表空间中页的偏移值。
3. FIL_PAGE_PREV, FIL_PAGE_NEXT:当前页的上一个页以及下一个页。B+Tree特性决定了叶子节点必须是双向列表。
4. FIL_PAGE_LSN:该值代表该页最后被修改的日子序列位置LSN（Log Sequence Number）。
5. FIL_PAGE_TYPE: 页的类型。通常有以下几种类型 请记住0x45BF，该值代表了存放的数据页。

Page类型表

|名称|十六进制|解析|
|:--:|:--:|:--:|
|FIL_PAGE_INDEX|0x45BF|B+树叶节点|
|FIL_PAGE_UNDO_LOG|0x0002|Undo Log页|
|FIL_PAGE_INODE|0x0003|索引节点|
|FIL_PAGE_IBUF_FREE_LIST|0x0004|Insert Buffer空闲列表|
|FIL_PAGE_TYPE_ALLOCATED|0x0000|该页为最新分配|
|FIL_PAGE_IBUF_BITMAP|0x0005|Insert Buffer位图|
|FIL_PAGE_TYPE_SYS|0x0006|系统页|
|FIL_PAGE_TYPE_TRX_SYS|0x0007|事务系统数据|
|FIL_PAGE_TYPE_FSP_HDR|0x0008|File Space Header|
|FIL_PAGE_TYPE_XDES|0x0009|扩展描述页|
|FIL_PAGE_TYPE_BLOB|0x000A|BLOB页|

6. FIL_PAGE_FILE_FLSH_LSH:该值仅在数据挖掘中的一共页中定义，代表挖掘至少被更新到了该LSN值。
7. FIL_PAGE_ARCH_LOG_NO_OR_SPACE_ID:  从MySQL 4.1开始，该值代表页属于哪个表空间。


##### ② Page Header 

接着FIle Header部分的是Page Header， 用来记录数据页的状态信息。由以下14个部分组成，共占用56个字节。

Page Header 组成部分

|名称|大小（字节）|
|PAGE_N_DIR_SLOTS|2|
|PAGE_HEAP_TOP|2|
|PAGE_N_HEAP|2|
|PAGE_FREE|2|
|PAGE_GARBASGE|2|
|PAGE_LAST_INSERT|2|
|PAGE_DIRECTION|2|
|PAGE_N_DIRECTION|2|
|PAGE_N_RECS|2|
|PAGE_MAX_TRX_ID|8|
|PAGE_LEVEL|2|
|PAGE_INDEX_ID|8|
|PAGE_BTR_SEG_LEAF|10|
|PAGE_BTR_SEG_TOP|10|

1. PAGE_N_DIR_SLOTS:在Page Directory(页目录)中的Slot（槽）数。 
2. PAGE_HEAP_TOP: 堆中第一个记录的指针。
3. PAGE_N_HEAP: 堆中的记录数。
4. PAGE_FREE: 指向空闲列表的首指针。
5. PAGE_GARBAGE：已删除记录的字节数，即行记录结构中，delete flag 为1的记录大小的总数。
6. PAGE_LAST_INSERT:最后插入记录的位置。
7. PAGE_DIRECTION:最后插入的方向。可能的取值为PAGE_LEFT（0x01），PAGE_RIGHT（0x02），PAGE_SAME_REC（0x03），PAGE_SAME_PAGE(0x04),PAGE_NO_DIRECTION(0x05)
8. PAGE_N_DIRECTION:一个方向连接插入记录的数量。
9. PAGE_N_RECS: 该页中记录的数量。
10. PAGE_MAX_TRX_ID：修改当前页的最大事务ID，注意该值仅在Secondary Index定义。
11. PAGE_LEVEL：当前页在索引树中的位置，0x00代表叶节点。
12. PAGE_INDEX_ID：当前页属于哪个索引ID。
13. PAGE_BTR_SEG_LEAF：B+树的叶节点中，文件段的首指针位置。注意该值仅在B+树的Root页中定义。
14. PAGE_BTR_SEG_TOP: B+树的非叶节点中，文件段的首指针位置。注意该值仅在B+树的Root页中定义。

##### ③ Infimum和Supremum记录

在InnoDB存储引擎中，每个数据页中有两个虚拟的行记录，用来限定记录的边界。Infimum记录是比该页中任何主键值都要小的值，Supremum指比任何困难大的值还要大的值。这两个值在页创建时被建立，并且在任何情况下班后被删除。在Compact行格式和Redundant行格式下，两者占用的字节数各不相同。

##### ④ User Records与FreeSpace

User Records 是实际存储行记录的内容。InnoDB存储引擎表总是B+树索引组织的。

Free Space 指的就是空闲空间，同样也是个链表数据结构。当一条记录被删除后，该空间会被加入空闲链表中。

##### ⑤ Page Directory 

Page Directory（页目录）中存放了记录的相对位置（注意，这里存放的是页相对位置，而不是偏移量），有些时候最小记录指针称为slots（槽）或者目录槽（Directory Slots）。与其他数据库系统不同的是，InnoDB并不是每个记录拥有一个槽，InnoDB存储引擎的槽是一个稀疏目录（sparse directory），即一个槽中可能属于（belong to）多个记录，最少属于4条记录，最多属于8条记录。

Slots中记录安装键顺序存放，这样可以利用二叉查找迅速找到记录的指针。假设我们有（'i', 'd', 'c', 'b', 'e', 'g', 'l', 'h', 'f', 'j', 'k', 'a'）,同时假设一个槽中包含4条记录，则Slots中的记录可能是（'a', 'e', 'i'）。

由于InnoDB存储引擎中Slots是稀疏目录，二叉查找的价格指数一个粗略的价格，所以InnoDB必须通过recorder header 中next_record来继续查找相关记录。同时，slots很好地解析了recorder header 中的n_owned值的含义，即还有多少记录需要查找，因为最小记录并不包含在slots中。

需要牢记的是，B+树索引本身并不能找到具体的一条记录，B+树索引能找到指数该记录所在的页。数据库把页载入内存，然后通过Page Directory在进行二叉查找。只不过二叉查找的时间复杂度很低，同时内存中的查找很快，因此通常我们忽略了这部分查找所用的时间。


##### ⑥ File Trailer

为了保证页能够完整地写入磁盘（如可能发生的写入过程中磁盘损坏，机器宕机等原因），InnoDB存储引擎的页中设置了File Trailer部分。File Tailer只有一个FIL_PAGE_SPACE_OR_CHKSUM和FIL_PAGE_LSN值较小比较，看是否一致（checksum的比较需要通过InnoDB的checksum函数来进行比较，不是简单的等值比较），以此来保证页的完整性（corrupted）。


#### 3, InnoDB  数据页结构分析

首先创建一个表的， 导入一定量的数据：

```
drop table if exists `t_test_innodb_data`;
create table `t_test_innodb_data`(
`a` int unsigned not null auto_increment, 
`b` char(10), 
primary key(`a`)
)ENGINE=InnoDB CHARSET=UTF8;

-- 存储过程
delimiter $$
create procedure load_t(count int unsigned)
begin
set @c = 0;
while @c < count do
insert into `t_test_innodb_data` select null, repeat(char(97+rand()*26), 10);
set @c=@c+1;
end while;
end;
$$
delimiter;

-- 调用
call load_t(100);

```

接下来使用 py_innodb_page_info 来分析t_test_innodb_data.ibd 信息

```
python py_innodb_page_info.py C:\wamp\bin\mysql\mysql5.7.14\data\chensong\t_test_innodb_data.ibd -v

page offset 00000000, page type <File Space Header>
page offset 00000001, page type <Insert Buffer Bitmap>
page offset 00000002, page type <File Segment inode>
page offset 00000003, page type <B-tree Node>, page level <0000>
page offset 00000000, page type <Freshly Allocated Page>
page offset 00000000, page type <Freshly Allocated Page>
Total number of page: 6:
Freshly Allocated Page: 2
Insert Buffer Bitmap: 1
File Space Header: 1
B-tree Node: 1
File Segment inode: 1
```

看到第四个页（page offset 3）是数据页，然后通过hex来分析.ibd文件，打开整理得到的十六进制文件，数据页在0x0000c000h(16K*3=0xc000)处开始，得到以下内容：

【】

先来分析前面File Header的38个字节：

1. CC AB 6E 4F 数据页的Checksum值。
2. 00 00 00 03 页的偏移量， 从0开始
3. FF FF FF FF 前一个页，因为只有当前一个数据页，所以这里为0xFFFFFF。
4. FF FF FF FF 下一个页，因为只有当前一个数据页，所以这里为0xFFFFFF。
5. 00 00 00 00 00 27 FA AC 页的LSN 占8字节
6. 45 BF 页类型， 0x45BF代表数据页。
7. 00 00 00 00 00 00 00 这里暂时不管该值。
8. 00 00 00 00 表空间的SPACE ID

来看一下File Trailer部分。因为FIle Trailer 通过比较File Header部分来保证页写入的完整性。

【】

CC AD 6E 4F Checknum值，该值通过checksum函数和File Header部分的checksum值较小比较。
00 27 FA AC 注意到该值和File Header部分也的LSN后4个值相等。







