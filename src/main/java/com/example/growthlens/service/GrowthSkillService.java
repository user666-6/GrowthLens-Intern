package com.example.growthlens.service;

import com.example.growthlens.entity.GrowthSkill;

import java.util.List;
import java.util.Map;

public interface GrowthSkillService {

    GrowthSkill findById(Long id);

    List<GrowthSkill> findByUserId(Long userId);

    List<GrowthSkill> findByUserIdAndType(Long userId, String skillType);

    GrowthSkill add(GrowthSkill skill);

    GrowthSkill update(GrowthSkill skill);

    void deleteById(Long id);

    List<Map<String, Object>> countBySkillType(Long userId);

    List<Map<String, Object>> countByMasterLevel(Long userId);
}
