package com.example.growthlens.entity;

import lombok.Data;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
public class GoalInfo {

    private Long id;

    private Long userId;

    private String goalName;

    private String goalDesc;

    private String goalType;

    private Integer priority;

    private LocalDate startDate;

    private LocalDate endDate;

    private String expectResult;

    private Integer progress;

    private Integer status;

    private LocalDateTime createTime;

    private LocalDateTime updateTime;
}