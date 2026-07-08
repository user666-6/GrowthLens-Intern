package com.example.growthlens.mapper;

import com.example.growthlens.entity.InterviewQuestion;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface InterviewQuestionMapper {

    int insert(InterviewQuestion question);

    int update(InterviewQuestion question);

    int deleteById(@Param("id") Long id);

    int deleteByCategoryId(@Param("categoryId") Long categoryId);

    InterviewQuestion findById(@Param("id") Long id);

    List<InterviewQuestion> findByUserId(@Param("userId") Long userId);

    List<InterviewQuestion> findByCategoryId(@Param("userId") Long userId, @Param("categoryId") Long categoryId);

    List<InterviewQuestion> findByMasterLevel(@Param("userId") Long userId, @Param("masterLevel") Integer masterLevel);

    List<InterviewQuestion> findWrongQuestions(@Param("userId") Long userId);

    List<InterviewQuestion> findCollectedQuestions(@Param("userId") Long userId);

    List<InterviewQuestion> findRandomQuestions(@Param("userId") Long userId, @Param("limit") Integer limit);

    List<InterviewQuestion> search(@Param("userId") Long userId, 
                                   @Param("categoryId") Long categoryId,
                                   @Param("keyword") String keyword,
                                   @Param("isWrong") Integer isWrong,
                                   @Param("isCollected") Integer isCollected);

    int countByUserId(@Param("userId") Long userId);

    int countByCategoryId(@Param("userId") Long userId, @Param("categoryId") Long categoryId);
}