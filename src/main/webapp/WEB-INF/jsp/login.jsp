<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>登录 - GrowthLens Intern</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .login-container {
            background: white;
            border-radius: 12px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
            padding: 40px;
            width: 100%;
            max-width: 420px;
        }
        .login-title {
            text-align: center;
            margin-bottom: 30px;
            color: #333;
        }
        .login-title h1 {
            font-size: 28px;
            font-weight: 600;
        }
        .login-title p {
            color: #666;
            margin-top: 8px;
        }
        .form-group {
            margin-bottom: 20px;
        }
        .btn-login {
            width: 100%;
            padding: 12px;
            font-size: 16px;
            font-weight: 500;
        }
        .register-link {
            text-align: center;
            margin-top: 20px;
        }
        .register-link a {
            color: #667eea;
            text-decoration: none;
        }
        .register-link a:hover {
            text-decoration: underline;
        }
        .alert-message {
            margin-bottom: 15px;
        }
    </style>
</head>
<body>
    <div class="login-container">
        <div class="login-title">
            <h1>🚀 GrowthLens</h1>
            <p>欢迎来到实训平台</p>
        </div>
        
        <c:if test="${not empty errorMsg}">
            <div class="alert alert-danger alert-message">${errorMsg}</div>
        </c:if>
        
        <form id="loginForm">
            <div class="form-group">
                <label for="username" class="form-label">用户名</label>
                <input type="text" class="form-control" id="username" placeholder="请输入用户名" required>
            </div>
            <div class="form-group">
                <label for="password" class="form-label">密码</label>
                <input type="password" class="form-control" id="password" placeholder="请输入密码" required>
            </div>
            <button type="submit" class="btn btn-primary btn-login">登 录</button>
        </form>
        
        <div class="register-link">
            <span>还没有账号？</span>
            <a href="javascript:void(0)" id="registerLink">立即注册</a>
        </div>
    </div>

    <div class="modal fade" id="registerModal" tabindex="-1" aria-labelledby="registerModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="registerModalLabel">用户注册</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form id="registerForm">
                        <div class="mb-3">
                            <label for="regUsername" class="form-label">用户名</label>
                            <input type="text" class="form-control" id="regUsername" placeholder="请输入用户名" required>
                        </div>
                        <div class="mb-3">
                            <label for="regPassword" class="form-label">密码</label>
                            <input type="password" class="form-control" id="regPassword" placeholder="请输入密码" required>
                        </div>
                        <div class="mb-3">
                            <label for="regEmail" class="form-label">邮箱</label>
                            <input type="email" class="form-control" id="regEmail" placeholder="请输入邮箱" required>
                        </div>
                        <div class="mb-3">
                            <label for="regNickname" class="form-label">昵称</label>
                            <input type="text" class="form-control" id="regNickname" placeholder="请输入昵称">
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">取消</button>
                    <button type="button" class="btn btn-primary" id="btnRegister">注册</button>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        const ctxPath = "${pageContext.request.contextPath}";
        
        document.getElementById('loginForm').addEventListener('submit', async function(e) {
            e.preventDefault();
            const username = document.getElementById('username').value;
            const password = document.getElementById('password').value;
            
            try {
                const response = await fetch(ctxPath + '/user/login', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: 'username=' + encodeURIComponent(username) + '&password=' + encodeURIComponent(password)
                });
                const result = await response.json();
                
                if (result.code === 200) {
                    window.location.href = ctxPath + '/?t=' + new Date().getTime();
                } else {
                    alert(result.msg);
                }
            } catch (error) {
                alert('登录失败，请稍后重试');
            }
        });
        
        document.getElementById('registerLink').addEventListener('click', function() {
            const modal = new bootstrap.Modal(document.getElementById('registerModal'));
            modal.show();
        });
        
        document.getElementById('btnRegister').addEventListener('click', async function() {
            const username = document.getElementById('regUsername').value;
            const password = document.getElementById('regPassword').value;
            const email = document.getElementById('regEmail').value;
            const nickname = document.getElementById('regNickname').value;
            
            try {
                const response = await fetch(ctxPath + '/user/register', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                    },
                    body: JSON.stringify({
                        username: username,
                        password: password,
                        email: email,
                        nickname: nickname || username
                    })
                });
                const result = await response.json();
                
                if (result.code === 200) {
                    alert('注册成功，请登录');
                    const modal = bootstrap.Modal.getInstance(document.getElementById('registerModal'));
                    modal.hide();
                } else {
                    alert(result.msg);
                }
            } catch (error) {
                alert('注册失败，请稍后重试');
            }
        });
    </script>
</body>
</html>