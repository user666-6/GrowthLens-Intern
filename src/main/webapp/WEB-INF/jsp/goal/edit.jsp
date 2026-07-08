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
    <title>GrowthLens Intern - 编辑目标</title>
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
        .form-group { margin-bottom: 16px; }
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
                        编辑目标
                        <button class="btn btn-secondary btn-sm float-end" onclick="goBack()">返回</button>
                    </div>
                    <div class="card-body">
                        <form id="goalForm">
                            <input type="hidden" id="id" value="${goal.id}">
                            
                            <div class="form-group">
                                <label class="form-label">目标名称 *</label>
                                <input type="text" class="form-control" id="goalName" value="${goal.goalName}" required>
                            </div>
                            
                            <div class="form-group">
                                <label class="form-label">目标描述</label>
                                <textarea class="form-control" id="goalDesc" rows="3">${goal.goalDesc}</textarea>
                            </div>
                            
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label class="form-label">目标类型</label>
                                        <select class="form-select" id="goalType">
                                            <option value="study" ${goal.goalType == 'study' ? 'selected' : ''}>学习目标</option>
                                            <option value="work" ${goal.goalType == 'work' ? 'selected' : ''}>工作目标</option>
                                            <option value="intern" ${goal.goalType == 'intern' ? 'selected' : ''}>实习目标</option>
                                            <option value="other" ${goal.goalType == 'other' ? 'selected' : ''}>其他</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label class="form-label">优先级</label>
                                        <select class="form-select" id="priority">
                                            <option value="1" ${goal.priority == 1 ? 'selected' : ''}>高优先级</option>
                                            <option value="2" ${goal.priority == 2 ? 'selected' : ''}>中优先级</option>
                                            <option value="3" ${goal.priority == 3 ? 'selected' : ''}>低优先级</option>
                                        </select>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label class="form-label">开始日期</label>
                                        <input type="date" class="form-control" id="startDate" value="${goal.startDate}">
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label class="form-label">截止日期</label>
                                        <input type="date" class="form-control" id="endDate" value="${goal.endDate}">
                                    </div>
                                </div>
                            </div>
                            
                            <div class="form-group">
                                <label class="form-label">预期成果</label>
                                <textarea class="form-control" id="expectResult" rows="3">${goal.expectResult}</textarea>
                            </div>
                            
                            <div class="form-group">
                                <label class="form-label">状态</label>
                                <select class="form-select" id="status">
                                    <option value="0" ${goal.status == 0 ? 'selected' : ''}>已取消</option>
                                    <option value="1" ${goal.status == 1 ? 'selected' : ''}>未开始</option>
                                    <option value="2" ${goal.status == 2 ? 'selected' : ''}>进行中</option>
                                    <option value="3" ${goal.status == 3 ? 'selected' : ''}>已完成</option>
                                    <option value="4" ${goal.status == 4 ? 'selected' : ''}>已延期</option>
                                </select>
                            </div>
                            
                            <div class="mt-4">
                                <button type="button" class="btn btn-primary" onclick="submitForm()">保存修改</button>
                                <button type="button" class="btn btn-secondary ms-2" onclick="goBack()">取消</button>
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
        
        function goBack() {
            window.location.href = ctxPath + '/goal/list';
        }
        
        function submitForm() {
            var formData = new FormData();
            formData.append('id', document.getElementById('id').value);
            formData.append('goalName', document.getElementById('goalName').value);
            formData.append('goalDesc', document.getElementById('goalDesc').value);
            formData.append('goalType', document.getElementById('goalType').value);
            formData.append('priority', document.getElementById('priority').value);
            formData.append('startDate', document.getElementById('startDate').value);
            formData.append('endDate', document.getElementById('endDate').value);
            formData.append('expectResult', document.getElementById('expectResult').value);
            formData.append('status', document.getElementById('status').value);
            
            fetch(ctxPath + '/goal/edit', {
                method: 'POST',
                body: formData
            }).then(res => res.json()).then(result => {
                if (result.code === 200) {
                    alert('目标更新成功');
                    window.location.href = ctxPath + '/goal/detail/' + result.data.id;
                } else {
                    alert(result.msg);
                }
            }).catch(err => alert('提交失败'));
        }
    </script>
</body>
</html>