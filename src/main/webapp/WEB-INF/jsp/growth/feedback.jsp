<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    request.setAttribute("currentMenu", "growth");
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>GrowthLens Intern - 反馈记录</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif; background-color: #f8f9fa; }
        .sidebar-placeholder { width: 200px; flex-shrink: 0; }
        .sidebar-inner { min-height: 100vh; background: linear-gradient(180deg, #667eea 0%, #764ba2 100%); padding: 0; }
        .sidebar-header { padding: 24px; color: white; font-size: 20px; font-weight: 600; border-bottom: 1px solid rgba(255,255,255,0.1); }
        .sidebar-menu { list-style: none; padding: 0; margin: 0; }
        .sidebar-menu li a { display: block; padding: 14px 24px; color: rgba(255,255,255,0.9); text-decoration: none; transition: all 0.3s; }
        .sidebar-menu li a:hover { background-color: rgba(255,255,255,0.1); color: white; }
        .sidebar-menu li a.active { background-color: rgba(255,255,255,0.2); color: white; }
        .main-content { padding: 24px; }
        .navbar { background-color: white; border-bottom: 1px solid #e9ecef; padding: 12px 24px; }
        .navbar-right { display: flex; align-items: center; gap: 16px; }
        .card { border: none; box-shadow: 0 2px 8px rgba(0,0,0,0.08); border-radius: 12px; }
        .card-header { background-color: white; border-bottom: 1px solid #f0f0f0; font-weight: 600; padding: 16px 20px; }
        .btn-primary { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); border: none; }
        .btn-primary:hover { opacity: 0.9; }
        .sub-nav { margin-bottom: 20px; }
        .sub-nav .nav-link { color: #666; border-radius: 8px; padding: 8px 16px; }
        .sub-nav .nav-link.active { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; }
        .feedback-card { padding: 16px; margin-bottom: 12px; border-radius: 10px; background: white; box-shadow: 0 1px 4px rgba(0,0,0,0.06); border-left: 4px solid #ddd; transition: transform 0.2s; }
        .feedback-card:hover { transform: translateY(-2px); box-shadow: 0 4px 12px rgba(0,0,0,0.1); }
        .feedback-card.type-praise { border-left-color: #28a745; }
        .feedback-card.type-suggest { border-left-color: #667eea; }
        .feedback-card.type-criticism { border-left-color: #fd7e14; }
        .source-badge { font-size: 12px; padding: 2px 10px; border-radius: 12px; }
        .source-mentor { background-color: #e8f0fe; color: #667eea; }
        .source-colleague { background-color: #e6f7ec; color: #28a745; }
        .source-self { background-color: #fff3cd; color: #856404; }
        .source-other { background-color: #f0f0f0; color: #666; }
        .type-badge { font-size: 12px; padding: 2px 8px; border-radius: 12px; }
        .type-praise-badge { background-color: #e6f7ec; color: #28a745; }
        .type-suggest-badge { background-color: #e8f0fe; color: #667eea; }
        .type-criticism-badge { background-color: #fff3cd; color: #856404; }
        .filter-bar { display: flex; gap: 12px; align-items: center; margin-bottom: 16px; flex-wrap: wrap; }
    </style>
</head>
<body>
    <div class="d-flex">
        <div class="sidebar-placeholder"></div>
        <jsp:include page="/WEB-INF/jsp/common/sidebar.jsp" />
        <div class="flex-grow-1">
            <jsp:include page="/WEB-INF/jsp/common/header.jsp" />
            <div class="main-content">
                <ul class="nav sub-nav">
                    <li class="nav-item"><a class="nav-link" href="<%=request.getContextPath()%>/growth/list">数据看板</a></li>
                    <li class="nav-item"><a class="nav-link" href="<%=request.getContextPath()%>/growth/skill">技能管理</a></li>
                    <li class="nav-item"><a class="nav-link" href="<%=request.getContextPath()%>/growth/project">项目经历</a></li>
                    <li class="nav-item"><a class="nav-link active" href="<%=request.getContextPath()%>/growth/feedback">反馈记录</a></li>
                </ul>

                <div class="card">
                    <div class="card-header d-flex justify-content-between align-items-center">
                        <span>反馈记录</span>
                        <button class="btn btn-primary btn-sm" id="btn-add">+ 新增反馈</button>
                    </div>
                    <div class="card-body">
                        <div class="filter-bar">
                            <select class="form-select form-select-sm" id="filter-source" style="width:140px">
                                <option value="">全部来源</option>
                                <option value="导师">导师</option>
                                <option value="同事">同事</option>
                                <option value="自评">自评</option>
                                <option value="其他">其他</option>
                            </select>
                            <select class="form-select form-select-sm" id="filter-type" style="width:140px">
                                <option value="">全部类型</option>
                                <option value="praise">表扬</option>
                                <option value="suggest">建议</option>
                                <option value="criticism">批评</option>
                            </select>
                        </div>
                        <div id="feedback-list"></div>
                        <div class="text-center text-muted py-4" id="empty-tip" style="display:none">暂无反馈记录，点击右上角新增</div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="feedbackModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="modal-title">新增反馈</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <form id="feedbackForm">
                        <input type="hidden" id="f-id">
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label">反馈来源 <span class="text-danger">*</span></label>
                                <select class="form-select" id="f-feedbackSource">
                                    <option value="导师">导师</option>
                                    <option value="同事">同事</option>
                                    <option value="自评">自评</option>
                                    <option value="其他">其他</option>
                                </select>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">反馈类型</label>
                                <select class="form-select" id="f-feedbackType">
                                    <option value="praise">表扬</option>
                                    <option value="suggest">建议</option>
                                    <option value="criticism">批评</option>
                                </select>
                            </div>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">反馈内容 <span class="text-danger">*</span></label>
                            <textarea class="form-control" id="f-feedbackContent" rows="4" required></textarea>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">对应场景/事件</label>
                            <input type="text" class="form-control" id="f-correspondScene" placeholder="如：项目中期评审">
                        </div>
                        <div class="mb-3">
                            <label class="form-label">记录日期</label>
                            <input type="date" class="form-control" id="f-recordDate">
                        </div>
                        <div class="mb-3">
                            <label class="form-label">备注/改进记录</label>
                            <textarea class="form-control" id="f-remark" rows="2"></textarea>
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
        var typeLabels = {praise: '表扬', suggest: '建议', criticism: '批评'};
        var typeBadgeClass = {praise: 'type-praise-badge', suggest: 'type-suggest-badge', criticism: 'type-criticism-badge'};
        var sourceClass = {'导师': 'source-mentor', '同事': 'source-colleague', '自评': 'source-self', '其他': 'source-other'};
        var allFeedback = [];

        document.addEventListener('DOMContentLoaded', function() {
            loadFeedback();
            document.getElementById('btn-add').addEventListener('click', function() { openModal(); });
            document.getElementById('btn-save').addEventListener('click', saveFeedback);
            document.getElementById('filter-source').addEventListener('change', renderList);
            document.getElementById('filter-type').addEventListener('change', renderList);
        });

        function loadFeedback() {
            fetch(ctxPath + '/feedback/list').then(function(r) { return r.json(); }).then(function(res) {
                if (res.code === 200) { allFeedback = res.data; renderList(); }
            });
        }

        function renderList() {
            var srcFilter = document.getElementById('filter-source').value;
            var typeFilter = document.getElementById('filter-type').value;
            var filtered = allFeedback.filter(function(f) {
                if (srcFilter && f.feedbackSource !== srcFilter) return false;
                if (typeFilter && f.feedbackType !== typeFilter) return false;
                return true;
            });
            var c = document.getElementById('feedback-list');
            var emptyTip = document.getElementById('empty-tip');
            if (filtered.length === 0) { c.innerHTML = ''; emptyTip.style.display = ''; return; }
            emptyTip.style.display = 'none';
            c.innerHTML = filtered.map(function(f) {
                var srcCls = sourceClass[f.feedbackSource] || 'source-other';
                var typeCls = typeBadgeClass[f.feedbackType] || 'type-suggest-badge';
                var cardCls = 'feedback-card type-' + (f.feedbackType || 'suggest');
                return '<div class="' + cardCls + '">' +
                    '<div class="d-flex justify-content-between align-items-start">' +
                    '<div>' +
                    '<span class="source-badge ' + srcCls + '">' + escHtml(f.feedbackSource) + '</span> ' +
                    '<span class="type-badge ' + typeCls + '">' + (typeLabels[f.feedbackType] || f.feedbackType) + '</span> ' +
                    '<span class="text-muted" style="font-size:12px;margin-left:8px">' + (f.recordDate || '') + '</span>' +
                    '</div>' +
                    '<div class="d-flex gap-1">' +
                    '<button class="btn btn-sm btn-outline-primary btn-edit" data-id="' + f.id + '">编辑</button>' +
                    '<button class="btn btn-sm btn-outline-danger btn-del" data-id="' + f.id + '">删除</button>' +
                    '</div></div>' +
                    '<p class="mt-2 mb-1" style="font-size:14px">' + escHtml(f.feedbackContent) + '</p>' +
                    (f.correspondScene ? '<p class="mb-0" style="font-size:12px;color:#888">场景：' + escHtml(f.correspondScene) + '</p>' : '') +
                    (f.remark ? '<p class="mb-0" style="font-size:12px;color:#667eea">改进：' + escHtml(f.remark) + '</p>' : '') +
                    '</div>';
            }).join('');
            c.querySelectorAll('.btn-edit').forEach(function(b) { b.addEventListener('click', function() { openModal(findFeedback(this.dataset.id)); }); });
            c.querySelectorAll('.btn-del').forEach(function(b) { b.addEventListener('click', function() { deleteFeedback(this.dataset.id); }); });
        }

        function findFeedback(id) { return allFeedback.find(function(f) { return f.id == id; }); }

        function openModal(f) {
            document.getElementById('f-id').value = f ? f.id : '';
            document.getElementById('f-feedbackSource').value = f ? f.feedbackSource : '导师';
            document.getElementById('f-feedbackType').value = f ? f.feedbackType : 'praise';
            document.getElementById('f-feedbackContent').value = f ? f.feedbackContent : '';
            document.getElementById('f-correspondScene').value = f ? (f.correspondScene || '') : '';
            document.getElementById('f-recordDate').value = f ? (f.recordDate || '') : '';
            document.getElementById('f-remark').value = f ? (f.remark || '') : '';
            document.getElementById('modal-title').textContent = f ? '编辑反馈' : '新增反馈';
            new bootstrap.Modal(document.getElementById('feedbackModal')).show();
        }

        function saveFeedback() {
            var id = document.getElementById('f-id').value;
            var data = {
                feedbackSource: document.getElementById('f-feedbackSource').value,
                feedbackType: document.getElementById('f-feedbackType').value,
                feedbackContent: document.getElementById('f-feedbackContent').value,
                correspondScene: document.getElementById('f-correspondScene').value,
                recordDate: document.getElementById('f-recordDate').value || null,
                remark: document.getElementById('f-remark').value
            };
            if (!data.feedbackContent) { alert('请输入反馈内容'); return; }
            var method = id ? 'PUT' : 'POST';
            if (id) data.id = parseInt(id);
            fetch(ctxPath + '/feedback', { method: method, headers: { 'Content-Type': 'application/json' }, body: JSON.stringify(data) })
                .then(function(r) { return r.json(); }).then(function(res) {
                    if (res.code === 200) { bootstrap.Modal.getInstance(document.getElementById('feedbackModal')).hide(); loadFeedback(); }
                    else { alert(res.msg); }
                });
        }

        function deleteFeedback(id) {
            if (!confirm('确定删除该反馈记录？')) return;
            fetch(ctxPath + '/feedback/' + id, { method: 'DELETE' }).then(function(r) { return r.json(); }).then(function(res) {
                if (res.code === 200) loadFeedback(); else alert(res.msg);
            });
        }

        function escHtml(s) { var d = document.createElement('div'); d.textContent = s; return d.innerHTML; }
    </script>
</body>
</html>
