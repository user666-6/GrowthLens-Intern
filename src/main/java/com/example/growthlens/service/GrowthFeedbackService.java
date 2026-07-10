package com.example.growthlens.service;

import com.example.growthlens.entity.GrowthFeedback;

import java.util.List;
import java.util.Map;

public interface GrowthFeedbackService {

    GrowthFeedback findById(Long id);

    List<GrowthFeedback> findByUserId(Long userId);

    List<GrowthFeedback> findByUserIdAndSource(Long userId, String feedbackSource);

    GrowthFeedback add(GrowthFeedback feedback);

    GrowthFeedback update(GrowthFeedback feedback);

    void deleteById(Long id);

    List<Map<String, Object>> countByFeedbackType(Long userId);

    List<Map<String, Object>> countByFeedbackSource(Long userId);
}
