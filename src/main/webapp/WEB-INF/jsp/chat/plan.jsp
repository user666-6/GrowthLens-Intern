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
    <title>GrowthLens Intern - 技能学习规划</title>
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
        .form-label {
            font-weight: 500;
            color: #333;
        }
        .result-card {
            background-color: #f8f9fa;
            border-radius: 8px;
            padding: 24px;
            margin-top: 20px;
            min-height: 200px;
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
        .skill-tags {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            margin-bottom: 16px;
        }
        .skill-tag {
            padding: 6px 14px;
            background-color: #e9ecef;
            border-radius: 20px;
            cursor: pointer;
            font-size: 14px;
            transition: all 0.3s;
        }
        .skill-tag:hover {
            background-color: #667eea;
            color: white;
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
                                <a class="nav-link" href="<%= request.getContextPath() %>/chat/script">话术生成</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link active" href="<%= request.getContextPath() %>/chat/plan">学习规划</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="<%= request.getContextPath() %>/chat/history">历史记录</a>
                            </li>
                        </ul>

                        <h5 class="mb-3">热门技能</h5>
                        <div class="skill-tags">
                            <span class="skill-tag" onclick="setSkill('Java')">Java</span>
                            <span class="skill-tag" onclick="setSkill('Python')">Python</span>
                            <span class="skill-tag" onclick="setSkill('Spring Boot')">Spring Boot</span>
                            <span class="skill-tag" onclick="setSkill('MySQL')">MySQL</span>
                            <span class="skill-tag" onclick="setSkill('Vue.js')">Vue.js</span>
                            <span class="skill-tag" onclick="setSkill('Git')">Git</span>
                            <span class="skill-tag" onclick="setSkill('Linux')">Linux</span>
                            <span class="skill-tag" onclick="setSkill('Redis')">Redis</span>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">技能名称</label>
                            <input type="text" class="form-control" id="skillName" placeholder="请输入要学习的技能名称，如：Java、Spring Boot等">
                        </div>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label">目标水平</label>
                                <select class="form-select" id="targetLevel">
                                    <option value="入门掌握">入门掌握（了解基础概念，能做简单开发）</option>
                                    <option value="熟练应用" selected>熟练应用（能独立完成一般任务）</option>
                                    <option value="深入精通">深入精通（掌握底层原理，能解决复杂问题）</option>
                                </select>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">学习周期</label>
                                <select class="form-select" id="duration">
                                    <option value="2周">2周（快速入门）</option>
                                    <option value="1个月">1个月（系统学习）</option>
                                    <option value="3个月" selected>3个月（深入掌握）</option>
                                    <option value="6个月">6个月（全面精进）</option>
                                </select>
                            </div>
                        </div>

                        <button class="btn btn-primary" onclick="generatePlan()">生成学习规划</button>

                        <div class="result-card loading" id="resultCard">
                            生成的学习规划将显示在这里
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        var ctxPath = "<%= request.getContextPath() %>";

        function setSkill(skill) {
            document.getElementById('skillName').value = skill;
        }

        function generatePlan() {
            var skillName = document.getElementById('skillName').value.trim();
            var targetLevel = document.getElementById('targetLevel').value;
            var duration = document.getElementById('duration').value;

            if (!skillName) {
                alert('请输入技能名称');
                return;
            }

            var resultCard = document.getElementById('resultCard');
            resultCard.classList.add('loading');
            resultCard.textContent = '正在生成学习规划，请稍候...';

            var formData = new FormData();
            formData.append('skillName', skillName);
            formData.append('targetLevel', targetLevel);
            formData.append('duration', duration);

            fetch(ctxPath + '/chat/plan', {
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
            });
        }
    </script>
</body>
</html>
