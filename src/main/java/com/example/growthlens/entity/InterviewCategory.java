package com.example.growthlens.entity;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class InterviewCategory {

    private Long id;

    private Long userId;

    private String categoryName;

    private String categoryType;

    private Long parentId;

    private Integer sort;

    private String remark;

    private LocalDateTime createTime;

    private LocalDateTime updateTime;
}