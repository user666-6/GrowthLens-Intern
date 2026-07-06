package com.example.growthlens.controller;

import com.example.growthlens.common.Result;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.ui.Model;

import java.util.ArrayList;
import java.util.List;

/**
 * 日报周报管理控制器
 * 处理日报周报相关的页面跳转和数据操作
 */
@Controller
@RequestMapping("/dailyreport")
public class DailyReportController {

    /**
     * 跳转到日报列表页
     * @param pageNum 页码，默认1
     * @param pageSize 每页条数，默认10
     * @param model 数据模型
     * @return 列表页视图
     */
    @GetMapping("/list")
    public String list(
            @RequestParam(defaultValue = "1") Integer pageNum,
            @RequestParam(defaultValue = "10") Integer pageSize,
            Model model) {
        
        PageHelper.startPage(pageNum, pageSize);
        
        List<DailyReport> list = new ArrayList<>();
        
        PageInfo<DailyReport> pageInfo = new PageInfo<>(list);
        model.addAttribute("pageInfo", pageInfo);
        
        return "dailyreport/list";
    }

    /**
     * 跳转到新增日报页面
     * @return 新增页视图
     */
    @GetMapping("/add")
    public String add() {
        return "dailyreport/add";
    }

    /**
     * 新增日报提交
     * @param title 标题
     * @param type 类型（DAILY-日报，WEEKLY-周报）
     * @param reportDate 报告日期
     * @param content 内容
     * @return 统一返回结果
     */
    @PostMapping("/add")
    @ResponseBody
    public Result<Object> addSubmit(
            @RequestParam String title,
            @RequestParam String type,
            @RequestParam String reportDate,
            @RequestParam(required = false) String content) {
        
        return Result.success();
    }

    /**
     * 删除日报
     * @param id 日报ID
     * @return 统一返回结果
     */
    @DeleteMapping("/delete/{id}")
    @ResponseBody
    public Result<Object> delete(@PathVariable Long id) {
        
        return Result.success();
    }

    /**
     * 跳转到编辑页面
     * @param id 日报ID
     * @param model 数据模型
     * @return 编辑页视图
     */
    @GetMapping("/edit/{id}")
    public String edit(@PathVariable Long id, Model model) {
        return "dailyreport/edit";
    }

    /**
     * 日报周报实体类（示例）
     */
    public static class DailyReport {
        private Long id;
        private String title;
        private String type;
        private String reportDate;
        private Integer status;
        private String createTime;

        public Long getId() {
            return id;
        }

        public void setId(Long id) {
            this.id = id;
        }

        public String getTitle() {
            return title;
        }

        public void setTitle(String title) {
            this.title = title;
        }

        public String getType() {
            return type;
        }

        public void setType(String type) {
            this.type = type;
        }

        public String getReportDate() {
            return reportDate;
        }

        public void setReportDate(String reportDate) {
            this.reportDate = reportDate;
        }

        public Integer getStatus() {
            return status;
        }

        public void setStatus(Integer status) {
            this.status = status;
        }

        public String getCreateTime() {
            return createTime;
        }

        public void setCreateTime(String createTime) {
            this.createTime = createTime;
        }
    }
}