package com.example.growthlens.service.impl;

import com.example.growthlens.common.BusinessException;
import com.example.growthlens.entity.DailyReport;
import com.example.growthlens.mapper.DailyReportMapper;
import com.example.growthlens.service.DailyReportService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;

@Service
public class DailyReportServiceImpl implements DailyReportService {

    @Autowired
    private DailyReportMapper dailyReportMapper;

    private static final DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd");

    @Override
    public DailyReport findById(Long id) {
        return dailyReportMapper.findById(id);
    }

    @Override
    public List<DailyReport> findByUserId(Long userId) {
        return dailyReportMapper.findByUserId(userId);
    }

    @Override
    public DailyReport findByUserAndDate(Long userId, LocalDate reportDate) {
        return dailyReportMapper.findByUserAndDate(userId, reportDate);
    }

    @Override
    public List<DailyReport> findByDateRange(Long userId, LocalDate startDate, LocalDate endDate) {
        return dailyReportMapper.findByDateRange(userId, startDate, endDate);
    }

    @Override
    public List<DailyReport> searchByKeyword(Long userId, String keyword) {
        return dailyReportMapper.searchByKeyword(userId, keyword);
    }

    @Override
    public DailyReport save(DailyReport report) {
        if (report.getId() == null) {
            DailyReport existing = dailyReportMapper.findByUserAndDate(report.getUserId(), report.getReportDate());
            if (existing != null) {
                throw new BusinessException("该日期已有日报");
            }
            if (report.getStatus() == null) {
                report.setStatus(0);
            }
            dailyReportMapper.insert(report);
        } else {
            dailyReportMapper.update(report);
        }
        return report;
    }

    @Override
    public void update(DailyReport report) {
        dailyReportMapper.update(report);
    }

    @Override
    public void deleteById(Long id) {
        DailyReport report = dailyReportMapper.findById(id);
        if (report == null) {
            throw new BusinessException("日报不存在");
        }
        dailyReportMapper.deleteById(id);
    }

    @Override
    public void submit(Long id) {
        DailyReport report = dailyReportMapper.findById(id);
        if (report == null) {
            throw new BusinessException("日报不存在");
        }
        report.setStatus(1);
        dailyReportMapper.update(report);
    }

    @Override
    public void saveDraft(DailyReport report) {
        if (report.getId() == null) {
            report.setStatus(0);
            dailyReportMapper.insert(report);
        } else {
            report.setStatus(0);
            dailyReportMapper.update(report);
        }
    }

    @Override
    public String exportToText(Long id) {
        DailyReport report = dailyReportMapper.findById(id);
        if (report == null) {
            throw new BusinessException("日报不存在");
        }
        StringBuilder sb = new StringBuilder();
        sb.append("日报\n");
        sb.append("日期：").append(report.getReportDate().format(DATE_FORMATTER)).append("\n\n");
        sb.append("今日完成：\n");
        sb.append(report.getTodayFinish() != null ? report.getTodayFinish() : "").append("\n\n");
        sb.append("遇到问题：\n");
        sb.append(report.getEncounterProblem() != null ? report.getEncounterProblem() : "").append("\n\n");
        sb.append("明日计划：\n");
        sb.append(report.getTomorrowPlan() != null ? report.getTomorrowPlan() : "").append("\n");
        return sb.toString();
    }
}