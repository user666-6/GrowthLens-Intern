package com.example.growthlens.mapper;

import com.example.growthlens.entity.GoalInfo;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.util.List;

@Mapper
public interface GoalInfoMapper {

    List<GoalInfo> findByUserId(@Param("userId") Long userId);

    GoalInfo findById(@Param("id") Long id);

    int insert(GoalInfo goalInfo);

    int update(GoalInfo goalInfo);

    int deleteById(@Param("id") Long id);

    int updateProgress(@Param("id") Long id, @Param("progress") Integer progress);

    @Select("SELECT COUNT(*) FROM goal_task WHERE goal_id = #{goalId} AND status = 3")
    int countCompletedTasks(@Param("goalId") Long goalId);

    @Select("SELECT COUNT(*) FROM goal_task WHERE goal_id = #{goalId}")
    int countTotalTasks(@Param("goalId") Long goalId);

    List<GoalInfo> findByUserIdAndStatus(@Param("userId") Long userId, @Param("status") Integer status);

    List<GoalInfo> findByUserIdAndType(@Param("userId") Long userId, @Param("goalType") String goalType);
}