package com.example.growthlens.entity;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class InterviewQuestion {

    private Long id;

    private Long userId;

    private Long categoryId;

    private String questionTitle;

    private String questionContent;

    private String myAnswer;

    private String referenceAnswer;

    private String reviewSummary;

    private Integer difficultyLevel;

    private Integer masterLevel;

    private String sourceCompany;

    private String sourcePost;

    private Integer isCollected;

    private Integer isWrong;

    private LocalDateTime createTime;

    private LocalDateTime updateTime;
}