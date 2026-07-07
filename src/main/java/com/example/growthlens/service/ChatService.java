package com.example.growthlens.service;

import com.example.growthlens.entity.ChatRecord;

import java.util.List;

public interface ChatService {

    String freeChat(Long userId, String username, String question, String sessionId);

    String generateScript(Long userId, String username, String sceneSubType, String context);

    String generateStudyPlan(Long userId, String username, String skillName, String targetLevel, String duration);

    List<ChatRecord> getUserChatRecords(Long userId);

    List<ChatRecord> getChatRecordsBySceneType(Long userId, String sceneType);

    List<ChatRecord> getCollectedRecords(Long userId);

    ChatRecord getRecordById(Long id);

    void toggleCollection(Long id, Integer isCollected);

    void deleteRecord(Long id);

    void deleteSession(String sessionId);

    List<ChatRecord> getSessionRecords(String sessionId);
}
