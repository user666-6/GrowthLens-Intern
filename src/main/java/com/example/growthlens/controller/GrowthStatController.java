package com.example.growthlens.controller;

import com.example.growthlens.common.LoginUserHolder;
import com.example.growthlens.common.Result;
import com.example.growthlens.entity.SysUser;
import com.example.growthlens.service.GrowthFeedbackService;
import com.example.growthlens.service.GrowthProjectService;
import com.example.growthlens.service.GrowthSkillService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/stat")
public class GrowthStatController {

    @Autowired
    private GrowthSkillService skillService;

    @Autowired
    private GrowthProjectService projectService;

    @Autowired
    private GrowthFeedbackService feedbackService;

    @GetMapping("/dashboard")
    public Result<Map<String, Object>> dashboard() {
        SysUser user = LoginUserHolder.getCurrentUser();
        Map<String, Object> data = new HashMap<>();

        data.put("skillTypeDistribution", skillService.countBySkillType(user.getId()));
        data.put("skillLevelDistribution", skillService.countByMasterLevel(user.getId()));
        data.put("projectMonthTrend", projectService.countByMonth(user.getId()));
        data.put("feedbackTypeDistribution", feedbackService.countByFeedbackType(user.getId()));
        data.put("feedbackSourceDistribution", feedbackService.countByFeedbackSource(user.getId()));

        data.put("skillCount", skillService.findByUserId(user.getId()).size());
        data.put("projectCount", projectService.findByUserId(user.getId()).size());
        data.put("feedbackCount", feedbackService.findByUserId(user.getId()).size());

        return Result.success(data);
    }

    @GetMapping("/skill/distribution")
    public Result<List<Map<String, Object>>> skillDistribution() {
        SysUser user = LoginUserHolder.getCurrentUser();
        return Result.success(skillService.countBySkillType(user.getId()));
    }

    @GetMapping("/skill/level-distribution")
    public Result<List<Map<String, Object>>> skillLevelDistribution() {
        SysUser user = LoginUserHolder.getCurrentUser();
        return Result.success(skillService.countByMasterLevel(user.getId()));
    }

    @GetMapping("/project/trend")
    public Result<List<Map<String, Object>>> projectTrend() {
        SysUser user = LoginUserHolder.getCurrentUser();
        return Result.success(projectService.countByMonth(user.getId()));
    }

    @GetMapping("/feedback/type-distribution")
    public Result<List<Map<String, Object>>> feedbackTypeDistribution() {
        SysUser user = LoginUserHolder.getCurrentUser();
        return Result.success(feedbackService.countByFeedbackType(user.getId()));
    }

    @GetMapping("/feedback/source-distribution")
    public Result<List<Map<String, Object>>> feedbackSourceDistribution() {
        SysUser user = LoginUserHolder.getCurrentUser();
        return Result.success(feedbackService.countByFeedbackSource(user.getId()));
    }
}
