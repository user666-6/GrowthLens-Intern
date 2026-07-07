<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    request.setAttribute("currentMenu", "usermanage");
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>GrowthLens Intern - 用户管理</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
            background-color: #f8f9fa;
        }
        .sidebar {
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
            margin-bottom: 20px;
            padding: 16px;
            background: #f8f9fa;
            border-radius: 8px;
        }
        .search-form .form-group {
            margin-bottom: 0;
        }
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
                        用户管理
                        <button class="btn btn-primary btn-sm float-end" id="btn-add">新增用户</button>
                    </div>
                    <div class="card-body">
                        <div class="search-form row">
                            <div class="col-md-3">
                                <input type="text" class="form-control" id="search-username" placeholder="用户名" value="${username != null ? username : ''}">
                            </div>
                            <div class="col-md-3">
                                <input type="text" class="form-control" id="search-nickname" placeholder="昵称" value="${nickname != null ? nickname : ''}">
                            </div>
                            <div class="col-md-3">
                                <select class="form-control" id="search-status">
                                    <option value="">全部状态</option>
                                    <option value="1" <c:if test="${status == 1}">selected</c:if>>启用</option>
                                    <option value="0" <c:if test="${status == 0}">selected</c:if>>禁用</option>
                                </select>
                            </div>
                            <div class="col-md-3">
                                <button class="btn btn-primary" id="btn-search">搜索</button>
                                <button class="btn btn-secondary ms-2" id="btn-reset">重置</button>
                            </div>
                        </div>
                        
                        <table class="table table-striped">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>用户名</th>
                                    <th>昵称</th>
                                    <th>邮箱</th>
                                    <th>手机号</th>
                                    <th>状态</th>
                                    <th>创建时间</th>
                                    <th>操作</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${pageInfo.list}" var="user">
                                    <tr>
                                        <td>${user.id}</td>
                                        <td>${user.username}</td>
                                        <td>${user.nickname != null ? user.nickname : '-'}</td>
                                        <td>${user.email != null ? user.email : '-'}</td>
                                        <td>${user.phone != null ? user.phone : '-'}</td>
                                        <td>
                                            <c:if test="${user.status == 1}">
                                                <span class="text-success">启用</span>
                                            </c:if>
                                            <c:if test="${user.status == 0}">
                                                <span class="text-danger">禁用</span>
                                            </c:if>
                                        </td>
                                        <td>${user.createTime}</td>
                                        <td>
                                            <button class="btn btn-sm btn-warning btn-edit" data-id="${user.id}">编辑</button>
                                            <button class="btn btn-sm btn-danger btn-delete" data-id="${user.id}">删除</button>
                                            <button class="btn btn-sm btn-info btn-status" data-id="${user.id}" data-status="${user.status}">
                                                ${user.status == 1 ? '禁用' : '启用'}
                                            </button>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty pageInfo.list}">
                                    <tr>
                                        <td colspan="8" class="text-center text-muted">暂无数据</td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                        
                        <div class="page-info">
                            共 ${pageInfo.total} 条记录，当前第 ${pageInfo.pageNum} / ${pageInfo.pages} 页
                            <div class="mt-2">
                                <c:if test="${pageInfo.hasPreviousPage}">
                                    <a href="list?pageNum=${pageInfo.prePage}&username=${username != null ? username : ''}&nickname=${nickname != null ? nickname : ''}&status=${status != null ? status : ''}" class="btn btn-sm btn-outline-secondary">上一页</a>
                                </c:if>
                                <c:if test="${pageInfo.hasNextPage}">
                                    <a href="list?pageNum=${pageInfo.nextPage}&username=${username != null ? username : ''}&nickname=${nickname != null ? nickname : ''}&status=${status != null ? status : ''}" class="btn btn-sm btn-outline-secondary">下一页</a>
                                </c:if>
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
        
        document.addEventListener('DOMContentLoaded', function() {
            document.getElementById('btn-add').addEventListener('click', function() {
                window.location.href = ctxPath + '/user/manage/add';
            });
            
            document.getElementById('btn-search').addEventListener('click', function() {
                var username = document.getElementById('search-username').value;
                var nickname = document.getElementById('search-nickname').value;
                var status = document.getElementById('search-status').value;
                var url = ctxPath + '/user/manage/list?pageNum=1';
                if (username) url += '&username=' + encodeURIComponent(username);
                if (nickname) url += '&nickname=' + encodeURIComponent(nickname);
                if (status) url += '&status=' + status;
                window.location.href = url;
            });
            
            document.getElementById('btn-reset').addEventListener('click', function() {
                window.location.href = ctxPath + '/user/manage/list';
            });
            
            document.querySelectorAll('.btn-edit').forEach(function(btn) {
                btn.addEventListener('click', function() {
                    var id = this.dataset.id;
                    window.location.href = ctxPath + '/user/manage/edit/' + id;
                });
            });
            
            document.querySelectorAll('.btn-delete').forEach(function(btn) {
                btn.addEventListener('click', function() {
                    var id = this.dataset.id;
                    if (id == 1) {
                        alert('超级管理员账号禁止删除');
                        return;
                    }
                    if (confirm('确定要删除该用户吗？')) {
                        fetch(ctxPath + '/user/manage/delete/' + id, {
                            method: 'POST'
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
                });
            });
            
            document.querySelectorAll('.btn-status').forEach(function(btn) {
                btn.addEventListener('click', function() {
                    var id = this.dataset.id;
                    if (id == 1) {
                        alert('超级管理员账号状态禁止修改');
                        return;
                    }
                    var status = this.dataset.status;
                    var action = status == 1 ? '禁用' : '启用';
                    if (confirm('确定要' + action + '该用户吗？')) {
                        fetch(ctxPath + '/user/manage/status/' + id, {
                            method: 'POST'
                        }).then(function(response) {
                            return response.json();
                        }).then(function(result) {
                            if (result.code === 200) {
                                alert(result.msg);
                                window.location.reload();
                            } else {
                                alert(result.msg);
                            }
                        }).catch(function(error) {
                            alert('操作失败');
                        });
                    }
                });
            });
        });
    </script>
</body>
</html>