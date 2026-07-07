package com.example.growthlens.mapper;

import com.example.growthlens.entity.DailyReport;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.time.LocalDate;
import java.util.List;

@Mapper
public interface DailyReportMapper {

    @Select("SELECT * FROM daily_report WHERE id = #{id}")
    DailyReport findById(@Param("id") Long id);

    @Select("SELECT * FROM daily_report WHERE user_id = #{userId} ORDER BY report_date DESC")
    List<DailyReport> findByUserId(@Param("userId") Long userId);

    @Select("SELECT * FROM daily_report WHERE user_id = #{userId} AND report_date = #{reportDate}")
    DailyReport findByUserAndDate(@Param("userId") Long userId, @Param("reportDate") LocalDate reportDate);

    @Select("SELECT * FROM daily_report WHERE user_id = #{userId} AND report_date BETWEEN #{startDate} AND #{endDate} ORDER BY report_date DESC")
    List<DailyReport> findByDateRange(@Param("userId") Long userId, @Param("startDate") LocalDate startDate, @Param("endDate") LocalDate endDate);

    List<DailyReport> searchByKeyword(@Param("userId") Long userId, @Param("keyword") String keyword);

    List<DailyReport> findByUserAndStatus(@Param("userId") Long userId, @Param("status") Integer status);

    int insert(DailyReport report);

    int update(DailyReport report);

    int deleteById(@Param("id") Long id);
}