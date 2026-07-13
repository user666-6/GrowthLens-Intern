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
    <title>GrowthLens Intern - 新增目标</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif; background-color: #f8f9fa; }
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
                        新增目标
                        <button class="btn btn-secondary btn-sm float-end" onclick="goBack()">返回</button>
                    </div>
                    <div class="card-body">
                        <form id="goalForm">
                            <div class="form-group">
                                <label class="form-label">目标名称 *</label>
                                <input type="text" class="form-control" id="goalName" placeholder="请输入目标名称" required>
                            </div>
                            
                            <div class="form-group">
                                <label class="form-label">目标描述</label>
                                <textarea class="form-control" id="goalDesc" rows="3" placeholder="请输入目标描述"></textarea>
                            </div>
                            
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label class="form-label">目标类型</label>
                                        <select class="form-select" id="goalType">
                                            <option value="study">学习目标</option>
                                            <option value="work">工作目标</option>
                                            <option value="intern">实习目标</option>
                                            <option value="other">其他</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label class="form-label">优先级</label>
                                        <select class="form-select" id="priority">
                                            <option value="1">高优先级</option>
                                            <option value="2" selected>中优先级</option>
                                            <option value="3">低优先级</option>
                                        </select>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label class="form-label">开始日期</label>
                                        <input type="date" class="form-control" id="startDate">
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label class="form-label">截止日期</label>
                                        <input type="date" class="form-control" id="endDate">
                                    </div>
                                </div>
                            </div>
                            
                            <div class="form-group">
                                <label class="form-label">预期成果</label>
                                <textarea class="form-control" id="expectResult" rows="3" placeholder="请输入预期成果"></textarea>
                            </div>
                            
                            <div class="mt-4">
                                <button type="button" class="btn btn-primary" onclick="submitForm()">保存目标</button>
                                <button type="button" class="btn btn-secondary ms-2" onclick="goBack()">取消</button>
                                <button type="button" class="btn btn-outline-info ms-2" onclick="generateSmartGoals()">AI智能拆解</button>
                            </div>
                        </form>
                        
                        <div id="smartResult" class="mt-4 d-none">
                            <div class="card">
                                <div class="card-header">AI智能拆解结果</div>
                                <div class="card-body">
                                    <pre id="smartContent" class="bg-light p-3 rounded"></pre>
                                    <button class="btn btn-sm btn-primary mt-2" onclick="applySmartGoals()">应用拆解结果</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        var ctxPath = "<%= request.getContextPath() %>";
        var smartResultData = null;
        
        function goBack() {
            window.location.href = ctxPath + '/goal/list';
        }
        
        function submitForm() {
            var formData = new FormData();
            formData.append('goalName', document.getElementById('goalName').value);
            formData.append('goalDesc', document.getElementById('goalDesc').value);
            formData.append('goalType', document.getElementById('goalType').value);
            formData.append('priority', document.getElementById('priority').value);
            formData.append('startDate', document.getElementById('startDate').value);
            formData.append('endDate', document.getElementById('endDate').value);
            formData.append('expectResult', document.getElementById('expectResult').value);
            
            fetch(ctxPath + '/goal/add', {
                method: 'POST',
                body: formData
            }).then(res => res.json()).then(result => {
                if (result.code === 200) {
                    alert('目标创建成功');
                    window.location.href = ctxPath + '/goal/detail/' + result.data.id;
                } else {
                    alert(result.msg);
                }
            }).catch(err => alert('提交失败'));
        }
        
        function generateSmartGoals() {
            var goalName = document.getElementById('goalName').value;
            var goalDesc = document.getElementById('goalDesc').value;
            var endDate = document.getElementById('endDate').value;
            
            if (!goalName) {
                alert('请先输入目标名称');
                return;
            }

            var btn = document.querySelector('.btn-outline-info');
            var originalText = btn.textContent;
            btn.disabled = true;
            btn.textContent = '拆解中...';
            
            var duration = 30;
            if (endDate) {
                var start = new Date();
                var end = new Date(endDate);
                duration = Math.ceil((end - start) / (1000 * 60 * 60 * 24));
                if (duration < 1) duration = 30;
            }
            
            fetch(ctxPath + '/goal/smart/generate', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: 'goalName=' + encodeURIComponent(goalName) + '&goalDesc=' + encodeURIComponent(goalDesc) + '&duration=' + duration
            }).then(res => res.json()).then(result => {
                if (result.code === 200) {
                    smartResultData = result.data;
                    document.getElementById('smartContent').textContent = result.data;
                    document.getElementById('smartResult').classList.remove('d-none');
                } else {
                    alert(result.msg);
                }
            }).catch(err => alert('AI拆解失败')).finally(function() {
                btn.disabled = false;
                btn.textContent = originalText;
            });
        }
        
        function applySmartGoals() {
            if (!smartResultData) {
                alert('请先生成AI拆解结果');
                return;
            }
            
            var formData = new FormData();
            formData.append('goalName', document.getElementById('goalName').value);
            formData.append('goalDesc', document.getElementById('goalDesc').value || '');
            formData.append('goalType', document.getElementById('goalType').value);
            formData.append('priority', parseInt(document.getElementById('priority').value));
            formData.append('startDate', document.getElementById('startDate').value || '');
            formData.append('endDate', document.getElementById('endDate').value || '');
            formData.append('expectResult', document.getElementById('expectResult').value || '');
            
            fetch(ctxPath + '/goal/smart/save', {
                method: 'POST',
                body: formData
            }).then(res => res.json()).then(result => {
                if (result.code === 200) {
                    var data = result.data;
                    alert('目标创建成功，已自动生成 ' + data.taskCount + ' 个任务');
                    window.location.href = ctxPath + '/goal/detail/' + data.goalId;
                } else {
                    alert(result.msg);
                }
            }).catch(err => alert('应用拆解失败: ' + err.message));
        }
    </script>
</body>
</html>