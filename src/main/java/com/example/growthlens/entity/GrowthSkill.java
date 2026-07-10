package com.example.growthlens.entity;

import lombok.Data;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
public class GrowthSkill {

    private Long id;

    private Long userId;

    private String skillName;

    private String skillType;

    private Integer masterLevel;

    private LocalDate masterDate;

    private String remark;

    private LocalDateTime createTime;

    private LocalDateTime updateTime;
}
