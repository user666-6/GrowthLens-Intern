package com.example.growthlens.controller;

import com.example.growthlens.common.LoginUserHolder;
import com.example.growthlens.common.Result;
import com.example.growthlens.entity.GrowthProject;
import com.example.growthlens.entity.SysUser;
import com.example.growthlens.service.AiService;
import com.example.growthlens.service.GrowthProjectService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/project")
public class GrowthProjectController {

    @Autowired
    private GrowthProjectService projectService;

    @Autowired
    private AiService aiService;

    @GetMapping("/list")
    public Result<List<GrowthProject>> list() {
        SysUser user = LoginUserHolder.getCurrentUser();
        return Result.success(projectService.findByUserId(user.getId()));
    }

    @GetMapping("/{id}")
    public Result<GrowthProject> detail(@PathVariable Long id) {
        return Result.success(projectService.findById(id));
    }

    @PostMapping
    public Result<GrowthProject> add(@RequestBody GrowthProject project) {
        SysUser user = LoginUserHolder.getCurrentUser();
        project.setUserId(user.getId());
        return Result.success("添加成功", projectService.add(project));
    }

    @PutMapping
    public Result<GrowthProject> update(@RequestBody GrowthProject project) {
        SysUser user = LoginUserHolder.getCurrentUser();
        project.setUserId(user.getId());
        return Result.success("更新成功", projectService.update(project));
    }

    @DeleteMapping("/{id}")
    public Result<?> delete(@PathVariable Long id) {
        projectService.deleteById(id);
        return Result.success("删除成功");
    }

    @PostMapping("/{id}/star-optimize")
    public Result<String> starOptimize(@PathVariable Long id) {
        SysUser user = LoginUserHolder.getCurrentUser();
        GrowthProject project = projectService.findById(id);

        Map<String, String> params = new HashMap<>();
        params.put("projectName", project.getProjectName());
        params.put("projectRole", project.getProjectRole() != null ? project.getProjectRole() : "");
        params.put("projectDesc", project.getProjectDesc() != null ? project.getProjectDesc() : "");
        params.put("personalDuty", project.getPersonalDuty() != null ? project.getPersonalDuty() : "");
        params.put("achievement", project.getAchievement() != null ? project.getAchievement() : "");
        params.put("techStack", project.getTechStack() != null ? project.getTechStack() : "");

        String result = aiService.callByTemplate(user.getId(), user.getUsername(), "STAR_TEMPLATE", params);
        return Result.success("STAR优化成功", result);
    }

    @GetMapping("/stat/month")
    public Result<List<Map<String, Object>>> statByMonth() {
        SysUser user = LoginUserHolder.getCurrentUser();
        return Result.success(projectService.countByMonth(user.getId()));
    }
}
