<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    request.setAttribute("currentMenu", "interview");
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>GrowthLens Intern - 刷题练习</title>
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
        .badge {
            padding: 4px 10px;
            border-radius: 12px;
            font-size: 12px;
        }
        .badge-danger {
            background-color: #fee2e2;
            color: #dc2626;
        }
        .badge-success {
            background-color: #dcfce7;
            color: #16a34a;
        }
        .badge-warning {
            background-color: #fef3c7;
            color: #d97706;
        }
        .badge-info {
            background-color: #dbeafe;
            color: #2563eb;
        }
        .question-card {
            background-color: white;
            border: 1px solid #e9ecef;
            border-radius: 12px;
            padding: 20px;
            margin-bottom: 20px;
        }
        .question-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 12px;
        }
        .answer-section {
            background-color: #f8f9fa;
            padding: 16px;
            border-radius: 8px;
            margin-top: 12px;
        }
        .answer-section h5 {
            margin-bottom: 10px;
            color: #667eea;
        }
        .practice-tabs {
            margin-bottom: 20px;
        }
        .practice-tabs button {
            margin-right: 10px;
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
                        刷题练习
                        <button class="btn btn-secondary btn-sm float-end" id="btn-back">返回题库</button>
                    </div>
                    <div class="card-body">
                        <div class="practice-tabs">
                            <button class="btn btn-primary btn-sm" onclick="switchMode('random')" <c:if test="${mode == 'random'}">disabled</c:if>>随机刷题</button>
                            <button class="btn btn-secondary btn-sm" onclick="switchMode('wrong')" <c:if test="${mode == 'wrong'}">disabled</c:if>>错题练习</button>
                            <button class="btn btn-secondary btn-sm" onclick="switchMode('collected')" <c:if test="${mode == 'collected'}">disabled</c:if>>收藏练习</button>
                            <button class="btn btn-secondary btn-sm dropdown-toggle" type="button" id="categoryDropdown" data-bs-toggle="dropdown" aria-expanded="false">
                                按分类练习
                            </button>
                            <ul class="dropdown-menu" aria-labelledby="categoryDropdown">
                                <c:forEach items="${categories}" var="cat">
                                    <li><a class="dropdown-item" href="<%= request.getContextPath() %>/interview/practice?mode=category&categoryId=${cat.id}">${cat.categoryName}</a></li>
                                </c:forEach>
                            </ul>
                        </div>

                        <div class="mb-4">
                            <span class="badge bg-info">共 ${questions.size()} 道题目</span>
                        </div>

                        <c:forEach items="${questions}" var="item" varStatus="status">
                            <div class="question-card">
                                <div class="question-header">
                                    <span class="badge bg-secondary">第 ${status.index + 1} 题</span>
                                    <div>
                                        <c:if test="${item.difficultyLevel == 1}"><span class="badge badge-success">简单</span></c:if>
                                        <c:if test="${item.difficultyLevel == 2}"><span class="badge badge-warning">中等</span></c:if>
                                        <c:if test="${item.difficultyLevel == 3}"><span class="badge badge-danger">困难</span></c:if>
                                        <c:if test="${item.isCollected == 1}"><span class="badge badge-info">收藏</span></c:if>
                                        <c:if test="${item.isWrong == 1}"><span class="badge badge-danger">错题</span></c:if>
                                    </div>
                                </div>
                                
                                <h4>${item.questionTitle}</h4>
                                <p class="text-muted mt-2">${item.questionContent}</p>
                                
                                <div class="answer-section">
                                    <h5>我的答案</h5>
                                    <p>${item.myAnswer != null ? item.myAnswer : '暂无答案'}</p>
                                </div>
                                
                                <div class="answer-section">
                                    <h5>参考答案</h5>
                                    <p>${item.referenceAnswer != null ? item.referenceAnswer : '暂无参考答案，点击下方按钮生成'}</p>
                                    <button class="btn btn-sm btn-primary mt-2 btn-generate" data-id="${item.id}">生成参考答案</button>
                                </div>
                                
                                <div class="answer-section">
                                    <h5>复盘总结</h5>
                                    <p>${item.reviewSummary != null ? item.reviewSummary : '暂无复盘总结'}</p>
                                </div>
                                
                                <div class="mt-3">
                                    <span class="mr-2">掌握程度：</span>
                                    <button class="btn btn-sm btn-outline-danger btn-master" data-id="${item.id}" data-level="1" <c:if test="${item.masterLevel == 1}">disabled</c:if>>不熟</button>
                                    <button class="btn btn-sm btn-outline-warning btn-master" data-id="${item.id}" data-level="2" <c:if test="${item.masterLevel == 2}">disabled</c:if>>熟练</button>
                                    <button class="btn btn-sm btn-outline-success btn-master" data-id="${item.id}" data-level="3" <c:if test="${item.masterLevel == 3}">disabled</c:if>>精通</button>
                                </div>
                            </div>
                        </c:forEach>
                        
                        <c:if test="${empty questions}">
                            <div class="text-center text-muted py-10">
                                <p>暂无题目，快去添加吧！</p>
                                <button class="btn btn-primary mt-4" onclick="window.location.href='<%= request.getContextPath() %>/interview/add'">新增题目</button>
                            </div>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        var ctxPath = "<%= request.getContextPath() %>";
        
        function switchMode(mode) {
            var url = ctxPath + '/interview/practice?mode=' + mode;
            window.location.href = url;
        }
        
        document.addEventListener('DOMContentLoaded', function() {
            document.getElementById('btn-back').addEventListener('click', function() {
                window.location.href = ctxPath + '/interview/list';
            });
            
            document.querySelectorAll('.btn-generate').forEach(function(btn) {
                btn.addEventListener('click', function() {
                    var id = this.dataset.id;
                    var btnEl = this;
                    btnEl.disabled = true;
                    btnEl.textContent = '生成中...';
                    
                    fetch(ctxPath + '/interview/generateAnswer/' + id, {
                        method: 'POST'
                    }).then(function(response) {
                        return response.json();
                    }).then(function(result) {
                        if (result.code === 200) {
                            alert('参考答案生成成功');
                            window.location.reload();
                        } else {
                            alert(result.msg);
                            btnEl.disabled = false;
                            btnEl.textContent = '生成参考答案';
                        }
                    }).catch(function(error) {
                        alert('生成失败');
                        btnEl.disabled = false;
                        btnEl.textContent = '生成参考答案';
                    });
                });
            });
            
            document.querySelectorAll('.btn-master').forEach(function(btn) {
                btn.addEventListener('click', function() {
                    var id = this.dataset.id;
                    var level = this.dataset.level;
                    
                    fetch(ctxPath + '/interview/updateMasterLevel/' + id + '?level=' + level, {
                        method: 'POST'
                    }).then(function(response) {
                        return response.json();
                    }).then(function(result) {
                        if (result.code === 200) {
                            alert('掌握程度已更新');
                            window.location.reload();
                        }
                    });
                });
            });
        });
    </script>
</body>
</html>