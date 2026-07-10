package com.example.growthlens.mapper;

import com.example.growthlens.entity.GrowthProject;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.util.List;
import java.util.Map;

@Mapper
public interface GrowthProjectMapper {

    @Select("SELECT * FROM growth_project WHERE id = #{id}")
    GrowthProject findById(@Param("id") Long id);

    @Select("SELECT * FROM growth_project WHERE user_id = #{userId} ORDER BY start_date DESC")
    List<GrowthProject> findByUserId(@Param("userId") Long userId);

    List<Map<String, Object>> countByMonth(@Param("userId") Long userId);

    int insert(GrowthProject project);

    int update(GrowthProject project);

    int deleteById(@Param("id") Long id);
}
