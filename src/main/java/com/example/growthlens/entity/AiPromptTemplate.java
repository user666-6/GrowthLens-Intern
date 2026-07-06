package com.example.growthlens.entity;

import lombok.Data;

import java.time.LocalDateTime;

/**
 * AI提示词模板实体类
 * 对应数据库表ai_prompt_template
 */
@Data
public class AiPromptTemplate {

    /**
     * 模板ID，主键自增
     */
    private Long id;

    /**
     * 模板名称
     */
    private String templateName;

    /**
     * 模板编码（唯一标识）
     */
    private String templateCode;

    /**
     * 模板内容（支持变量占位符）
     */
    private String templateContent;

    /**
     * 模板描述
     */
    private String description;

    /**
     * 场景类型：polish-润色，review-复盘，answer-生成答案，summary-总结，translate-翻译
     */
    private String sceneType;

    /**
     * 状态：0-禁用，1-启用
     */
    private Integer status;

    /**
     * 创建时间
     */
    private LocalDateTime createTime;

    /**
     * 更新时间
     */
    private LocalDateTime updateTime;
}