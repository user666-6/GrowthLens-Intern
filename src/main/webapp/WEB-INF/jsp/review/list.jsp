<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    request.setAttribute("currentMenu", "review");
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>GrowthLens Intern - 智能复盘分析</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css" rel="stylesheet">
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
            margin-bottom: 20px;
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
        .search-form {
            margin-bottom: 16px;
            display: flex;
            gap: 12px;
            align-items: center;
            flex-wrap: wrap;
        }
        .search-form input, .search-form select {
            max-width: 200px;
        }
        .type-badge {
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 500;
        }
        .type-daily {
            background-color: #e3f2fd;
            color: #1976d2;
        }
        .type-weekly {
            background-color: #e8f5e9;
            color: #388e3c;
        }
        .status-success {
            color: #28a745;
        }
        .status-fail {
            color: #dc3545;
        }
        .status-pending {
            color: #ffc107;
        }
        .status-processing {
            color: #17a2b8;
        }
        .result-section {
            display: none;
            margin-top: 20px;
            padding: 16px;
            background-color: #f8f9fa;
            border-radius: 8px;
        }
        .result-card {
            margin-bottom: 16px;
            padding: 16px;
            background-color: white;
            border-radius: 8px;
            border-left: 4px solid #667eea;
        }
        .result-card h5 {
            margin-bottom: 8px;
            font-size: 14px;
            font-weight: 600;
        }
        .result-card p {
            margin: 0;
            font-size: 13px;
            line-height: 1.6;
        }
        .copy-btn {
            float: right;
            font-size: 12px;
            padding: 4px 8px;
        }
        .modal-body {
            max-height: 60vh;
            overflow-y: auto;
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
                        生成智能复盘
                    </div>
                    <div class="card-body">
                        <form class="row g-3" onsubmit="generateReview(event)">
                            <div class="col-md-3">
                                <label class="form-label">复盘类型</label>
                                <select class="form-control" id="reviewType" required>
                                    <option value="daily">日度复盘</option>
                                    <option value="weekly">周度复盘（最多7天）</option>
                                </select>
                            </div>
                            <div class="col-md-3">
                                <label class="form-label">开始日期</label>
                                <input type="date" class="form-control" id="startDate" required>
                            </div>
                            <div class="col-md-3">
                                <label class="form-label">结束日期</label>
                                <input type="date" class="form-control" id="endDate" required>
                            </div>
                            <div class="col-md-3 d-flex align-items-end">
                                <button type="submit" class="btn btn-primary w-100" id="generateBtn">生成复盘</button>
                            </div>
                        </form>

                        <div id="resultArea" class="result-section">
                            <h5>复盘结果</h5>
                            <div id="highlightCard" class="result-card" style="border-left-color: #28a745;">
                                <button class="btn btn-secondary btn-sm copy-btn" onclick="copyContent('highlightCard')">复制</button>
                                <h5>【工作亮点】</h5>
                                <p id="resultHighlight"></p>
                            </div>
                            <div id="shortageCard" class="result-card" style="border-left-color: #dc3545;">
                                <button class="btn btn-secondary btn-sm copy-btn" onclick="copyContent('shortageCard')">复制</button>
                                <h5>【存在不足】</h5>
                                <p id="resultShortage"></p>
                            </div>
                            <div id="suggestionCard" class="result-card" style="border-left-color: #ffc107;">
                                <button class="btn btn-secondary btn-sm copy-btn" onclick="copyContent('suggestionCard')">复制</button>
                                <h5>【改进建议】</h5>
                                <p id="resultSuggestion"></p>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="card">
                    <div class="card-header">
                        历史复盘记录
                        <button class="btn btn-primary btn-sm float-right" onclick="refreshList()">刷新</button>
                    </div>
                    <div class="card-body">
                        <form class="search-form" onsubmit="searchReview(event)">
                            <select class="form-control" id="searchType">
                                <option value="">全部类型</option>
                                <option value="daily">日度复盘</option>
                                <option value="weekly">周度复盘</option>
                            </select>
                            <input type="date" class="form-control" id="searchStartDate" placeholder="开始日期">
                            <span>至</span>
                            <input type="date" class="form-control" id="searchEndDate" placeholder="结束日期">
                            <button type="submit" class="btn btn-outline-primary btn-sm">查询</button>
                            <button type="button" class="btn btn-outline-secondary btn-sm" onclick="resetSearch()">重置</button>
                        </form>
                        <table class="table table-striped">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>类型</th>
                                    <th>日期范围</th>
                                    <th>状态</th>
                                    <th>生成时间</th>
                                    <th>操作</th>
                                </tr>
                            </thead>
                            <tbody id="reviewTableBody">
                            </tbody>
                        </table>
                        <div class="page-info" id="pageInfo">
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="detailModal" tabindex="-1" role="dialog">
        <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">复盘详情</h5>
                    <button type="button" class="close" data-dismiss="modal">
                        <span>&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label">复盘类型</label>
                        <span id="detailType" class="type-badge"></span>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">日期范围</label>
                        <span id="detailDateRange"></span>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">状态</label>
                        <span id="detailStatus"></span>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">工作亮点</label>
                        <div id="detailHighlight" class="border p-3 rounded"></div>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">存在不足</label>
                        <div id="detailShortage" class="border p-3 rounded"></div>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">改进建议</label>
                        <div id="detailSuggestion" class="border p-3 rounded"></div>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">完整内容</label>
                        <div id="detailFullContent" class="border p-3 rounded" style="max-height: 200px; overflow-y: auto;"></div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">关闭</button>
                    <button type="button" class="btn btn-primary" onclick="copyDetailContent()">复制完整内容</button>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/jquery@3.6.4/dist/jquery.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        var ctxPath = "<%= request.getContextPath() %>";
        var currentPage = 1;

        function init() {
            var today = new Date().toISOString().split('T')[0];
            document.getElementById('startDate').value = today;
            document.getElementById('endDate').value = today;
            loadReviewList();
        }

        document.getElementById('reviewType').addEventListener('change', function() {
            var type = this.value;
            var today = new Date();
            var startDate, endDate;
            var endDateInput = document.getElementById('endDate');
            
            if (type === 'daily') {
                endDateInput.disabled = true;
                startDate = today.toISOString().split('T')[0];
                endDate = startDate;
            } else {
                endDateInput.disabled = false;
                var day = today.getDay();
                var diff = today.getDate() - day + (day === 0 ? -6 : 1);
                startDate = new Date(today.setDate(diff)).toISOString().split('T')[0];
                endDate = new Date(today.setDate(today.getDate() + 6)).toISOString().split('T')[0];
            }
            
            if (startDate && endDate) {
                document.getElementById('startDate').value = startDate;
                document.getElementById('endDate').value = endDate;
            }
        });

        document.getElementById('startDate').addEventListener('change', function() {
            var reviewType = document.getElementById('reviewType').value;
            var endDateInput = document.getElementById('endDate');
            
            if (reviewType === 'daily') {
                endDateInput.value = this.value;
                return;
            }
            
            var start = new Date(this.value);
            var maxEnd = new Date(start.getTime() + 6 * 24 * 60 * 60 * 1000);
            endDateInput.max = maxEnd.toISOString().split('T')[0];
            
            if (reviewType === 'weekly') {
                endDateInput.value = maxEnd.toISOString().split('T')[0];
            }
        });

        document.getElementById('endDate').addEventListener('change', function() {
            var reviewType = document.getElementById('reviewType').value;
            if (reviewType !== 'weekly') return;
            
            var start = new Date(document.getElementById('startDate').value);
            var end = new Date(this.value);
            var daysDiff = Math.ceil((end - start) / (1000 * 60 * 60 * 24)) + 1;
            
            if (daysDiff > 7) {
                alert('日期范围不能超过7天');
                var maxEnd = new Date(start.getTime() + 6 * 24 * 60 * 60 * 1000);
                this.value = maxEnd.toISOString().split('T')[0];
            }
        });

        function generateReview(event) {
            event.preventDefault();
            
            var reviewType = document.getElementById('reviewType').value;
            var startDate = document.getElementById('startDate').value;
            var endDate = document.getElementById('endDate').value;
            
            if (!startDate || !endDate) {
                alert('请选择日期');
                return;
            }
            
            var start = new Date(startDate);
            var end = new Date(endDate);
            var daysDiff = Math.ceil((end - start) / (1000 * 60 * 60 * 24)) + 1;
            
            if (reviewType === 'weekly' && daysDiff > 7) {
                alert('日期范围不能超过7天');
                return;
            }
            
            var btn = document.getElementById('generateBtn');
            btn.disabled = true;
            btn.innerText = '生成中请稍候...';
            
            document.getElementById('resultArea').style.display = 'none';
            
            fetch(ctxPath + '/review/generate', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded'
                },
                body: 'reviewType=' + encodeURIComponent(reviewType) + 
                      '&startDate=' + encodeURIComponent(startDate) + 
                      '&endDate=' + encodeURIComponent(endDate)
            }).then(function(response) {
                return response.json();
            }).then(function(result) {
                if (result.code === 200) {
                    var data = result.data;
                    document.getElementById('resultHighlight').innerText = data.highlight || '无';
                    document.getElementById('resultShortage').innerText = data.shortage || '无';
                    document.getElementById('resultSuggestion').innerText = data.suggestion || '无';
                    document.getElementById('resultArea').style.display = 'block';
                    loadReviewList(1);
                } else {
                    alert(result.msg);
                }
            }).catch(function(error) {
                alert('生成失败，请稍后重试');
            }).finally(function() {
                btn.disabled = false;
                btn.innerText = '生成复盘';
            });
        }

        function loadReviewList(pageNum) {
            if (!pageNum) pageNum = 1;
            currentPage = pageNum;
            
            var reviewType = document.getElementById('searchType').value;
            var startDate = document.getElementById('searchStartDate').value;
            var endDate = document.getElementById('searchEndDate').value;
            
            var url = ctxPath + '/review/page?pageNum=' + pageNum + '&pageSize=10';
            if (reviewType) url += '&reviewType=' + encodeURIComponent(reviewType);
            if (startDate) url += '&startDate=' + encodeURIComponent(startDate);
            if (endDate) url += '&endDate=' + encodeURIComponent(endDate);
            
            fetch(url).then(function(response) {
                return response.json();
            }).then(function(result) {
                if (result.code === 200) {
                    renderTable(result.data);
                }
            }).catch(function(error) {
                console.error('加载失败', error);
            });
        }

        function renderTable(pageInfo) {
            var tbody = document.getElementById('reviewTableBody');
            tbody.innerHTML = '';
            
            if (!pageInfo.list || pageInfo.list.length === 0) {
                tbody.innerHTML = '<tr><td colspan="6" class="text-center text-muted">暂无数据</td></tr>';
                document.getElementById('pageInfo').innerHTML = '';
                return;
            }
            
            pageInfo.list.forEach(function(item) {
                var typeClass = 'type-daily';
                var typeText = '日度';
                if (item.reviewType === 'weekly') { 
                    typeClass = 'type-weekly'; 
                    typeText = '周度'; 
                }
                
                var statusClass = 'status-success';
                var statusText = '成功';
                if (item.status === 0) { 
                    statusClass = 'status-fail'; 
                    statusText = '失败'; 
                } else if (item.status === 2) {
                    statusClass = 'status-processing';
                    statusText = '生成中';
                }
                
                var row = '<tr>' +
                    '<td>' + item.id + '</td>' +
                    '<td><span class="type-badge ' + typeClass + '">' + typeText + '</span></td>' +
                    '<td>' + item.startDate + ' ~ ' + item.endDate + '</td>' +
                    '<td><span class="' + statusClass + '">' + statusText + '</span></td>' +
                    '<td>' + formatDateTime(item.createTime) + '</td>' +
                    '<td>' +
                        '<button class="btn btn-sm btn-primary" onclick="viewDetail(' + item.id + ')">查看</button> ' +
                        '<button class="btn btn-sm btn-danger" onclick="deleteReview(' + item.id + ')">删除</button>' +
                    '</td>' +
                '</tr>';
                tbody.innerHTML += row;
            });
            
            var pageHtml = '共 ' + pageInfo.total + ' 条记录，当前第 ' + pageInfo.pageNum + ' / ' + pageInfo.pages + ' 页';
            if (pageInfo.pages > 1) {
                pageHtml += ' | ';
                if (pageInfo.pageNum > 1) {
                    pageHtml += '<a href="#" onclick="loadReviewList(' + (pageInfo.pageNum - 1) + ')">上一页</a> ';
                }
                if (pageInfo.pageNum < pageInfo.pages) {
                    pageHtml += '<a href="#" onclick="loadReviewList(' + (pageInfo.pageNum + 1) + ')">下一页</a>';
                }
            }
            document.getElementById('pageInfo').innerHTML = pageHtml;
        }

        function viewDetail(id) {
            fetch(ctxPath + '/review/detail?id=' + id).then(function(response) {
                return response.json();
            }).then(function(result) {
                if (result.code === 200) {
                    var data = result.data;
                    
                    var typeClass = 'type-daily';
                    var typeText = '日度';
                    if (data.reviewType === 'weekly') { 
                        typeClass = 'type-weekly'; 
                        typeText = '周度'; 
                    }
                    
                    var statusClass = 'text-success';
                    var statusText = '成功';
                    if (data.status === 0) { 
                        statusClass = 'text-danger'; 
                        statusText = '失败'; 
                    } else if (data.status === 2) {
                        statusClass = 'text-info';
                        statusText = '生成中';
                    }
                    
                    document.getElementById('detailType').className = 'type-badge ' + typeClass;
                    document.getElementById('detailType').innerText = typeText;
                    document.getElementById('detailDateRange').innerText = data.startDate + ' ~ ' + data.endDate;
                    document.getElementById('detailStatus').className = statusClass;
                    document.getElementById('detailStatus').innerText = statusText;
                    document.getElementById('detailHighlight').innerText = data.highlight || '无';
                    document.getElementById('detailShortage').innerText = data.shortage || '无';
                    document.getElementById('detailSuggestion').innerText = data.suggestion || '无';
                    document.getElementById('detailFullContent').innerText = data.fullContent || '无';
                    
                    $('#detailModal').modal('show');
                } else {
                    alert(result.msg);
                }
            }).catch(function(error) {
                alert('获取详情失败');
            });
        }

        function deleteReview(id) {
            if (!confirm('确定要删除这条复盘记录吗？')) {
                return;
            }
            
            fetch(ctxPath + '/review/delete', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded'
                },
                body: 'id=' + id
            }).then(function(response) {
                return response.json();
            }).then(function(result) {
                if (result.code === 200) {
                    alert('删除成功');
                    loadReviewList(currentPage);
                } else {
                    alert(result.msg);
                }
            }).catch(function(error) {
                alert('删除失败');
            });
        }

        function searchReview(event) {
            event.preventDefault();
            loadReviewList(1);
        }

        function resetSearch() {
            document.getElementById('searchType').value = '';
            document.getElementById('searchStartDate').value = '';
            document.getElementById('searchEndDate').value = '';
            loadReviewList(1);
        }

        function refreshList() {
            loadReviewList(currentPage);
        }

        function formatDateTime(dt) {
            if (!dt) return '';
            return dt.replace('T', ' ').substring(0, 19);
        }

        function copyContent(elementId) {
            var content = document.getElementById(elementId).querySelector('p').innerText;
            if (!content || content === '无') {
                alert('没有可复制的内容');
                return;
            }
            navigator.clipboard.writeText(content).then(function() {
                alert('复制成功');
            }).catch(function() {
                alert('复制失败');
            });
        }

        function copyDetailContent() {
            var content = document.getElementById('detailFullContent').innerText;
            if (!content || content === '无') {
                alert('没有可复制的内容');
                return;
            }
            navigator.clipboard.writeText(content).then(function() {
                alert('复制成功');
            }).catch(function() {
                alert('复制失败');
            });
        }

        document.addEventListener('DOMContentLoaded', function() {
            init();
        });
        window.onload = init;
    </script>
</body>
</html>
