package com.example.growthlens;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.boot.web.servlet.support.SpringBootServletInitializer;
import org.springframework.context.annotation.Bean;
import org.springframework.web.client.RestTemplate;

/**
 * GrowthLens启动类
 * Spring Boot单体项目入口，配置Mapper扫描和RestTemplate
 */
@SpringBootApplication
@MapperScan("com.example.growthlens.mapper")
public class GrowthLensApplication extends SpringBootServletInitializer {

    public static void main(String[] args) {
        SpringApplication.run(GrowthLensApplication.class, args);
        System.out.println("\n========================================");
        System.out.println("  访问 http://localhost:8080/intern/login");
        System.out.println("========================================\n");
    }

    @Override
    protected SpringApplicationBuilder configure(SpringApplicationBuilder application) {
        return application.sources(GrowthLensApplication.class);
    }

    /**
     * 注册RestTemplate用于HTTP请求
     */
    @Bean
    public RestTemplate restTemplate() {
        return new RestTemplate();
    }

    
}