package com.example.growthlens.service;

import com.example.growthlens.entity.WeeklyReport;

import java.time.LocalDate;
import java.util.List;

public interface WeeklyReportService {

    WeeklyReport findById(Long id);

    List<WeeklyReport> findByUserId(Long userId);

    WeeklyReport findByUserAndWeek(Long userId, Integer weekYear, Integer weekNum);

    List<WeeklyReport> findByDateRange(Long userId, LocalDate startDate, LocalDate endDate);

    List<WeeklyReport> searchByKeyword(Long userId, String keyword);

    WeeklyReport save(WeeklyReport report);

    void update(WeeklyReport report);

    void deleteById(Long id);

    void submit(Long id);

    void saveDraft(WeeklyReport report);

    WeeklyReport generateFromDaily(Long userId, Integer weekYear, Integer weekNum);

    String exportToText(Long id);
}