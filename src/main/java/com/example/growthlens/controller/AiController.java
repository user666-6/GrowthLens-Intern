package com.example.growthlens.controller;

import com.example.growthlens.common.LoginUserHolder;
import com.example.growthlens.common.Result;
import com.example.growthlens.entity.AiCallLog;
import com.example.growthlens.entity.AiPromptTemplate;
import com.example.growthlens.entity.SysUser;
import com.example.growthlens.service.AiService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

/**
 * AI控制器
 * 处理AI相关的HTTP请求
 */
@RestController
@RequestMapping("/ai")
public class AiController {

    @Autowired
    private AiService aiService;

    /**
     * 润色文本
     */
    @PostMapping("/polish")
    public Result<String> polish(@RequestParam String content) {
        SysUser user = LoginUserHolder.getCurrentUser();
        String result = aiService.polish(user.getId(), user.getUsername(), content);
        return Result.success("润色成功", result);
    }

    /**
     * 复盘分析
     */
    @PostMapping("/review")
    public Result<String> review(@RequestParam String content) {
        SysUser user = LoginUserHolder.getCurrentUser();
        String result = aiService.review(user.getId(), user.getUsername(), content);
        return Result.success("复盘分析成功", result);
    }

    /**
     * 生成答案
     */
    @PostMapping("/answer")
    public Result<String> generateAnswer(@RequestParam String question) {
        SysUser user = LoginUserHolder.getCurrentUser();
        String result = aiService.generateAnswer(user.getId(), user.getUsername(), question);
        return Result.success("生成答案成功", result);
    }

    /**
     * 总结文本
     */
    @PostMapping("/summary")
    public Result<String> summarize(@RequestParam String content) {
        SysUser user = LoginUserHolder.getCurrentUser();
        String result = aiService.summarize(user.getId(), user.getUsername(), content);
        return Result.success("总结成功", result);
    }

    /**
     * 翻译文本
     */
    @PostMapping("/translate")
    public Result<String> translate(@RequestParam String content, @RequestParam String targetLang) {
        SysUser user = LoginUserHolder.getCurrentUser();
        String result = aiService.translate(user.getId(), user.getUsername(), content, targetLang);
        return Result.success("翻译成功", result);
    }

    /**
     * 根据模板调用AI
     */
    @PostMapping("/call")
    public Result<String> callByTemplate(@RequestParam String templateCode, @RequestBody Map<String, String> params) {
        SysUser user = LoginUserHolder.getCurrentUser();
        String result = aiService.callByTemplate(user.getId(), user.getUsername(), templateCode, params);
        return Result.success("调用成功", result);
    }

    /**
     * 获取所有启用的模板
     */
    @GetMapping("/templates")
    public Result<List<AiPromptTemplate>> getAllTemplates() {
        List<AiPromptTemplate> templates = aiService.getAllEnabledTemplates();
        return Result.success(templates);
    }

    /**
     * 根据场景类型获取模板
     */
    @GetMapping("/templates/scene/{sceneType}")
    public Result<List<AiPromptTemplate>> getTemplatesByScene(@PathVariable String sceneType) {
        List<AiPromptTemplate> templates = aiService.getTemplatesBySceneType(sceneType);
        return Result.success(templates);
    }

    /**
     * 获取模板详情
     */
    @GetMapping("/templates/{id}")
    public Result<AiPromptTemplate> getTemplate(@PathVariable Long id) {
        AiPromptTemplate template = aiService.getTemplateById(id);
        return Result.success(template);
    }

    /**
     * 添加模板
     */
    @PostMapping("/templates")
    public Result<AiPromptTemplate> addTemplate(@RequestBody AiPromptTemplate template) {
        AiPromptTemplate newTemplate = aiService.addTemplate(template);
        return Result.success("添加成功", newTemplate);
    }

    /**
     * 更新模板
     */
    @PutMapping("/templates")
    public Result<?> updateTemplate(@RequestBody AiPromptTemplate template) {
        aiService.updateTemplate(template);
        return Result.success("更新成功");
    }

    /**
     * 删除模板
     */
    @DeleteMapping("/templates/{id}")
    public Result<?> deleteTemplate(@PathVariable Long id) {
        aiService.deleteTemplate(id);
        return Result.success("删除成功");
    }

    /**
     * 获取当前用户调用日志
     */
    @GetMapping("/logs")
    public Result<List<AiCallLog>> getUserLogs() {
        SysUser user = LoginUserHolder.getCurrentUser();
        List<AiCallLog> logs = aiService.getUserCallLogs(user.getId());
        return Result.success(logs);
    }

    /**
     * 获取所有调用日志（管理员权限）
     */
    @GetMapping("/logs/all")
    public Result<List<AiCallLog>> getAllLogs() {
        List<AiCallLog> logs = aiService.getAllCallLogs();
        return Result.success(logs);
    }
}
