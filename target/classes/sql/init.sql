CREATE DATABASE IF NOT EXISTS `GrowthLens Intern` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE `GrowthLens Intern`;

-- 用户表
CREATE TABLE IF NOT EXISTS sys_user (
    id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '用户ID，主键自增',
    username VARCHAR(50) NOT NULL UNIQUE COMMENT '用户名',
    password VARCHAR(255) NOT NULL COMMENT '密码（加密存储）',
    email VARCHAR(100) UNIQUE COMMENT '邮箱',
    phone VARCHAR(20) COMMENT '手机号',
    nickname VARCHAR(50) COMMENT '用户昵称',
    avatar VARCHAR(255) COMMENT '用户头像',
    status TINYINT DEFAULT 1 COMMENT '状态：0-禁用，1-启用',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    INDEX idx_username (username),
    INDEX idx_email (email),
    INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户表';

-- AI提示词模板表
CREATE TABLE IF NOT EXISTS ai_prompt_template (
    id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '模板ID，主键自增',
    template_name VARCHAR(100) NOT NULL COMMENT '模板名称',
    template_code VARCHAR(50) NOT NULL UNIQUE COMMENT '模板编码（唯一标识）',
    template_content TEXT NOT NULL COMMENT '模板内容（支持变量占位符）',
    description VARCHAR(500) COMMENT '模板描述',
    scene_type VARCHAR(20) NOT NULL COMMENT '场景类型：polish-润色，review-复盘，answer-生成答案，summary-总结，translate-翻译',
    status TINYINT DEFAULT 1 COMMENT '状态：0-禁用，1-启用',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    INDEX idx_template_code (template_code),
    INDEX idx_scene_type (scene_type),
    INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='AI提示词模板表';

-- AI调用日志表
CREATE TABLE IF NOT EXISTS ai_call_log (
    id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '日志ID，主键自增',
    user_id BIGINT NOT NULL COMMENT '用户ID',
    username VARCHAR(50) NOT NULL COMMENT '用户名',
    template_id BIGINT COMMENT '模板ID',
    template_name VARCHAR(100) COMMENT '模板名称',
    scene_type VARCHAR(20) COMMENT '场景类型',
    request_content TEXT COMMENT '请求内容（发送给AI的完整prompt）',
    response_content LONGTEXT COMMENT '响应内容（AI返回的结果）',
    call_status VARCHAR(20) NOT NULL COMMENT '调用状态：success-成功，fail-失败',
    error_message VARCHAR(1000) COMMENT '错误信息（失败时记录）',
    duration BIGINT COMMENT '耗时（毫秒）',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    INDEX idx_user_id (user_id),
    INDEX idx_template_id (template_id),
    INDEX idx_call_status (call_status),
    INDEX idx_create_time (create_time)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='AI调用日志表';

-- 插入初始化模板数据
INSERT INTO ai_prompt_template (template_name, template_code, template_content, description, scene_type, status) VALUES
('文本润色模板', 'POLISH_TEMPLATE', '请对以下文本进行润色优化，使其更加通顺、专业、优美：\n\n{{content}}', '用于文本润色场景，优化文本表达', 'polish', 1),
('复盘分析模板', 'REVIEW_TEMPLATE', '请对以下内容进行复盘分析，总结优点、不足和改进建议：\n\n{{content}}', '用于复盘分析场景，帮助总结经验教训', 'review', 1),
('智能问答模板', 'ANSWER_TEMPLATE', '请详细回答以下问题：\n\n{{question}}', '用于智能问答场景，生成问题答案', 'answer', 1),
('文本总结模板', 'SUMMARY_TEMPLATE', '请对以下文本进行总结，提炼核心要点：\n\n{{content}}', '用于文本总结场景，提取关键信息', 'summary', 1),
('文本翻译模板', 'TRANSLATE_TEMPLATE', '请将以下文本翻译成{{targetLang}}：\n\n{{content}}', '用于文本翻译场景，支持多种语言', 'translate', 1);