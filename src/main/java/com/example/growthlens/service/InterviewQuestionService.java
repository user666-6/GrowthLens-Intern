package com.example.growthlens.service;

import com.example.growthlens.entity.InterviewQuestion;

import java.util.List;

public interface InterviewQuestionService {

    InterviewQuestion addQuestion(InterviewQuestion question);

    void updateQuestion(InterviewQuestion question);

    void deleteQuestion(Long id);

    void deleteByCategoryId(Long categoryId);

    InterviewQuestion findById(Long id);

    List<InterviewQuestion> findByUserId(Long userId);

    List<InterviewQuestion> findByCategoryId(Long userId, Long categoryId);

    List<InterviewQuestion> findByMasterLevel(Long userId, Integer masterLevel);

    List<InterviewQuestion> findWrongQuestions(Long userId);

    List<InterviewQuestion> findCollectedQuestions(Long userId);

    List<InterviewQuestion> findRandomQuestions(Long userId, Integer limit);

    List<InterviewQuestion> search(Long userId, Long categoryId, String keyword, Integer isWrong, Integer isCollected);

    int countByUserId(Long userId);

    int countByCategoryId(Long userId, Long categoryId);

    String generateAnswer(Long userId, String username, String question);
}