package com.example.growthlens.entity;

import lombok.Data;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
public class GrowthFeedback {

    private Long id;

    private Long userId;

    private String feedbackSource;

    private String feedbackType;

    private String feedbackContent;

    private String correspondScene;

    private LocalDate recordDate;

    private String remark;

    private LocalDateTime createTime;

    private LocalDateTime updateTime;
}
