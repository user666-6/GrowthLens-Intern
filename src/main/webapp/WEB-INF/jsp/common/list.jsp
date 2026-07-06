<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    request.setAttribute("currentMenu", "daily");
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>GrowthLens Intern - 日报周报管理</title>
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
        .table {
            margin-bottom: 0;
        }
        .table th {
            background-color: #f8f9fa;
            border-bottom: 2px solid #dee2e6;
        }
        .page-info {
            margin-top: 16px;
            text-align: center;
            color: #666;
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
                        日报周报管理
                        <button class="btn btn-primary btn-sm float-end" id="btn-add">新增日报</button>
                    </div>
                    <div class="card-body">
                        <table class="table table-striped">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>标题</th>
                                    <th>类型</th>
                                    <th>日期</th>
                                    <th>状态</th>
                                    <th>创建时间</th>
                                    <th>操作</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${pageInfo.list}" var="item">
                                    <tr>
                                        <td>${item.id}</td>
                                        <td>${item.title}</td>
                                        <td>${item.type == 'DAILY' ? '日报' : '周报'}</td>
                                        <td>${item.reportDate}</td>
                                        <td>
                                            <c:if test="${item.status == 1}">
                                                <span class="text-success">已提交</span>
                                            </c:if>
                                            <c:if test="${item.status == 0}">
                                                <span class="text-danger">草稿</span>
                                            </c:if>
                                        </td>
                                        <td>${item.createTime}</td>
                                        <td>
                                            <button class="btn btn-sm btn-warning btn-edit" data-id="${item.id}">编辑</button>
                                            <button class="btn btn-sm btn-danger btn-delete" data-id="${item.id}">删除</button>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty pageInfo.list}">
                                    <tr>
                                        <td colspan="7" class="text-center text-muted">暂无数据</td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                        
                        <div class="page-info">
                            共 ${pageInfo.total} 条记录，当前第 ${pageInfo.pageNum} / ${pageInfo.pages} 页
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        var ctxPath = "<%= request.getContextPath() %>";
        
        document.addEventListener('DOMContentLoaded', function() {
            document.getElementById('btn-add').addEventListener('click', function() {
                window.location.href = ctxPath + '/daily/add';
            });
            
            document.querySelectorAll('.btn-edit').forEach(function(btn) {
                btn.addEventListener('click', function() {
                    var id = this.dataset.id;
                    window.location.href = ctxPath + '/daily/edit/' + id;
                });
            });
            
            document.querySelectorAll('.btn-delete').forEach(function(btn) {
                btn.addEventListener('click', function() {
                    var id = this.dataset.id;
                    if (confirm('确定要删除这条日报吗？')) {
                        fetch(ctxPath + '/daily/delete/' + id, {
                            method: 'DELETE'
                        }).then(function(response) {
                            return response.json();
                        }).then(function(result) {
                            if (result.code === 200) {
                                alert('删除成功');
                                window.location.reload();
                            } else {
                                alert(result.msg);
                            }
                        }).catch(function(error) {
                            alert('删除失败');
                        });
                    }
                });
            });
        });
    </script>
</body>
</html>