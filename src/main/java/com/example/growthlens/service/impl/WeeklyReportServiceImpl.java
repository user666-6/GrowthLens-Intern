package com.example.growthlens.service.impl;

import com.example.growthlens.common.BusinessException;
import com.example.growthlens.entity.DailyReport;
import com.example.growthlens.entity.WeeklyReport;
import com.example.growthlens.mapper.DailyReportMapper;
import com.example.growthlens.mapper.WeeklyReportMapper;
import com.example.growthlens.service.WeeklyReportService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.temporal.IsoFields;
import java.time.format.DateTimeFormatter;
import java.util.List;

@Service
public class WeeklyReportServiceImpl implements WeeklyReportService {

    @Autowired
    private WeeklyReportMapper weeklyReportMapper;

    @Autowired
    private DailyReportMapper dailyReportMapper;

    private static final DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd");

    @Override
    public WeeklyReport findById(Long id) {
        return weeklyReportMapper.findById(id);
    }

    @Override
    public List<WeeklyReport> findByUserId(Long userId) {
        return weeklyReportMapper.findByUserId(userId);
    }

    @Override
    public WeeklyReport findByUserAndWeek(Long userId, Integer weekYear, Integer weekNum) {
        return weeklyReportMapper.findByUserAndWeek(userId, weekYear, weekNum);
    }

    @Override
    public List<WeeklyReport> findByDateRange(Long userId, LocalDate startDate, LocalDate endDate) {
        return weeklyReportMapper.findByDateRange(userId, startDate, endDate);
    }

    @Override
    public List<WeeklyReport> searchByKeyword(Long userId, String keyword) {
        return weeklyReportMapper.searchByKeyword(userId, keyword);
    }

    @Override
    public WeeklyReport save(WeeklyReport report) {
        if (report.getId() == null) {
            WeeklyReport existing = weeklyReportMapper.findByUserAndWeek(report.getUserId(), report.getWeekYear(), report.getWeekNum());
            if (existing != null) {
                throw new BusinessException("该周已有周报");
            }
            if (report.getStatus() == null) {
                report.setStatus(0);
            }
            weeklyReportMapper.insert(report);
        } else {
            weeklyReportMapper.update(report);
        }
        return report;
    }

    @Override
    public void update(WeeklyReport report) {
        weeklyReportMapper.update(report);
    }

    @Override
    public void deleteById(Long id) {
        WeeklyReport report = weeklyReportMapper.findById(id);
        if (report == null) {
            throw new BusinessException("周报不存在");
        }
        weeklyReportMapper.deleteById(id);
    }

    @Override
    public void submit(Long id) {
        WeeklyReport report = weeklyReportMapper.findById(id);
        if (report == null) {
            throw new BusinessException("周报不存在");
        }
        report.setStatus(1);
        weeklyReportMapper.update(report);
    }

    @Override
    public void saveDraft(WeeklyReport report) {
        if (report.getId() == null) {
            report.setStatus(0);
            weeklyReportMapper.insert(report);
        } else {
            report.setStatus(0);
            weeklyReportMapper.update(report);
        }
    }

    @Override
    public WeeklyReport generateFromDaily(Long userId, Integer weekYear, Integer weekNum) {
        LocalDate startDate = getWeekStartDate(weekYear, weekNum);
        LocalDate endDate = getWeekEndDate(weekYear, weekNum);

        List<DailyReport> dailyReports = dailyReportMapper.findByDateRange(userId, startDate, endDate);

        if (dailyReports.isEmpty()) {
            throw new BusinessException("该周没有日报数据，无法生成周报");
        }

        StringBuilder weekSummary = new StringBuilder();
        StringBuilder problemReview = new StringBuilder();
        StringBuilder nextWeekPlan = new StringBuilder();

        for (DailyReport daily : dailyReports) {
            weekSummary.append("【").append(daily.getReportDate().format(DATE_FORMATTER)).append("】\n");
            weekSummary.append(daily.getTodayFinish() != null ? daily.getTodayFinish() : "").append("\n\n");

            if (daily.getEncounterProblem() != null && !daily.getEncounterProblem().isEmpty()) {
                problemReview.append("【").append(daily.getReportDate().format(DATE_FORMATTER)).append("】\n");
                problemReview.append(daily.getEncounterProblem()).append("\n\n");
            }
        }

        WeeklyReport report = new WeeklyReport();
        report.setUserId(userId);
        report.setWeekYear(weekYear);
        report.setWeekNum(weekNum);
        report.setStartDate(startDate);
        report.setEndDate(endDate);
        report.setWeekSummary(weekSummary.toString());
        report.setProblemReview(problemReview.toString());
        report.setNextWeekPlan(nextWeekPlan.toString());
        report.setStatus(0);

        weeklyReportMapper.insert(report);
        return report;
    }

    @Override
    public String exportToText(Long id) {
        WeeklyReport report = weeklyReportMapper.findById(id);
        if (report == null) {
            throw new BusinessException("周报不存在");
        }
        StringBuilder sb = new StringBuilder();
        sb.append("周报\n");
        sb.append("年份：").append(report.getWeekYear()).append("年\n");
        sb.append("周次：第").append(report.getWeekNum()).append("周\n");
        sb.append("日期：").append(report.getStartDate().format(DATE_FORMATTER)).append(" ~ ").append(report.getEndDate().format(DATE_FORMATTER)).append("\n\n");
        sb.append("本周工作总结：\n");
        sb.append(report.getWeekSummary() != null ? report.getWeekSummary() : "").append("\n");
        sb.append("问题与复盘：\n");
        sb.append(report.getProblemReview() != null ? report.getProblemReview() : "").append("\n");
        sb.append("下周工作计划：\n");
        sb.append(report.getNextWeekPlan() != null ? report.getNextWeekPlan() : "").append("\n");
        return sb.toString();
    }

    private LocalDate getWeekStartDate(int year, int week) {
        return LocalDate.of(year, 1, 4)
                .with(IsoFields.WEEK_OF_WEEK_BASED_YEAR, week)
                .with(DayOfWeek.MONDAY);
    }

    private LocalDate getWeekEndDate(int year, int week) {
        return getWeekStartDate(year, week).plusDays(6);
    }
}