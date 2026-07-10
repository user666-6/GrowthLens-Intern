package com.example.growthlens.service.impl;

import com.example.growthlens.common.BusinessException;
import com.example.growthlens.entity.GrowthFeedback;
import com.example.growthlens.mapper.GrowthFeedbackMapper;
import com.example.growthlens.service.GrowthFeedbackService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
public class GrowthFeedbackServiceImpl implements GrowthFeedbackService {

    @Autowired
    private GrowthFeedbackMapper feedbackMapper;

    @Override
    public GrowthFeedback findById(Long id) {
        GrowthFeedback feedback = feedbackMapper.findById(id);
        if (feedback == null) {
            throw new BusinessException("反馈记录不存在");
        }
        return feedback;
    }

    @Override
    public List<GrowthFeedback> findByUserId(Long userId) {
        return feedbackMapper.findByUserId(userId);
    }

    @Override
    public List<GrowthFeedback> findByUserIdAndSource(Long userId, String feedbackSource) {
        return feedbackMapper.findByUserIdAndSource(userId, feedbackSource);
    }

    @Override
    public GrowthFeedback add(GrowthFeedback feedback) {
        feedbackMapper.insert(feedback);
        return feedback;
    }

    @Override
    public GrowthFeedback update(GrowthFeedback feedback) {
        if (feedbackMapper.findById(feedback.getId()) == null) {
            throw new BusinessException("反馈记录不存在");
        }
        feedbackMapper.update(feedback);
        return feedback;
    }

    @Override
    public void deleteById(Long id) {
        if (feedbackMapper.findById(id) == null) {
            throw new BusinessException("反馈记录不存在");
        }
        feedbackMapper.deleteById(id);
    }

    @Override
    public List<Map<String, Object>> countByFeedbackType(Long userId) {
        return feedbackMapper.countByFeedbackType(userId);
    }

    @Override
    public List<Map<String, Object>> countByFeedbackSource(Long userId) {
        return feedbackMapper.countByFeedbackSource(userId);
    }
}
