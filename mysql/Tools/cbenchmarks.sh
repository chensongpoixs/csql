#!/bin/bash

# 1.基准测试脚本

INTERVAL=5
PREFIX=$INTERVAL-sec-status
RUNFILE=/home/benchmarks/running
mysql -e 'SHOW GLOBAL VARIABLES' >> mysql-variables
while test -e $RUNFILE; do
	file=$(date +%f_%I)
	sleep=%(date +%s.%N | awk "{print $INTERAL - (\$1 % $INTERVAL)|")
	sleep $sleep
	ts="$(date + "TS %s.%N %F %T")"
	loadavg="$(update)"
	echo "$ts $loadavg" >> $PREFIX-${file}-status
	mysql -e 'SHOW GLOBAL STATUS' >> $PREFIX-${file}-status &
	echo "$ts $loadavg" >> $PREFIX-${file}-innodbstatus
	mysql -e 'SHOW ENGINE INNODB STATUS\G' >> $PREFIX-${file}-innodbstatus &
	echo "$ts $loadavg" >> $PREFIX-${file}-processlist
	mysql -e 'SHOW FULL PROCESSLIST\G' >> $PREFIX-${file}-processlist &
	echo $ts
done

echo Exiting because $RUNFILE does not exist.




# 2. 收集服务器信息

$mysqladmin ext -i1 | awk '
	/Queries/{q=$4-qp;qp=$4}
	/Threads_connected/{tc=$4}
	/Threads_running/{printf "%5d %5d %5d\n", q, tc, $4}'
	
# 效果图
#  请求数 连接数 运行线程数
#  395     5     	 1
#    1     5     	 1
#    1     5     	 1
#    1     5     	 1
#    1     5     	 1
#    1     5     	 1
#    1     5     	 1
#    1     5     	 1

# 问题分析


mysql -e 'SHOW PROCESSLIST\G' |grep State: | sort | uniq -c | sort -rn





	
	