/*
 Navicat Premium Data Transfer

 Source Server         : localhost
 Source Server Type    : MySQL
 Source Server Version : 50617
 Source Host           : localhost:3306
 Source Schema         : chensong

 Target Server Type    : MySQL
 Target Server Version : 50617
 File Encoding         : 65001

 Date: 21/04/2019 22:40:10
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for t_test_tables
-- ----------------------------
DROP TABLE IF EXISTS `t_test_tables`;
CREATE TABLE `t_test_tables`  (
  `user_permission_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '编号',
  `user_id` int(10) UNSIGNED NOT NULL COMMENT '用户编号',
  `permission_id` int(10) UNSIGNED NOT NULL COMMENT '权限编号',
  `type` tinyint(4) NOT NULL COMMENT '权限类型(-1:减权限,1:增权限)',
  PRIMARY KEY (`user_permission_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 25 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '用户权限关联表' ROW_FORMAT = Compact;

-- ----------------------------
-- Records of t_test_tables
-- ----------------------------
INSERT INTO `t_test_tables` VALUES (3, 1, 22, -1);
INSERT INTO `t_test_tables` VALUES (4, 1, 22, 1);
INSERT INTO `t_test_tables` VALUES (5, 2, 24, -1);
INSERT INTO `t_test_tables` VALUES (6, 2, 26, -1);
INSERT INTO `t_test_tables` VALUES (7, 2, 27, -1);
INSERT INTO `t_test_tables` VALUES (8, 2, 29, -1);
INSERT INTO `t_test_tables` VALUES (9, 2, 32, -1);
INSERT INTO `t_test_tables` VALUES (10, 2, 51, -1);
INSERT INTO `t_test_tables` VALUES (11, 2, 48, -1);
INSERT INTO `t_test_tables` VALUES (12, 2, 50, -1);
INSERT INTO `t_test_tables` VALUES (13, 2, 35, -1);
INSERT INTO `t_test_tables` VALUES (14, 2, 46, -1);
INSERT INTO `t_test_tables` VALUES (15, 2, 37, -1);
INSERT INTO `t_test_tables` VALUES (16, 2, 38, -1);
INSERT INTO `t_test_tables` VALUES (17, 2, 57, -1);
INSERT INTO `t_test_tables` VALUES (18, 2, 56, -1);
INSERT INTO `t_test_tables` VALUES (19, 2, 59, -1);
INSERT INTO `t_test_tables` VALUES (20, 2, 78, -1);
INSERT INTO `t_test_tables` VALUES (21, 2, 67, -1);
INSERT INTO `t_test_tables` VALUES (22, 2, 83, -1);
INSERT INTO `t_test_tables` VALUES (23, 2, 71, -1);
INSERT INTO `t_test_tables` VALUES (24, 2, 75, -1);

SET FOREIGN_KEY_CHECKS = 1;
