package com.example.growthlens.mapper;

import com.example.growthlens.entity.AiPromptTemplate;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.util.List;

/**
 * AI提示词模板数据访问层
 * 只负责数据库CRUD操作，不包含业务逻辑
 */
@Mapper
public interface AiPromptTemplateMapper {

    /**
     * 根据模板ID查询
     */
    @Select("SELECT * FROM ai_prompt_template WHERE id = #{id}")
    AiPromptTemplate findById(@Param("id") Long id);

    /**
     * 根据模板编码查询
     */
    @Select("SELECT * FROM ai_prompt_template WHERE template_code = #{templateCode}")
    AiPromptTemplate findByCode(@Param("templateCode") String templateCode);

    /**
     * 根据场景类型查询
     */
    @Select("SELECT * FROM ai_prompt_template WHERE scene_type = #{sceneType} AND status = 1")
    List<AiPromptTemplate> findBySceneType(@Param("sceneType") String sceneType);

    /**
     * 查询所有启用的模板
     */
    @Select("SELECT * FROM ai_prompt_template WHERE status = 1")
    List<AiPromptTemplate> findAllEnabled();

    /**
     * 查询所有模板
     */
    @Select("SELECT * FROM ai_prompt_template")
    List<AiPromptTemplate> findAll();

    /**
     * 插入模板
     */
    int insert(AiPromptTemplate template);

    /**
     * 更新模板
     */
    int update(AiPromptTemplate template);

    /**
     * 删除模板
     */
    int deleteById(@Param("id") Long id);
}