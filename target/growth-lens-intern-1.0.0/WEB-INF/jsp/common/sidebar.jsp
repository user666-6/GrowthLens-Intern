<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String ctxPath = request.getContextPath();
    String currentMenu = (String) request.getAttribute("currentMenu");
    if (currentMenu == null) {
        currentMenu = "";
    }
%>
<style>
    .sidebar-inner {
        position: fixed;
        top: 0;
        left: 0;
        width: 200px;
        height: 100vh;
        display: flex;
        flex-direction: column;
        background: linear-gradient(180deg, #667eea 0%, #764ba2 100%);
    }
    .sidebar-user-card {
        padding: 16px;
        border-top: 1px solid rgba(255,255,255,0.1);
        background-color: rgba(0,0,0,0.1);
    }
    .sidebar-user-card a {
        display: flex;
        align-items: center;
        text-decoration: none;
        color: white;
        transition: all 0.3s;
    }
    .sidebar-user-card a:hover {
        opacity: 0.8;
    }
    .sidebar-avatar {
        width: 40px;
        height: 40px;
        border-radius: 50%;
        object-fit: cover;
        border: 2px solid rgba(255,255,255,0.3);
        margin-right: 12px;
        flex-shrink: 0;
    }
    .sidebar-user-info {
        display: flex;
        flex-direction: column;
        overflow: hidden;
    }
    .sidebar-username {
        font-size: 14px;
        font-weight: 500;
        white-space: nowrap;
        overflow: hidden;
        text-overflow: ellipsis;
    }
    .sidebar-user-status {
        font-size: 11px;
        color: rgba(255,255,255,0.6);
        display: flex;
        align-items: center;
    }
    .sidebar-user-status::before {
        content: '';
        width: 6px;
        height: 6px;
        background-color: #10b981;
        border-radius: 50%;
        margin-right: 6px;
    }
</style>
<div class="sidebar-inner">
    <div class="sidebar-header">
        GrowthLens
    </div>
    <ul class="sidebar-menu flex-grow-1">
        <li><a href="<%= ctxPath %>/index" <c:if test="${currentMenu == 'home'}">class="active"</c:if>>首页</a></li>
        <li><a href="<%= ctxPath %>/dailyreport/list" <c:if test="${currentMenu == 'daily'}">class="active"</c:if>>日报周报管理</a></li>
        <li><a href="<%= ctxPath %>/growth/list" <c:if test="${currentMenu == 'growth'}">class="active"</c:if>>成长轨迹追踪</a></li>
        <li><a href="<%= ctxPath %>/goal/list" <c:if test="${currentMenu == 'goal'}">class="active"</c:if>>目标任务管理</a></li>
        <li><a href="<%= ctxPath %>/review/list" <c:if test="${currentMenu == 'review'}">class="active"</c:if>>智能复盘分析</a></li>
        <li><a href="<%= ctxPath %>/interview/list" <c:if test="${currentMenu == 'interview'}">class="active"</c:if>>面经题库管理</a></li>
        <li><a href="<%= ctxPath %>/chat/index" <c:if test="${currentMenu == 'chat'}">class="active"</c:if>>职场智能助手</a></li>
        <c:if test="${sessionScope.loginUser.role == 1}">
            <li><a href="<%= ctxPath %>/user/manage/list" <c:if test="${currentMenu == 'usermanage'}">class="active"</c:if>>用户管理</a></li>
        </c:if>
    </ul>
    <div class="sidebar-user-card">
        <a href="<%= ctxPath %>/user/profile/info">
            <img src="<c:if test="${sessionScope.loginUser.avatar != null && !sessionScope.loginUser.avatar.isEmpty()}">${sessionScope.loginUser.avatar}</c:if><c:if test="${sessionScope.loginUser.avatar == null || sessionScope.loginUser.avatar.isEmpty()}">https://api.dicebear.com/7.x/avataaars/svg?seed=${sessionScope.loginUser.username}</c:if>" class="sidebar-avatar" alt="头像">
            <div class="sidebar-user-info">
                <div class="sidebar-username"><c:out value="${sessionScope.loginUser.nickname != null ? sessionScope.loginUser.nickname : sessionScope.loginUser.username}"/></div>
                <div class="sidebar-user-status">在线</div>
            </div>
        </a>
    </div>
</div>