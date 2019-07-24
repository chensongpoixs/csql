<?php
require_once('./header.php');


$db = get_chensong_db();
if($db == NULL)
{
	error_return(NULL, "get db failed");
}
//测试数量 11
$insert_num = 110000;

$num = 0;

while ($num < $insert_num)
{
	
	#$result = $db->query("insert INTO `t_webservicecalls` VALUES('2019-06-20', ".$num.", ".$num.", ".$num.", 1, 1, 1.1, 6, '2019-07-21');");
	$result = $db->query("insert INTO `t_payment` VALUES(".$insert_num.", ".$num.");");
	if (!$result)
	{
		error_return($db, "insert data error!");
	}
	DEBUG("insert db".$num." insert_num".$insert_num."----ok");
	++$num;
	--$insert_num;
}

$db->close();


?>