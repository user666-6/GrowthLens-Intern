package com.example.growthlens.controller;

import com.example.growthlens.common.LoginUserHolder;
import com.example.growthlens.common.Result;
import com.example.growthlens.entity.InterviewCategory;
import com.example.growthlens.entity.InterviewQuestion;
import com.example.growthlens.entity.SysUser;
import com.example.growthlens.service.InterviewCategoryService;
import com.example.growthlens.service.InterviewQuestionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequestMapping("/interview")
public class InterviewController {

    @Autowired
    private InterviewQuestionService questionService;

    @Autowired
    private InterviewCategoryService categoryService;

    @GetMapping("/list")
    public String list(
            @RequestParam(defaultValue = "") String keyword,
            @RequestParam(required = false) Long categoryId,
            @RequestParam(required = false) Integer isWrong,
            @RequestParam(required = false) Integer isCollected,
            Model model) {
        SysUser user = LoginUserHolder.getCurrentUser();
        List<InterviewQuestion> questions = questionService.search(
                user.getId(), categoryId, keyword, isWrong, isCollected);
        List<InterviewCategory> categories = categoryService.findByUserId(user.getId());

        model.addAttribute("questions", questions);
        model.addAttribute("categories", categories);
        model.addAttribute("keyword", keyword);
        model.addAttribute("categoryId", categoryId);
        model.addAttribute("isWrong", isWrong);
        model.addAttribute("isCollected", isCollected);
        return "interview/list";
    }

    @GetMapping("/add")
    public String add(Model model) {
        SysUser user = LoginUserHolder.getCurrentUser();
        List<InterviewCategory> categories = categoryService.findByUserId(user.getId());
        model.addAttribute("categories", categories);
        return "interview/add";
    }

    @PostMapping("/add")
    @ResponseBody
    public Result<InterviewQuestion> addSubmit(
            @RequestParam(required = false) Long categoryId,
            @RequestParam String questionTitle,
            @RequestParam(required = false) String questionContent,
            @RequestParam(defaultValue = "2") Integer difficultyLevel,
            @RequestParam(defaultValue = "1") Integer masterLevel,
            @RequestParam(required = false) String sourceCompany,
            @RequestParam(required = false) String sourcePost) {
        SysUser user = LoginUserHolder.getCurrentUser();
        InterviewQuestion question = new InterviewQuestion();
        question.setUserId(user.getId());
        question.setCategoryId(categoryId);
        question.setQuestionTitle(questionTitle);
        question.setQuestionContent(questionContent);
        question.setDifficultyLevel(difficultyLevel);
        question.setMasterLevel(masterLevel);
        question.setSourceCompany(sourceCompany);
        question.setSourcePost(sourcePost);
        question.setIsCollected(0);
        question.setIsWrong(0);
        questionService.addQuestion(question);
        return Result.success("添加成功", question);
    }

    @GetMapping("/edit/{id}")
    public String edit(@PathVariable Long id, Model model) {
        SysUser user = LoginUserHolder.getCurrentUser();
        InterviewQuestion question = questionService.findById(id);
        if (question == null || !question.getUserId().equals(user.getId())) {
            return "redirect:/interview/list";
        }
        List<InterviewCategory> categories = categoryService.findByUserId(user.getId());
        model.addAttribute("question", question);
        model.addAttribute("categories", categories);
        return "interview/edit";
    }

    @PostMapping("/edit")
    @ResponseBody
    public Result<InterviewQuestion> editSubmit(
            @RequestParam Long id,
            @RequestParam(required = false) Long categoryId,
            @RequestParam String questionTitle,
            @RequestParam(required = false) String questionContent,
            @RequestParam(defaultValue = "2") Integer difficultyLevel,
            @RequestParam(defaultValue = "1") Integer masterLevel,
            @RequestParam(required = false) String sourceCompany,
            @RequestParam(required = false) String sourcePost,
            @RequestParam(required = false) String myAnswer,
            @RequestParam(required = false) String reviewSummary) {
        SysUser user = LoginUserHolder.getCurrentUser();
        InterviewQuestion question = questionService.findById(id);
        if (question == null || !question.getUserId().equals(user.getId())) {
            return Result.error("题目不存在");
        }
        question.setCategoryId(categoryId);
        question.setQuestionTitle(questionTitle);
        question.setQuestionContent(questionContent);
        question.setDifficultyLevel(difficultyLevel);
        question.setMasterLevel(masterLevel);
        question.setSourceCompany(sourceCompany);
        question.setSourcePost(sourcePost);
        question.setMyAnswer(myAnswer);
        question.setReviewSummary(reviewSummary);
        questionService.updateQuestion(question);
        return Result.success("更新成功", question);
    }

    @DeleteMapping("/delete/{id}")
    @ResponseBody
    public Result<?> delete(@PathVariable Long id) {
        SysUser user = LoginUserHolder.getCurrentUser();
        InterviewQuestion question = questionService.findById(id);
        if (question != null && !question.getUserId().equals(user.getId())) {
            return Result.error("无权删除");
        }
        questionService.deleteQuestion(id);
        return Result.success("删除成功");
    }

    @PostMapping("/collect/{id}")
    @ResponseBody
    public Result<?> collect(@PathVariable Long id) {
        SysUser user = LoginUserHolder.getCurrentUser();
        InterviewQuestion question = questionService.findById(id);
        if (question == null || !question.getUserId().equals(user.getId())) {
            return Result.error("题目不存在");
        }
        question.setIsCollected(question.getIsCollected() == 1 ? 0 : 1);
        questionService.updateQuestion(question);
        return Result.success(question.getIsCollected() == 1 ? "已收藏" : "已取消收藏");
    }

    @PostMapping("/markWrong/{id}")
    @ResponseBody
    public Result<?> markWrong(@PathVariable Long id) {
        SysUser user = LoginUserHolder.getCurrentUser();
        InterviewQuestion question = questionService.findById(id);
        if (question == null || !question.getUserId().equals(user.getId())) {
            return Result.error("题目不存在");
        }
        question.setIsWrong(question.getIsWrong() == 1 ? 0 : 1);
        questionService.updateQuestion(question);
        return Result.success(question.getIsWrong() == 1 ? "已标记为错题" : "已取消错题标记");
    }

    @PostMapping("/updateMasterLevel/{id}")
    @ResponseBody
    public Result<?> updateMasterLevel(@PathVariable Long id, @RequestParam Integer level) {
        SysUser user = LoginUserHolder.getCurrentUser();
        InterviewQuestion question = questionService.findById(id);
        if (question == null || !question.getUserId().equals(user.getId())) {
            return Result.error("题目不存在");
        }
        question.setMasterLevel(level);
        questionService.updateQuestion(question);
        return Result.success("掌握程度已更新");
    }

    @PostMapping("/generateAnswer/{id}")
    @ResponseBody
    public Result<String> generateAnswer(@PathVariable Long id) {
        SysUser user = LoginUserHolder.getCurrentUser();
        InterviewQuestion question = questionService.findById(id);
        if (question == null || !question.getUserId().equals(user.getId())) {
            return Result.error("题目不存在");
        }
        String fullQuestion = question.getQuestionTitle();
        if (question.getQuestionContent() != null && !question.getQuestionContent().isEmpty()) {
            fullQuestion += "\n" + question.getQuestionContent();
        }
        String answer = questionService.generateAnswer(user.getId(), user.getUsername(), fullQuestion);
        question.setReferenceAnswer(answer);
        questionService.updateQuestion(question);
        return Result.success("参考答案已生成", answer);
    }

    @GetMapping("/category")
    public String categoryList(
            @RequestParam(defaultValue = "") String categoryType,
            Model model) {
        SysUser user = LoginUserHolder.getCurrentUser();
        List<InterviewCategory> categories = categoryService.findByUserId(user.getId());
        model.addAttribute("categories", categories);
        model.addAttribute("categoryType", categoryType);
        return "interview/category";
    }

    @PostMapping("/category/add")
    @ResponseBody
    public Result<InterviewCategory> addCategory(
            @RequestParam String categoryName,
            @RequestParam String categoryType,
            @RequestParam(required = false, defaultValue = "0") Long parentId,
            @RequestParam(required = false, defaultValue = "0") Integer sort,
            @RequestParam(required = false) String remark) {
        SysUser user = LoginUserHolder.getCurrentUser();
        InterviewCategory category = new InterviewCategory();
        category.setUserId(user.getId());
        category.setCategoryName(categoryName);
        category.setCategoryType(categoryType);
        category.setParentId(parentId);
        category.setSort(sort);
        category.setRemark(remark);
        categoryService.addCategory(category);
        return Result.success("分类添加成功", category);
    }

    @PostMapping("/category/edit")
    @ResponseBody
    public Result<InterviewCategory> editCategory(
            @RequestParam Long id,
            @RequestParam String categoryName,
            @RequestParam(required = false, defaultValue = "0") Integer sort,
            @RequestParam(required = false) String remark) {
        SysUser user = LoginUserHolder.getCurrentUser();
        InterviewCategory category = categoryService.findById(id);
        if (category == null || !category.getUserId().equals(user.getId())) {
            return Result.error("分类不存在");
        }
        category.setCategoryName(categoryName);
        category.setSort(sort);
        category.setRemark(remark);
        categoryService.updateCategory(category);
        return Result.success("分类更新成功", category);
    }

    @DeleteMapping("/category/delete/{id}")
    @ResponseBody
    public Result<?> deleteCategory(@PathVariable Long id) {
        SysUser user = LoginUserHolder.getCurrentUser();
        InterviewCategory category = categoryService.findById(id);
        if (category != null && !category.getUserId().equals(user.getId())) {
            return Result.error("无权删除");
        }
        questionService.deleteByCategoryId(id);
        categoryService.deleteCategory(id);
        return Result.success("分类删除成功");
    }

    @GetMapping("/practice")
    public String practice(
            @RequestParam(defaultValue = "random") String mode,
            @RequestParam(required = false) Long categoryId,
            Model model) {
        SysUser user = LoginUserHolder.getCurrentUser();
        List<InterviewQuestion> questions;

        switch (mode) {
            case "wrong":
                questions = questionService.findWrongQuestions(user.getId());
                break;
            case "collected":
                questions = questionService.findCollectedQuestions(user.getId());
                break;
            case "category":
                questions = questionService.findByCategoryId(user.getId(), categoryId);
                break;
            default:
                questions = questionService.findRandomQuestions(user.getId(), 10);
        }

        List<InterviewCategory> categories = categoryService.findByUserId(user.getId());

        model.addAttribute("questions", questions);
        model.addAttribute("categories", categories);
        model.addAttribute("mode", mode);
        model.addAttribute("categoryId", categoryId);
        return "interview/practice";
    }
}
