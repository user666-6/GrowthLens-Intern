package com.example.growthlens.controller;

import com.example.growthlens.common.LoginUserHolder;
import com.example.growthlens.entity.DailyReport;
import com.example.growthlens.entity.GoalInfo;
import com.example.growthlens.entity.GrowthProject;
import com.example.growthlens.entity.GrowthSkill;
import com.example.growthlens.entity.ReviewRecord;
import com.example.growthlens.entity.SysUser;
import com.example.growthlens.service.DailyReportService;
import com.example.growthlens.service.GoalService;
import com.example.growthlens.service.GrowthProjectService;
import com.example.growthlens.service.GrowthSkillService;
import com.example.growthlens.service.ReviewRecordService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
public class HomeController {

    private final DailyReportService dailyReportService;
    private final GoalService goalService;
    private final GrowthProjectService growthProjectService;
    private final GrowthSkillService growthSkillService;
    private final ReviewRecordService reviewRecordService;

    public HomeController(DailyReportService dailyReportService,
                         GoalService goalService,
                         GrowthProjectService growthProjectService,
                         GrowthSkillService growthSkillService,
                         ReviewRecordService reviewRecordService) {
        this.dailyReportService = dailyReportService;
        this.goalService = goalService;
        this.growthProjectService = growthProjectService;
        this.growthSkillService = growthSkillService;
        this.reviewRecordService = reviewRecordService;
    }

    @GetMapping({"/", "/index"})
    public String index(Model model) {
        SysUser currentUser = LoginUserHolder.getCurrentUser();
        if (currentUser == null) {
            return "login";
        }

        Long userId = currentUser.getId();

        LocalDate today = LocalDate.now();

        List<DailyReport> dailyReports = dailyReportService.findByUserId(userId);
        int dailyReportCount = dailyReports.size();

        DailyReport todayReport = dailyReportService.findByUserAndDate(userId, today);
        boolean todayReportSubmitted = todayReport != null && todayReport.getStatus() != null && todayReport.getStatus() == 1;

        List<GoalInfo> activeGoals = goalService.getGoalsByUserIdAndStatus(userId, 1);
        int activeGoalCount = activeGoals.size();

        List<GoalInfo> allGoals = goalService.getGoalsByUserId(userId);
        int totalGoalCount = allGoals.size();

        List<GrowthProject> projects = growthProjectService.findByUserId(userId);
        int projectCount = projects.size();

        List<GrowthSkill> skills = growthSkillService.findByUserId(userId);
        int skillCount = skills.size();

        List<ReviewRecord> reviews = reviewRecordService.getMyReviewPage(1, 100, null, null, null).getList();
        int reviewCount = reviews.size();

        List<Map<String, Object>> activityList = new ArrayList<>();
        for (DailyReport report : dailyReports) {
            Map<String, Object> activity = new HashMap<>();
            activity.put("type", "report");
            activity.put("title", "提交日报");
            activity.put("date", report.getReportDate());
            activity.put("content", report.getTodayFinish());
            activity.put("createTime", report.getCreateTime());
            activity.put("id", report.getId());
            activityList.add(activity);
        }
        for (ReviewRecord review : reviews) {
            Map<String, Object> activity = new HashMap<>();
            activity.put("type", "review");
            activity.put("title", "生成" + ("daily".equals(review.getReviewType()) ? "日度复盘" : "周度复盘"));
            activity.put("date", review.getEndDate());
            activity.put("content", review.getHighlight());
            activity.put("createTime", review.getCreateTime());
            activity.put("id", review.getId());
            activityList.add(activity);
        }
        for (GoalInfo goal : allGoals) {
            Map<String, Object> activity = new HashMap<>();
            activity.put("type", "goal");
            activity.put("title", "创建目标");
            activity.put("date", goal.getStartDate());
            activity.put("content", goal.getGoalName());
            activity.put("createTime", goal.getCreateTime());
            activity.put("id", goal.getId());
            activityList.add(activity);
        }

        activityList.sort(Comparator.comparing((Map<String, Object> m) -> (LocalDateTime) m.get("createTime")).reversed());
        if (activityList.size() > 5) {
            activityList = activityList.subList(0, 5);
        }

        String welcomeMsg = getWelcomeMessage(currentUser.getNickname());

        model.addAttribute("user", currentUser);
        model.addAttribute("today", today.format(DateTimeFormatter.ofPattern("yyyy年MM月dd日")));
        model.addAttribute("dayOfWeek", getDayOfWeek(today.getDayOfWeek().getValue()));
        model.addAttribute("welcomeMsg", welcomeMsg);
        model.addAttribute("dailyReportCount", dailyReportCount);
        model.addAttribute("activeGoalCount", activeGoalCount);
        model.addAttribute("totalGoalCount", totalGoalCount);
        model.addAttribute("projectCount", projectCount);
        model.addAttribute("skillCount", skillCount);
        model.addAttribute("reviewCount", reviewCount);
        model.addAttribute("todayReportSubmitted", todayReportSubmitted);
        model.addAttribute("activeGoals", activeGoals);
        model.addAttribute("recentActivities", activityList);

        return "index";
    }

    @GetMapping("/login")
    public String login() {
        return "login";
    }

    private String getWelcomeMessage(String nickname) {
        LocalDateTime now = LocalDateTime.now();
        int hour = now.getHour();
        if (hour < 6) {
            return "夜深了，注意休息";
        } else if (hour < 12) {
            return "早上好";
        } else if (hour < 14) {
            return "中午好";
        } else if (hour < 18) {
            return "下午好";
        } else if (hour < 22) {
            return "晚上好";
        } else {
            return "夜深了，注意休息";
        }
    }

    private String getDayOfWeek(int day) {
        String[] days = {"", "周一", "周二", "周三", "周四", "周五", "周六", "周日"};
        return days[day];
    }
}