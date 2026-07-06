package com.example.growthlens.config;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Configuration;

/**
 * AI模型配置类
 * 从application.yml读取大模型相关配置
 */
@Data
@Configuration
@ConfigurationProperties(prefix = "ai.model")
public class AiModelConfig {

    /**
     * 大模型API基础地址
     */
    private String baseUrl;

    /**
     * API密钥
     */
    private String apiKey;

    /**
     * 模型名称
     */
    private String modelName;

    /**
     * 请求超时时间（毫秒）
     */
    private Integer timeout;
}