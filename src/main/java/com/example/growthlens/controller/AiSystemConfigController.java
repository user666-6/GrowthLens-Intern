package com.example.growthlens.controller;

import com.example.growthlens.entity.AiSystemConfig;
import com.example.growthlens.service.AiSystemConfigService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/ai/config")
public class AiSystemConfigController {

    @Autowired
    private AiSystemConfigService configService;

    @GetMapping
    public ResponseEntity<List<AiSystemConfig>> list() {
        return ResponseEntity.ok(configService.findAll());
    }

    @GetMapping("/{id}")
    public ResponseEntity<AiSystemConfig> getById(@PathVariable Long id) {
        AiSystemConfig config = configService.findById(id);
        return config != null ? ResponseEntity.ok(config) : ResponseEntity.notFound().build();
    }

    @GetMapping("/key/{configKey}")
    public ResponseEntity<AiSystemConfig> getByKey(@PathVariable String configKey) {
        AiSystemConfig config = configService.findByKey(configKey);
        return config != null ? ResponseEntity.ok(config) : ResponseEntity.notFound().build();
    }

    @PostMapping
    public ResponseEntity<Map<String, Object>> save(@RequestBody AiSystemConfig config) {
        Map<String, Object> result = new HashMap<>();
        int rows = configService.save(config);
        if (rows > 0) {
            result.put("success", true);
            result.put("message", "保存成功");
            return ResponseEntity.ok(result);
        }
        result.put("success", false);
        result.put("message", "保存失败");
        return ResponseEntity.badRequest().body(result);
    }

    @PutMapping("/{id}")
    public ResponseEntity<Map<String, Object>> update(@PathVariable Long id, @RequestBody Map<String, String> body) {
        Map<String, Object> result = new HashMap<>();
        String configValue = body.get("configValue");
        int rows = configService.updateValue(id, configValue);
        if (rows > 0) {
            result.put("success", true);
            result.put("message", "更新成功");
            return ResponseEntity.ok(result);
        }
        result.put("success", false);
        result.put("message", "更新失败");
        return ResponseEntity.badRequest().body(result);
    }

    @PutMapping("/key/{configKey}")
    public ResponseEntity<Map<String, Object>> updateByKey(@PathVariable String configKey, @RequestBody Map<String, String> body) {
        Map<String, Object> result = new HashMap<>();
        String configValue = body.get("configValue");
        int rows = configService.updateByKey(configKey, configValue);
        if (rows > 0) {
            result.put("success", true);
            result.put("message", "更新成功");
            return ResponseEntity.ok(result);
        }
        result.put("success", false);
        result.put("message", "更新失败");
        return ResponseEntity.badRequest().body(result);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Map<String, Object>> delete(@PathVariable Long id) {
        Map<String, Object> result = new HashMap<>();
        int rows = configService.deleteById(id);
        if (rows > 0) {
            result.put("success", true);
            result.put("message", "删除成功");
            return ResponseEntity.ok(result);
        }
        result.put("success", false);
        result.put("message", "删除失败");
        return ResponseEntity.badRequest().body(result);
    }
}