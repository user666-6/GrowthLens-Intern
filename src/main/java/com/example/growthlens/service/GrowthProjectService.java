package com.example.growthlens.service;

import com.example.growthlens.entity.GrowthProject;

import java.util.List;
import java.util.Map;

public interface GrowthProjectService {

    GrowthProject findById(Long id);

    List<GrowthProject> findByUserId(Long userId);

    GrowthProject add(GrowthProject project);

    GrowthProject update(GrowthProject project);

    void deleteById(Long id);

    List<Map<String, Object>> countByMonth(Long userId);
}
