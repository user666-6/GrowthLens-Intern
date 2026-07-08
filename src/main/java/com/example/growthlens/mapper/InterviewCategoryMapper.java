package com.example.growthlens.mapper;

import com.example.growthlens.entity.InterviewCategory;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface InterviewCategoryMapper {

    int insert(InterviewCategory category);

    int update(InterviewCategory category);

    int deleteById(@Param("id") Long id);

    InterviewCategory findById(@Param("id") Long id);

    List<InterviewCategory> findByUserId(@Param("userId") Long userId);

    List<InterviewCategory> findByType(@Param("userId") Long userId, @Param("categoryType") String categoryType);

    List<InterviewCategory> findByParentId(@Param("userId") Long userId, @Param("parentId") Long parentId);

    List<InterviewCategory> findAll();
}