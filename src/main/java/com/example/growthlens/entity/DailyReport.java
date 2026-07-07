package com.example.growthlens.entity;

import lombok.Data;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
public class DailyReport {

    private Long id;

    private Long userId;

    private LocalDate reportDate;

    private String todayFinish;

    private String encounterProblem;

    private String tomorrowPlan;

    private Integer status;

    private LocalDateTime createTime;

    private LocalDateTime updateTime;
}