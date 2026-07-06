package com.example.growthlens.mapper;

import com.example.growthlens.entity.AiSystemConfig;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import java.util.List;

@Mapper
public interface AiSystemConfigMapper {

    @Select("SELECT * FROM ai_system_config WHERE id = #{id}")
    AiSystemConfig findById(@Param("id") Long id);

    @Select("SELECT * FROM ai_system_config WHERE config_key = #{configKey}")
    AiSystemConfig findByKey(@Param("configKey") String configKey);

    @Select("SELECT * FROM ai_system_config WHERE status = 1")
    List<AiSystemConfig> findAllEnabled();

    @Select("SELECT * FROM ai_system_config")
    List<AiSystemConfig> findAll();

    int insert(AiSystemConfig config);

    @Update("UPDATE ai_system_config SET config_value = #{configValue}, update_time = NOW() WHERE id = #{id}")
    int updateValue(@Param("id") Long id, @Param("configValue") String configValue);

    int update(AiSystemConfig config);

    int deleteById(@Param("id") Long id);
}