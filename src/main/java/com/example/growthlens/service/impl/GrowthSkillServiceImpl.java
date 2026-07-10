package com.example.growthlens.service.impl;

import com.example.growthlens.common.BusinessException;
import com.example.growthlens.entity.GrowthSkill;
import com.example.growthlens.mapper.GrowthSkillMapper;
import com.example.growthlens.service.GrowthSkillService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
public class GrowthSkillServiceImpl implements GrowthSkillService {

    @Autowired
    private GrowthSkillMapper skillMapper;

    @Override
    public GrowthSkill findById(Long id) {
        GrowthSkill skill = skillMapper.findById(id);
        if (skill == null) {
            throw new BusinessException("技能记录不存在");
        }
        return skill;
    }

    @Override
    public List<GrowthSkill> findByUserId(Long userId) {
        return skillMapper.findByUserId(userId);
    }

    @Override
    public List<GrowthSkill> findByUserIdAndType(Long userId, String skillType) {
        return skillMapper.findByUserIdAndType(userId, skillType);
    }

    @Override
    public GrowthSkill add(GrowthSkill skill) {
        if (skill.getMasterLevel() == null) {
            skill.setMasterLevel(1);
        }
        if (skill.getSkillType() == null) {
            skill.setSkillType("tech");
        }
        skillMapper.insert(skill);
        return skill;
    }

    @Override
    public GrowthSkill update(GrowthSkill skill) {
        if (skillMapper.findById(skill.getId()) == null) {
            throw new BusinessException("技能记录不存在");
        }
        skillMapper.update(skill);
        return skill;
    }

    @Override
    public void deleteById(Long id) {
        if (skillMapper.findById(id) == null) {
            throw new BusinessException("技能记录不存在");
        }
        skillMapper.deleteById(id);
    }

    @Override
    public List<Map<String, Object>> countBySkillType(Long userId) {
        return skillMapper.countBySkillType(userId);
    }

    @Override
    public List<Map<String, Object>> countByMasterLevel(Long userId) {
        return skillMapper.countByMasterLevel(userId);
    }
}
