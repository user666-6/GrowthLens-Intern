<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    request.setAttribute("currentMenu", "interview");
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>GrowthLens Intern - 面经题库管理</title>
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
        .badge {
            padding: 4px 10px;
            border-radius: 12px;
            font-size: 12px;
        }
        .badge-danger {
            background-color: #fee2e2;
            color: #dc2626;
        }
        .badge-success {
            background-color: #dcfce7;
            color: #16a34a;
        }
        .badge-warning {
            background-color: #fef3c7;
            color: #d97706;
        }
        .badge-info {
            background-color: #dbeafe;
            color: #2563eb;
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
                        面试题库管理
                        <div class="float-end">
                            <button class="btn btn-primary btn-sm" id="btn-add">新增题目</button>
                            <button class="btn btn-secondary btn-sm" id="btn-category">分类管理</button>
                            <button class="btn btn-success btn-sm" id="btn-practice">刷题练习</button>
                        </div>
                    </div>
                    <div class="card-body">
                        <form class="mb-4" id="search-form" action="<%= request.getContextPath() %>/interview/list" method="GET">
                            <div class="row g-3">
                                <div class="col-md-3">
                                    <input type="text" class="form-control" name="keyword" placeholder="搜索题目..." value="${keyword}">
                                </div>
                                <div class="col-md-3">
                                    <select class="form-control" name="categoryId">
                                        <option value="">全部分类</option>
                                        <c:forEach items="${categories}" var="cat">
                                            <option value="${cat.id}" <c:if test="${categoryId == cat.id}">selected</c:if>>${cat.categoryName}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="col-md-2">
                                    <select class="form-control" name="isWrong">
                                        <option value="">全部状态</option>
                                        <option value="1" <c:if test="${isWrong == 1}">selected</c:if>>错题</option>
                                        <option value="0" <c:if test="${isWrong == 0}">selected</c:if>>正确</option>
                                    </select>
                                </div>
                                <div class="col-md-2">
                                    <select class="form-control" name="isCollected">
                                        <option value="">全部</option>
                                        <option value="1" <c:if test="${isCollected == 1}">selected</c:if>>已收藏</option>
                                        <option value="0" <c:if test="${isCollected == 0}">selected</c:if>>未收藏</option>
                                    </select>
                                </div>
                                <div class="col-md-2">
                                    <button type="submit" class="btn btn-primary w-100">搜索</button>
                                </div>
                            </div>
                        </form>

                        <table class="table table-striped">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>题目</th>
                                    <th>分类</th>
                                    <th>难度</th>
                                    <th>掌握程度</th>
                                    <th>来源</th>
                                    <th>标签</th>
                                    <th>操作</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${questions}" var="item">
                                    <tr>
                                        <td>${item.id}</td>
                                        <td>${item.questionTitle}</td>
                                        <td>
                                            <c:forEach items="${categories}" var="cat">
                                                <c:if test="${cat.id == item.categoryId}">${cat.categoryName}</c:if>
                                            </c:forEach>
                                            <c:if test="${item.categoryId == null}">未分类</c:if>
                                        </td>
                                        <td>
                                            <c:if test="${item.difficultyLevel == 1}"><span class="badge badge-success">简单</span></c:if>
                                            <c:if test="${item.difficultyLevel == 2}"><span class="badge badge-warning">中等</span></c:if>
                                            <c:if test="${item.difficultyLevel == 3}"><span class="badge badge-danger">困难</span></c:if>
                                        </td>
                                        <td>
                                            <c:if test="${item.masterLevel == 1}"><span class="badge badge-danger">不熟</span></c:if>
                                            <c:if test="${item.masterLevel == 2}"><span class="badge badge-warning">熟练</span></c:if>
                                            <c:if test="${item.masterLevel == 3}"><span class="badge badge-success">精通</span></c:if>
                                        </td>
                                        <td>${item.sourceCompany != null ? item.sourceCompany : '-'}</td>
                                        <td>
                                            <c:if test="${item.isCollected == 1}"><span class="badge badge-info">收藏</span></c:if>
                                            <c:if test="${item.isWrong == 1}"><span class="badge badge-danger">错题</span></c:if>
                                        </td>
                                        <td>
                                            <button class="btn btn-sm btn-primary btn-edit" data-id="${item.id}">编辑</button>
                                            <button class="btn btn-sm btn-warning btn-collect" data-id="${item.id}" data-collected="${item.isCollected}">
                                                ${item.isCollected == 1 ? '取消收藏' : '收藏'}
                                            </button>
                                            <button class="btn btn-sm btn-danger btn-mark-wrong" data-id="${item.id}" data-wrong="${item.isWrong}">
                                                ${item.isWrong == 1 ? '取消错题' : '标记错题'}
                                            </button>
                                            <button class="btn btn-sm btn-info btn-delete" data-id="${item.id}">删除</button>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty questions}">
                                    <tr>
                                        <td colspan="8" class="text-center text-muted">暂无数据</td>
                                    </tr>
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
        
        document.addEventListener('DOMContentLoaded', function() {
            document.getElementById('btn-add').addEventListener('click', function() {
                window.location.href = ctxPath + '/interview/add';
            });
            
            document.getElementById('btn-category').addEventListener('click', function() {
                window.location.href = ctxPath + '/interview/category';
            });
            
            document.getElementById('btn-practice').addEventListener('click', function() {
                window.location.href = ctxPath + '/interview/practice';
            });
            
            document.querySelectorAll('.btn-edit').forEach(function(btn) {
                btn.addEventListener('click', function() {
                    var id = this.dataset.id;
                    window.location.href = ctxPath + '/interview/edit/' + id;
                });
            });
            
            document.querySelectorAll('.btn-collect').forEach(function(btn) {
                btn.addEventListener('click', function() {
                    var id = this.dataset.id;
                    fetch(ctxPath + '/interview/collect/' + id, {
                        method: 'POST'
                    }).then(function(response) {
                        return response.json();
                    }).then(function(result) {
                        if (result.code === 200) {
                            alert(result.msg);
                            window.location.reload();
                        }
                    });
                });
            });
            
            document.querySelectorAll('.btn-mark-wrong').forEach(function(btn) {
                btn.addEventListener('click', function() {
                    var id = this.dataset.id;
                    fetch(ctxPath + '/interview/markWrong/' + id, {
                        method: 'POST'
                    }).then(function(response) {
                        return response.json();
                    }).then(function(result) {
                        if (result.code === 200) {
                            alert(result.msg);
                            window.location.reload();
                        }
                    });
                });
            });
            
            document.querySelectorAll('.btn-delete').forEach(function(btn) {
                btn.addEventListener('click', function() {
                    var id = this.dataset.id;
                    if (confirm('确定要删除这条题目吗？')) {
                        fetch(ctxPath + '/interview/delete/' + id, {
                            method: 'DELETE'
                        }).then(function(response) {
                            return response.json();
                        }).then(function(result) {
                            if (result.code === 200) {
                                alert('删除成功');
                                window.location.reload();
                            }
                        });
                    }
                });
            });
        });
    </script>
</body>
</html>