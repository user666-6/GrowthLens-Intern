<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    request.setAttribute("currentMenu", "chat");
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>GrowthLens Intern - 历史记录</title>
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
        .nav-tabs {
            margin-bottom: 20px;
            border-bottom: 1px solid #dee2e6;
        }
        .nav-tabs .nav-link {
            color: #666;
            border: none;
            padding: 10px 20px;
        }
        .nav-tabs .nav-link.active {
            color: #667eea;
            border-bottom: 2px solid #667eea;
            font-weight: 600;
            background: none;
        }
        .filter-bar {
            display: flex;
            gap: 12px;
            margin-bottom: 20px;
            align-items: center;
            flex-wrap: wrap;
        }
        .filter-bar .form-select {
            width: auto;
        }
        .scene-tag {
            display: inline-block;
            padding: 2px 10px;
            border-radius: 12px;
            font-size: 12px;
            background-color: #e9ecef;
            color: #666;
        }
        .scene-tag.free {
            background-color: #e3f2fd;
            color: #1976d2;
        }
        .scene-tag.script {
            background-color: #fff3e0;
            color: #f57c00;
        }
        .scene-tag.plan {
            background-color: #e8f5e9;
            color: #388e3c;
        }
        .question-text {
            max-width: 300px;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
            display: inline-block;
            vertical-align: middle;
        }
        .modal-body {
            max-height: 60vh;
            overflow-y: auto;
        }
        .answer-content {
            white-space: pre-wrap;
            line-height: 1.8;
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
                        职场智能助手
                    </div>
                    <div class="card-body">
                        <ul class="nav nav-tabs">
                            <li class="nav-item">
                                <a class="nav-link" href="<%= request.getContextPath() %>/chat/index">自由问答</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="<%= request.getContextPath() %>/chat/script">话术生成</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="<%= request.getContextPath() %>/chat/plan">学习规划</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link active" href="<%= request.getContextPath() %>/chat/history">历史记录</a>
                            </li>
                        </ul>

                        <div class="filter-bar">
                            <label class="form-label mb-0">场景筛选：</label>
                            <select class="form-select form-select-sm" id="sceneFilter" onchange="filterByScene()">
                                <option value="">全部场景</option>
                                <option value="free" <c:if test="${sceneType == 'free'}">selected</c:if>>自由问答</option>
                                <option value="script" <c:if test="${sceneType == 'script'}">selected</c:if>>话术生成</option>
                                <option value="plan" <c:if test="${sceneType == 'plan'}">selected</c:if>>学习规划</option>
                            </select>
                            <button class="btn btn-outline-warning btn-sm" onclick="filterByCollection()">
                                <c:if test="${isCollected == 1}">取消收藏筛选</c:if>
                                <c:if test="${isCollected != 1}">只看收藏</c:if>
                            </button>
                        </div>

                        <table class="table table-striped">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>场景</th>
                                    <th>问题/输入</th>
                                    <th>收藏</th>
                                    <th>创建时间</th>
                                    <th>操作</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${pageInfo.list}" var="item">
                                    <tr>
                                        <td>${item.id}</td>
                                        <td>
                                            <span class="scene-tag ${item.sceneType}">
                                                <c:if test="${item.sceneType == 'free'}">自由问答</c:if>
                                                <c:if test="${item.sceneType == 'script'}">话术生成</c:if>
                                                <c:if test="${item.sceneType == 'plan'}">学习规划</c:if>
                                            </span>
                                        </td>
                                        <td>
                                            <span class="question-text" title="${item.userQuestion}">${item.userQuestion}</span>
                                        </td>
                                        <td>
                                            <c:if test="${item.isCollected == 1}">
                                                <span class="text-warning">★ 已收藏</span>
                                            </c:if>
                                            <c:if test="${item.isCollected != 1}">
                                                <span class="text-muted">☆</span>
                                            </c:if>
                                        </td>
                                        <td>${item.createTime}</td>
                                        <td>
                                            <button class="btn btn-sm btn-info btn-view" data-id="${item.id}">查看</button>
                                            <button class="btn btn-sm btn-warning btn-collect" data-id="${item.id}" data-collected="${item.isCollected}">
                                                <c:if test="${item.isCollected == 1}">取消收藏</c:if>
                                                <c:if test="${item.isCollected != 1}">收藏</c:if>
                                            </button>
                                            <button class="btn btn-sm btn-danger btn-delete" data-id="${item.id}">删除</button>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty pageInfo.list}">
                                    <tr>
                                        <td colspan="6" class="text-center text-muted">暂无记录</td>
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

    <div class="modal fade" id="detailModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">对话详情</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body" id="modalBody">
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">关闭</button>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        var ctxPath = "<%= request.getContextPath() %>";
        var currentSceneType = "${sceneType}";
        var currentIsCollected = "${isCollected}";

        function filterByScene() {
            var sceneType = document.getElementById('sceneFilter').value;
            var url = ctxPath + '/chat/history?pageNum=1&pageSize=10';
            if (sceneType) {
                url += '&sceneType=' + sceneType;
            }
            if (currentIsCollected == 1) {
                url += '&isCollected=1';
            }
            window.location.href = url;
        }

        function filterByCollection() {
            var url = ctxPath + '/chat/history?pageNum=1&pageSize=10';
            if (currentIsCollected != 1) {
                url += '&isCollected=1';
            }
            if (currentSceneType) {
                url += '&sceneType=' + currentSceneType;
            }
            window.location.href = url;
        }

        document.addEventListener('DOMContentLoaded', function() {
            document.querySelectorAll('.btn-view').forEach(function(btn) {
                btn.addEventListener('click', function() {
                    var id = this.dataset.id;
                    viewDetail(id);
                });
            });

            document.querySelectorAll('.btn-collect').forEach(function(btn) {
                btn.addEventListener('click', function() {
                    var id = this.dataset.id;
                    var collected = this.dataset.collected;
                    var newCollected = collected == 1 ? 0 : 1;
                    toggleCollection(id, newCollected);
                });
            });

            document.querySelectorAll('.btn-delete').forEach(function(btn) {
                btn.addEventListener('click', function() {
                    var id = this.dataset.id;
                    if (confirm('确定要删除这条记录吗？')) {
                        deleteRecord(id);
                    }
                });
            });
        });

        function viewDetail(id) {
            fetch(ctxPath + '/chat/record/' + id)
                .then(function(response) { return response.json(); })
                .then(function(result) {
                    if (result.code === 200) {
                        var record = result.data;
                        var sceneText = '';
                        if (record.sceneType == 'free') sceneText = '自由问答';
                        else if (record.sceneType == 'script') sceneText = '话术生成';
                        else if (record.sceneType == 'plan') sceneText = '学习规划';

                        var html = '<div class="mb-3"><strong>场景：</strong>' + sceneText + '</div>';
                        html += '<div class="mb-3"><strong>问题/输入：</strong><p>' + record.userQuestion + '</p></div>';
                        html += '<div class="mb-3"><strong>AI回答：</strong><div class="answer-content">' + record.aiAnswer + '</div></div>';
                        html += '<div class="text-muted"><small>创建时间：' + record.createTime + '</small></div>';

                        document.getElementById('modalBody').innerHTML = html;
                        var modal = new bootstrap.Modal(document.getElementById('detailModal'));
                        modal.show();
                    } else {
                        alert('获取详情失败');
                    }
                });
        }

        function toggleCollection(id, isCollected) {
            var formData = new FormData();
            formData.append('isCollected', isCollected);
            fetch(ctxPath + '/chat/collect/' + id, {
                method: 'POST',
                body: formData
            }).then(function(response) {
                return response.json();
            }).then(function(result) {
                if (result.code === 200) {
                    window.location.reload();
                } else {
                    alert(result.msg);
                }
            });
        }

        function deleteRecord(id) {
            fetch(ctxPath + '/chat/delete/' + id, {
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
            });
        }
    </script>
</body>
</html>
