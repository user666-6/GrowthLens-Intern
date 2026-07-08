package com.example.growthlens.service;

import com.example.growthlens.entity.GoalInfo;
import com.example.growthlens.entity.GoalTask;

import java.util.List;
import java.util.Map;

public interface GoalService {

    GoalInfo addGoal(GoalInfo goalInfo);

    GoalInfo updateGoal(GoalInfo goalInfo);

    void deleteGoal(Long id);

    GoalInfo getGoalById(Long id);

    List<GoalInfo> getGoalsByUserId(Long userId);

    List<GoalInfo> getGoalsByUserIdAndStatus(Long userId, Integer status);

    List<GoalInfo> getGoalsByUserIdAndType(Long userId, String goalType);

    void updateGoalProgress(Long goalId);

    GoalTask addTask(GoalTask goalTask);

    GoalTask updateTask(GoalTask goalTask);

    void deleteTask(Long id);

    GoalTask getTaskById(Long id);

    List<GoalTask> getTasksByGoalId(Long goalId);

    List<GoalTask> getTasksByUserId(Long userId);

    void updateTaskStatus(Long taskId, Integer status);

    List<GoalTask> getTasksByUserIdAndStatus(Long userId, Integer status);

    String generateSmartGoals(Long userId, String goalName, String goalDesc, Integer duration);
}