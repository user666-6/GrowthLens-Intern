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
    <title>GrowthLens Intern - 新增面试题</title>
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
            padding: 20px;
        }
        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
        }
        .btn-primary:hover {
            opacity: 0.9;
        }
        .form-group {
            margin-bottom: 16px;
        }
        .form-group label {
            display: block;
            margin-bottom: 6px;
            font-weight: 500;
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
                        新增面试题
                        <button class="btn btn-secondary btn-sm float-end" id="btn-back">返回列表</button>
                    </div>
                    <div class="card-body">
                        <form id="add-form">
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>所属分类</label>
                                        <select class="form-control" name="categoryId">
                                            <option value="">请选择分类</option>
                                            <c:forEach items="${categories}" var="cat">
                                                <option value="${cat.id}">${cat.categoryName}</option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>来源公司</label>
                                        <input type="text" class="form-control" name="sourceCompany" placeholder="如：阿里巴巴">
                                    </div>
                                </div>
                            </div>
                            
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>来源岗位</label>
                                        <input type="text" class="form-control" name="sourcePost" placeholder="如：Java开发工程师">
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>难度等级</label>
                                        <select class="form-control" name="difficultyLevel">
                                            <option value="1">简单</option>
                                            <option value="2" selected>中等</option>
                                            <option value="3">困难</option>
                                        </select>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>掌握程度</label>
                                        <select class="form-control" name="masterLevel">
                                            <option value="1" selected>不熟</option>
                                            <option value="2">熟练</option>
                                            <option value="3">精通</option>
                                        </select>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="form-group">
                                <label>题目标题</label>
                                <input type="text" class="form-control" name="questionTitle" placeholder="请输入题目标题" required>
                            </div>
                            
                            <div class="form-group">
                                <label>题目详情</label>
                                <textarea class="form-control" name="questionContent" rows="4" placeholder="请输入题目详细内容（可选）"></textarea>
                            </div>
                            
                            <div class="form-group">
                                <button type="submit" class="btn btn-primary">保存</button>
                                <button type="button" class="btn btn-secondary" id="btn-cancel">取消</button>
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
                window.location.href = ctxPath + '/interview/list';
            });
            
            document.getElementById('btn-cancel').addEventListener('click', function() {
                window.location.href = ctxPath + '/interview/list';
            });
            
            document.getElementById('add-form').addEventListener('submit', function(e) {
                e.preventDefault();
                var formData = new FormData(this);
                
                fetch(ctxPath + '/interview/add', {
                    method: 'POST',
                    body: formData
                }).then(function(response) {
                    return response.json();
                }).then(function(result) {
                    if (result.code === 200) {
                        alert('添加成功');
                        window.location.href = ctxPath + '/interview/list';
                    } else {
                        alert(result.msg);
                    }
                }).catch(function(error) {
                    alert('添加失败');
                });
            });
        });
    </script>
</body>
</html>