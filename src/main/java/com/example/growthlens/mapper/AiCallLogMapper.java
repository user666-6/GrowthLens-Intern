package com.example.growthlens.mapper;

import com.example.growthlens.entity.AiCallLog;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.util.List;

/**
 * AI调用日志数据访问层
 * 只负责数据库CRUD操作，不包含业务逻辑
 */
@Mapper
public interface AiCallLogMapper {

    /**
     * 根据日志ID查询
     */
    @Select("SELECT * FROM ai_call_log WHERE id = #{id}")
    AiCallLog findById(@Param("id") Long id);

    /**
     * 根据用户ID查询调用日志
     */
    @Select("SELECT * FROM ai_call_log WHERE user_id = #{userId} ORDER BY create_time DESC")
    List<AiCallLog> findByUserId(@Param("userId") Long userId);

    /**
     * 查询所有日志
     */
    @Select("SELECT * FROM ai_call_log ORDER BY create_time DESC")
    List<AiCallLog> findAll();

    /**
     * 插入调用日志
     */
    int insert(AiCallLog callLog);

    /**
     * 更新日志（用于记录失败信息）
     */
    int update(AiCallLog callLog);
}