package com.example.growthlens.service;

import com.example.growthlens.entity.InterviewCategory;

import java.util.List;

public interface InterviewCategoryService {

    InterviewCategory addCategory(InterviewCategory category);

    void updateCategory(InterviewCategory category);

    void deleteCategory(Long id);

    InterviewCategory findById(Long id);

    List<InterviewCategory> findByUserId(Long userId);

    List<InterviewCategory> findByType(Long userId, String categoryType);

    List<InterviewCategory> findByParentId(Long userId, Long parentId);

    List<InterviewCategory> findAll();
}