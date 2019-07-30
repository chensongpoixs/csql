/*
Navicat MySQL Data Transfer

Source Server         : localhost
Source Server Version : 50714
Source Host           : localhost:3306
Source Database       : chensong

Target Server Type    : MYSQL
Target Server Version : 50714
File Encoding         : 65001

Date: 2019-07-30 12:06:10
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for t_test
-- ----------------------------
DROP TABLE IF EXISTS `t_test`;
CREATE TABLE `t_test` (
  `t1` varchar(10) DEFAULT NULL,
  `t2` varchar(10) DEFAULT NULL,
  `t3` char(10) DEFAULT NULL,
  `t4` varchar(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Records of t_test
-- ----------------------------
INSERT INTO `t_test` VALUES ('a', 'a', 'a', 'a');
INSERT INTO `t_test` VALUES ('b', 'b', 'b', 'b');
INSERT INTO `t_test` VALUES ('b', 'c', 'c', 'c');
INSERT INTO `t_test` VALUES ('g', 'g', 'g', 'g');
INSERT INTO `t_test` VALUES ('e', 'e', 'e', 'e');
INSERT INTO `t_test` VALUES ('k', 'k', 'k', 'k');



-- 复制t_test表 到redundant的操作
create table `t_test_redundant` engine=innodb row_format=redundant as select *from `t_test`;
