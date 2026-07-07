<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    request.setAttribute("currentMenu", "profile");
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>GrowthLens Intern - 个人信息</title>
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
            padding: 24px;
        }
        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
        }
        .btn-primary:hover {
            opacity: 0.9;
        }
        .avatar-preview {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            object-fit: cover;
            border: 3px solid #667eea;
        }
        .info-row {
            margin-bottom: 16px;
        }
        .info-label {
            font-weight: 500;
            color: #666;
        }
        .info-value {
            color: #333;
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
                        个人信息
                        <button class="btn btn-primary btn-sm float-end" id="btn-edit">编辑信息</button>
                    </div>
                    <div class="card-body">
                        <div class="row mb-6">
                            <div class="col-md-3 text-center">
                                <img src="<c:if test="${user.avatar != null && !user.avatar.isEmpty()}">${user.avatar}</c:if><c:if test="${user.avatar == null || user.avatar.isEmpty()}">https://api.dicebear.com/7.x/avataaars/svg?seed=${user.username}</c:if>" class="avatar-preview" alt="头像">
                                <div class="mt-2">
                                    <button class="btn btn-sm btn-outline-primary" id="btn-change-avatar">更换头像</button>
                                </div>
                            </div>
                            <div class="col-md-9">
                                <div class="info-row">
                                    <span class="info-label">用户名：</span>
                                    <span class="info-value">${user.username}</span>
                                </div>
                                <div class="info-row">
                                    <span class="info-label">昵称：</span>
                                    <span class="info-value">${user.nickname != null ? user.nickname : '-'}</span>
                                </div>
                                <div class="info-row">
                                    <span class="info-label">邮箱：</span>
                                    <span class="info-value">${user.email != null ? user.email : '-'}</span>
                                </div>
                                <div class="info-row">
                                    <span class="info-label">手机号：</span>
                                    <span class="info-value">${user.phone != null ? user.phone : '-'}</span>
                                </div>
                                <div class="info-row">
                                    <span class="info-label">状态：</span>
                                    <span class="info-value">${user.status == 1 ? '启用' : '禁用'}</span>
                                </div>
                            </div>
                        </div>
                        
                        <hr>
                        
                        <div class="row">
                            <div class="col-md-6">
                                <div class="info-row">
                                    <span class="info-label">用户ID：</span>
                                    <span class="info-value">${user.id}</span>
                                </div>
                                <div class="info-row">
                                    <span class="info-label">创建时间：</span>
                                    <span class="info-value">${user.createTime}</span>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="info-row">
                                    <span class="info-label">更新时间：</span>
                                    <span class="info-value">${user.updateTime}</span>
                                </div>
                                <div class="info-row mt-4">
                                    <button class="btn btn-outline-secondary" id="btn-change-password">修改密码</button>
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
        
        document.addEventListener('DOMContentLoaded', function() {
            document.getElementById('btn-edit').addEventListener('click', function() {
                window.location.href = ctxPath + '/user/profile/edit';
            });
            
            document.getElementById('btn-change-password').addEventListener('click', function() {
                window.location.href = ctxPath + '/user/profile/password';
            });
            
            document.getElementById('btn-change-avatar').addEventListener('click', function() {
                var avatarUrl = prompt('请输入头像URL地址：');
                if (avatarUrl) {
                    fetch(ctxPath + '/user/profile/edit', {
                        method: 'POST',
                        body: new URLSearchParams({
                            avatar: avatarUrl
                        })
                    }).then(function(response) {
                        return response.json();
                    }).then(function(result) {
                        if (result.code === 200) {
                            location.reload();
                        } else {
                            alert(result.msg);
                        }
                    }).catch(function(error) {
                        alert('更新失败');
                    });
                }
            });
        });
    </script>
</body>
</html>