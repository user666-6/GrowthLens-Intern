package com.example.growthlens.controller;

import com.example.growthlens.common.LoginUserHolder;
import com.example.growthlens.common.Result;
import com.example.growthlens.entity.GoalInfo;
import com.example.growthlens.entity.GoalTask;
import com.example.growthlens.entity.SysUser;
import com.example.growthlens.service.GoalService;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/goal")
public class GoalController {

    @Autowired
    private GoalService goalService;

    @GetMapping("/list")
    public String list(
            @RequestParam(required = false) Integer status,
            @RequestParam(required = false) String goalType,
            Model model) {
        
        SysUser user = LoginUserHolder.getCurrentUser();
        List<GoalInfo> goalList;
        
        if (status != null) {
            goalList = goalService.getGoalsByUserIdAndStatus(user.getId(), status);
        } else if (goalType != null && !goalType.isEmpty()) {
            goalList = goalService.getGoalsByUserIdAndType(user.getId(), goalType);
        } else {
            goalList = goalService.getGoalsByUserId(user.getId());
        }
        
        model.addAttribute("goalList", goalList);
        model.addAttribute("status", status);
        model.addAttribute("goalType", goalType);
        return "goal/list";
    }

    @GetMapping("/add")
    public String add() {
        return "goal/add";
    }

    @PostMapping("/add")
    @ResponseBody
    public Result<GoalInfo> addSubmit(
            @RequestParam String goalName,
            @RequestParam(required = false) String goalDesc,
            @RequestParam(required = false, defaultValue = "study") String goalType,
            @RequestParam(required = false) Integer priority,
            @RequestParam(required = false) String startDate,
            @RequestParam(required = false) String endDate,
            @RequestParam(required = false) String expectResult) {
        
        SysUser user = LoginUserHolder.getCurrentUser();
        
        GoalInfo goalInfo = new GoalInfo();
        goalInfo.setUserId(user.getId());
        goalInfo.setGoalName(goalName);
        goalInfo.setGoalDesc(goalDesc);
        goalInfo.setGoalType(goalType);
        goalInfo.setPriority(priority);
        if (startDate != null && !startDate.isEmpty()) {
            goalInfo.setStartDate(java.time.LocalDate.parse(startDate));
        }
        if (endDate != null && !endDate.isEmpty()) {
            goalInfo.setEndDate(java.time.LocalDate.parse(endDate));
        }
        goalInfo.setExpectResult(expectResult);
        goalInfo.setProgress(0);
        goalInfo.setStatus(1);
        
        GoalInfo result = goalService.addGoal(goalInfo);
        return Result.success("目标创建成功", result);
    }

    @GetMapping("/edit/{id}")
    public String edit(@PathVariable Long id, Model model) {
        GoalInfo goalInfo = goalService.getGoalById(id);
        model.addAttribute("goal", goalInfo);
        return "goal/edit";
    }

    @PostMapping("/edit")
    @ResponseBody
    public Result<GoalInfo> editSubmit(
            @RequestParam Long id,
            @RequestParam String goalName,
            @RequestParam(required = false) String goalDesc,
            @RequestParam(required = false) String goalType,
            @RequestParam(required = false) Integer priority,
            @RequestParam(required = false) String startDate,
            @RequestParam(required = false) String endDate,
            @RequestParam(required = false) String expectResult,
            @RequestParam(required = false) Integer status) {
        
        GoalInfo goalInfo = goalService.getGoalById(id);
        goalInfo.setGoalName(goalName);
        goalInfo.setGoalDesc(goalDesc);
        goalInfo.setGoalType(goalType);
        goalInfo.setPriority(priority);
        if (startDate != null && !startDate.isEmpty()) {
            goalInfo.setStartDate(java.time.LocalDate.parse(startDate));
        }
        if (endDate != null && !endDate.isEmpty()) {
            goalInfo.setEndDate(java.time.LocalDate.parse(endDate));
        }
        goalInfo.setExpectResult(expectResult);
        if (status != null) {
            goalInfo.setStatus(status);
        }
        
        GoalInfo result = goalService.updateGoal(goalInfo);
        return Result.success("目标更新成功", result);
    }

    @PostMapping("/delete/{id}")
    @ResponseBody
    public Result<Object> delete(@PathVariable Long id) {
        goalService.deleteGoal(id);
        return Result.success("目标删除成功");
    }

    @GetMapping("/detail/{id}")
    public String detail(@PathVariable Long id, 
                         @RequestParam(required = false) Integer status,
                         Model model) {
        GoalInfo goalInfo = goalService.getGoalById(id);
        List<GoalTask> tasks = goalService.getTasksByGoalId(id);
        
        if (status != null) {
            tasks = tasks.stream().filter(t -> status.equals(t.getStatus())).toList();
        }
        
        model.addAttribute("goal", goalInfo);
        model.addAttribute("tasks", tasks);
        model.addAttribute("taskStatusFilter", status);
        return "goal/detail";
    }

    @PostMapping("/task/add")
    @ResponseBody
    public Result<GoalTask> addTask(
            @RequestParam Long goalId,
            @RequestParam String taskName,
            @RequestParam(required = false) String taskDesc,
            @RequestParam(required = false) Integer priority,
            @RequestParam(required = false) String deadline,
            @RequestParam(required = false) Integer sort,
            @RequestParam(required = false) Integer status) {
        
        SysUser user = LoginUserHolder.getCurrentUser();
        
        GoalTask goalTask = new GoalTask();
        goalTask.setUserId(user.getId());
        goalTask.setGoalId(goalId);
        goalTask.setTaskName(taskName);
        goalTask.setTaskDesc(taskDesc);
        goalTask.setPriority(priority);
        if (deadline != null && !deadline.isEmpty()) {
            goalTask.setDeadline(java.time.LocalDate.parse(deadline));
        }
        goalTask.setSort(sort);
        goalTask.setStatus(status != null ? status : 1);
        
        GoalTask result = goalService.addTask(goalTask);
        return Result.success("任务添加成功", result);
    }

    @PostMapping("/task/update")
    @ResponseBody
    public Result<GoalTask> updateTask(
            @RequestParam Long id,
            @RequestParam(required = false) String taskName,
            @RequestParam(required = false) String taskDesc,
            @RequestParam(required = false) Integer priority,
            @RequestParam(required = false) String deadline,
            @RequestParam(required = false) Integer sort,
            @RequestParam(required = false) Integer status) {
        
        GoalTask goalTask = goalService.getTaskById(id);
        if (taskName != null) goalTask.setTaskName(taskName);
        if (taskDesc != null) goalTask.setTaskDesc(taskDesc);
        if (priority != null) goalTask.setPriority(priority);
        if (deadline != null && !deadline.isEmpty()) {
            goalTask.setDeadline(java.time.LocalDate.parse(deadline));
        }
        if (sort != null) goalTask.setSort(sort);
        if (status != null) goalTask.setStatus(status);
        
        GoalTask result = goalService.updateTask(goalTask);
        return Result.success("任务更新成功", result);
    }

    @PostMapping("/task/delete/{id}")
    @ResponseBody
    public Result<Object> deleteTask(@PathVariable Long id) {
        goalService.deleteTask(id);
        return Result.success("任务删除成功");
    }

    @PostMapping("/task/status/{id}/{status}")
    @ResponseBody
    public Result<Object> updateTaskStatus(@PathVariable Long id, @PathVariable Integer status) {
        goalService.updateTaskStatus(id, status);
        return Result.success("任务状态更新成功");
    }

    @PostMapping("/smart/generate")
    @ResponseBody
    public Result<String> generateSmartGoals(
            @RequestParam String goalName,
            @RequestParam(required = false) String goalDesc,
            @RequestParam(defaultValue = "30") Integer duration) {
        
        SysUser user = LoginUserHolder.getCurrentUser();
        String result = goalService.generateSmartGoals(user.getId(), goalName, goalDesc != null ? goalDesc : "", duration);
        return Result.success("智能拆解成功", result);
    }

    @PostMapping("/smart/save")
    @ResponseBody
    public Result<Map<String, Object>> generateAndSaveSmartGoals(
            @RequestParam String goalName,
            @RequestParam(required = false) String goalDesc,
            @RequestParam(required = false, defaultValue = "study") String goalType,
            @RequestParam(required = false) Integer priority,
            @RequestParam(required = false) String startDate,
            @RequestParam(required = false) String endDate,
            @RequestParam(required = false) String expectResult) {
        
        SysUser user = LoginUserHolder.getCurrentUser();
        Map<String, Object> result = goalService.generateAndSaveSmartGoals(
                user.getId(), goalName, goalDesc, goalType, priority, startDate, endDate, expectResult);
        return Result.success("智能拆解并保存成功", result);
    }

    @PostMapping("/smart/tasks/save")
    @ResponseBody
    public Result<Map<String, Object>> generateAndSaveSmartTasks(
            @RequestParam Long goalId,
            @RequestParam(required = false) String goalName,
            @RequestParam(required = false) String goalDesc) {
        
        Map<String, Object> result = goalService.generateAndSaveSmartTasks(goalId, goalName, goalDesc);
        return Result.success("智能拆解并保存任务成功", result);
    }

    @GetMapping("/api/list")
    @ResponseBody
    public Result<List<GoalInfo>> getGoalList() {
        SysUser user = LoginUserHolder.getCurrentUser();
        List<GoalInfo> goals = goalService.getGoalsByUserId(user.getId());
        return Result.success(goals);
    }

    @GetMapping("/api/tasks/{goalId}")
    @ResponseBody
    public Result<List<GoalTask>> getTaskList(@PathVariable Long goalId) {
        List<GoalTask> tasks = goalService.getTasksByGoalId(goalId);
        return Result.success(tasks);
    }
}