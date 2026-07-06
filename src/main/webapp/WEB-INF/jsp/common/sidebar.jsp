<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String ctxPath = request.getContextPath();
    String currentMenu = (String) request.getAttribute("currentMenu");
    if (currentMenu == null) {
        currentMenu = "";
    }
%>
<div class="sidebar col-2">
    <div class="sidebar-header">
        GrowthLens
    </div>
    <ul class="sidebar-menu">
        <li><a href="<%= ctxPath %>/index" <c:if test="${currentMenu == 'home'}">class="active"</c:if>><i>home</i> 首页</a></li>
        <li><a href="<%= ctxPath %>/daily/list" <c:if test="${currentMenu == 'daily'}">class="active"</c:if>><i>file-text</i> 日报周报管理</a></li>
        <li><a href="<%= ctxPath %>/growth/list" <c:if test="${currentMenu == 'growth'}">class="active"</c:if>><i>trending-up</i> 成长轨迹追踪</a></li>
        <li><a href="<%= ctxPath %>/goal/list" <c:if test="${currentMenu == 'goal'}">class="active"</c:if>><i>target</i> 目标任务管理</a></li>
        <li><a href="<%= ctxPath %>/review/list" <c:if test="${currentMenu == 'review'}">class="active"</c:if>><i>clipboard</i> 智能复盘分析</a></li>
        <li><a href="<%= ctxPath %>/interview/list" <c:if test="${currentMenu == 'interview'}">class="active"</c:if>><i>book-open</i> 面经题库管理</a></li>
        <li><a href="<%= ctxPath %>/chat/index" <c:if test="${currentMenu == 'chat'}">class="active"</c:if>><i>message</i> 职场智能助手</a></li>
    </ul>
</div>