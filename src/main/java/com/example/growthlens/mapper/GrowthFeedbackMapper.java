package com.example.growthlens.mapper;

import com.example.growthlens.entity.GrowthFeedback;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.util.List;
import java.util.Map;

@Mapper
public interface GrowthFeedbackMapper {

    @Select("SELECT * FROM growth_feedback WHERE id = #{id}")
    GrowthFeedback findById(@Param("id") Long id);

    @Select("SELECT * FROM growth_feedback WHERE user_id = #{userId} ORDER BY record_date DESC, create_time DESC")
    List<GrowthFeedback> findByUserId(@Param("userId") Long userId);

    @Select("SELECT * FROM growth_feedback WHERE user_id = #{userId} AND feedback_source = #{feedbackSource} ORDER BY record_date DESC")
    List<GrowthFeedback> findByUserIdAndSource(@Param("userId") Long userId, @Param("feedbackSource") String feedbackSource);

    List<Map<String, Object>> countByFeedbackType(@Param("userId") Long userId);

    List<Map<String, Object>> countByFeedbackSource(@Param("userId") Long userId);

    int insert(GrowthFeedback feedback);

    int update(GrowthFeedback feedback);

    int deleteById(@Param("id") Long id);
}
