<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%
    request.setAttribute("currentMenu", "home");
    String ctxPath = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>GrowthLens Intern - 首页</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
            background-color: #f8f9fa;
        }
        .sidebar-placeholder { width: 200px; flex-shrink: 0; }
        .sidebar-inner {
            min-height: 100vh;
            background: linear-gradient(180deg, #667eea 0%, #764ba2 100%);
            padding: 0;
        }
        .sidebar-header {
            padding: 24px;
            color: white;
            font-size: 20px;
            font-weight: 600;
            border-bottom: 1px solid rgba(255,255,255,0.1);
        }
        .sidebar-menu {
            list-style: none;
            padding: 0;
            margin: 0;
        }
        .sidebar-menu li {
            margin: 0;
        }
        .sidebar-menu li a {
            display: block;
            padding: 14px 24px;
            color: rgba(255,255,255,0.9);
            text-decoration: none;
            transition: all 0.3s;
        }
        .sidebar-menu li a:hover {
            background-color: rgba(255,255,255,0.1);
            color: white;
        }
        .sidebar-menu li a.active {
            background-color: rgba(255,255,255,0.2);
            color: white;
        }
        .sidebar-menu li i {
            margin-right: 10px;
        }
        .main-content {
            padding: 24px;
        }
        .navbar {
            background-color: white;
            border-bottom: 1px solid #e9ecef;
            padding: 12px 24px;
        }
        .navbar-right {
            display: flex;
            align-items: center;
            gap: 16px;
        }
        .card {
            border: none;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            border-radius: 12px;
        }
        .card-header {
            background-color: white;
            border-bottom: 1px solid #f0f0f0;
            font-weight: 600;
            padding: 16px 20px;
        }
        .card-body {
            padding: 20px;
        }
        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
        }
        .btn-primary:hover {
            opacity: 0.9;
        }
        .welcome-banner {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 16px;
            padding: 32px;
            color: white;
            margin-bottom: 24px;
        }
        .welcome-banner h1 {
            font-size: 28px;
            font-weight: 600;
            margin-bottom: 8px;
        }
        .welcome-banner p {
            opacity: 0.9;
            font-size: 16px;
        }
        .quick-actions {
            display: flex;
            gap: 12px;
            margin-top: 20px;
        }
        .quick-action-btn {
            background: rgba(255,255,255,0.2);
            border: 1px solid rgba(255,255,255,0.3);
            color: white;
            padding: 10px 20px;
            border-radius: 8px;
            text-decoration: none;
            transition: all 0.3s;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .quick-action-btn:hover {
            background: rgba(255,255,255,0.3);
            color: white;
            text-decoration: none;
        }
        .stats-card {
            text-align: center;
            padding: 24px;
            background: white;
            border-radius: 12px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            transition: transform 0.3s, box-shadow 0.3s;
        }
        .stats-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 4px 16px rgba(0,0,0,0.12);
        }
        .stats-card .number {
            font-size: 36px;
            font-weight: 700;
            color: #667eea;
        }
        .stats-card .label {
            color: #666;
            margin-top: 8px;
            font-size: 14px;
        }
        .stats-card .icon {
            font-size: 28px;
            margin-bottom: 12px;
        }
        .today-report-card {
            padding: 24px;
            border-radius: 12px;
        }
        .today-report-card.success {
            background: linear-gradient(135deg, #d1fae5 0%, #a7f3d0 100%);
            border: 1px solid #34d399;
        }
        .today-report-card.pending {
            background: linear-gradient(135deg, #fef3c7 0%, #fde68a 100%);
            border: 1px solid #f59e0b;
        }
        .today-report-icon {
            font-size: 48px;
            margin-bottom: 16px;
        }
        .progress-bar-container {
            margin: 16px 0;
        }
        .progress-bar-label {
            display: flex;
            justify-content: space-between;
            margin-bottom: 8px;
            font-size: 14px;
            color: #555;
        }
        .progress-bar {
            height: 8px;
            background: #e5e7eb;
            border-radius: 4px;
            overflow: hidden;
        }
        .progress-fill {
            height: 100%;
            background: linear-gradient(90deg, #667eea 0%, #764ba2 100%);
            border-radius: 4px;
            transition: width 0.5s;
        }
        .module-card {
            border: none;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            border-radius: 12px;
            padding: 24px;
            text-align: center;
            transition: all 0.3s;
            cursor: pointer;
            background: white;
            text-decoration: none;
            color: inherit;
            display: flex;
            flex-direction: column;
            height: 100%;
            min-height: 160px;
        }
        .module-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 4px 16px rgba(0,0,0,0.12);
            text-decoration: none;
            color: inherit;
        }
        .module-card .module-icon {
            font-size: 40px;
            margin-bottom: 12px;
            color: #667eea;
        }
        .module-card .module-title {
            font-weight: 600;
            font-size: 16px;
            margin-bottom: 8px;
        }
        .module-card .module-desc {
            font-size: 13px;
            color: #888;
            line-height: 1.5;
            flex-grow: 1;
        }
        .timeline-item {
            display: flex;
            padding: 16px 0;
            border-bottom: 1px solid #f0f0f0;
        }
        .timeline-item:last-child {
            border-bottom: none;
        }
        .timeline-icon {
            width: 36px;
            height: 36px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 18px;
            margin-right: 16px;
            flex-shrink: 0;
        }
        .timeline-icon.report {
            background: #dbeafe;
            color: #3b82f6;
        }
        .timeline-icon.review {
            background: #fef3c7;
            color: #f59e0b;
        }
        .timeline-icon.goal {
            background: #d1fae5;
            color: #10b981;
        }
        .timeline-content {
            flex-grow: 1;
        }
        .timeline-title {
            font-weight: 500;
            color: #333;
            margin-bottom: 4px;
        }
        .timeline-date {
            font-size: 12px;
            color: #999;
        }
        .timeline-preview {
            font-size: 13px;
            color: #666;
            margin-top: 4px;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }
        .empty-state {
            text-align: center;
            padding: 40px 20px;
            color: #999;
        }
        .empty-state .empty-icon {
            font-size: 48px;
            margin-bottom: 16px;
            color: #ddd;
        }
        .empty-state a {
            color: #667eea;
            text-decoration: none;
        }
        .empty-state a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <div class="d-flex">
        <div class="sidebar-placeholder"></div>
        <jsp:include page="/WEB-INF/jsp/common/sidebar.jsp" />
        
        <div class="flex-grow-1">
            <jsp:include page="/WEB-INF/jsp/common/header.jsp" />
            
            <div class="main-content">
                <div class="welcome-banner">
                    <h1>${welcomeMsg}，${user.nickname != null ? user.nickname : user.username}</h1>
                    <p>${today} ${dayOfWeek}</p>
                    <div class="quick-actions">
                        <a href="<%= ctxPath %>/dailyreport/add" class="quick-action-btn">
                            <span>📝</span>写日报
                        </a>
                        <a href="<%= ctxPath %>/goal/add" class="quick-action-btn">
                            <span>🎯</span>创建目标
                        </a>
                        <a href="<%= ctxPath %>/chat/index" class="quick-action-btn">
                            <span>🤖</span>AI对话
                        </a>
                    </div>
                </div>

                <div class="row mb-4">
                    <div class="col-md-3">
                        <div class="stats-card">
                            <div class="icon">📝</div>
                            <div class="number">${dailyReportCount}</div>
                            <div class="label">日报总数</div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="stats-card">
                            <div class="icon">🎯</div>
                            <div class="number">${activeGoalCount}</div>
                            <div class="label">进行中目标</div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="stats-card">
                            <div class="icon">📊</div>
                            <div class="number">${projectCount}</div>
                            <div class="label">成长项目</div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="stats-card">
                            <div class="icon">💡</div>
                            <div class="number">${skillCount}</div>
                            <div class="label">已掌握技能</div>
                        </div>
                    </div>
                </div>

                <div class="row mb-4">
                    <div class="col-md-4">
                        <c:choose>
                            <c:when test="${todayReportSubmitted}">
                                <div class="today-report-card success">
                                    <div class="today-report-icon">✅</div>
                                    <h4>今日日报已提交</h4>
                                    <p class="text-success" style="opacity: 0.8;">再接再厉，继续保持！</p>
                                    <a href="<%= ctxPath %>/dailyreport/list" class="btn btn-success btn-sm mt-3">查看记录</a>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="today-report-card pending">
                                    <div class="today-report-icon">⏰</div>
                                    <h4>今日日报待提交</h4>
                                    <p style="opacity: 0.8;">今日事，今日毕。记得提交今日日报！</p>
                                    <a href="<%= ctxPath %>/dailyreport/add" class="btn btn-warning btn-sm mt-3">立即提交</a>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div class="col-md-8">
                        <div class="card">
                            <div class="card-header">进行中目标</div>
                            <div class="card-body">
                                <c:choose>
                                    <c:when test="${activeGoals != null && activeGoals.size() > 0}">
                                        <c:forEach var="goal" items="${activeGoals}">
                                            <div class="progress-bar-container">
                                                <div class="progress-bar-label">
                                                    <span>${goal.goalName}</span>
                                                    <span>${goal.progress != null ? goal.progress : 0}%</span>
                                                </div>
                                                <div class="progress-bar">
                                                    <div class="progress-fill" style="width: ${goal.progress != null ? goal.progress : 0}%"></div>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="empty-state">
                                            <div class="empty-icon">🎯</div>
                                            <p>暂无进行中的目标</p>
                                            <a href="<%= ctxPath %>/goal/add">去创建目标</a>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="card mb-4">
                    <div class="card-header">功能模块</div>
                    <div class="card-body">
                        <div class="row align-items-stretch">
                            <div class="col-md-2 mb-3">
                                <a href="<%= ctxPath %>/dailyreport/list" class="module-card">
                                    <div class="module-icon">📝</div>
                                    <div class="module-title">日报周报</div>
                                    <div class="module-desc">记录每日工作，每周总结</div>
                                </a>
                            </div>
                            <div class="col-md-2 mb-3">
                                <a href="<%= ctxPath %>/growth/list" class="module-card">
                                    <div class="module-icon">📈</div>
                                    <div class="module-title">成长轨迹</div>
                                    <div class="module-desc">追踪技能与项目成长</div>
                                </a>
                            </div>
                            <div class="col-md-2 mb-3">
                                <a href="<%= ctxPath %>/goal/list" class="module-card">
                                    <div class="module-icon">🎯</div>
                                    <div class="module-title">目标任务</div>
                                    <div class="module-desc">管理目标与任务进度</div>
                                </a>
                            </div>
                            <div class="col-md-2 mb-3">
                                <a href="<%= ctxPath %>/review/list" class="module-card">
                                    <div class="module-icon">🔍</div>
                                    <div class="module-title">智能复盘</div>
                                    <div class="module-desc">AI分析工作亮点与不足</div>
                                </a>
                            </div>
                            <div class="col-md-2 mb-3">
                                <a href="<%= ctxPath %>/interview/list" class="module-card">
                                    <div class="module-icon">💼</div>
                                    <div class="module-title">面经题库</div>
                                    <div class="module-desc">学习面试知识与技巧</div>
                                </a>
                            </div>
                            <div class="col-md-2 mb-3">
                                <a href="<%= ctxPath %>/chat/index" class="module-card">
                                    <div class="module-icon">🤖</div>
                                    <div class="module-title">智能助手</div>
                                    <div class="module-desc">AI职场问答与辅助</div>
                                </a>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="card">
                    <div class="card-header">最近活动</div>
                    <div class="card-body">
                        <c:choose>
                            <c:when test="${recentActivities != null && recentActivities.size() > 0}">
                                <c:forEach var="activity" items="${recentActivities}">
                                    <div class="timeline-item">
                                        <div class="timeline-icon ${activity.type}">
                                            <c:choose>
                                                <c:when test="${activity.type == 'report'}">📝</c:when>
                                                <c:when test="${activity.type == 'review'}">🔍</c:when>
                                                <c:otherwise>🎯</c:otherwise>
                                            </c:choose>
                                        </div>
                                        <div class="timeline-content">
                                            <div class="timeline-title">${activity.title}</div>
                                            <div class="timeline-date">${activity.date}</div>
                                            <c:if test="${activity.content != null && activity.content != ''}">
                                                <div class="timeline-preview">${fn:substring(activity.content, 0, 50)}${fn:length(activity.content) > 50 ? '...' : ''}</div>
                                            </c:if>
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <div class="empty-state">
                                    <div class="empty-icon">📋</div>
                                    <p>暂无活动记录</p>
                                    <a href="<%= ctxPath %>/dailyreport/add">开始记录你的第一个日报</a>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>