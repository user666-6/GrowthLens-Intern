package com.example.growthlens.service.impl;

import com.example.growthlens.common.BusinessException;
import com.example.growthlens.common.LoginUserHolder;
import com.example.growthlens.entity.AiPromptTemplate;
import com.example.growthlens.entity.DailyReport;
import com.example.growthlens.entity.ReviewRecord;
import com.example.growthlens.entity.SysUser;
import com.example.growthlens.mapper.AiPromptTemplateMapper;
import com.example.growthlens.mapper.ReviewRecordMapper;
import com.example.growthlens.service.AiService;
import com.example.growthlens.service.DailyReportService;
import com.example.growthlens.service.ReviewRecordService;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * 复盘记录业务层实现类
 */
@Slf4j
@Service
public class ReviewRecordServiceImpl implements ReviewRecordService {

    @Autowired
    private ReviewRecordMapper reviewRecordMapper;

    @Autowired
    private DailyReportService dailyReportService;

    @Autowired
    private AiService aiService;

    @Autowired
    private AiPromptTemplateMapper promptTemplateMapper;

    /**
     * AI模板编码常量
     */
    private static final String TEMPLATE_DAILY_POINT_EXTRACT = "daily_point_extract";
    private static final String TEMPLATE_MULTI_DAY_REVIEW = "multi_day_summary_review";

    /**
     * 日期格式化器
     */
    private static final DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd");

    /**
     * 周度复盘最大天数
     */
    private static final int WEEKLY_MAX_DAYS = 7;

    /**
     * 正则表达式模式，用于解析AI返回的结构化内容
     */
    private static final Pattern HIGHLIGHT_PATTERN = Pattern.compile("(【?工作亮点】?|【?亮点】?|##?\\s*工作亮点|##?\\s*亮点)[：:]?\\s*(.*?)(?=(【?存在不足】?|【?不足】?|【?改进建议】?|【?建议】?|##?\\s*存在不足|##?\\s*改进建议|$))", Pattern.DOTALL);
    private static final Pattern SHORTAGE_PATTERN = Pattern.compile("(【?存在不足】?|【?不足】?|##?\\s*存在不足|##?\\s*不足)[：:]?\\s*(.*?)(?=(【?工作亮点】?|【?亮点】?|【?改进建议】?|【?建议】?|##?\\s*工作亮点|##?\\s*改进建议|$))", Pattern.DOTALL);
    private static final Pattern SUGGESTION_PATTERN = Pattern.compile("(【?改进建议】?|【?建议】?|##?\\s*改进建议|##?\\s*建议)[：:]?\\s*(.*?)(?=(【?工作亮点】?|【?亮点】?|【?存在不足】?|【?不足】?|##?\\s*工作亮点|##?\\s*存在不足|$))", Pattern.DOTALL);

    @Override
    public ReviewRecord generateReview(String reviewType, LocalDate startDate, LocalDate endDate) {
        log.info("========== 生成复盘开始 ==========");
        
        ReviewRecord record = null;
        
        try {
            log.info("[步骤0] 初始化AI模板");
            ensureTemplatesExist();
            log.info("[步骤0成功] AI模板初始化完成");

            log.info("[步骤1] 参数校验，类型: {}, 开始日期: {}, 结束日期: {}", reviewType, startDate, endDate);

            if (reviewType == null || reviewType.isEmpty()) {
                throw new BusinessException("复盘类型不能为空");
            }
            if (startDate == null || endDate == null) {
                throw new BusinessException("日期不能为空");
            }
            if (endDate.isBefore(startDate)) {
                throw new BusinessException("结束日期不能早于开始日期");
            }

            long daysBetween = ChronoUnit.DAYS.between(startDate, endDate) + 1;
            if ("daily".equals(reviewType)) {
                if (!startDate.equals(endDate)) {
                    throw new BusinessException("日度复盘起止日期必须为同一天");
                }
            } else if ("weekly".equals(reviewType)) {
                if (daysBetween > WEEKLY_MAX_DAYS) {
                    throw new BusinessException("日期范围不能超过7天");
                }
            }

            SysUser currentUser = LoginUserHolder.getCurrentUser();
            if (currentUser == null) {
                throw new BusinessException("用户未登录");
            }
            log.info("[步骤1成功] 获取当前用户，ID: {}, 用户名: {}", currentUser.getId(), currentUser.getUsername());

            log.info("[步骤2] 查询日报，用户ID: {}, 日期范围: {} - {}", currentUser.getId(), startDate, endDate);
            List<DailyReport> reports = dailyReportService.findByDateRange(currentUser.getId(), startDate, endDate);

            if (reports == null || reports.isEmpty()) {
                throw new BusinessException("对应日期无日报记录，无法生成复盘");
            }
            log.info("[步骤2成功] 查询到日报数量: {}", reports.size());

            log.info("[步骤3] 拼接原始日报内容");
            StringBuilder originalContentBuilder = new StringBuilder();
            for (DailyReport report : reports) {
                originalContentBuilder.append("日期: ").append(report.getReportDate().format(DATE_FORMATTER)).append("\n");
                originalContentBuilder.append("今日完成: ").append(report.getTodayFinish() != null ? report.getTodayFinish() : "").append("\n");
                originalContentBuilder.append("遇到问题: ").append(report.getEncounterProblem() != null ? report.getEncounterProblem() : "").append("\n");
                originalContentBuilder.append("明日计划: ").append(report.getTomorrowPlan() != null ? report.getTomorrowPlan() : "").append("\n\n");
            }
            String originalContent = originalContentBuilder.toString();
            log.info("[步骤3成功] 原始内容拼接完成，长度: {} 字符", originalContent.length());

            record = new ReviewRecord();
            record.setUserId(currentUser.getId());
            record.setReviewType(reviewType);
            record.setStartDate(startDate);
            record.setEndDate(endDate);
            record.setOriginalContent(originalContent);
            record.setStatus(2);
            reviewRecordMapper.insert(record);
            log.info("[步骤4成功] 记录已保存到数据库，ID: {}", record.getId());

            log.info("[步骤5] 逐天提取要点");
            StringBuilder allPointsBuilder = new StringBuilder();
            int successCount = 0;
            int failCount = 0;

            for (DailyReport report : reports) {
                String dailyContent = buildDailyContent(report);
                LocalDate reportDate = report.getReportDate();

                try {
                    Map<String, String> params = new HashMap<>();
                    params.put("content", dailyContent);
                    String extractedPoints = aiService.callByTemplate(currentUser.getId(), currentUser.getUsername(), TEMPLATE_DAILY_POINT_EXTRACT, params);

                    allPointsBuilder.append("【").append(reportDate.format(DATE_FORMATTER)).append("】\n");
                    allPointsBuilder.append(extractedPoints).append("\n\n");
                    successCount++;
                    log.info("[步骤5] 日期 {} 要点提取成功", reportDate);
                } catch (Exception e) {
                    failCount++;
                    log.warn("[步骤5] 日期 {} 要点提取失败，跳过该天: {}", reportDate, e.getMessage());
                }
            }

            if (successCount == 0) {
                String errorMsg = "所有日期要点提取均失败";
                record.setStatus(0);
                record.setErrorMsg(errorMsg);
                reviewRecordMapper.updateById(record);
                log.error("[步骤5失败] {}", errorMsg);
                throw new BusinessException(errorMsg);
            }

            String allPoints = allPointsBuilder.toString();
            log.info("[步骤5成功] 要点提取完成，成功: {} 天，失败: {} 天，要点内容长度: {} 字符", successCount, failCount, allPoints.length());

            log.info("[步骤6] 汇总生成复盘");
            String aiResult = null;
            try {
                Map<String, String> params = new HashMap<>();
                params.put("content", allPoints);
                aiResult = aiService.callByTemplate(currentUser.getId(), currentUser.getUsername(), TEMPLATE_MULTI_DAY_REVIEW, params);
                log.info("[步骤6成功] AI复盘生成完成，返回内容长度: {} 字符", aiResult != null ? aiResult.length() : 0);
            } catch (Exception e) {
                String errorMsg = "汇总生成复盘失败: " + e.getMessage();
                record.setStatus(0);
                record.setErrorMsg(errorMsg);
                reviewRecordMapper.updateById(record);
                log.error("[步骤6失败] {}", errorMsg, e);
                throw new BusinessException("生成失败，请缩小日期范围后重试");
            }

            log.info("[步骤7] 解析AI返回结果");
            String highlight = extractSection(aiResult, HIGHLIGHT_PATTERN);
            String shortage = extractSection(aiResult, SHORTAGE_PATTERN);
            String suggestion = extractSection(aiResult, SUGGESTION_PATTERN);

            log.info("[步骤7成功] 解析完成");

            record.setHighlight(highlight);
            record.setShortage(shortage);
            record.setSuggestion(suggestion);
            record.setFullContent(aiResult);
            record.setStatus(1);
            reviewRecordMapper.updateById(record);
            log.info("[步骤8成功] 数据库更新完成");

            log.info("========== 生成复盘完成 ==========");
            return record;
            
        } catch (BusinessException e) {
            if (record != null) {
                record.setStatus(0);
                record.setErrorMsg(e.getMessage());
                reviewRecordMapper.updateById(record);
            }
            log.error("复盘生成失败（业务异常）: {}", e.getMessage());
            throw e;
        } catch (Exception e) {
            if (record != null) {
                record.setStatus(0);
                record.setErrorMsg("系统异常: " + e.getMessage());
                reviewRecordMapper.updateById(record);
            }
            log.error("复盘生成失败（系统异常）", e);
            throw new BusinessException("生成失败，请稍后重试");
        }
    }

    /**
     * 构建单日日报内容
     */
    private String buildDailyContent(DailyReport report) {
        StringBuilder builder = new StringBuilder();
        builder.append("今日完成：").append(report.getTodayFinish() != null ? report.getTodayFinish() : "").append("\n");
        builder.append("遇到问题：").append(report.getEncounterProblem() != null ? report.getEncounterProblem() : "").append("\n");
        builder.append("明日计划：").append(report.getTomorrowPlan() != null ? report.getTomorrowPlan() : "").append("\n");
        return builder.toString();
    }

    /**
     * 确保复盘所需的AI模板存在，不存在则自动创建
     */
    private void ensureTemplatesExist() {
        if (promptTemplateMapper.findByCode(TEMPLATE_DAILY_POINT_EXTRACT) == null) {
            AiPromptTemplate template = new AiPromptTemplate();
            template.setTemplateName("单日要点提取模板");
            template.setTemplateCode(TEMPLATE_DAILY_POINT_EXTRACT);
            template.setTemplateContent("请将以下单日工作日报内容提取为结构化要点，包括：工作亮点、存在不足、改进建议，语言简洁精炼，每个部分控制在50字以内：\n\n{{content}}");
            template.setDescription("用于提取单日日报的核心要点");
            template.setSceneType("summary");
            template.setStatus(1);
            promptTemplateMapper.insert(template);
            log.info("已创建模板: {}", TEMPLATE_DAILY_POINT_EXTRACT);
        }

        if (promptTemplateMapper.findByCode(TEMPLATE_MULTI_DAY_REVIEW) == null) {
            AiPromptTemplate template = new AiPromptTemplate();
            template.setTemplateName("多日汇总复盘模板");
            template.setTemplateCode(TEMPLATE_MULTI_DAY_REVIEW);
            template.setTemplateContent("请对以下多日工作要点进行汇总复盘分析，从三个维度总结：\n\n{{content}}\n\n【工作亮点】：做得好的地方\n【存在不足】：需要改进的地方\n【改进建议】：具体改进措施");
            template.setDescription("用于汇总多日要点生成最终复盘报告");
            template.setSceneType("review");
            template.setStatus(1);
            promptTemplateMapper.insert(template);
            log.info("已创建模板: {}", TEMPLATE_MULTI_DAY_REVIEW);
        }
    }

    /**
     * 从AI返回内容中提取指定段落
     */
    private String extractSection(String content, Pattern pattern) {
        if (content == null || content.isEmpty()) {
            return null;
        }
        Matcher matcher = pattern.matcher(content);
        if (matcher.find()) {
            return matcher.group(2).trim();
        }
        return null;
    }

    @Override
    public PageInfo<ReviewRecord> getMyReviewPage(int pageNum, int pageSize, String reviewType, LocalDate startDate, LocalDate endDate) {
        SysUser currentUser = LoginUserHolder.getCurrentUser();
        Long userId = currentUser.getId();

        PageHelper.startPage(pageNum, pageSize);
        List<ReviewRecord> list = reviewRecordMapper.selectPage(userId, reviewType, startDate, endDate);
        return new PageInfo<>(list);
    }

    @Override
    public ReviewRecord getDetailById(Long id) {
        ReviewRecord record = reviewRecordMapper.selectById(id);
        if (record == null) {
            throw new BusinessException("复盘记录不存在");
        }

        SysUser currentUser = LoginUserHolder.getCurrentUser();
        if (currentUser.getRole() != 1 && !currentUser.getId().equals(record.getUserId())) {
            throw new BusinessException("无权查看该复盘记录");
        }

        return record;
    }

    @Override
    public void deleteById(Long id) {
        ReviewRecord record = reviewRecordMapper.selectById(id);
        if (record == null) {
            throw new BusinessException("复盘记录不存在");
        }

        SysUser currentUser = LoginUserHolder.getCurrentUser();
        if (currentUser.getRole() != 1 && !currentUser.getId().equals(record.getUserId())) {
            throw new BusinessException("无权删除该复盘记录");
        }

        reviewRecordMapper.deleteById(id);
    }
}
