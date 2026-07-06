package com.example.growthlens.service;

import com.example.growthlens.entity.AiSystemConfig;

import java.util.List;
import java.util.Map;

public interface AiSystemConfigService {

    AiSystemConfig findById(Long id);

    AiSystemConfig findByKey(String configKey);

    List<AiSystemConfig> findAll();

    String getConfigValue(String configKey);

    Map<String, String> getAllConfigMap();

    int updateValue(Long id, String configValue);

    int updateByKey(String configKey, String configValue);

    int save(AiSystemConfig config);

    int deleteById(Long id);
}