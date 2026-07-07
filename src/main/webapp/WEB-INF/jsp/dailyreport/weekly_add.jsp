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
    <title>GrowthLens Intern - 新增周报</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif; background-color: #f8f9fa; }
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
        .form-group { margin-bottom: 16px; }
        .form-group label { display: block; margin-bottom: 6px; font-weight: 500; }
        .form-control { border-radius: 8px; border: 1px solid #e0e0e0; }
        .form-control:focus { border-color: #667eea; box-shadow: 0 0 0 3px rgba(102,126,234,0.1); }
        .polish-btn { float: right; margin-top: 4px; font-size: 12px; padding: 2px 8px; }
        .week-info { margin-bottom: 16px; padding: 12px; background-color: #f8f9fa; border-radius: 8px; }
    </style>
</head>
<body>
    <div class="d-flex">
        <jsp:include page="/WEB-INF/jsp/common/sidebar.jsp" />
        <div class="flex-grow-1">
            <jsp:include page="/WEB-INF/jsp/common/header.jsp" />
            <div class="main-content">
                <div class="card">
                    <div class="card-header">新增周报</div>
                    <div class="card-body">
                        <form id="weeklyForm">
                            <div class="form-group">
                                <label for="weekYear">年份</label>
                                <input type="number" class="form-control" id="weekYear" name="weekYear" value="${weekYear}" required>
                            </div>
                            <div class="form-group">
                                <label for="weekNum">周次</label>
                                <input type="number" class="form-control" id="weekNum" name="weekNum" value="${weekNum}" min="1" max="53" required>
                            </div>
                            <div class="week-info">
                                <strong>本周日期范围：</strong>
                                <span id="dateRange">请选择年份和周次</span>
                            </div>
                            <div class="form-group">
                                <label for="weekSummary">本周工作总结</label>
                                <button type="button" class="btn btn-sm btn-outline-primary polish-btn" onclick="polish('weekSummary')">AI润色</button>
                                <textarea class="form-control" id="weekSummary" name="weekSummary" rows="6" placeholder="请输入本周工作总结..."></textarea>
                            </div>
                            <div class="form-group">
                                <label for="problemReview">问题与复盘</label>
                                <button type="button" class="btn btn-sm btn-outline-primary polish-btn" onclick="polish('problemReview')">AI润色</button>
                                <textarea class="form-control" id="problemReview" name="problemReview" rows="4" placeholder="请输入本周遇到的问题及复盘..."></textarea>
                            </div>
                            <div class="form-group">
                                <label for="nextWeekPlan">下周工作计划</label>
                                <button type="button" class="btn btn-sm btn-outline-primary polish-btn" onclick="polish('nextWeekPlan')">AI润色</button>
                                <textarea class="form-control" id="nextWeekPlan" name="nextWeekPlan" rows="4" placeholder="请输入下周工作计划..."></textarea>
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

        document.getElementById('weekYear').addEventListener('change', updateDateRange);
        document.getElementById('weekNum').addEventListener('change', updateDateRange);
        updateDateRange();

        function updateDateRange() {
            var year = document.getElementById('weekYear').value;
            var week = document.getElementById('weekNum').value;
            if (year && week) {
                var startDate = getWeekStartDate(parseInt(year), parseInt(week));
                var endDate = new Date(startDate.getTime() + 6 * 86400000);
                document.getElementById('dateRange').textContent = startDate.toISOString().split('T')[0] + ' ~ ' + endDate.toISOString().split('T')[0];
            }
        }

        function getWeekStartDate(year, week) {
            var date = new Date(year, 0, 1);
            while (date.getISOWeek() !== week) {
                date.setDate(date.getDate() + 1);
            }
            while (date.getDay() !== 1) {
                date.setDate(date.getDate() - 1);
            }
            return date;
        }

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
            
            fetch(ctxPath + '/dailyreport/weekly/polish', {
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
            var formData = new FormData(document.getElementById('weeklyForm'));
            formData.append('status', '0');
            fetch(ctxPath + '/dailyreport/weekly/save', {
                method: 'POST',
                body: formData
            }).then(function(response) {
                return response.json();
            }).then(function(result) {
                if (result.code === 200) {
                    alert('保存草稿成功');
                    window.location.href = ctxPath + '/dailyreport/weekly/list';
                } else {
                    alert(result.msg);
                }
            }).catch(function(error) {
                alert('保存失败');
            });
        }

        function submitReport() {
            var formData = new FormData(document.getElementById('weeklyForm'));
            formData.append('status', '1');
            fetch(ctxPath + '/dailyreport/weekly/save', {
                method: 'POST',
                body: formData
            }).then(function(response) {
                return response.json();
            }).then(function(result) {
                if (result.code === 200) {
                    alert('提交成功');
                    window.location.href = ctxPath + '/dailyreport/weekly/list';
                } else {
                    alert(result.msg);
                }
            }).catch(function(error) {
                alert('提交失败');
            });
        }

        function goBack() {
            window.location.href = ctxPath + '/dailyreport/weekly/list';
        }

        Date.prototype.getISOWeek = function() {
            var date = new Date(this.getTime());
            date.setHours(0, 0, 0, 0);
            date.setDate(date.getDate() + 3 - (date.getDay() + 6) % 7);
            var week1 = new Date(date.getFullYear(), 0, 4);
            return 1 + Math.round(((date.getTime() - week1.getTime()) / 86400000 - 3 + (week1.getDay() + 6) % 7) / 7);
        };
    </script>
</body>
</html>