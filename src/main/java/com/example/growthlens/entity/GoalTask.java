package com.example.growthlens.entity;

import lombok.Data;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
public class GoalTask {

    private Long id;

    private Long userId;

    private Long goalId;

    private String taskName;

    private String taskDesc;

    private Integer priority;

    private LocalDate deadline;

    private Integer sort;

    private Integer status;

    private LocalDateTime createTime;

    private LocalDateTime updateTime;
}