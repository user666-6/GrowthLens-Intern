package com.example.growthlens.entity;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class AiSystemConfig {

    private Long id;

    private String configKey;

    private String configValue;

    private String configName;

    private String configDesc;

    private String configType;

    private Integer status;

    private LocalDateTime createTime;

    private LocalDateTime updateTime;
}