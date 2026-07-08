package com.example.growthlens.service.impl;

import com.example.growthlens.common.BusinessException;
import com.example.growthlens.entity.GoalInfo;
import com.example.growthlens.entity.GoalTask;
import com.example.growthlens.mapper.GoalInfoMapper;
import com.example.growthlens.mapper.GoalTaskMapper;
import com.example.growthlens.service.AiService;
import com.example.growthlens.service.GoalService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class GoalServiceImpl implements GoalService {

    @Autowired
    private GoalInfoMapper goalInfoMapper;

    @Autowired
    private GoalTaskMapper goalTaskMapper;

    @Autowired
    private AiService aiService;

    @Override
    public GoalInfo addGoal(GoalInfo goalInfo) {
        if (goalInfo.getProgress() == null) {
            goalInfo.setProgress(0);
        }
        if (goalInfo.getStatus() == null) {
            goalInfo.setStatus(1);
        }
        if (goalInfo.getPriority() == null) {
            goalInfo.setPriority(2);
        }
        goalInfoMapper.insert(goalInfo);
        return goalInfo;
    }

    @Override
    public GoalInfo updateGoal(GoalInfo goalInfo) {
        GoalInfo existing = goalInfoMapper.findById(goalInfo.getId());
        if (existing == null) {
            throw new BusinessException("目标不存在");
        }
        goalInfoMapper.update(goalInfo);
        return goalInfoMapper.findById(goalInfo.getId());
    }

    @Override
    @Transactional
    public void deleteGoal(Long id) {
        GoalInfo goalInfo = goalInfoMapper.findById(id);
        if (goalInfo == null) {
            throw new BusinessException("目标不存在");
        }
        goalTaskMapper.deleteByGoalId(id);
        goalInfoMapper.deleteById(id);
    }

    @Override
    public GoalInfo getGoalById(Long id) {
        GoalInfo goalInfo = goalInfoMapper.findById(id);
        if (goalInfo == null) {
            throw new BusinessException("目标不存在");
        }
        return goalInfo;
    }

    @Override
    public List<GoalInfo> getGoalsByUserId(Long userId) {
        return goalInfoMapper.findByUserId(userId);
    }

    @Override
    public List<GoalInfo> getGoalsByUserIdAndStatus(Long userId, Integer status) {
        return goalInfoMapper.findByUserIdAndStatus(userId, status);
    }

    @Override
    public List<GoalInfo> getGoalsByUserIdAndType(Long userId, String goalType) {
        return goalInfoMapper.findByUserIdAndType(userId, goalType);
    }

    @Override
    @Transactional
    public void updateGoalProgress(Long goalId) {
        int completedCount = goalInfoMapper.countCompletedTasks(goalId);
        int totalCount = goalInfoMapper.countTotalTasks(goalId);
        
        int progress = 0;
        if (totalCount > 0) {
            progress = (completedCount * 100) / totalCount;
        }
        
        goalInfoMapper.updateProgress(goalId, progress);
        
        if (progress == 100) {
            GoalInfo goalInfo = goalInfoMapper.findById(goalId);
            if (goalInfo != null && goalInfo.getStatus() != 3) {
                goalInfo.setStatus(3);
                goalInfoMapper.update(goalInfo);
            }
        }
    }

    @Override
    @Transactional
    public GoalTask addTask(GoalTask goalTask) {
        GoalInfo goalInfo = goalInfoMapper.findById(goalTask.getGoalId());
        if (goalInfo == null) {
            throw new BusinessException("目标不存在");
        }
        
        if (goalTask.getStatus() == null) {
            goalTask.setStatus(1);
        }
        if (goalTask.getPriority() == null) {
            goalTask.setPriority(2);
        }
        if (goalTask.getSort() == null) {
            goalTask.setSort(0);
        }
        
        goalTaskMapper.insert(goalTask);
        updateGoalProgress(goalTask.getGoalId());
        return goalTask;
    }

    @Override
    @Transactional
    public GoalTask updateTask(GoalTask goalTask) {
        GoalTask existing = goalTaskMapper.findById(goalTask.getId());
        if (existing == null) {
            throw new BusinessException("任务不存在");
        }
        goalTaskMapper.update(goalTask);
        updateGoalProgress(goalTask.getGoalId());
        return goalTaskMapper.findById(goalTask.getId());
    }

    @Override
    @Transactional
    public void deleteTask(Long id) {
        GoalTask goalTask = goalTaskMapper.findById(id);
        if (goalTask == null) {
            throw new BusinessException("任务不存在");
        }
        Long goalId = goalTask.getGoalId();
        goalTaskMapper.deleteById(id);
        updateGoalProgress(goalId);
    }

    @Override
    public GoalTask getTaskById(Long id) {
        GoalTask goalTask = goalTaskMapper.findById(id);
        if (goalTask == null) {
            throw new BusinessException("任务不存在");
        }
        return goalTask;
    }

    @Override
    public List<GoalTask> getTasksByGoalId(Long goalId) {
        return goalTaskMapper.findByGoalId(goalId);
    }

    @Override
    public List<GoalTask> getTasksByUserId(Long userId) {
        return goalTaskMapper.findByUserId(userId);
    }

    @Override
    @Transactional
    public void updateTaskStatus(Long taskId, Integer status) {
        GoalTask goalTask = goalTaskMapper.findById(taskId);
        if (goalTask == null) {
            throw new BusinessException("任务不存在");
        }
        goalTaskMapper.updateStatus(taskId, status);
        updateGoalProgress(goalTask.getGoalId());
    }

    @Override
    public List<GoalTask> getTasksByUserIdAndStatus(Long userId, Integer status) {
        return goalTaskMapper.findByUserIdAndStatus(userId, status);
    }

    @Override
    public String generateSmartGoals(Long userId, String goalName, String goalDesc, Integer duration) {
        String prompt = String.format("请帮我将以下目标拆解为阶段性目标和具体任务：\n\n目标名称：%s\n目标描述：%s\n预计周期：%d天\n\n请按照以下格式输出JSON：\n{\n  \"phases\": [\n    {\n      \"phaseName\": \"阶段名称\",\n      \"startDay\": 开始天数,\n      \"endDay\": 结束天数,\n      \"tasks\": [\n        {\"taskName\": \"任务名称\", \"taskDesc\": \"任务描述\", \"priority\": 优先级(1-3)}\n      ]\n    }\n  ]\n}", goalName, goalDesc, duration);

        try {
            return aiService.generateAnswer(userId, "", prompt);
        } catch (Exception e) {
            throw new BusinessException("AI智能拆解失败：" + e.getMessage());
        }
    }
}