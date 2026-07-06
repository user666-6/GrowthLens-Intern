package com.example.growthlens.entity;

import lombok.Data;

import java.time.LocalDateTime;

/**
 * AI调用日志实体类
 * 对应数据库表ai_call_log
 */
@Data
public class AiCallLog {

    /**
     * 日志ID，主键自增
     */
    private Long id;

    /**
     * 用户ID
     */
    private Long userId;

    /**
     * 用户名
     */
    private String username;

    /**
     * 模板ID
     */
    private Long templateId;

    /**
     * 模板名称
     */
    private String templateName;

    /**
     * 场景类型
     */
    private String sceneType;

    /**
     * 请求内容（发送给AI的完整prompt）
     */
    private String requestContent;

    /**
     * 响应内容（AI返回的结果）
     */
    private String responseContent;

    /**
     * 调用状态：success-成功，fail-失败
     */
    private String callStatus;

    /**
     * 错误信息（失败时记录）
     */
    private String errorMessage;

    /**
     * 耗时（毫秒）
     */
    private Long duration;

    /**
     * 创建时间
     */
    private LocalDateTime createTime;
}