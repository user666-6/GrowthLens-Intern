package com.example.growthlens.service.impl;

import com.example.growthlens.common.BusinessException;
import com.example.growthlens.entity.InterviewQuestion;
import com.example.growthlens.mapper.InterviewQuestionMapper;
import com.example.growthlens.service.AiService;
import com.example.growthlens.service.InterviewQuestionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class InterviewQuestionServiceImpl implements InterviewQuestionService {

    @Autowired
    private InterviewQuestionMapper questionMapper;

    @Autowired
    private AiService aiService;

    @Override
    public InterviewQuestion addQuestion(InterviewQuestion question) {
        questionMapper.insert(question);
        return question;
    }

    @Override
    public void updateQuestion(InterviewQuestion question) {
        if (questionMapper.findById(question.getId()) == null) {
            throw new BusinessException("题目不存在");
        }
        questionMapper.update(question);
    }

    @Override
    public void deleteQuestion(Long id) {
        if (questionMapper.findById(id) == null) {
            throw new BusinessException("题目不存在");
        }
        questionMapper.deleteById(id);
    }

    @Override
    @Transactional
    public void deleteByCategoryId(Long categoryId) {
        questionMapper.deleteByCategoryId(categoryId);
    }

    @Override
    public InterviewQuestion findById(Long id) {
        return questionMapper.findById(id);
    }

    @Override
    public List<InterviewQuestion> findByUserId(Long userId) {
        return questionMapper.findByUserId(userId);
    }

    @Override
    public List<InterviewQuestion> findByCategoryId(Long userId, Long categoryId) {
        return questionMapper.findByCategoryId(userId, categoryId);
    }

    @Override
    public List<InterviewQuestion> findByMasterLevel(Long userId, Integer masterLevel) {
        return questionMapper.findByMasterLevel(userId, masterLevel);
    }

    @Override
    public List<InterviewQuestion> findWrongQuestions(Long userId) {
        return questionMapper.findWrongQuestions(userId);
    }

    @Override
    public List<InterviewQuestion> findCollectedQuestions(Long userId) {
        return questionMapper.findCollectedQuestions(userId);
    }

    @Override
    public List<InterviewQuestion> findRandomQuestions(Long userId, Integer limit) {
        return questionMapper.findRandomQuestions(userId, limit);
    }

    @Override
    public List<InterviewQuestion> search(Long userId, Long categoryId, String keyword, Integer isWrong, Integer isCollected) {
        return questionMapper.search(userId, categoryId, keyword, isWrong, isCollected);
    }

    @Override
    public int countByUserId(Long userId) {
        return questionMapper.countByUserId(userId);
    }

    @Override
    public int countByCategoryId(Long userId, Long categoryId) {
        return questionMapper.countByCategoryId(userId, categoryId);
    }

    @Override
    public String generateAnswer(Long userId, String username, String question) {
        return aiService.generateAnswer(userId, username, question);
    }
}