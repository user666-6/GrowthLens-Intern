package com.example.growthlens.controller;

import com.example.growthlens.common.Result;
import com.example.growthlens.entity.ReviewRecord;
import com.example.growthlens.service.ReviewRecordService;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;

/**
 * 复盘分析控制器
 */
@Controller
@RequestMapping("/review")
public class ReviewController {

    @Autowired
    private ReviewRecordService reviewRecordService;

    /**
     * 跳转复盘列表页面
     */
    @GetMapping("/list")
    public String reviewList(Model model) {
        model.addAttribute("currentMenu", "review");
        return "review/list";
    }

    /**
     * 生成复盘
     */
    @PostMapping("/generate")
    @ResponseBody
    public Result<ReviewRecord> generateReview(
            @RequestParam String reviewType,
            @RequestParam String startDate,
            @RequestParam String endDate) {

        LocalDate start = LocalDate.parse(startDate);
        LocalDate end = LocalDate.parse(endDate);

        ReviewRecord record = reviewRecordService.generateReview(reviewType, start, end);
        return Result.success("复盘生成成功", record);
    }

    /**
     * 分页查询复盘记录
     */
    @GetMapping("/page")
    @ResponseBody
    public Result<PageInfo<ReviewRecord>> getReviewPage(
            @RequestParam(defaultValue = "1") Integer pageNum,
            @RequestParam(defaultValue = "10") Integer pageSize,
            @RequestParam(required = false) String reviewType,
            @RequestParam(required = false) String startDate,
            @RequestParam(required = false) String endDate) {

        LocalDate start = null;
        LocalDate end = null;
        if (startDate != null && !startDate.isEmpty()) {
            start = LocalDate.parse(startDate);
        }
        if (endDate != null && !endDate.isEmpty()) {
            end = LocalDate.parse(endDate);
        }

        PageInfo<ReviewRecord> pageInfo = reviewRecordService.getMyReviewPage(pageNum, pageSize, reviewType, start, end);
        return Result.success(pageInfo);
    }

    /**
     * 查询复盘详情
     */
    @GetMapping("/detail")
    @ResponseBody
    public Result<ReviewRecord> getReviewDetail(@RequestParam Long id) {
        ReviewRecord record = reviewRecordService.getDetailById(id);
        return Result.success(record);
    }

    /**
     * 删除复盘记录
     */
    @PostMapping("/delete")
    @ResponseBody
    public Result deleteReview(@RequestParam Long id) {
        reviewRecordService.deleteById(id);
        return Result.success("删除成功");
    }
}
