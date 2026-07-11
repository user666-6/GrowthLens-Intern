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
    <title>GrowthLens Intern - 修改密码</title>
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
                        修改密码
                        <button class="btn btn-secondary btn-sm float-end" id="btn-back">返回</button>
                    </div>
                    <div class="card-body">
                        <form id="passwordForm">
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label class="form-label">原密码</label>
                                        <input type="password" class="form-control" id="oldPassword" name="oldPassword" placeholder="请输入原密码">
                                        <div class="error-message" id="error-oldPassword"></div>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label class="form-label">新密码</label>
                                        <input type="password" class="form-control" id="newPassword" name="newPassword" placeholder="请输入新密码（至少6位）">
                                        <div class="error-message" id="error-newPassword"></div>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label class="form-label">确认新密码</label>
                                        <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" placeholder="请再次输入新密码">
                                        <div class="error-message" id="error-confirmPassword"></div>
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
                document.getElementById('oldPassword').value = '';
                document.getElementById('newPassword').value = '';
                document.getElementById('confirmPassword').value = '';
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
            
            var oldPassword = document.getElementById('oldPassword').value;
            var newPassword = document.getElementById('newPassword').value;
            var confirmPassword = document.getElementById('confirmPassword').value;
            
            if (!oldPassword) {
                document.getElementById('error-oldPassword').textContent = '请输入原密码';
                isValid = false;
            }
            
            if (!newPassword) {
                document.getElementById('error-newPassword').textContent = '请输入新密码';
                isValid = false;
            } else if (newPassword.length < 6) {
                document.getElementById('error-newPassword').textContent = '新密码长度至少6位';
                isValid = false;
            }
            
            if (!confirmPassword) {
                document.getElementById('error-confirmPassword').textContent = '请确认新密码';
                isValid = false;
            } else if (newPassword !== confirmPassword) {
                document.getElementById('error-confirmPassword').textContent = '两次输入的密码不一致';
                isValid = false;
            }
            
            return isValid;
        }
        
        function submitForm() {
            var formData = new FormData(document.getElementById('passwordForm'));
            
            fetch(ctxPath + '/user/profile/password', {
                method: 'POST',
                body: formData
            }).then(function(response) {
                return response.json();
            }).then(function(result) {
                if (result.code === 200) {
                    alert('密码修改成功，请重新登录');
                    window.location.href = ctxPath + '/logout';
                } else {
                    if (result.msg === '原密码错误') {
                        document.getElementById('error-oldPassword').textContent = '原密码错误';
                    } else {
                        alert(result.msg);
                    }
                }
            }).catch(function(error) {
                alert('提交失败');
            });
        }
    </script>
</body>
</html>