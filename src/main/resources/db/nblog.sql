/*
Navicat MySQL Data Transfer

Source Server         : localhost_3306
Source Server Version : 50722
Source Host           : localhost:3306
Source Database       : nblog

Target Server Type    : MYSQL
Target Server Version : 50722
File Encoding         : 65001

Date: 2019-02-04 10:49:34
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for about
-- ----------------------------
DROP TABLE IF EXISTS `about`;
CREATE TABLE `about` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) DEFAULT NULL,
  `logo` varchar(255) DEFAULT NULL,
  `sub_title` varchar(255) DEFAULT NULL,
  `keywords` varchar(255) DEFAULT NULL,
  `description` varchar(500) DEFAULT NULL,
  `site_email` varchar(255) DEFAULT NULL,
  `site_icp` varchar(255) DEFAULT NULL,
  `ping_sites` varchar(255) DEFAULT NULL,
  `meta` varchar(255) DEFAULT NULL,
  `remark` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of about
-- ----------------------------

-- ----------------------------
-- Table structure for article
-- ----------------------------
DROP TABLE IF EXISTS `article`;
CREATE TABLE `article` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) DEFAULT NULL,
  `subtitle` varchar(255) DEFAULT NULL,
  `author` varchar(255) DEFAULT NULL,
  `keyword` varchar(255) DEFAULT NULL COMMENT '关键词',
  `shortcut` varchar(255) DEFAULT NULL,
  `content` text,
  `numbers` int(11) DEFAULT NULL COMMENT '字数',
  `origin` int(11) DEFAULT NULL COMMENT '是否原创：0转载，1原创',
  `tag_ids` varchar(255) DEFAULT NULL COMMENT '标签id',
  `category_id` bigint(20) DEFAULT NULL COMMENT '分类id',
  `create_time` datetime DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  `deploy_time` datetime DEFAULT NULL,
  `user_id` bigint(20) DEFAULT NULL,
  `is_top` tinyint(4) DEFAULT NULL COMMENT '是否置顶：0为不置顶，1为置顶',
  `is_recommend` tinyint(4) DEFAULT NULL COMMENT '是否推荐：0为不推荐；1为推荐',
  `status` tinyint(2) DEFAULT NULL COMMENT '状态:0草稿；1：发布',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of article
-- ----------------------------

-- ----------------------------
-- Table structure for article_likes
-- ----------------------------
DROP TABLE IF EXISTS `article_likes`;
CREATE TABLE `article_likes` (
  `id` bigint(20) NOT NULL,
  `article_id` bigint(20) DEFAULT NULL,
  `ip_address` bigint(20) DEFAULT NULL COMMENT 'ip地址',
  `is_like` tinyint(2) DEFAULT NULL COMMENT '是否点赞：0为点赞，1为不点赞',
  `like_source` int(11) DEFAULT NULL COMMENT '点赞分数:1-5个等级',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of article_likes
-- ----------------------------

-- ----------------------------
-- Table structure for category
-- ----------------------------
DROP TABLE IF EXISTS `category`;
CREATE TABLE `category` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL COMMENT '分类名称',
  `desc` varchar(255) DEFAULT NULL COMMENT '分类描述',
  `create_time` datetime DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of category
-- ----------------------------

-- ----------------------------
-- Table structure for comment
-- ----------------------------
DROP TABLE IF EXISTS `comment`;
CREATE TABLE `comment` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `article_id` bigint(20) DEFAULT NULL COMMENT '文章id',
  `content` varchar(255) DEFAULT NULL COMMENT '评论内容',
  `is_top` tinyint(2) DEFAULT NULL COMMENT '是否置顶：0为不置顶;1为置顶',
  `is_recommend` tinyint(4) DEFAULT NULL COMMENT '是否推荐：0：不推荐，1推荐',
  `user_id` bigint(20) DEFAULT NULL,
  `status` tinyint(2) DEFAULT NULL COMMENT '审核状态：0为未审核，1为审核通过',
  `create_time` datetime DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of comment
-- ----------------------------

-- ----------------------------
-- Table structure for message
-- ----------------------------
DROP TABLE IF EXISTS `message`;
CREATE TABLE `message` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) DEFAULT NULL COMMENT '留言用户',
  `content` varchar(500) DEFAULT NULL COMMENT '留言内容',
  `status` tinyint(2) DEFAULT NULL COMMENT '审核是否通过：0：通过；1不通过',
  `create_time` datetime DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of message
-- ----------------------------

-- ----------------------------
-- Table structure for tag
-- ----------------------------
DROP TABLE IF EXISTS `tag`;
CREATE TABLE `tag` (
  `id` bigint(20) NOT NULL,
  `name` varchar(255) DEFAULT NULL COMMENT '标签名',
  `desc` varchar(255) DEFAULT NULL COMMENT '标签描述',
  `icon` varchar(255) DEFAULT NULL COMMENT '标签图标',
  `create_time` datetime DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of tag
-- ----------------------------

-- ----------------------------
-- Table structure for time_axis
-- ----------------------------
DROP TABLE IF EXISTS `time_axis`;
CREATE TABLE `time_axis` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) DEFAULT NULL COMMENT '时间轴节点标题',
  `content` varchar(255) DEFAULT NULL COMMENT '时间轴内容',
  `status` tinyint(2) DEFAULT NULL COMMENT '状态',
  `start_time` datetime DEFAULT NULL COMMENT '开始时间',
  `end_time` datetime DEFAULT NULL COMMENT '结束时间',
  `create_time` datetime DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  `user_id` bigint(20) DEFAULT NULL COMMENT '用户id',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of time_axis
-- ----------------------------

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `username` varchar(255) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `phone` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `sex` varchar(4) DEFAULT NULL,
  `icon` varchar(255) DEFAULT NULL,
  `remark` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of user
-- ----------------------------
