<?php
require_once('./config.php');

	function get_db($tmp_config)
	{
		$tmp_db = @new mysqli($tmp_config["host"], $tmp_config["username"], $tmp_config["passwd"], $tmp_config["dbname"], $tmp_config["port"]);
		if ($tmp_db->connect_errno)
		{
			return NULL;
		}
		$tmp_db->query("set names 'utf8'");
		return $tmp_db;
	}
	
	function get_chensong_db()
	{
		global $chensong_db_config;
		return get_db($chensong_db_config);
	}
	

	function DEBUG($str)
	{
		error_log(date("[Y-m-d H:i:s]")." [".$_SERVER['REQUEST_URI']."] : ".$str."\n", 3, "./debug.log");
	}

	function error_return($db, $str)
	{
		$reply["ret"] = 1;
		$reply["msg"] = $str;
		echo json_encode($reply);
		if($db != NULL)
		{
			$db->close();
		}
		exit;
	}
	
	function access_url($url)
	{
		if ($url=='') return false;
		$fp = fopen($url, 'r');
		if(!$fp)
		{
			return('Open url faild!');
		}
		$file = '';
		while(!feof($fp)) {
			$file.=fgets($fp)."";
		}
		fclose($fp);
		return $file;
   } 

?>
