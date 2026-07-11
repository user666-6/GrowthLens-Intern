package com.example.growthlens.service;

import com.example.growthlens.entity.AiPromptTemplate;
import com.example.growthlens.entity.AiCallLog;

import java.util.List;
import java.util.Map;

/**
 * AI服务接口
 * 定义AI相关的业务操作方法，包括润色、复盘、生成答案等场景
 */
public interface AiService {

    /**
     * 润色文本
     * @param userId 用户ID
     * @param username 用户名
     * @param content 需要润色的文本
     * @return 润色后的文本
     */
    String polish(Long userId, String username, String content);

    /**
     * 复盘分析
     * @param userId 用户ID
     * @param username 用户名
     * @param content 需要复盘的内容
     * @return 复盘分析结果
     */
    String review(Long userId, String username, String content);

    /**
     * 生成答案
     * @param userId 用户ID
     * @param username 用户名
     * @param question 问题
     * @return 生成的答案
     */
    String generateAnswer(Long userId, String username, String question);

    /**
     * 总结文本
     * @param userId 用户ID
     * @param username 用户名
     * @param content 需要总结的文本
     * @return 总结结果
     */
    String summarize(Long userId, String username, String content);

    /**
     * 翻译文本
     * @param userId 用户ID
     * @param username 用户名
     * @param content 需要翻译的文本
     * @param targetLang 目标语言
     * @return 翻译结果
     */
    String translate(Long userId, String username, String content, String targetLang);

    /**
     * 根据模板调用AI
     * @param userId 用户ID
     * @param username 用户名
     * @param templateCode 模板编码
     * @param params 参数（用于替换模板中的占位符）
     * @return AI返回的结果
     */
    String callByTemplate(Long userId, String username, String templateCode, Map<String, String> params);

    /**
     * 使用STAR法则生成成果表述
     * @param userId 用户ID
     * @param username 用户名
     * @param projectName 项目名称
     * @param projectRole 项目角色
     * @param projectDesc 项目描述
     * @param personalDuty 个人职责
     * @param achievement 主要成果
     * @param techStack 技术栈
     * @return STAR格式的成果表述
     */
    String generateStar(Long userId, String username, String projectName, String projectRole, String projectDesc, String personalDuty, String achievement, String techStack);

    /**
     * 获取所有启用的模板
     */
    List<AiPromptTemplate> getAllEnabledTemplates();

    /**
     * 根据场景类型获取模板
     */
    List<AiPromptTemplate> getTemplatesBySceneType(String sceneType);

    /**
     * 获取模板详情
     */
    AiPromptTemplate getTemplateById(Long id);

    /**
     * 添加模板
     */
    AiPromptTemplate addTemplate(AiPromptTemplate template);

    /**
     * 更新模板
     */
    void updateTemplate(AiPromptTemplate template);

    /**
     * 删除模板
     */
    void deleteTemplate(Long id);

    /**
     * 获取用户调用日志
     */
    List<AiCallLog> getUserCallLogs(Long userId);

    /**
     * 获取所有调用日志
     */
    List<AiCallLog> getAllCallLogs();
}