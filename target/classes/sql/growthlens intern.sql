/*
 Navicat Premium Data Transfer

 Source Server         : myboot
 Source Server Type    : MySQL
 Source Server Version : 90200 (9.2.0)
 Source Host           : localhost:3306
 Source Schema         : growthlens intern

 Target Server Type    : MySQL
 Target Server Version : 90200 (9.2.0)
 File Encoding         : 65001

 Date: 06/07/2026 18:25:05
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for ai_call_log
-- ----------------------------
DROP TABLE IF EXISTS `ai_call_log`;
CREATE TABLE `ai_call_log`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '日志ID，主键自增',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '用户名',
  `template_id` bigint NULL DEFAULT NULL COMMENT '模板ID',
  `template_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '模板名称',
  `scene_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '场景类型',
  `request_content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '请求内容（发送给AI的完整prompt）',
  `response_content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '响应内容（AI返回的结果）',
  `call_status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '调用状态：success-成功，fail-失败',
  `error_message` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '错误信息（失败时记录）',
  `duration` bigint NULL DEFAULT NULL COMMENT '耗时（毫秒）',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user_id`(`user_id` ASC) USING BTREE,
  INDEX `idx_template_id`(`template_id` ASC) USING BTREE,
  INDEX `idx_call_status`(`call_status` ASC) USING BTREE,
  INDEX `idx_create_time`(`create_time` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'AI调用日志表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of ai_call_log
-- ----------------------------
INSERT INTO `ai_call_log` VALUES (1, 1, 'huang', 1, '文本润色模板', 'polish', '请对以下文本进行润色优化，使其更加通顺、专业、优美：\n\n', NULL, 'fail', 'I/O error on POST request for \"https://api.openai.com/v1/chat/completions\": Connection timed out: connect', 21472, '2026-07-06 16:02:08');
INSERT INTO `ai_call_log` VALUES (2, 1, 'huang', 1, '文本润色模板', 'polish', '请对以下文本进行润色优化，使其更加通顺、专业、优美：\n\n111', NULL, 'fail', 'I/O error on POST request for \"https://api.openai.com/v1/chat/completions\": Connection timed out: connect', 21045, '2026-07-06 16:02:12');

-- ----------------------------
-- Table structure for ai_prompt_template
-- ----------------------------
DROP TABLE IF EXISTS `ai_prompt_template`;
CREATE TABLE `ai_prompt_template`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '模板ID，主键自增',
  `template_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '模板名称',
  `template_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '模板编码（唯一标识）',
  `template_content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '模板内容（支持变量占位符）',
  `description` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '模板描述',
  `scene_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '场景类型：polish-润色，review-复盘，answer-生成答案，summary-总结，translate-翻译',
  `status` tinyint NULL DEFAULT 1 COMMENT '状态：0-禁用，1-启用',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `template_code`(`template_code` ASC) USING BTREE,
  INDEX `idx_template_code`(`template_code` ASC) USING BTREE,
  INDEX `idx_scene_type`(`scene_type` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'AI提示词模板表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of ai_prompt_template
-- ----------------------------
INSERT INTO `ai_prompt_template` VALUES (1, '文本润色模板', 'POLISH_TEMPLATE', '请对以下文本进行润色优化，使其更加通顺、专业、优美：\n\n{{content}}', '用于文本润色场景，优化文本表达', 'polish', 1, '2026-07-06 14:50:56', '2026-07-06 14:50:56');
INSERT INTO `ai_prompt_template` VALUES (2, '复盘分析模板', 'REVIEW_TEMPLATE', '请对以下内容进行复盘分析，总结优点、不足和改进建议：\n\n{{content}}', '用于复盘分析场景，帮助总结经验教训', 'review', 1, '2026-07-06 14:50:56', '2026-07-06 14:50:56');
INSERT INTO `ai_prompt_template` VALUES (3, '智能问答模板', 'ANSWER_TEMPLATE', '请详细回答以下问题：\n\n{{question}}', '用于智能问答场景，生成问题答案', 'answer', 1, '2026-07-06 14:50:56', '2026-07-06 14:50:56');
INSERT INTO `ai_prompt_template` VALUES (4, '文本总结模板', 'SUMMARY_TEMPLATE', '请对以下文本进行总结，提炼核心要点：\n\n{{content}}', '用于文本总结场景，提取关键信息', 'summary', 1, '2026-07-06 14:50:56', '2026-07-06 14:50:56');
INSERT INTO `ai_prompt_template` VALUES (5, '文本翻译模板', 'TRANSLATE_TEMPLATE', '请将以下文本翻译成{{targetLang}}：\n\n{{content}}', '用于文本翻译场景，支持多种语言', 'translate', 1, '2026-07-06 14:50:56', '2026-07-06 14:50:56');

-- ----------------------------
-- Table structure for chat_record
-- ----------------------------
DROP TABLE IF EXISTS `chat_record`;
CREATE TABLE `chat_record`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '对话ID，主键自增',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `session_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '会话ID（同一会话的记录共享ID）',
  `scene_type` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '场景类型：free-自由问答，script-话术生成，plan-学习规划',
  `scene_sub_type` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '子场景：report-汇报，ask-请教，leave-请假，refuse-拒绝等',
  `user_question` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '用户问题/输入内容',
  `ai_answer` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'AI回答内容',
  `is_collected` tinyint NULL DEFAULT 0 COMMENT '是否收藏：0-否，1-是',
  `ai_call_id` bigint NULL DEFAULT NULL COMMENT '关联AI调用日志ID',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user_id`(`user_id` ASC) USING BTREE,
  INDEX `idx_session_id`(`session_id` ASC) USING BTREE,
  INDEX `idx_scene_type`(`scene_type` ASC) USING BTREE,
  INDEX `idx_is_collected`(`is_collected` ASC) USING BTREE,
  INDEX `idx_create_time`(`create_time` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '对话记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of chat_record
-- ----------------------------

-- ----------------------------
-- Table structure for daily_report
-- ----------------------------
DROP TABLE IF EXISTS `daily_report`;
CREATE TABLE `daily_report`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '日报ID，主键自增',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `report_date` date NOT NULL COMMENT '日报日期',
  `today_finish` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '今日完成工作',
  `encounter_problem` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '遇到的问题',
  `tomorrow_plan` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '明日计划',
  `status` tinyint NULL DEFAULT 0 COMMENT '状态：0-草稿，1-已提交',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user_id`(`user_id` ASC) USING BTREE,
  INDEX `idx_report_date`(`report_date` ASC) USING BTREE,
  INDEX `idx_user_date`(`user_id` ASC, `report_date` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '日报表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of daily_report
-- ----------------------------

-- ----------------------------
-- Table structure for goal_info
-- ----------------------------
DROP TABLE IF EXISTS `goal_info`;
CREATE TABLE `goal_info`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '目标ID，主键自增',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `goal_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '目标名称',
  `goal_desc` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '目标描述',
  `goal_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'study' COMMENT '目标类型：study-学习目标，work-工作目标，intern-实习目标，other-其他',
  `priority` tinyint NULL DEFAULT 2 COMMENT '优先级：1-高，2-中，3-低',
  `start_date` date NULL DEFAULT NULL COMMENT '开始时间',
  `end_date` date NULL DEFAULT NULL COMMENT '截止时间',
  `expect_result` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '预期成果',
  `progress` int NULL DEFAULT 0 COMMENT '完成进度（0-100百分比）',
  `status` tinyint NULL DEFAULT 1 COMMENT '状态：0-已取消，1-未开始，2-进行中，3-已完成，4-已延期',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user_id`(`user_id` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE,
  INDEX `idx_priority`(`priority` ASC) USING BTREE,
  INDEX `idx_end_date`(`end_date` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '目标主表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of goal_info
-- ----------------------------

-- ----------------------------
-- Table structure for goal_task
-- ----------------------------
DROP TABLE IF EXISTS `goal_task`;
CREATE TABLE `goal_task`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '任务ID，主键自增',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `goal_id` bigint NOT NULL COMMENT '关联目标ID',
  `task_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '任务名称',
  `task_desc` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '任务描述',
  `priority` tinyint NULL DEFAULT 2 COMMENT '优先级：1-高，2-中，3-低',
  `deadline` date NULL DEFAULT NULL COMMENT '截止时间',
  `sort` int NULL DEFAULT 0 COMMENT '排序号',
  `status` tinyint NULL DEFAULT 1 COMMENT '状态：0-已取消，1-待开始，2-进行中，3-已完成',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user_id`(`user_id` ASC) USING BTREE,
  INDEX `idx_goal_id`(`goal_id` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE,
  INDEX `idx_deadline`(`deadline` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '目标子任务表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of goal_task
-- ----------------------------

-- ----------------------------
-- Table structure for growth_feedback
-- ----------------------------
DROP TABLE IF EXISTS `growth_feedback`;
CREATE TABLE `growth_feedback`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '反馈ID，主键自增',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `feedback_source` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '反馈来源：导师/同事/自评/其他',
  `feedback_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '反馈类型：praise-表扬，suggest-建议，criticism-批评',
  `feedback_content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '反馈内容',
  `correspond_scene` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '对应场景/事件',
  `record_date` date NULL DEFAULT NULL COMMENT '记录日期',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '备注/改进记录',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user_id`(`user_id` ASC) USING BTREE,
  INDEX `idx_feedback_type`(`feedback_type` ASC) USING BTREE,
  INDEX `idx_record_date`(`record_date` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '反馈评价表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of growth_feedback
-- ----------------------------

-- ----------------------------
-- Table structure for growth_project
-- ----------------------------
DROP TABLE IF EXISTS `growth_project`;
CREATE TABLE `growth_project`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '项目ID，主键自增',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `project_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '项目名称',
  `project_role` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '项目角色',
  `project_desc` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '项目描述',
  `personal_duty` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '个人职责',
  `achievement` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '主要成果/产出',
  `tech_stack` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '技术栈',
  `start_date` date NULL DEFAULT NULL COMMENT '项目开始时间',
  `end_date` date NULL DEFAULT NULL COMMENT '项目结束时间',
  `project_link` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '项目链接/地址',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '备注',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user_id`(`user_id` ASC) USING BTREE,
  INDEX `idx_start_date`(`start_date` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '项目经历表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of growth_project
-- ----------------------------

-- ----------------------------
-- Table structure for growth_skill
-- ----------------------------
DROP TABLE IF EXISTS `growth_skill`;
CREATE TABLE `growth_skill`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '技能ID，主键自增',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `skill_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '技能名称',
  `skill_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'tech' COMMENT '技能类型：tech-技术技能，soft-软技能',
  `master_level` tinyint NULL DEFAULT 1 COMMENT '掌握等级：1-了解，2-熟悉，3-掌握，4-精通',
  `master_date` date NULL DEFAULT NULL COMMENT '掌握时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '备注说明',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user_id`(`user_id` ASC) USING BTREE,
  INDEX `idx_skill_type`(`skill_type` ASC) USING BTREE,
  INDEX `idx_master_level`(`master_level` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '技能记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of growth_skill
-- ----------------------------

-- ----------------------------
-- Table structure for interview_category
-- ----------------------------
DROP TABLE IF EXISTS `interview_category`;
CREATE TABLE `interview_category`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '分类ID，主键自增',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `category_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '分类名称',
  `category_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '分类类型：company-公司，post-岗位，type-题型',
  `parent_id` bigint NULL DEFAULT 0 COMMENT '父分类ID，0为顶级分类',
  `sort` int NULL DEFAULT 0 COMMENT '排序号',
  `remark` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '备注',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user_id`(`user_id` ASC) USING BTREE,
  INDEX `idx_category_type`(`category_type` ASC) USING BTREE,
  INDEX `idx_parent_id`(`parent_id` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '面试题分类表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of interview_category
-- ----------------------------

-- ----------------------------
-- Table structure for interview_question
-- ----------------------------
DROP TABLE IF EXISTS `interview_question`;
CREATE TABLE `interview_question`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '题目ID，主键自增',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `category_id` bigint NULL DEFAULT NULL COMMENT '所属分类ID',
  `question_title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '题目标题',
  `question_content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '题目详细内容',
  `my_answer` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '我的答案',
  `reference_answer` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '参考答案（AI生成）',
  `review_summary` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '复盘总结/优化思路',
  `difficulty_level` tinyint NULL DEFAULT 2 COMMENT '难度：1-简单，2-中等，3-困难',
  `master_level` tinyint NULL DEFAULT 1 COMMENT '掌握程度：1-不熟，2-熟练，3-精通',
  `source_company` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '来源公司',
  `source_post` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '来源岗位',
  `is_collected` tinyint NULL DEFAULT 0 COMMENT '是否收藏：0-否，1-是',
  `is_wrong` tinyint NULL DEFAULT 0 COMMENT '是否错题：0-否，1-是',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user_id`(`user_id` ASC) USING BTREE,
  INDEX `idx_category_id`(`category_id` ASC) USING BTREE,
  INDEX `idx_difficulty`(`difficulty_level` ASC) USING BTREE,
  INDEX `idx_master_level`(`master_level` ASC) USING BTREE,
  INDEX `idx_is_collected`(`is_collected` ASC) USING BTREE,
  INDEX `idx_is_wrong`(`is_wrong` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '面试题库表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of interview_question
-- ----------------------------

-- ----------------------------
-- Table structure for review_record
-- ----------------------------
DROP TABLE IF EXISTS `review_record`;
CREATE TABLE `review_record`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '复盘ID，主键自增',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `review_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '复盘类型：daily-日度，weekly-周度，monthly-月度，custom-自定义',
  `start_date` date NOT NULL COMMENT '复盘开始日期',
  `end_date` date NOT NULL COMMENT '复盘结束日期',
  `original_content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '原始内容（日报/工作记录汇总）',
  `highlights` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '复盘亮点',
  `shortcomings` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '存在不足',
  `suggestions` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '改进建议',
  `full_content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '完整复盘内容',
  `status` tinyint NULL DEFAULT 1 COMMENT '状态：0-生成失败，1-生成成功',
  `ai_call_id` bigint NULL DEFAULT NULL COMMENT '关联AI调用日志ID',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user_id`(`user_id` ASC) USING BTREE,
  INDEX `idx_review_type`(`review_type` ASC) USING BTREE,
  INDEX `idx_create_time`(`create_time` ASC) USING BTREE,
  INDEX `idx_user_date`(`user_id` ASC, `start_date` ASC, `end_date` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '复盘记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of review_record
-- ----------------------------

-- ----------------------------
-- Table structure for sys_user
-- ----------------------------
DROP TABLE IF EXISTS `sys_user`;
CREATE TABLE `sys_user`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '用户ID，主键自增',
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '用户名',
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '密码（加密存储）',
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '邮箱',
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '手机号',
  `nickname` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '用户昵称',
  `avatar` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '用户头像',
  `status` tinyint NULL DEFAULT 1 COMMENT '状态：0-禁用，1-启用',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `username`(`username` ASC) USING BTREE,
  UNIQUE INDEX `email`(`email` ASC) USING BTREE,
  INDEX `idx_username`(`username` ASC) USING BTREE,
  INDEX `idx_email`(`email` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '用户表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_user
-- ----------------------------
INSERT INTO `sys_user` VALUES (1, 'huang', '$2a$10$MNfSw39.fz5N9bTOrOPB4.rPoa3ZEIdlzm34SsCRca1do1Mtc9esi', '1430846198@qq.com', NULL, '珉锡', NULL, 1, '2026-07-06 15:38:55', '2026-07-06 15:38:55');
INSERT INTO `sys_user` VALUES (2, 'admin', '$2a$10$FGmEqeH1d/36vC/R4tjPrO2FRNMBbrqEnn3UZyzgCt4Stj4aO3ZQ.', '1234567890@qq.com', NULL, 'admin', NULL, 1, '2026-07-06 17:36:10', '2026-07-06 17:36:10');

-- ----------------------------
-- Table structure for weekly_report
-- ----------------------------
DROP TABLE IF EXISTS `weekly_report`;
CREATE TABLE `weekly_report`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '周报ID，主键自增',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `week_year` int NOT NULL COMMENT '年份',
  `week_num` int NOT NULL COMMENT '周次（当年第几周）',
  `start_date` date NOT NULL COMMENT '本周开始日期',
  `end_date` date NOT NULL COMMENT '本周结束日期',
  `week_summary` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '本周工作总结',
  `problem_review` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '问题与复盘',
  `next_week_plan` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '下周工作计划',
  `status` tinyint NULL DEFAULT 0 COMMENT '状态：0-草稿，1-已提交',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user_id`(`user_id` ASC) USING BTREE,
  INDEX `idx_week`(`week_year` ASC, `week_num` ASC) USING BTREE,
  INDEX `idx_user_week`(`user_id` ASC, `week_year` ASC, `week_num` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '周报表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of weekly_report
-- ----------------------------

SET FOREIGN_KEY_CHECKS = 1;
