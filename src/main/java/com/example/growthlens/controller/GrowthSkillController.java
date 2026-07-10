package com.example.growthlens.controller;

import com.example.growthlens.common.LoginUserHolder;
import com.example.growthlens.common.Result;
import com.example.growthlens.entity.GrowthSkill;
import com.example.growthlens.entity.SysUser;
import com.example.growthlens.service.GrowthSkillService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/skill")
public class GrowthSkillController {

    @Autowired
    private GrowthSkillService skillService;

    @GetMapping("/list")
    public Result<List<GrowthSkill>> list() {
        SysUser user = LoginUserHolder.getCurrentUser();
        return Result.success(skillService.findByUserId(user.getId()));
    }

    @GetMapping("/list/type/{skillType}")
    public Result<List<GrowthSkill>> listByType(@PathVariable String skillType) {
        SysUser user = LoginUserHolder.getCurrentUser();
        return Result.success(skillService.findByUserIdAndType(user.getId(), skillType));
    }

    @GetMapping("/{id}")
    public Result<GrowthSkill> detail(@PathVariable Long id) {
        return Result.success(skillService.findById(id));
    }

    @PostMapping
    public Result<GrowthSkill> add(@RequestBody GrowthSkill skill) {
        SysUser user = LoginUserHolder.getCurrentUser();
        skill.setUserId(user.getId());
        return Result.success("添加成功", skillService.add(skill));
    }

    @PutMapping
    public Result<GrowthSkill> update(@RequestBody GrowthSkill skill) {
        SysUser user = LoginUserHolder.getCurrentUser();
        skill.setUserId(user.getId());
        return Result.success("更新成功", skillService.update(skill));
    }

    @DeleteMapping("/{id}")
    public Result<?> delete(@PathVariable Long id) {
        skillService.deleteById(id);
        return Result.success("删除成功");
    }

    @PutMapping("/{id}/level")
    public Result<GrowthSkill> updateLevel(@PathVariable Long id, @RequestParam Integer masterLevel) {
        SysUser user = LoginUserHolder.getCurrentUser();
        GrowthSkill skill = skillService.findById(id);
        skill.setMasterLevel(masterLevel);
        skill.setUserId(user.getId());
        return Result.success("等级更新成功", skillService.update(skill));
    }

    @GetMapping("/stat/type")
    public Result<List<Map<String, Object>>> statByType() {
        SysUser user = LoginUserHolder.getCurrentUser();
        return Result.success(skillService.countBySkillType(user.getId()));
    }

    @GetMapping("/stat/level")
    public Result<List<Map<String, Object>>> statByLevel() {
        SysUser user = LoginUserHolder.getCurrentUser();
        return Result.success(skillService.countByMasterLevel(user.getId()));
    }
}
