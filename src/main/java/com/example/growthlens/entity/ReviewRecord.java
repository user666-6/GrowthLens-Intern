package com.example.growthlens.entity;

import lombok.Data;

import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 * 复盘记录实体类
 */
@Data
public class ReviewRecord {

    /**
     * 复盘ID，主键自增
     */
    private Long id;

    /**
     * 用户ID
     */
    private Long userId;

    /**
     * 复盘类型：daily-日度，weekly-周度
     */
    private String reviewType;

    /**
     * 开始日期
     */
    private LocalDate startDate;

    /**
     * 结束日期
     */
    private LocalDate endDate;

    /**
     * 原始日报内容
     */
    private String originalContent;

    /**
     * 复盘亮点
     */
    private String highlight;

    /**
     * 存在不足
     */
    private String shortage;

    /**
     * 改进建议
     */
    private String suggestion;

    /**
     * 完整复盘内容
     */
    private String fullContent;

    /**
     * 状态：0-失败，1-成功
     */
    private Integer status;

    /**
     * 失败信息
     */
    private String errorMsg;

    /**
     * 创建时间
     */
    private LocalDateTime createTime;

    /**
     * 更新时间
     */
    private LocalDateTime updateTime;
}
