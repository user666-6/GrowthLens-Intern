package com.example.growthlens.controller;

import com.example.growthlens.common.Result;
import com.example.growthlens.entity.DailyReport;
import com.example.growthlens.entity.SysUser;
import com.example.growthlens.entity.WeeklyReport;
import com.example.growthlens.service.AiService;
import com.example.growthlens.service.DailyReportService;
import com.example.growthlens.service.WeeklyReportService;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.temporal.IsoFields;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/dailyreport")
public class DailyReportController {

    @Autowired
    private DailyReportService dailyReportService;

    @Autowired
    private WeeklyReportService weeklyReportService;

    @Autowired
    private AiService aiService;

    private static final String SESSION_USER_KEY = "loginUser";

    private SysUser getCurrentUser(HttpSession session) {
        return (SysUser) session.getAttribute(SESSION_USER_KEY);
    }

    @GetMapping("/list")
    public String dailyList(
            @RequestParam(defaultValue = "1") Integer pageNum,
            @RequestParam(defaultValue = "10") Integer pageSize,
            @RequestParam(required = false) String startDate,
            @RequestParam(required = false) String endDate,
            @RequestParam(required = false) String keyword,
            Model model, HttpSession session) {

        SysUser user = getCurrentUser(session);
        if (user == null) {
            return "redirect:/login";
        }

        PageHelper.startPage(pageNum, pageSize);

        List<DailyReport> list;
        try {
            if (keyword != null && !keyword.trim().isEmpty()) {
                list = dailyReportService.searchByKeyword(user.getId(), keyword.trim());
            } else if (startDate != null && !startDate.isEmpty() && endDate != null && !endDate.isEmpty()) {
                LocalDate start = LocalDate.parse(startDate);
                LocalDate end = LocalDate.parse(endDate);
                list = dailyReportService.findByDateRange(user.getId(), start, end);
            } else {
                list = dailyReportService.findByUserId(user.getId());
            }
        } catch (Exception e) {
            list = dailyReportService.findByUserId(user.getId());
        }

        PageInfo<DailyReport> pageInfo = new PageInfo<>(list);
        model.addAttribute("pageInfo", pageInfo);
        model.addAttribute("startDate", startDate);
        model.addAttribute("endDate", endDate);
        model.addAttribute("keyword", keyword);

        return "dailyreport/list";
    }

    @GetMapping("/add")
    public String dailyAdd(Model model) {
        model.addAttribute("reportDate", LocalDate.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd")));
        return "dailyreport/add";
    }

    @PostMapping("/save")
    @ResponseBody
    public Result<DailyReport> dailySave(
            @RequestParam String reportDate,
            @RequestParam(required = false) String todayFinish,
            @RequestParam(required = false) String encounterProblem,
            @RequestParam(required = false) String tomorrowPlan,
            @RequestParam(defaultValue = "0") Integer status,
            HttpSession session) {

        SysUser user = getCurrentUser(session);
        DailyReport report = new DailyReport();
        report.setUserId(user.getId());
        report.setReportDate(LocalDate.parse(reportDate));
        report.setTodayFinish(todayFinish);
        report.setEncounterProblem(encounterProblem);
        report.setTomorrowPlan(tomorrowPlan);
        report.setStatus(status);

        dailyReportService.save(report);
        String msg = status == 1 ? "提交成功" : "保存草稿成功";
        return Result.success(msg, report);
    }

    @PostMapping("/draft")
    @ResponseBody
    public Result<DailyReport> dailyDraft(
            @RequestParam String reportDate,
            @RequestParam(required = false) String todayFinish,
            @RequestParam(required = false) String encounterProblem,
            @RequestParam(required = false) String tomorrowPlan,
            HttpSession session) {

        SysUser user = getCurrentUser(session);
        DailyReport report = new DailyReport();
        report.setUserId(user.getId());
        report.setReportDate(LocalDate.parse(reportDate));
        report.setTodayFinish(todayFinish);
        report.setEncounterProblem(encounterProblem);
        report.setTomorrowPlan(tomorrowPlan);
        report.setStatus(0);

        dailyReportService.saveDraft(report);
        return Result.success("保存草稿成功", report);
    }

    @PostMapping("/submit/{id}")
    @ResponseBody
    public Result<?> dailySubmit(@PathVariable Long id) {
        dailyReportService.submit(id);
        return Result.success("提交成功");
    }

    @GetMapping("/edit/{id}")
    public String dailyEdit(@PathVariable Long id, Model model) {
        DailyReport report = dailyReportService.findById(id);
        model.addAttribute("report", report);
        return "dailyreport/edit";
    }

    @PostMapping("/update")
    @ResponseBody
    public Result<DailyReport> dailyUpdate(
            @RequestParam Long id,
            @RequestParam String reportDate,
            @RequestParam(required = false) String todayFinish,
            @RequestParam(required = false) String encounterProblem,
            @RequestParam(required = false) String tomorrowPlan,
            @RequestParam(defaultValue = "0") Integer status) {

        DailyReport report = dailyReportService.findById(id);
        report.setReportDate(LocalDate.parse(reportDate));
        report.setTodayFinish(todayFinish);
        report.setEncounterProblem(encounterProblem);
        report.setTomorrowPlan(tomorrowPlan);
        report.setStatus(status);

        dailyReportService.update(report);
        String msg = status == 1 ? "提交成功" : "更新成功";
        return Result.success(msg, report);
    }

    @DeleteMapping("/delete/{id}")
    @ResponseBody
    public Result<?> dailyDelete(@PathVariable Long id) {
        dailyReportService.deleteById(id);
        return Result.success("删除成功");
    }

    @GetMapping("/export/{id}")
    public void dailyExport(@PathVariable Long id, HttpServletResponse response) throws IOException {
        String content = dailyReportService.exportToText(id);
        response.setContentType("text/plain;charset=UTF-8");
        response.setHeader("Content-Disposition", "attachment;filename=daily_report_" + id + ".txt");
        try (PrintWriter writer = response.getWriter()) {
            writer.write(content);
        }
    }

    @PostMapping("/polish")
    @ResponseBody
    public Result<String> dailyPolish(
            @RequestParam String content,
            HttpSession session) {

        SysUser user = getCurrentUser(session);
        String polished = aiService.polish(user.getId(), user.getUsername(), content);
        return Result.success("润色成功", polished);
    }

    @GetMapping("/weekly/list")
    public String weeklyList(
            @RequestParam(defaultValue = "1") Integer pageNum,
            @RequestParam(defaultValue = "10") Integer pageSize,
            @RequestParam(required = false) String startDate,
            @RequestParam(required = false) String endDate,
            @RequestParam(required = false) String keyword,
            Model model, HttpSession session) {

        SysUser user = getCurrentUser(session);
        if (user == null) {
            return "redirect:/login";
        }

        PageHelper.startPage(pageNum, pageSize);

        List<WeeklyReport> list;
        try {
            if (keyword != null && !keyword.trim().isEmpty()) {
                list = weeklyReportService.searchByKeyword(user.getId(), keyword.trim());
            } else if (startDate != null && !startDate.isEmpty() && endDate != null && !endDate.isEmpty()) {
                LocalDate start = LocalDate.parse(startDate);
                LocalDate end = LocalDate.parse(endDate);
                list = weeklyReportService.findByDateRange(user.getId(), start, end);
            } else {
                list = weeklyReportService.findByUserId(user.getId());
            }
        } catch (Exception e) {
            list = weeklyReportService.findByUserId(user.getId());
        }

        PageInfo<WeeklyReport> pageInfo = new PageInfo<>(list);
        model.addAttribute("pageInfo", pageInfo);
        model.addAttribute("startDate", startDate);
        model.addAttribute("endDate", endDate);
        model.addAttribute("keyword", keyword);

        return "dailyreport/weekly_list";
    }

    @GetMapping("/weekly/add")
    public String weeklyAdd(Model model) {
        LocalDate today = LocalDate.now();
        int year = today.getYear();
        int week = today.get(IsoFields.WEEK_OF_WEEK_BASED_YEAR);
        model.addAttribute("weekYear", year);
        model.addAttribute("weekNum", week);
        return "dailyreport/weekly_add";
    }

    @PostMapping("/weekly/save")
    @ResponseBody
    public Result<WeeklyReport> weeklySave(
            @RequestParam Integer weekYear,
            @RequestParam Integer weekNum,
            @RequestParam(required = false) String weekSummary,
            @RequestParam(required = false) String problemReview,
            @RequestParam(required = false) String nextWeekPlan,
            @RequestParam(defaultValue = "0") Integer status,
            HttpSession session) {

        SysUser user = getCurrentUser(session);
        WeeklyReport report = new WeeklyReport();
        report.setUserId(user.getId());
        report.setWeekYear(weekYear);
        report.setWeekNum(weekNum);
        report.setWeekSummary(weekSummary);
        report.setProblemReview(problemReview);
        report.setNextWeekPlan(nextWeekPlan);
        report.setStatus(status);

        LocalDate startDate = getWeekStartDate(weekYear, weekNum);
        LocalDate endDate = getWeekEndDate(weekYear, weekNum);
        report.setStartDate(startDate);
        report.setEndDate(endDate);

        weeklyReportService.save(report);
        String msg = status == 1 ? "提交成功" : "保存草稿成功";
        return Result.success(msg, report);
    }

    @PostMapping("/weekly/generate")
    @ResponseBody
    public Result<WeeklyReport> weeklyGenerate(
            @RequestParam Integer weekYear,
            @RequestParam Integer weekNum,
            HttpSession session) {

        SysUser user = getCurrentUser(session);
        WeeklyReport report = weeklyReportService.generateFromDaily(user.getId(), weekYear, weekNum);
        return Result.success("生成成功", report);
    }

    @PostMapping("/weekly/submit/{id}")
    @ResponseBody
    public Result<?> weeklySubmit(@PathVariable Long id) {
        weeklyReportService.submit(id);
        return Result.success("提交成功");
    }

    @GetMapping("/weekly/edit/{id}")
    public String weeklyEdit(@PathVariable Long id, Model model) {
        WeeklyReport report = weeklyReportService.findById(id);
        model.addAttribute("report", report);
        return "dailyreport/weekly_edit";
    }

    @PostMapping("/weekly/update")
    @ResponseBody
    public Result<WeeklyReport> weeklyUpdate(
            @RequestParam Long id,
            @RequestParam Integer weekYear,
            @RequestParam Integer weekNum,
            @RequestParam(required = false) String weekSummary,
            @RequestParam(required = false) String problemReview,
            @RequestParam(required = false) String nextWeekPlan,
            @RequestParam(defaultValue = "0") Integer status) {

        WeeklyReport report = weeklyReportService.findById(id);
        report.setWeekYear(weekYear);
        report.setWeekNum(weekNum);
        report.setWeekSummary(weekSummary);
        report.setProblemReview(problemReview);
        report.setNextWeekPlan(nextWeekPlan);
        report.setStatus(status);

        LocalDate startDate = getWeekStartDate(weekYear, weekNum);
        LocalDate endDate = getWeekEndDate(weekYear, weekNum);
        report.setStartDate(startDate);
        report.setEndDate(endDate);

        weeklyReportService.update(report);
        String msg = status == 1 ? "提交成功" : "更新成功";
        return Result.success(msg, report);
    }

    @DeleteMapping("/weekly/delete/{id}")
    @ResponseBody
    public Result<?> weeklyDelete(@PathVariable Long id) {
        weeklyReportService.deleteById(id);
        return Result.success("删除成功");
    }

    @GetMapping("/weekly/export/{id}")
    public void weeklyExport(@PathVariable Long id, HttpServletResponse response) throws IOException {
        String content = weeklyReportService.exportToText(id);
        response.setContentType("text/plain;charset=UTF-8");
        response.setHeader("Content-Disposition", "attachment;filename=weekly_report_" + id + ".txt");
        try (PrintWriter writer = response.getWriter()) {
            writer.write(content);
        }
    }

    @PostMapping("/weekly/polish")
    @ResponseBody
    public Result<String> weeklyPolish(
            @RequestParam String content,
            HttpSession session) {

        SysUser user = getCurrentUser(session);
        String polished = aiService.polish(user.getId(), user.getUsername(), content);
        return Result.success("润色成功", polished);
    }

    private LocalDate getWeekStartDate(int year, int week) {
        return LocalDate.of(year, 1, 4)
                .with(IsoFields.WEEK_OF_WEEK_BASED_YEAR, week)
                .with(java.time.DayOfWeek.MONDAY);
    }

    private LocalDate getWeekEndDate(int year, int week) {
        return getWeekStartDate(year, week).plusDays(6);
    }
}