package com.example.growthlens.mapper;

import com.example.growthlens.entity.GrowthSkill;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.util.List;
import java.util.Map;

@Mapper
public interface GrowthSkillMapper {

    @Select("SELECT * FROM growth_skill WHERE id = #{id}")
    GrowthSkill findById(@Param("id") Long id);

    @Select("SELECT * FROM growth_skill WHERE user_id = #{userId} ORDER BY master_level DESC, create_time DESC")
    List<GrowthSkill> findByUserId(@Param("userId") Long userId);

    @Select("SELECT * FROM growth_skill WHERE user_id = #{userId} AND skill_type = #{skillType} ORDER BY master_level DESC")
    List<GrowthSkill> findByUserIdAndType(@Param("userId") Long userId, @Param("skillType") String skillType);

    List<Map<String, Object>> countBySkillType(@Param("userId") Long userId);

    List<Map<String, Object>> countByMasterLevel(@Param("userId") Long userId);

    int insert(GrowthSkill skill);

    int update(GrowthSkill skill);

    int deleteById(@Param("id") Long id);
}
