package com.example.growthlens.service.impl;

import com.example.growthlens.common.BusinessException;
import com.example.growthlens.entity.ChatRecord;
import com.example.growthlens.mapper.ChatRecordMapper;
import com.example.growthlens.service.AiService;
import com.example.growthlens.service.ChatService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

@Slf4j
@Service
public class ChatServiceImpl implements ChatService {

    @Autowired
    private AiService aiService;

    @Autowired
    private ChatRecordMapper chatRecordMapper;

    private static final String SCENE_FREE = "free";
    private static final String SCENE_SCRIPT = "script";
    private static final String SCENE_PLAN = "plan";

    @Override
    public String freeChat(Long userId, String username, String question, String sessionId) {
        String answer = aiService.generateAnswer(userId, username, question);

        ChatRecord record = new ChatRecord();
        record.setUserId(userId);
        record.setSessionId(sessionId != null ? sessionId : UUID.randomUUID().toString().replace("-", ""));
        record.setSceneType(SCENE_FREE);
        record.setUserQuestion(question);
        record.setAiAnswer(answer);
        record.setIsCollected(0);
        chatRecordMapper.insert(record);

        return answer;
    }

    @Override
    public String generateScript(Long userId, String username, String sceneSubType, String context) {
        String prompt = buildScriptPrompt(sceneSubType, context);
        Map<String, String> params = new HashMap<>();
        params.put("question", prompt);
        String answer = aiService.callByTemplate(userId, username, "ANSWER_TEMPLATE", params);

        ChatRecord record = new ChatRecord();
        record.setUserId(userId);
        record.setSessionId(UUID.randomUUID().toString().replace("-", ""));
        record.setSceneType(SCENE_SCRIPT);
        record.setSceneSubType(sceneSubType);
        record.setUserQuestion(context);
        record.setAiAnswer(answer);
        record.setIsCollected(0);
        chatRecordMapper.insert(record);

        return answer;
    }

    @Override
    public String generateStudyPlan(Long userId, String username, String skillName, String targetLevel, String duration) {
        String prompt = buildStudyPlanPrompt(skillName, targetLevel, duration);
        Map<String, String> params = new HashMap<>();
        params.put("question", prompt);
        String answer = aiService.callByTemplate(userId, username, "ANSWER_TEMPLATE", params);

        ChatRecord record = new ChatRecord();
        record.setUserId(userId);
        record.setSessionId(UUID.randomUUID().toString().replace("-", ""));
        record.setSceneType(SCENE_PLAN);
        record.setSceneSubType(skillName);
        record.setUserQuestion("技能：" + skillName + "，目标：" + targetLevel + "，周期：" + duration);
        record.setAiAnswer(answer);
        record.setIsCollected(0);
        chatRecordMapper.insert(record);

        return answer;
    }

    @Override
    public List<ChatRecord> getUserChatRecords(Long userId) {
        return chatRecordMapper.findByUserId(userId);
    }

    @Override
    public List<ChatRecord> getChatRecordsBySceneType(Long userId, String sceneType) {
        return chatRecordMapper.findByUserIdAndSceneType(userId, sceneType);
    }

    @Override
    public List<ChatRecord> getCollectedRecords(Long userId) {
        return chatRecordMapper.findCollectedByUserId(userId);
    }

    @Override
    public ChatRecord getRecordById(Long id) {
        ChatRecord record = chatRecordMapper.findById(id);
        if (record == null) {
            throw new BusinessException("记录不存在");
        }
        return record;
    }

    @Override
    public void toggleCollection(Long id, Integer isCollected) {
        chatRecordMapper.updateCollection(id, isCollected);
    }

    @Override
    public void deleteRecord(Long id) {
        chatRecordMapper.deleteById(id);
    }

    @Override
    public void deleteSession(String sessionId) {
        chatRecordMapper.deleteBySessionId(sessionId);
    }

    @Override
    public List<ChatRecord> getSessionRecords(String sessionId) {
        return chatRecordMapper.findBySessionId(sessionId);
    }

    private String buildScriptPrompt(String sceneSubType, String context) {
        StringBuilder prompt = new StringBuilder();
        prompt.append("请帮我生成一段职场沟通话术，场景：");

        switch (sceneSubType) {
            case "report":
                prompt.append("工作汇报");
                break;
            case "leave":
                prompt.append("请假申请");
                break;
            case "ask":
                prompt.append("请教问题");
                break;
            case "refuse":
                prompt.append("委婉拒绝");
                break;
            default:
                prompt.append(sceneSubType);
        }

        prompt.append("。\n\n具体背景：");
        prompt.append(context);
        prompt.append("\n\n请生成得体、专业的沟通话术，要求：\n");
        prompt.append("1. 语言简洁明了，逻辑清晰\n");
        prompt.append("2. 语气礼貌得体，符合职场规范\n");
        prompt.append("3. 提供1-2个不同风格的版本供选择\n");
        prompt.append("4. 每个版本标注适用场景");

        return prompt.toString();
    }

    private String buildStudyPlanPrompt(String skillName, String targetLevel, String duration) {
        StringBuilder prompt = new StringBuilder();
        prompt.append("请为我制定一份\"");
        prompt.append(skillName);
        prompt.append("\"的学习规划。\n\n");
        prompt.append("当前基础：初学者/有一定了解\n");
        prompt.append("目标水平：").append(targetLevel).append("\n");
        prompt.append("学习周期：").append(duration).append("\n\n");
        prompt.append("请按照以下格式输出学习规划：\n");
        prompt.append("1. 学习目标概述\n");
        prompt.append("2. 阶段划分（按周/月划分）\n");
        prompt.append("3. 每个阶段的具体学习内容和重点\n");
        prompt.append("4. 推荐的学习资源（书籍、课程、网站等）\n");
        prompt.append("5. 实践练习建议\n");
        prompt.append("6. 学习方法和技巧\n");
        prompt.append("7. 验收标准和里程碑\n\n");
        prompt.append("要求计划切实可行，循序渐进，符合实习生的学习节奏。");

        return prompt.toString();
    }
}
