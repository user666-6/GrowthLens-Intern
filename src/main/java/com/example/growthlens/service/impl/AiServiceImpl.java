package com.example.growthlens.service.impl;

import com.example.growthlens.common.BusinessException;
import com.example.growthlens.config.AiModelConfig;
import com.example.growthlens.entity.AiCallLog;
import com.example.growthlens.entity.AiPromptTemplate;
import com.example.growthlens.mapper.AiCallLogMapper;
import com.example.growthlens.mapper.AiPromptTemplateMapper;
import com.example.growthlens.service.AiService;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * AI服务实现类
 * 封装RestTemplate调用大模型，统一处理请求响应
 */
@Slf4j
@Service
public class AiServiceImpl implements AiService {

    @Autowired
    private AiModelConfig aiModelConfig;

    @Autowired
    private RestTemplate restTemplate;

    @Autowired
    private AiPromptTemplateMapper promptTemplateMapper;

    @Autowired
    private AiCallLogMapper callLogMapper;

    private final ObjectMapper objectMapper = new ObjectMapper();

    /**
     * 场景类型常量
     */
    private static final String SCENE_POLISH = "polish";
    private static final String SCENE_REVIEW = "review";
    private static final String SCENE_ANSWER = "answer";
    private static final String SCENE_SUMMARY = "summary";
    private static final String SCENE_TRANSLATE = "translate";

    @Override
    public String polish(Long userId, String username, String content) {
        AiPromptTemplate template = promptTemplateMapper.findByCode("POLISH_TEMPLATE");
        if (template == null) {
            throw new BusinessException("润色模板不存在");
        }
        Map<String, String> params = new HashMap<>();
        params.put("content", content);
        return callByTemplate(userId, username, template.getTemplateCode(), params);
    }

    @Override
    public String review(Long userId, String username, String content) {
        AiPromptTemplate template = promptTemplateMapper.findByCode("REVIEW_TEMPLATE");
        if (template == null) {
            throw new BusinessException("复盘模板不存在");
        }
        Map<String, String> params = new HashMap<>();
        params.put("content", content);
        return callByTemplate(userId, username, template.getTemplateCode(), params);
    }

    @Override
    public String generateAnswer(Long userId, String username, String question) {
        AiPromptTemplate template = promptTemplateMapper.findByCode("ANSWER_TEMPLATE");
        if (template == null) {
            throw new BusinessException("问答模板不存在");
        }
        Map<String, String> params = new HashMap<>();
        params.put("question", question);
        return callByTemplate(userId, username, template.getTemplateCode(), params);
    }

    @Override
    public String summarize(Long userId, String username, String content) {
        AiPromptTemplate template = promptTemplateMapper.findByCode("SUMMARY_TEMPLATE");
        if (template == null) {
            throw new BusinessException("总结模板不存在");
        }
        Map<String, String> params = new HashMap<>();
        params.put("content", content);
        return callByTemplate(userId, username, template.getTemplateCode(), params);
    }

    @Override
    public String translate(Long userId, String username, String content, String targetLang) {
        AiPromptTemplate template = promptTemplateMapper.findByCode("TRANSLATE_TEMPLATE");
        if (template == null) {
            throw new BusinessException("翻译模板不存在");
        }
        Map<String, String> params = new HashMap<>();
        params.put("content", content);
        params.put("targetLang", targetLang);
        return callByTemplate(userId, username, template.getTemplateCode(), params);
    }

    @Override
    public String callByTemplate(Long userId, String username, String templateCode, Map<String, String> params) {
        // 查询模板
        AiPromptTemplate template = promptTemplateMapper.findByCode(templateCode);
        if (template == null) {
            throw new BusinessException("模板不存在");
        }
        if (template.getStatus() == 0) {
            throw new BusinessException("模板已禁用");
        }

        // 构建完整的prompt（替换占位符）
        String prompt = template.getTemplateContent();
        for (Map.Entry<String, String> entry : params.entrySet()) {
            prompt = prompt.replace("{{" + entry.getKey() + "}}", entry.getValue());
        }

        // 创建调用日志（预提交）
        AiCallLog callLog = new AiCallLog();
        callLog.setUserId(userId);
        callLog.setUsername(username);
        callLog.setTemplateId(template.getId());
        callLog.setTemplateName(template.getTemplateName());
        callLog.setSceneType(template.getSceneType());
        callLog.setRequestContent(prompt);
        callLog.setCallStatus("pending");
        callLogMapper.insert(callLog);

        long startTime = System.currentTimeMillis();
        String responseContent = null;
        String errorMessage = null;

        try {
            // 调用大模型API
            responseContent = callAiApi(prompt);
            callLog.setCallStatus("success");
            callLog.setResponseContent(responseContent);
            log.info("AI调用成功，用户ID: {}, 模板: {}", userId, templateCode);
        } catch (Exception e) {
            callLog.setCallStatus("fail");
            callLog.setErrorMessage(e.getMessage());
            log.error("AI调用失败，用户ID: {}, 模板: {}", userId, templateCode, e);
            throw new BusinessException("AI调用失败：" + e.getMessage());
        } finally {
            // 更新调用日志（记录耗时和结果）
            long duration = System.currentTimeMillis() - startTime;
            callLog.setDuration(duration);
            callLogMapper.update(callLog);
        }

        return responseContent;
    }

    /**
     * 调用大模型API
     */
    private String callAiApi(String prompt) {
        String url = aiModelConfig.getBaseUrl() + "/chat/completions";

        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        headers.set("Authorization", "Bearer " + aiModelConfig.getApiKey());

        Map<String, Object> body = new HashMap<>();
        body.put("model", aiModelConfig.getModelName());

        List<Map<String, String>> messages = List.of(
            Map.of("role", "user", "content", prompt)
        );
        body.put("messages", messages);
        body.put("temperature", 0.7);

        HttpEntity<Map<String, Object>> request = new HttpEntity<>(body, headers);

        ResponseEntity<String> response = restTemplate.postForEntity(url, request, String.class);

        // 解析响应
        try {
            JsonNode root = objectMapper.readTree(response.getBody());
            JsonNode choices = root.get("choices");
            if (choices != null && choices.isArray() && choices.size() > 0) {
                JsonNode message = choices.get(0).get("message");
                if (message != null) {
                    return message.get("content").asText();
                }
            }
        } catch (Exception e) {
            log.error("解析AI响应失败", e);
        }

        throw new BusinessException("AI响应解析失败");
    }

    @Override
    public List<AiPromptTemplate> getAllEnabledTemplates() {
        return promptTemplateMapper.findAllEnabled();
    }

    @Override
    public List<AiPromptTemplate> getTemplatesBySceneType(String sceneType) {
        return promptTemplateMapper.findBySceneType(sceneType);
    }

    @Override
    public AiPromptTemplate getTemplateById(Long id) {
        AiPromptTemplate template = promptTemplateMapper.findById(id);
        if (template == null) {
            throw new BusinessException("模板不存在");
        }
        return template;
    }

    @Override
    public AiPromptTemplate addTemplate(AiPromptTemplate template) {
        // 检查模板编码是否已存在
        if (promptTemplateMapper.findByCode(template.getTemplateCode()) != null) {
            throw new BusinessException("模板编码已存在");
        }
        template.setStatus(1);
        promptTemplateMapper.insert(template);
        return template;
    }

    @Override
    public void updateTemplate(AiPromptTemplate template) {
        if (promptTemplateMapper.findById(template.getId()) == null) {
            throw new BusinessException("模板不存在");
        }
        promptTemplateMapper.update(template);
    }

    @Override
    public void deleteTemplate(Long id) {
        if (promptTemplateMapper.findById(id) == null) {
            throw new BusinessException("模板不存在");
        }
        promptTemplateMapper.deleteById(id);
    }

    @Override
    public List<AiCallLog> getUserCallLogs(Long userId) {
        return callLogMapper.findByUserId(userId);
    }

    @Override
    public List<AiCallLog> getAllCallLogs() {
        return callLogMapper.findAll();
    }
}