package com.example.growthlens.mapper;

import com.example.growthlens.entity.ReviewRecord;
import org.apache.ibatis.annotations.Param;

import java.time.LocalDate;
import java.util.List;

/**
 * 复盘记录数据访问层接口
 */
public interface ReviewRecordMapper {

    /**
     * 插入复盘记录
     *
     * @param record 复盘记录实体
     * @return 影响行数
     */
    int insert(ReviewRecord record);

    /**
     * 根据ID更新复盘记录
     *
     * @param record 复盘记录实体
     * @return 影响行数
     */
    int updateById(ReviewRecord record);

    /**
     * 根据ID删除复盘记录
     *
     * @param id 复盘ID
     * @return 影响行数
     */
    int deleteById(Long id);

    /**
     * 根据ID查询复盘记录
     *
     * @param id 复盘ID
     * @return 复盘记录实体
     */
    ReviewRecord selectById(Long id);

    /**
     * 分页查询复盘记录
     *
     * @param userId     用户ID（可为空，为空时查询全部）
     * @param reviewType 复盘类型（可为空）
     * @param startDate  开始日期（可为空）
     * @param endDate    结束日期（可为空）
     * @return 复盘记录列表
     */
    List<ReviewRecord> selectPage(@Param("userId") Long userId,
                                   @Param("reviewType") String reviewType,
                                   @Param("startDate") LocalDate startDate,
                                   @Param("endDate") LocalDate endDate);
}
