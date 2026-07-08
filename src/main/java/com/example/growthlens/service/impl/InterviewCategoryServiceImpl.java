package com.example.growthlens.service.impl;

import com.example.growthlens.common.BusinessException;
import com.example.growthlens.entity.InterviewCategory;
import com.example.growthlens.mapper.InterviewCategoryMapper;
import com.example.growthlens.service.InterviewCategoryService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class InterviewCategoryServiceImpl implements InterviewCategoryService {

    @Autowired
    private InterviewCategoryMapper categoryMapper;

    @Override
    public InterviewCategory addCategory(InterviewCategory category) {
        categoryMapper.insert(category);
        return category;
    }

    @Override
    public void updateCategory(InterviewCategory category) {
        if (categoryMapper.findById(category.getId()) == null) {
            throw new BusinessException("分类不存在");
        }
        categoryMapper.update(category);
    }

    @Override
    @Transactional
    public void deleteCategory(Long id) {
        if (categoryMapper.findById(id) == null) {
            throw new BusinessException("分类不存在");
        }
        categoryMapper.deleteById(id);
    }

    @Override
    public InterviewCategory findById(Long id) {
        return categoryMapper.findById(id);
    }

    @Override
    public List<InterviewCategory> findByUserId(Long userId) {
        return categoryMapper.findByUserId(userId);
    }

    @Override
    public List<InterviewCategory> findByType(Long userId, String categoryType) {
        return categoryMapper.findByType(userId, categoryType);
    }

    @Override
    public List<InterviewCategory> findByParentId(Long userId, Long parentId) {
        return categoryMapper.findByParentId(userId, parentId);
    }

    @Override
    public List<InterviewCategory> findAll() {
        return categoryMapper.findAll();
    }
}