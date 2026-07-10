package com.example.growthlens.entity;

import lombok.Data;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
public class GrowthProject {

    private Long id;

    private Long userId;

    private String projectName;

    private String projectRole;

    private String projectDesc;

    private String personalDuty;

    private String achievement;

    private String techStack;

    private LocalDate startDate;

    private LocalDate endDate;

    private String projectLink;

    private String remark;

    private LocalDateTime createTime;

    private LocalDateTime updateTime;
}
