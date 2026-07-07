package com.example.growthlens.mapper;

import com.example.growthlens.entity.ChatRecord;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface ChatRecordMapper {

    ChatRecord findById(@Param("id") Long id);

    List<ChatRecord> findByUserId(@Param("userId") Long userId);

    List<ChatRecord> findByUserIdAndSceneType(@Param("userId") Long userId, @Param("sceneType") String sceneType);

    List<ChatRecord> findCollectedByUserId(@Param("userId") Long userId);

    int insert(ChatRecord chatRecord);

    int updateCollection(@Param("id") Long id, @Param("isCollected") Integer isCollected);

    int deleteById(@Param("id") Long id);

    int deleteBySessionId(@Param("sessionId") String sessionId);

    List<ChatRecord> findBySessionId(@Param("sessionId") String sessionId);
}
