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
    <title>GrowthLens Intern - 分类管理</title>
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
        .modal-content {
            border-radius: 12px;
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
                        面试题分类管理
                        <div class="float-end">
                            <button class="btn btn-primary btn-sm" id="btn-add">新增分类</button>
                            <button class="btn btn-secondary btn-sm" id="btn-back">返回题库</button>
                        </div>
                    </div>
                    <div class="card-body">
                        <table class="table table-striped">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>分类名称</th>
                                    <th>分类类型</th>
                                    <th>父分类</th>
                                    <th>排序</th>
                                    <th>备注</th>
                                    <th>创建时间</th>
                                    <th>操作</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${categories}" var="item">
                                    <tr>
                                        <td>${item.id}</td>
                                        <td>${item.categoryName}</td>
                                        <td>
                                            <c:if test="${item.categoryType == 'company'}"><span class="badge badge-info">公司</span></c:if>
                                            <c:if test="${item.categoryType == 'post'}"><span class="badge badge-warning">岗位</span></c:if>
                                            <c:if test="${item.categoryType == 'type'}"><span class="badge badge-success">题型</span></c:if>
                                        </td>
                                        <td>
                                            <c:forEach items="${categories}" var="cat">
                                                <c:if test="${cat.id == item.parentId}">${cat.categoryName}</c:if>
                                            </c:forEach>
                                            <c:if test="${item.parentId == 0}">顶级分类</c:if>
                                        </td>
                                        <td>${item.sort}</td>
                                        <td>${item.remark != null ? item.remark : '-'}</td>
                                        <td>${item.createTime}</td>
                                        <td>
                                            <button class="btn btn-sm btn-primary btn-edit" data-id="${item.id}" 
                                                data-name="${item.categoryName}" data-sort="${item.sort}" data-remark="${item.remark}">编辑</button>
                                            <button class="btn btn-sm btn-danger btn-delete" data-id="${item.id}">删除</button>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty categories}">
                                    <tr>
                                        <td colspan="8" class="text-center text-muted">暂无分类数据</td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="categoryModal" tabindex="-1" aria-labelledby="categoryModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="categoryModalLabel">新增分类</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form id="category-form">
                        <input type="hidden" name="id" id="category-id">
                        <div class="mb-3">
                            <label class="form-label">分类名称</label>
                            <input type="text" class="form-control" name="categoryName" id="category-name" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">分类类型</label>
                            <select class="form-control" name="categoryType" id="category-type">
                                <option value="company">公司</option>
                                <option value="post">岗位</option>
                                <option value="type">题型</option>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">父分类</label>
                            <select class="form-control" name="parentId" id="category-parent">
                                <option value="0">顶级分类</option>
                                <c:forEach items="${categories}" var="cat">
                                    <option value="${cat.id}">${cat.categoryName}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">排序号</label>
                            <input type="number" class="form-control" name="sort" id="category-sort" value="0">
                        </div>
                        <div class="mb-3">
                            <label class="form-label">备注</label>
                            <input type="text" class="form-control" name="remark" id="category-remark">
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">取消</button>
                    <button type="button" class="btn btn-primary" id="btn-save">保存</button>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        var ctxPath = "<%= request.getContextPath() %>";
        var categoryModal = new bootstrap.Modal(document.getElementById('categoryModal'));
        
        document.addEventListener('DOMContentLoaded', function() {
            document.getElementById('btn-add').addEventListener('click', function() {
                document.getElementById('categoryModalLabel').textContent = '新增分类';
                document.getElementById('category-id').value = '';
                document.getElementById('category-name').value = '';
                document.getElementById('category-type').value = 'type';
                document.getElementById('category-type').disabled = false;
                document.getElementById('category-parent').value = '0';
                document.getElementById('category-sort').value = '0';
                document.getElementById('category-remark').value = '';
                categoryModal.show();
            });
            
            document.getElementById('btn-back').addEventListener('click', function() {
                window.location.href = ctxPath + '/interview/list';
            });
            
            document.getElementById('btn-save').addEventListener('click', function() {
                var formData = new FormData(document.getElementById('category-form'));
                var id = document.getElementById('category-id').value;
                var url = id ? ctxPath + '/interview/category/edit' : ctxPath + '/interview/category/add';
                
                fetch(url, {
                    method: 'POST',
                    body: formData
                }).then(function(response) {
                    return response.json();
                }).then(function(result) {
                    if (result.code === 200) {
                        alert(result.msg);
                        window.location.reload();
                    } else {
                        alert(result.msg);
                    }
                });
            });
            
            document.querySelectorAll('.btn-edit').forEach(function(btn) {
                btn.addEventListener('click', function() {
                    document.getElementById('categoryModalLabel').textContent = '编辑分类';
                    document.getElementById('category-id').value = this.dataset.id;
                    document.getElementById('category-name').value = this.dataset.name;
                    document.getElementById('category-sort').value = this.dataset.sort;
                    document.getElementById('category-remark').value = this.dataset.remark || '';
                    document.getElementById('category-type').disabled = true;
                    categoryModal.show();
                });
            });
            
            document.querySelectorAll('.btn-delete').forEach(function(btn) {
                btn.addEventListener('click', function() {
                    var id = this.dataset.id;
                    if (confirm('确定要删除这个分类吗？相关题目也会被删除。')) {
                        fetch(ctxPath + '/interview/category/delete/' + id, {
                            method: 'DELETE'
                        }).then(function(response) {
                            return response.json();
                        }).then(function(result) {
                            if (result.code === 200) {
                                alert(result.msg);
                                window.location.reload();
                            }
                        });
                    }
                });
            });
        });
    </script>
</body>
</html>