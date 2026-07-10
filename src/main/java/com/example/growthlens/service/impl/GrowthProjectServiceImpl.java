package com.example.growthlens.service.impl;

import com.example.growthlens.common.BusinessException;
import com.example.growthlens.entity.GrowthProject;
import com.example.growthlens.mapper.GrowthProjectMapper;
import com.example.growthlens.service.GrowthProjectService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
public class GrowthProjectServiceImpl implements GrowthProjectService {

    @Autowired
    private GrowthProjectMapper projectMapper;

    @Override
    public GrowthProject findById(Long id) {
        GrowthProject project = projectMapper.findById(id);
        if (project == null) {
            throw new BusinessException("项目经历不存在");
        }
        return project;
    }

    @Override
    public List<GrowthProject> findByUserId(Long userId) {
        return projectMapper.findByUserId(userId);
    }

    @Override
    public GrowthProject add(GrowthProject project) {
        projectMapper.insert(project);
        return project;
    }

    @Override
    public GrowthProject update(GrowthProject project) {
        if (projectMapper.findById(project.getId()) == null) {
            throw new BusinessException("项目经历不存在");
        }
        projectMapper.update(project);
        return project;
    }

    @Override
    public void deleteById(Long id) {
        if (projectMapper.findById(id) == null) {
            throw new BusinessException("项目经历不存在");
        }
        projectMapper.deleteById(id);
    }

    @Override
    public List<Map<String, Object>> countByMonth(Long userId) {
        return projectMapper.countByMonth(userId);
    }
}
