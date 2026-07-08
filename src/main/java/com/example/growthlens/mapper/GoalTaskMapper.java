package com.example.growthlens.mapper;

import com.example.growthlens.entity.GoalTask;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface GoalTaskMapper {

    List<GoalTask> findByGoalId(@Param("goalId") Long goalId);

    List<GoalTask> findByUserId(@Param("userId") Long userId);

    GoalTask findById(@Param("id") Long id);

    int insert(GoalTask goalTask);

    int update(GoalTask goalTask);

    int deleteById(@Param("id") Long id);

    int deleteByGoalId(@Param("goalId") Long goalId);

    int updateStatus(@Param("id") Long id, @Param("status") Integer status);

    List<GoalTask> findByUserIdAndStatus(@Param("userId") Long userId, @Param("status") Integer status);
}