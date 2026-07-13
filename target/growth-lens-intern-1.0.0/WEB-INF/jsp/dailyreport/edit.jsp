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
    <title>GrowthLens Intern - 编辑日报</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif; background-color: #f8f9fa; }
        .sidebar-placeholder { width: 200px; flex-shrink: 0; }
        .sidebar-inner { min-height: 100vh; background: linear-gradient(180deg, #667eea 0%, #764ba2 100%); padding: 0; }
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
        .form-group { margin-bottom: 16px; }
        .form-group label { display: block; margin-bottom: 6px; font-weight: 500; }
        .form-control { border-radius: 8px; border: 1px solid #e0e0e0; }
        .form-control:focus { border-color: #667eea; box-shadow: 0 0 0 3px rgba(102,126,234,0.1); }
        .polish-btn { float: right; margin-top: 4px; font-size: 12px; padding: 2px 8px; }
        .status-tag { display: inline-block; padding: 4px 12px; border-radius: 20px; font-size: 12px; }
        .status-draft { background-color: #fff3cd; color: #856404; }
        .status-submitted { background-color: #d4edda; color: #155724; }
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
                        编辑日报
                        <span class="status-tag ${report.status == 1 ? 'status-submitted' : 'status-draft'}">
                            ${report.status == 1 ? '已提交' : '草稿'}
                        </span>
                    </div>
                    <div class="card-body">
                        <form id="dailyForm">
                            <input type="hidden" id="id" name="id" value="${report.id}">
                            <div class="form-group">
                                <label for="reportDate">日报日期</label>
                                <input type="date" class="form-control" id="reportDate" name="reportDate" value="${report.reportDate}" required>
                            </div>
                            <div class="form-group">
                                <label for="todayFinish">今日完成工作</label>
                                <button type="button" class="btn btn-sm btn-outline-primary polish-btn" onclick="polish('todayFinish')">AI润色</button>
                                <textarea class="form-control" id="todayFinish" name="todayFinish" rows="4" placeholder="请输入今日完成的工作内容...">${report.todayFinish}</textarea>
                            </div>
                            <div class="form-group">
                                <label for="encounterProblem">遇到的问题</label>
                                <button type="button" class="btn btn-sm btn-outline-primary polish-btn" onclick="polish('encounterProblem')">AI润色</button>
                                <textarea class="form-control" id="encounterProblem" name="encounterProblem" rows="3" placeholder="请输入工作中遇到的问题...">${report.encounterProblem}</textarea>
                            </div>
                            <div class="form-group">
                                <label for="tomorrowPlan">明日计划</label>
                                <button type="button" class="btn btn-sm btn-outline-primary polish-btn" onclick="polish('tomorrowPlan')">AI润色</button>
                                <textarea class="form-control" id="tomorrowPlan" name="tomorrowPlan" rows="3" placeholder="请输入明日工作计划...">${report.tomorrowPlan}</textarea>
                            </div>
                            <div class="mt-4">
                                <button type="button" class="btn btn-secondary" onclick="saveDraft()">保存草稿</button>
                                <button type="button" class="btn btn-primary" onclick="submitReport()">正式提交</button>
                                <button type="button" class="btn btn-outline-secondary" onclick="goBack()">返回列表</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        var ctxPath = "<%= request.getContextPath() %>";

        function polish(fieldId) {
            var content = document.getElementById(fieldId).value;
            if (!content.trim()) {
                alert("请先输入内容");
                return;
            }
            
            var textarea = document.getElementById(fieldId);
            var btn = textarea.parentNode.querySelector('.polish-btn');
            btn.disabled = true;
            btn.innerHTML = '润色中...';
            
            fetch(ctxPath + '/dailyreport/polish', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: 'content=' + encodeURIComponent(content)
            }).then(function(response) {
                return response.json();
            }).then(function(result) {
                if (result.code === 200) {
                    document.getElementById(fieldId).value = result.data;
                } else {
                    alert(result.msg);
                }
                btn.disabled = false;
                btn.innerHTML = 'AI润色';
            }).catch(function(error) {
                alert('润色失败');
                btn.disabled = false;
                btn.innerHTML = 'AI润色';
            });
        }

        function saveDraft() {
            var formData = new FormData(document.getElementById('dailyForm'));
            formData.append('status', '0');
            fetch(ctxPath + '/dailyreport/update', {
                method: 'POST',
                body: formData
            }).then(function(response) {
                return response.json();
            }).then(function(result) {
                if (result.code === 200) {
                    alert('保存草稿成功');
                    window.location.href = ctxPath + '/dailyreport/list';
                } else {
                    alert(result.msg);
                }
            }).catch(function(error) {
                alert('保存失败');
            });
        }

        function submitReport() {
            var formData = new FormData(document.getElementById('dailyForm'));
            formData.append('status', '1');
            fetch(ctxPath + '/dailyreport/update', {
                method: 'POST',
                body: formData
            }).then(function(response) {
                return response.json();
            }).then(function(result) {
                if (result.code === 200) {
                    alert('提交成功');
                    window.location.href = ctxPath + '/dailyreport/list';
                } else {
                    alert(result.msg);
                }
            }).catch(function(error) {
                alert('提交失败');
            });
        }

        function goBack() {
            window.location.href = ctxPath + '/dailyreport/list';
        }
    </script>
</body>
</html>