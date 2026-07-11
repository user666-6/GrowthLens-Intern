package com.example.growthlens.controller;

import com.example.growthlens.common.LoginUserHolder;
import com.example.growthlens.common.Result;
import com.example.growthlens.entity.GrowthProject;
import com.example.growthlens.entity.SysUser;
import com.example.growthlens.service.AiService;
import com.example.growthlens.service.GrowthProjectService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

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

        String result = aiService.generateStar(
                user.getId(), user.getUsername(),
                project.getProjectName(),
                project.getProjectRole(),
                project.getProjectDesc(),
                project.getPersonalDuty(),
                project.getAchievement(),
                project.getTechStack()
        );
        return Result.success("STAR优化成功", result);
    }

    @PostMapping("/star-generate")
    public Result<String> starGenerate(@RequestBody Map<String, String> request) {
        SysUser user = LoginUserHolder.getCurrentUser();

        String result = aiService.generateStar(
                user.getId(), user.getUsername(),
                request.getOrDefault("projectName", ""),
                request.getOrDefault("projectRole", ""),
                request.getOrDefault("projectDesc", ""),
                request.getOrDefault("personalDuty", ""),
                request.getOrDefault("achievement", ""),
                request.getOrDefault("techStack", "")
        );
        return Result.success("STAR成果提炼成功", result);
    }

    @GetMapping("/stat/month")
    public Result<List<Map<String, Object>>> statByMonth() {
        SysUser user = LoginUserHolder.getCurrentUser();
        return Result.success(projectService.countByMonth(user.getId()));
    }
}
