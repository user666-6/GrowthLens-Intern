package com.example.growthlens.controller;

import com.example.growthlens.common.LoginUserHolder;
import com.example.growthlens.common.Result;
import com.example.growthlens.entity.GrowthFeedback;
import com.example.growthlens.entity.SysUser;
import com.example.growthlens.service.GrowthFeedbackService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/feedback")
public class GrowthFeedbackController {

    @Autowired
    private GrowthFeedbackService feedbackService;

    @GetMapping("/list")
    public Result<List<GrowthFeedback>> list() {
        SysUser user = LoginUserHolder.getCurrentUser();
        return Result.success(feedbackService.findByUserId(user.getId()));
    }

    @GetMapping("/list/source/{feedbackSource}")
    public Result<List<GrowthFeedback>> listBySource(@PathVariable String feedbackSource) {
        SysUser user = LoginUserHolder.getCurrentUser();
        return Result.success(feedbackService.findByUserIdAndSource(user.getId(), feedbackSource));
    }

    @GetMapping("/{id}")
    public Result<GrowthFeedback> detail(@PathVariable Long id) {
        return Result.success(feedbackService.findById(id));
    }

    @PostMapping
    public Result<GrowthFeedback> add(@RequestBody GrowthFeedback feedback) {
        SysUser user = LoginUserHolder.getCurrentUser();
        feedback.setUserId(user.getId());
        return Result.success("添加成功", feedbackService.add(feedback));
    }

    @PutMapping
    public Result<GrowthFeedback> update(@RequestBody GrowthFeedback feedback) {
        SysUser user = LoginUserHolder.getCurrentUser();
        feedback.setUserId(user.getId());
        return Result.success("更新成功", feedbackService.update(feedback));
    }

    @DeleteMapping("/{id}")
    public Result<?> delete(@PathVariable Long id) {
        feedbackService.deleteById(id);
        return Result.success("删除成功");
    }

    @GetMapping("/stat/type")
    public Result<List<Map<String, Object>>> statByType() {
        SysUser user = LoginUserHolder.getCurrentUser();
        return Result.success(feedbackService.countByFeedbackType(user.getId()));
    }

    @GetMapping("/stat/source")
    public Result<List<Map<String, Object>>> statBySource() {
        SysUser user = LoginUserHolder.getCurrentUser();
        return Result.success(feedbackService.countByFeedbackSource(user.getId()));
    }
}
