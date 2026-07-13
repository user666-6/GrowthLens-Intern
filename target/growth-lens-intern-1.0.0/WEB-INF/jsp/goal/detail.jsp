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
    <title>GrowthLens Intern - 目标详情</title>
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
        .progress-bar { background: linear-gradient(90deg, #667eea 0%, #764ba2 100%); }
        .badge { font-size: 0.75rem; padding: 0.35em 0.65em; }
        .task-card { margin-bottom: 12px; }
        .task-card.completed { opacity: 0.6; }
        .modal { display: none; }
        .modal.show { display: block; background-color: rgba(0,0,0,0.5); }
        .modal-dialog { margin-top: 10%; }
    </style>
</head>
<body>
    <div class="d-flex">
        <div class="sidebar-placeholder"></div>
        <jsp:include page="/WEB-INF/jsp/common/sidebar.jsp" />
        
        <div class="flex-grow-1">
            <jsp:include page="/WEB-INF/jsp/common/header.jsp" />
            
            <div class="main-content">
                <div class="card mb-4">
                    <div class="card-header">
                        ${goal.goalName}
                        <div class="float-end">
                            <button class="btn btn-secondary btn-sm" onclick="goBack()">返回列表</button>
                            <button class="btn btn-warning btn-sm ms-2" onclick="editGoal(${goal.id})">编辑</button>
                        </div>
                    </div>
                    <div class="card-body">
                        <div class="row mb-4">
                            <div class="col-md-3">
                                <span class="badge ${goal.priority == 1 ? 'bg-danger' : goal.priority == 2 ? 'bg-warning' : 'bg-secondary'}">
                                    ${goal.priority == 1 ? '高优先级' : goal.priority == 2 ? '中优先级' : '低优先级'}
                                </span>
                            </div>
                            <div class="col-md-3">
                                <span class="badge bg-info">
                                    <c:choose>
                                        <c:when test="${goal.goalType == 'study'}">学习目标</c:when>
                                        <c:when test="${goal.goalType == 'work'}">工作目标</c:when>
                                        <c:when test="${goal.goalType == 'intern'}">实习目标</c:when>
                                        <c:otherwise>其他</c:otherwise>
                                    </c:choose>
                                </span>
                            </div>
                            <div class="col-md-3">
                                <span class="badge ${goal.status == 3 ? 'bg-success' : goal.status == 2 ? 'bg-primary' : goal.status == 4 ? 'bg-danger' : 'bg-secondary'}">
                                    <c:choose>
                                        <c:when test="${goal.status == 0}">已取消</c:when>
                                        <c:when test="${goal.status == 1}">未开始</c:when>
                                        <c:when test="${goal.status == 2}">进行中</c:when>
                                        <c:when test="${goal.status == 3}">已完成</c:when>
                                        <c:when test="${goal.status == 4}">已延期</c:when>
                                    </c:choose>
                                </span>
                            </div>
                        </div>
                        
                        <div class="mb-4">
                            <label class="form-label fw-bold">完成进度</label>
                            <div class="progress" style="height: 30px;">
                                <div class="progress-bar" role="progressbar" style="width: ${goal.progress}%" aria-valuenow="${goal.progress}" aria-valuemin="0" aria-valuemax="100">
                                    ${goal.progress}%
                                </div>
                            </div>
                        </div>
                        
                        <div class="row mb-4">
                            <div class="col-md-6">
                                <label class="form-label fw-bold">时间范围</label>
                                <p>${goal.startDate} ~ ${goal.endDate}</p>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-bold">预期成果</label>
                                <p>${goal.expectResult != null ? goal.expectResult : '暂无'}</p>
                            </div>
                        </div>
                        
                        <div class="mb-4">
                            <label class="form-label fw-bold">目标描述</label>
                            <p>${goal.goalDesc != null ? goal.goalDesc : '暂无'}</p>
                        </div>
                    </div>
                </div>
                
                <div class="card">
                    <div class="card-header">
                        子任务列表
                        <button class="btn btn-primary btn-sm float-end" onclick="openAddTaskModal()">添加任务</button>
                    </div>
                    <div class="card-body">
                        <div class="btn-group mb-3" role="group">
                            <button class="btn btn-secondary btn-sm ${taskStatusFilter == null ? 'active' : ''}" onclick="filterTasks(null)">全部</button>
                            <button class="btn btn-secondary btn-sm ${taskStatusFilter == 1 ? 'active' : ''}" onclick="filterTasks(1)">待开始</button>
                            <button class="btn btn-secondary btn-sm ${taskStatusFilter == 2 ? 'active' : ''}" onclick="filterTasks(2)">进行中</button>
                            <button class="btn btn-secondary btn-sm ${taskStatusFilter == 3 ? 'active' : ''}" onclick="filterTasks(3)">已完成</button>
                        </div>
                        
                        <div id="taskList">
                            <c:forEach items="${tasks}" var="task">
                                <div class="card task-card ${task.status == 3 ? 'completed' : ''}" data-id="${task.id}">
                                    <div class="card-body">
                                        <div class="d-flex justify-content-between align-items-start">
                                            <div class="flex-grow-1">
                                                <h5 class="card-title">${task.taskName}</h5>
                                                <p class="card-text text-muted">${task.taskDesc != null ? task.taskDesc : '暂无描述'}</p>
                                                <div class="d-flex gap-3 mt-2">
                                                    <span class="badge ${task.priority == 1 ? 'bg-danger' : task.priority == 2 ? 'bg-warning' : 'bg-secondary'}">
                                                        ${task.priority == 1 ? '高' : task.priority == 2 ? '中' : '低'}
                                                    </span>
                                                    <span class="badge ${task.status == 3 ? 'bg-success' : task.status == 2 ? 'bg-primary' : task.status == 1 ? 'bg-secondary' : 'bg-danger'}">
                                                        <c:choose>
                                                            <c:when test="${task.status == 0}">已取消</c:when>
                                                            <c:when test="${task.status == 1}">待开始</c:when>
                                                            <c:when test="${task.status == 2}">进行中</c:when>
                                                            <c:when test="${task.status == 3}">已完成</c:when>
                                                        </c:choose>
                                                    </span>
                                                    <c:if test="${task.deadline != null}">
                                                        <span class="badge bg-info">截止: ${task.deadline}</span>
                                                    </c:if>
                                                </div>
                                            </div>
                                            <div class="flex-shrink-0 ml-4">
                                                <button class="btn btn-sm btn-outline-success" onclick="updateTaskStatus(${task.id}, 3)" ${task.status == 3 ? 'disabled' : ''}>完成</button>
                                                <button class="btn btn-sm btn-outline-primary" onclick="editTask(${task.id})">编辑</button>
                                                <button class="btn btn-sm btn-outline-danger" onclick="deleteTask(${task.id})">删除</button>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                            <c:if test="${empty tasks}">
                                <p class="text-center text-muted">暂无任务，请添加子任务</p>
                            </c:if>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="modal" id="taskModal">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="taskModalTitle">添加任务</h5>
                    <button type="button" class="btn-close" onclick="closeTaskModal()"></button>
                </div>
                <div class="modal-body">
                    <form id="taskForm">
                        <input type="hidden" id="taskId">
                        <input type="hidden" id="taskGoalId" value="${goal.id}">
                        
                        <div class="mb-3">
                            <label class="form-label">任务名称 *</label>
                            <input type="text" class="form-control" id="taskName" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">任务描述</label>
                            <textarea class="form-control" id="taskDesc" rows="2"></textarea>
                        </div>
                        <div class="row">
                            <div class="col-md-6">
                                <label class="form-label">优先级</label>
                                <select class="form-select" id="taskPriority">
                                    <option value="1">高</option>
                                    <option value="2" selected>中</option>
                                    <option value="3">低</option>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">截止日期</label>
                                <input type="date" class="form-control" id="taskDeadline">
                            </div>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">状态</label>
                            <select class="form-select" id="taskStatus">
                                <option value="1">待开始</option>
                                <option value="2">进行中</option>
                                <option value="3">已完成</option>
                            </select>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" onclick="closeTaskModal()">取消</button>
                    <button type="button" class="btn btn-primary" onclick="submitTask()">保存</button>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        var ctxPath = "<%= request.getContextPath() %>";
        var goalId = ${goal.id};
        
        function goBack() {
            window.location.href = ctxPath + '/goal/list';
        }
        
        function editGoal(id) {
            window.location.href = ctxPath + '/goal/edit/' + id;
        }
        
        function filterTasks(status) {
            window.location.href = ctxPath + '/goal/detail/' + goalId + (status != null ? '?status=' + status : '');
        }
        
        function openAddTaskModal() {
            document.getElementById('taskModalTitle').textContent = '添加任务';
            document.getElementById('taskId').value = '';
            document.getElementById('taskName').value = '';
            document.getElementById('taskDesc').value = '';
            document.getElementById('taskPriority').value = '2';
            document.getElementById('taskDeadline').value = '';
            document.getElementById('taskStatus').value = '1';
            document.getElementById('taskModal').classList.add('show');
        }
        
        function editTask(id) {
            fetch(ctxPath + '/goal/api/tasks/' + goalId)
                .then(res => res.json())
                .then(result => {
                    if (result.code === 200) {
                        var task = result.data.find(t => t.id == id);
                        if (task) {
                            document.getElementById('taskModalTitle').textContent = '编辑任务';
                            document.getElementById('taskId').value = task.id;
                            document.getElementById('taskName').value = task.taskName;
                            document.getElementById('taskDesc').value = task.taskDesc || '';
                            document.getElementById('taskPriority').value = task.priority;
                            document.getElementById('taskDeadline').value = task.deadline || '';
                            document.getElementById('taskStatus').value = task.status;
                            document.getElementById('taskModal').classList.add('show');
                        }
                    }
                });
        }
        
        function closeTaskModal() {
            document.getElementById('taskModal').classList.remove('show');
        }
        
        function submitTask() {
            var taskId = document.getElementById('taskId').value;
            var url = taskId ? ctxPath + '/goal/task/update' : ctxPath + '/goal/task/add';
            var formData = new FormData();
            
            if (taskId) {
                formData.append('id', taskId);
            }
            formData.append('goalId', goalId);
            formData.append('taskName', document.getElementById('taskName').value);
            formData.append('taskDesc', document.getElementById('taskDesc').value);
            formData.append('priority', document.getElementById('taskPriority').value);
            formData.append('deadline', document.getElementById('taskDeadline').value);
            formData.append('status', document.getElementById('taskStatus').value);
            
            fetch(url, { method: 'POST', body: formData })
                .then(res => res.json())
                .then(result => {
                    if (result.code === 200) {
                        alert(taskId ? '任务更新成功' : '任务添加成功');
                        closeTaskModal();
                        window.location.reload();
                    } else {
                        alert(result.msg);
                    }
                }).catch(err => alert('提交失败'));
        }
        
        function updateTaskStatus(id, status) {
            fetch(ctxPath + '/goal/task/status/' + id + '/' + status, { method: 'POST' })
                .then(res => res.json())
                .then(result => {
                    if (result.code === 200) {
                        window.location.reload();
                    } else {
                        alert(result.msg);
                    }
                }).catch(err => alert('操作失败'));
        }
        
        function deleteTask(id) {
            if (confirm('确定要删除这个任务吗？')) {
                fetch(ctxPath + '/goal/task/delete/' + id, { method: 'POST' })
                    .then(res => res.json())
                    .then(result => {
                        if (result.code === 200) {
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