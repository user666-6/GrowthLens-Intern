<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    request.setAttribute("currentMenu", "daily");
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>GrowthLens Intern - 周报列表</title>
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
        .table {
            margin-bottom: 0;
        }
        .table th {
            background-color: #f8f9fa;
            border-bottom: 2px solid #dee2e6;
        }
        .page-info {
            margin-top: 16px;
            text-align: center;
            color: #666;
        }
        .search-form {
            margin-bottom: 16px;
            display: flex;
            gap: 12px;
            align-items: center;
            flex-wrap: wrap;
        }
        .search-form input {
            max-width: 200px;
        }
        .tab-nav {
            margin-bottom: 16px;
        }
        .tab-nav button {
            margin-right: 8px;
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
                <div class="card">
                    <div class="card-header">
                        <div class="tab-nav">
                            <button class="btn btn-outline-secondary" onclick="goDailyList()">日报管理</button>
                            <button class="btn btn-primary">周报管理</button>
                        </div>
                        <div class="float-end">
                            <button class="btn btn-primary btn-sm" onclick="goAdd()">手动新增</button>
                            <button class="btn btn-outline-primary btn-sm" onclick="goGenerate()">生成周报</button>
                        </div>
                    </div>
                    <div class="card-body">
                        <form class="search-form" onsubmit="search(event)">
                            <input type="text" class="form-control" id="keyword" name="keyword" placeholder="关键词搜索" value="${keyword}">
                            <input type="date" class="form-control" id="startDate" name="startDate" value="${startDate}">
                            <span>至</span>
                            <input type="date" class="form-control" id="endDate" name="endDate" value="${endDate}">
                            <button type="submit" class="btn btn-outline-primary btn-sm">搜索</button>
                            <button type="button" class="btn btn-outline-secondary btn-sm" onclick="resetSearch()">重置</button>
                        </form>
                        <table class="table table-striped">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>年份/周次</th>
                                    <th>日期范围</th>
                                    <th>状态</th>
                                    <th>创建时间</th>
                                    <th>操作</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${pageInfo.list}" var="item">
                                    <tr>
                                        <td>${item.id}</td>
                                        <td>${item.weekYear}年 第${item.weekNum}周</td>
                                        <td>${item.startDate} ~ ${item.endDate}</td>
                                        <td>
                                            <c:if test="${item.status == 1}">
                                                <span class="text-success">已提交</span>
                                            </c:if>
                                            <c:if test="${item.status == 0}">
                                                <span class="text-danger">草稿</span>
                                            </c:if>
                                        </td>
                                        <td>${item.createTime}</td>
                                        <td>
                                            <button class="btn btn-sm btn-primary" onclick="goEdit(${item.id})">编辑</button>
                                            <c:if test="${item.status == 0}">
                                                <button class="btn btn-sm btn-success" onclick="submitReport(${item.id})">提交</button>
                                            </c:if>
                                            <button class="btn btn-sm btn-secondary" onclick="exportReport(${item.id})">导出</button>
                                            <button class="btn btn-sm btn-danger" onclick="deleteReport(${item.id})">删除</button>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty pageInfo.list}">
                                    <tr>
                                        <td colspan="6" class="text-center text-muted">暂无数据</td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                        <div class="page-info">
                            共 ${pageInfo.total} 条记录，当前第 ${pageInfo.pageNum} / ${pageInfo.pages} 页
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        var ctxPath = "<%= request.getContextPath() %>";

        function goDailyList() {
            window.location.href = ctxPath + '/dailyreport/list';
        }

        function goAdd() {
            window.location.href = ctxPath + '/dailyreport/weekly/add';
        }

        function goGenerate() {
            var year = prompt("请输入年份（如2026）：", new Date().getFullYear());
            if (!year) return;
            var week = prompt("请输入周次：", "");
            if (!week) return;
            fetch(ctxPath + '/dailyreport/weekly/generate', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: 'weekYear=' + year + '&weekNum=' + week
            }).then(function(response) {
                return response.json();
            }).then(function(result) {
                if (result.code === 200) {
                    alert('生成成功');
                    window.location.href = ctxPath + '/dailyreport/weekly/edit/' + result.data.id;
                } else {
                    alert(result.msg);
                }
            }).catch(function(error) {
                alert('生成失败');
            });
        }

        function goEdit(id) {
            window.location.href = ctxPath + '/dailyreport/weekly/edit/' + id;
        }

        function submitReport(id) {
            if (confirm('确定要提交这份周报吗？')) {
                fetch(ctxPath + '/dailyreport/weekly/submit/' + id, {
                    method: 'POST'
                }).then(function(response) {
                    return response.json();
                }).then(function(result) {
                    if (result.code === 200) {
                        alert('提交成功');
                        window.location.reload();
                    } else {
                        alert(result.msg);
                    }
                }).catch(function(error) {
                    alert('提交失败');
                });
            }
        }

        function exportReport(id) {
            window.location.href = ctxPath + '/dailyreport/weekly/export/' + id;
        }

        function deleteReport(id) {
            if (confirm('确定要删除这份周报吗？')) {
                fetch(ctxPath + '/dailyreport/weekly/delete/' + id, {
                    method: 'DELETE'
                }).then(function(response) {
                    return response.json();
                }).then(function(result) {
                    if (result.code === 200) {
                        alert('删除成功');
                        window.location.reload();
                    } else {
                        alert(result.msg);
                    }
                }).catch(function(error) {
                    alert('删除失败');
                });
            }
        }

        function search(event) {
            event.preventDefault();
            var keyword = document.getElementById('keyword').value;
            var startDate = document.getElementById('startDate').value;
            var endDate = document.getElementById('endDate').value;
            var url = ctxPath + '/dailyreport/weekly/list?';
            if (keyword) url += 'keyword=' + encodeURIComponent(keyword) + '&';
            if (startDate) url += 'startDate=' + startDate + '&';
            if (endDate) url += 'endDate=' + endDate + '&';
            window.location.href = url;
        }

        function resetSearch() {
            window.location.href = ctxPath + '/dailyreport/weekly/list';
        }
    </script>
</body>
</html>