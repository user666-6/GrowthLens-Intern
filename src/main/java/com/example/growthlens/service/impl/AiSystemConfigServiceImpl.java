package com.example.growthlens.service.impl;

import com.example.growthlens.entity.AiSystemConfig;
import com.example.growthlens.mapper.AiSystemConfigMapper;
import com.example.growthlens.service.AiSystemConfigService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class AiSystemConfigServiceImpl implements AiSystemConfigService {

    @Autowired
    private AiSystemConfigMapper configMapper;

    @Override
    public AiSystemConfig findById(Long id) {
        return configMapper.findById(id);
    }

    @Override
    public AiSystemConfig findByKey(String configKey) {
        return configMapper.findByKey(configKey);
    }

    @Override
    public List<AiSystemConfig> findAll() {
        return configMapper.findAll();
    }

    @Override
    public String getConfigValue(String configKey) {
        AiSystemConfig config = configMapper.findByKey(configKey);
        return config != null ? config.getConfigValue() : null;
    }

    @Override
    public Map<String, String> getAllConfigMap() {
        List<AiSystemConfig> configs = configMapper.findAllEnabled();
        Map<String, String> map = new HashMap<>();
        for (AiSystemConfig config : configs) {
            map.put(config.getConfigKey(), config.getConfigValue());
        }
        return map;
    }

    @Override
    public int updateValue(Long id, String configValue) {
        return configMapper.updateValue(id, configValue);
    }

    @Override
    public int updateByKey(String configKey, String configValue) {
        AiSystemConfig config = configMapper.findByKey(configKey);
        if (config != null) {
            return configMapper.updateValue(config.getId(), configValue);
        }
        return 0;
    }

    @Override
    public int save(AiSystemConfig config) {
        if (config.getId() == null) {
            return configMapper.insert(config);
        }
        return configMapper.update(config);
    }

    @Override
    public int deleteById(Long id) {
        return configMapper.deleteById(id);
    }
}