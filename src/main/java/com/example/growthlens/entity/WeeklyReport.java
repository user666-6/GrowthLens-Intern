package com.example.growthlens.entity;

import lombok.Data;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
public class WeeklyReport {

    private Long id;

    private Long userId;

    private Integer weekYear;

    private Integer weekNum;

    private LocalDate startDate;

    private LocalDate endDate;

    private String weekSummary;

    private String problemReview;

    private String nextWeekPlan;

    private Integer status;

    private LocalDateTime createTime;

    private LocalDateTime updateTime;
}