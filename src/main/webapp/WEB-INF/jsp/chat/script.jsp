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
    <title>GrowthLens Intern - 场景话术生成</title>
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
        .scene-tabs {
            display: flex;
            gap: 12px;
            margin-bottom: 20px;
            flex-wrap: wrap;
        }
        .scene-tab {
            padding: 10px 24px;
            border-radius: 24px;
            border: 1px solid #dee2e6;
            cursor: pointer;
            transition: all 0.3s;
            background-color: white;
        }
        .scene-tab:hover {
            border-color: #667eea;
            color: #667eea;
        }
        .scene-tab.active {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-color: transparent;
        }
        .form-label {
            font-weight: 500;
            color: #333;
        }
        .result-card {
            background-color: #f8f9fa;
            border-radius: 8px;
            padding: 20px;
            margin-top: 20px;
            min-height: 100px;
            white-space: pre-wrap;
            line-height: 1.8;
            border: 1px solid #e9ecef;
        }
        .result-card.loading {
            display: flex;
            align-items: center;
            justify-content: center;
            color: #999;
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
                                <a class="nav-link active" href="<%= request.getContextPath() %>/chat/script">话术生成</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="<%= request.getContextPath() %>/chat/plan">学习规划</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="<%= request.getContextPath() %>/chat/history">历史记录</a>
                            </li>
                        </ul>

                        <h5 class="mb-3">选择场景</h5>
                        <div class="scene-tabs">
                            <div class="scene-tab active" data-type="report" onclick="selectScene(this, 'report')">工作汇报</div>
                            <div class="scene-tab" data-type="ask" onclick="selectScene(this, 'ask')">请教问题</div>
                            <div class="scene-tab" data-type="leave" onclick="selectScene(this, 'leave')">请假申请</div>
                            <div class="scene-tab" data-type="refuse" onclick="selectScene(this, 'refuse')">委婉拒绝</div>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">场景背景描述</label>
                            <textarea class="form-control" id="contextInput" rows="5" placeholder="请描述具体场景和背景信息，例如：需要向导师汇报本周的工作进展..."></textarea>
                        </div>

                        <button class="btn btn-primary" onclick="generateScript()">生成话术</button>

                        <div class="result-card loading" id="resultCard">
                            生成的话术将显示在这里
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        var ctxPath = "<%= request.getContextPath() %>";
        var currentScene = 'report';

        function selectScene(el, type) {
            document.querySelectorAll('.scene-tab').forEach(function(tab) {
                tab.classList.remove('active');
            });
            el.classList.add('active');
            currentScene = type;
        }

        function generateScript() {
            var context = document.getElementById('contextInput').value.trim();
            if (!context) {
                alert('请先描述场景背景');
                return;
            }

            var btn = document.querySelector('.btn-primary');
            var originalText = btn.textContent;
            btn.disabled = true;
            btn.textContent = '生成中...';

            var resultCard = document.getElementById('resultCard');
            resultCard.classList.add('loading');
            resultCard.textContent = '正在生成话术，请稍候...';

            var formData = new FormData();
            formData.append('sceneSubType', currentScene);
            formData.append('context', context);

            fetch(ctxPath + '/chat/script', {
                method: 'POST',
                body: formData
            }).then(function(response) {
                return response.json();
            }).then(function(result) {
                resultCard.classList.remove('loading');
                if (result.code === 200) {
                    resultCard.textContent = result.data;
                } else {
                    resultCard.textContent = '生成失败：' + result.msg;
                }
            }).catch(function(error) {
                resultCard.classList.remove('loading');
                resultCard.textContent = '网络错误，请稍后重试';
            }).finally(function() {
                btn.disabled = false;
                btn.textContent = originalText;
            });
        }
    </script>
</body>
</html>
