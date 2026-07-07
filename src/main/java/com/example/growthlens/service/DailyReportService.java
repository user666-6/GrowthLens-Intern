package com.example.growthlens.service;

import com.example.growthlens.entity.DailyReport;

import java.time.LocalDate;
import java.util.List;

public interface DailyReportService {

    DailyReport findById(Long id);

    List<DailyReport> findByUserId(Long userId);

    DailyReport findByUserAndDate(Long userId, LocalDate reportDate);

    List<DailyReport> findByDateRange(Long userId, LocalDate startDate, LocalDate endDate);

    List<DailyReport> searchByKeyword(Long userId, String keyword);

    DailyReport save(DailyReport report);

    void update(DailyReport report);

    void deleteById(Long id);

    void submit(Long id);

    void saveDraft(DailyReport report);

    String exportToText(Long id);
}