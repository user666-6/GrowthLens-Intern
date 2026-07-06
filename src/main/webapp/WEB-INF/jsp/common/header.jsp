<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String ctxPath = request.getContextPath();
%>
<nav class="navbar">
    <span class="navbar-brand mb-0 h1">GrowthLens</span>
    <div class="navbar-right">
        <span id="userInfo"></span>
        <button class="btn btn-outline-danger" id="logoutBtn">退出登录</button>
    </div>
</nav>

<script>
    var ctxPath = "<%= ctxPath %>";
    
    document.addEventListener('DOMContentLoaded', function() {
        getUserInfo();
        document.getElementById('logoutBtn').addEventListener('click', logout);
    });
    
    function getUserInfo() {
        fetch(ctxPath + '/user/info').then(function(response) {
            return response.json();
        }).then(function(result) {
            if (result.code === 200) {
                document.getElementById('userInfo').textContent = '欢迎, ' + (result.data.nickname || result.data.username);
            }
        }).catch(function(error) {
            console.error('获取用户信息失败');
        });
    }
    
    function logout() {
        fetch(ctxPath + '/user/logout', {
            method: 'POST'
        }).then(function() {
            window.location.href = ctxPath + '/login';
        }).catch(function(error) {
            alert('退出失败');
        });
    }
</script>