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
    <title>GrowthLens Intern - 编辑个人信息</title>
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
        .form-group {
            margin-bottom: 20px;
        }
        .form-label {
            font-weight: 500;
            margin-bottom: 8px;
            display: block;
        }
        .error-message {
            color: #dc3545;
            font-size: 12px;
            margin-top: 4px;
        }
        .avatar-preview {
            width: 100px;
            height: 100px;
            border-radius: 50%;
            object-fit: cover;
            border: 3px solid #667eea;
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
                        编辑个人信息
                        <button class="btn btn-secondary btn-sm float-end" id="btn-back">返回</button>
                    </div>
                    <div class="card-body">
                        <form id="editForm">
                            <input type="hidden" id="id" name="id" value="${user.id}">
                            
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label class="form-label">用户名</label>
                                        <input type="text" class="form-control" value="${user.username}" readonly>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label class="form-label">头像</label>
                                        <div class="mt-2">
                                            <img src="<c:if test="${user.avatar != null && !user.avatar.isEmpty()}">${user.avatar}</c:if><c:if test="${user.avatar == null || user.avatar.isEmpty()}">https://api.dicebear.com/7.x/avataaars/svg?seed=${user.username}</c:if>" class="avatar-preview" alt="头像">
                                        </div>
                                        <input type="text" class="form-control mt-2" id="avatar" name="avatar" value="${user.avatar != null ? user.avatar : ''}" placeholder="请输入头像URL">
                                    </div>
                                </div>
                            </div>
                            
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label class="form-label">昵称</label>
                                        <input type="text" class="form-control" id="nickname" name="nickname" value="${user.nickname != null ? user.nickname : ''}" placeholder="请输入昵称">
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label class="form-label">邮箱</label>
                                        <input type="email" class="form-control" id="email" name="email" value="${user.email != null ? user.email : ''}" placeholder="请输入邮箱">
                                        <div class="error-message" id="error-email"></div>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label class="form-label">手机号</label>
                                        <input type="tel" class="form-control" id="phone" name="phone" value="${user.phone != null ? user.phone : ''}" placeholder="请输入手机号">
                                    </div>
                                </div>
                            </div>
                            
                            <div class="mt-4">
                                <button type="button" class="btn btn-primary" id="btn-submit">保存修改</button>
                                <button type="button" class="btn btn-secondary ms-2" id="btn-reset">重置</button>
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
        
        document.addEventListener('DOMContentLoaded', function() {
            document.getElementById('btn-back').addEventListener('click', function() {
                window.location.href = ctxPath + '/user/profile/info';
            });
            
            document.getElementById('btn-reset').addEventListener('click', function() {
                document.getElementById('nickname').value = '<c:out value="${user.nickname}"/>';
                document.getElementById('email').value = '<c:out value="${user.email}"/>';
                document.getElementById('phone').value = '<c:out value="${user.phone}"/>';
                document.getElementById('avatar').value = '<c:out value="${user.avatar}"/>';
                clearErrors();
            });
            
            document.getElementById('btn-submit').addEventListener('click', function() {
                if (validateForm()) {
                    submitForm();
                }
            });
        });
        
        function clearErrors() {
            document.querySelectorAll('.error-message').forEach(function(el) {
                el.textContent = '';
            });
        }
        
        function validateForm() {
            clearErrors();
            var isValid = true;
            
            var email = document.getElementById('email').value;
            
            if (email && !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
                document.getElementById('error-email').textContent = '邮箱格式不正确';
                isValid = false;
            }
            
            return isValid;
        }
        
        function submitForm() {
            var formData = new FormData(document.getElementById('editForm'));
            
            fetch(ctxPath + '/user/profile/edit', {
                method: 'POST',
                body: formData
            }).then(function(response) {
                return response.json();
            }).then(function(result) {
                if (result.code === 200) {
                    alert('修改成功');
                    window.location.href = ctxPath + '/user/profile/info';
                } else {
                    alert(result.msg);
                }
            }).catch(function(error) {
                alert('提交失败');
            });
        }
    </script>
</body>
</html>