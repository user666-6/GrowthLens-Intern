package com.example.growthlens.mapper;

import com.example.growthlens.entity.WeeklyReport;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.time.LocalDate;
import java.util.List;

@Mapper
public interface WeeklyReportMapper {

    @Select("SELECT * FROM weekly_report WHERE id = #{id}")
    WeeklyReport findById(@Param("id") Long id);

    @Select("SELECT * FROM weekly_report WHERE user_id = #{userId} ORDER BY week_year DESC, week_num DESC")
    List<WeeklyReport> findByUserId(@Param("userId") Long userId);

    @Select("SELECT * FROM weekly_report WHERE user_id = #{userId} AND week_year = #{weekYear} AND week_num = #{weekNum}")
    WeeklyReport findByUserAndWeek(@Param("userId") Long userId, @Param("weekYear") Integer weekYear, @Param("weekNum") Integer weekNum);

    @Select("SELECT * FROM weekly_report WHERE user_id = #{userId} AND start_date >= #{startDate} AND end_date <= #{endDate}")
    List<WeeklyReport> findByDateRange(@Param("userId") Long userId, @Param("startDate") LocalDate startDate, @Param("endDate") LocalDate endDate);

    List<WeeklyReport> searchByKeyword(@Param("userId") Long userId, @Param("keyword") String keyword);

    int insert(WeeklyReport report);

    int update(WeeklyReport report);

    int deleteById(@Param("id") Long id);
}