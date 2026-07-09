<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    request.setAttribute("currentMenu", "goal");
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>GrowthLens Intern - 目标任务管理</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif; background-color: #f8f9fa; }
        .sidebar { min-height: 100vh; background: linear-gradient(180deg, #667eea 0%, #764ba2 100%); padding: 0; }
        .sidebar-header { padding: 24px; color: white; font-size: 20px; font-weight: 600; border-bottom: 1px solid rgba(255,255,255,0.1); }
        .sidebar-menu { list-style: none; padding: 0; margin: 0; }
        .sidebar-menu li a { display: block; padding: 14px 24px; color: rgba(255,255,255,0.9); text-decoration: none; transition: all 0.3s; }
        .sidebar-menu li a:hover { background-color: rgba(255,255,255,0.1); color: white; }
        .sidebar-menu li a.active { background-color: rgba(255,255,255,0.2); color: white; }
        .main-content { padding: 24px; }
        .navbar { background-color: white; border-bottom: 1px solid #e9ecef; padding: 12px 24px; }
        .navbar-right { display: flex; align-items: center; gap: 16px; }
        .card { border: none; box-shadow: 0 2px 8px rgba(0,0,0,0.08); border-radius: 12px; }
        .card-header { background-color: white; border-bottom: 1px solid #f0f0f0; font-weight: 600; padding: 16px 20px; }
        .card-body { padding: 20px; }
        .btn-primary { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); border: none; }
        .btn-primary:hover { opacity: 0.9; }
        .table { margin-bottom: 0; }
        .table th { background-color: #f8f9fa; border-bottom: 2px solid #dee2e6; }
        .progress-bar { background: linear-gradient(90deg, #667eea 0%, #764ba2 100%); }
        .badge { font-size: 0.75rem; padding: 0.35em 0.65em; }
    </style>
</head>
<body>
    <div class="d-flex">
        <jsp:include page="/WEB-INF/jsp/common/sidebar.jsp" />
        
        <div class="flex-grow-1">
            <jsp:include page="/WEB-INF/jsp/common/header.jsp" />
            
            <div class="main-content">
                <div class="card">
                    <div class="card-header">
                        目标任务管理
                        <button class="btn btn-primary btn-sm float-end" id="btn-add">新增目标</button>
                    </div>
                    <div class="card-body">
                        <div class="mb-3">
                            <div class="btn-group" role="group">
                                <button class="btn btn-secondary btn-sm ${status == null ? 'active' : ''}" onclick="filterByStatus(null)">全部</button>
                                <button class="btn btn-secondary btn-sm ${status == 1 ? 'active' : ''}" onclick="filterByStatus(1)">未开始</button>
                                <button class="btn btn-secondary btn-sm ${status == 2 ? 'active' : ''}" onclick="filterByStatus(2)">进行中</button>
                                <button class="btn btn-secondary btn-sm ${status == 3 ? 'active' : ''}" onclick="filterByStatus(3)">已完成</button>
                                <button class="btn btn-secondary btn-sm ${status == 4 ? 'active' : ''}" onclick="filterByStatus(4)">已延期</button>
                            </div>
                            <div class="btn-group ms-3" role="group">
                                <button class="btn btn-outline-secondary btn-sm ${goalType == null ? 'active' : ''}" onclick="filterByType(null)">全部分类</button>
                                <button class="btn btn-outline-secondary btn-sm ${goalType == 'study' ? 'active' : ''}" onclick="filterByType('study')">学习目标</button>
                                <button class="btn btn-outline-secondary btn-sm ${goalType == 'work' ? 'active' : ''}" onclick="filterByType('work')">工作目标</button>
                                <button class="btn btn-outline-secondary btn-sm ${goalType == 'intern' ? 'active' : ''}" onclick="filterByType('intern')">实习目标</button>
                            </div>
                        </div>
                        
                        <table class="table table-striped">
                            <thead>
                                <tr>
                                    <th>目标名称</th>
                                    <th>类型</th>
                                    <th>优先级</th>
                                    <th>进度</th>
                                    <th>状态</th>
                                    <th>时间范围</th>
                                    <th>操作</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${goalList}" var="goal">
                                    <tr>
                                        <td><a href="${ctxPath}/goal/detail/${goal.id}">${goal.goalName}</a></td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${goal.goalType == 'study'}">学习目标</c:when>
                                                <c:when test="${goal.goalType == 'work'}">工作目标</c:when>
                                                <c:when test="${goal.goalType == 'intern'}">实习目标</c:when>
                                                <c:otherwise>其他</c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <span class="badge ${goal.priority == 1 ? 'bg-danger' : goal.priority == 2 ? 'bg-warning' : 'bg-secondary'}">
                                                ${goal.priority == 1 ? '高' : goal.priority == 2 ? '中' : '低'}
                                            </span>
                                        </td>
                                        <td>
                                            <div class="progress" style="height: 20px;">
                                                <div class="progress-bar" role="progressbar" style="width: ${goal.progress}%" aria-valuenow="${goal.progress}" aria-valuemin="0" aria-valuemax="100">
                                                    ${goal.progress}%
                                                </div>
                                            </div>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${goal.status == 0}"><span class="text-muted">已取消</span></c:when>
                                                <c:when test="${goal.status == 1}"><span class="text-secondary">未开始</span></c:when>
                                                <c:when test="${goal.status == 2}"><span class="text-primary">进行中</span></c:when>
                                                <c:when test="${goal.status == 3}"><span class="text-success">已完成</span></c:when>
                                                <c:when test="${goal.status == 4}"><span class="text-danger">已延期</span></c:when>
                                            </c:choose>
                                        </td>
                                        <td>${goal.startDate} ~ ${goal.endDate}</td>
                                        <td>
                                            <button class="btn btn-sm btn-info" onclick="viewDetail(${goal.id})">详情</button>
                                            <button class="btn btn-sm btn-danger" onclick="deleteGoal(${goal.id})">删除</button>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty goalList}">
                                    <tr><td colspan="7" class="text-center text-muted">暂无目标数据</td></tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        var ctxPath = "<%= request.getContextPath() %>";
        
        document.getElementById('btn-add').addEventListener('click', function() {
            window.location.href = ctxPath + '/goal/add';
        });
        
        function filterByStatus(status) {
            var url = ctxPath + '/goal/list';
            if (status != null) {
                url += '?status=' + status;
            }
            window.location.href = url;
        }
        
        function filterByType(type) {
            var url = ctxPath + '/goal/list';
            if (type) {
                url += '?goalType=' + type;
            }
            window.location.href = url;
        }
        
        function viewDetail(id) {
            window.location.href = ctxPath + '/goal/detail/' + id;
        }
        
        function deleteGoal(id) {
            if (confirm('确定要删除这个目标吗？')) {
                fetch(ctxPath + '/goal/delete/' + id, { method: 'POST' })
                    .then(res => res.json())
                    .then(result => {
                        if (result.code === 200) {
                            alert('删除成功');
                            window.location.reload();
                        } else {
                            alert(result.msg);
                        }
                    }).catch(err => alert('删除失败'));
            }
        }
    </script>
</body>
</html>