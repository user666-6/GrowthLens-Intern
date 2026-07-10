package com.example.growthlens.service;

import com.example.growthlens.entity.ReviewRecord;
import com.github.pagehelper.PageInfo;

import java.time.LocalDate;

/**
 * 复盘记录业务层接口
 */
public interface ReviewRecordService {

    /**
     * 生成复盘
     *
     * @param reviewType 复盘类型：daily-日度，weekly-周度
     * @param startDate  开始日期
     * @param endDate    结束日期
     * @return 复盘记录
     */
    ReviewRecord generateReview(String reviewType, LocalDate startDate, LocalDate endDate);

    /**
     * 分页查询复盘记录
     *
     * @param pageNum    页码
     * @param pageSize   每页数量
     * @param reviewType 复盘类型（可为空）
     * @param startDate  开始日期（可为空）
     * @param endDate    结束日期（可为空）
     * @return 分页结果
     */
    PageInfo<ReviewRecord> getMyReviewPage(int pageNum, int pageSize, String reviewType, LocalDate startDate, LocalDate endDate);

    /**
     * 根据ID查询复盘详情
     *
     * @param id 复盘ID
     * @return 复盘记录
     */
    ReviewRecord getDetailById(Long id);

    /**
     * 根据ID删除复盘记录
     *
     * @param id 复盘ID
     */
    void deleteById(Long id);
}
