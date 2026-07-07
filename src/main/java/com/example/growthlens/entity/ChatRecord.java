package com.example.growthlens.entity;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class ChatRecord {

    private Long id;

    private Long userId;

    private String sessionId;

    private String sceneType;

    private String sceneSubType;

    private String userQuestion;

    private String aiAnswer;

    private Integer isCollected;

    private Long aiCallId;

    private LocalDateTime createTime;
}
