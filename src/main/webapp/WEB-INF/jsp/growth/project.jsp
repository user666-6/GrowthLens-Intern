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
    <title>GrowthLens Intern - 项目经历</title>
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
        .view-toggle .btn.active { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; }
        .timeline { position: relative; padding-left: 30px; }
        .timeline::before { content: ''; position: absolute; left: 14px; top: 0; bottom: 0; width: 2px; background: linear-gradient(180deg, #667eea, #764ba2); }
        .timeline-item { position: relative; margin-bottom: 24px; }
        .timeline-item::before { content: ''; position: absolute; left: -22px; top: 6px; width: 12px; height: 12px; border-radius: 50%; background: #667eea; border: 2px solid white; box-shadow: 0 0 0 2px #667eea; }
        .timeline-item .card { margin: 0; }
        .project-date { font-size: 13px; color: #888; }
        .project-role { font-size: 13px; color: #667eea; font-weight: 500; }
        .tech-tag { display: inline-block; font-size: 11px; padding: 2px 8px; border-radius: 10px; background: #e8f0fe; color: #667eea; margin: 2px; }
        .star-result { white-space: pre-wrap; font-size: 14px; line-height: 1.8; background: #f8f9fa; border-radius: 8px; padding: 16px; border-left: 4px solid #667eea; }
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
                    <li class="nav-item"><a class="nav-link active" href="<%=request.getContextPath()%>/growth/project">项目经历</a></li>
                    <li class="nav-item"><a class="nav-link" href="<%=request.getContextPath()%>/growth/feedback">反馈记录</a></li>
                </ul>

                <div class="card">
                    <div class="card-header d-flex justify-content-between align-items-center">
                        <div class="d-flex align-items-center gap-3">
                            <span>项目经历</span>
                            <div class="btn-group btn-group-sm view-toggle">
                                <button class="btn btn-outline-secondary active" id="view-list">列表</button>
                                <button class="btn btn-outline-secondary" id="view-timeline">时间轴</button>
                            </div>
                        </div>
                        <button class="btn btn-primary btn-sm" id="btn-add">+ 新增项目</button>
                    </div>
                    <div class="card-body">
                        <div id="list-view"></div>
                        <div id="timeline-view" style="display:none"></div>
                        <div class="text-center text-muted py-4" id="empty-tip" style="display:none">暂无项目经历，点击右上角新增</div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="projectModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="modal-title">新增项目</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <form id="projectForm">
                        <input type="hidden" id="f-id">
                        <div class="row">
                            <div class="col-md-8 mb-3">
                                <label class="form-label">项目名称 <span class="text-danger">*</span></label>
                                <input type="text" class="form-control" id="f-projectName" required>
                            </div>
                            <div class="col-md-4 mb-3">
                                <label class="form-label">项目角色</label>
                                <input type="text" class="form-control" id="f-projectRole" placeholder="如：前端开发">
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-4 mb-3">
                                <label class="form-label">开始时间</label>
                                <input type="date" class="form-control" id="f-startDate">
                            </div>
                            <div class="col-md-4 mb-3">
                                <label class="form-label">结束时间</label>
                                <input type="date" class="form-control" id="f-endDate">
                            </div>
                            <div class="col-md-4 mb-3">
                                <label class="form-label">技术栈</label>
                                <input type="text" class="form-control" id="f-techStack" placeholder="如：Java,Spring Boot,MySQL">
                            </div>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">项目描述</label>
                            <textarea class="form-control" id="f-projectDesc" rows="3"></textarea>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">个人职责</label>
                            <textarea class="form-control" id="f-personalDuty" rows="2"></textarea>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">主要成果</label>
                            <textarea class="form-control" id="f-achievement" rows="2"></textarea>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">项目链接</label>
                            <input type="text" class="form-control" id="f-projectLink" placeholder="https://...">
                        </div>
                        <div class="mb-3">
                            <label class="form-label">备注</label>
                            <input type="text" class="form-control" id="f-remark">
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">取消</button>
                    <button type="button" class="btn btn-success btn-sm" id="btn-ai-fill">AI生成成果</button>
                    <button type="button" class="btn btn-primary" id="btn-save">保存</button>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="detailModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="detail-title">项目详情</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body" id="detail-body"></div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="starModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">STAR 格式优化结果</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div id="star-content" class="star-result">生成中...</div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-primary" id="btn-copy-star">复制结果</button>
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">关闭</button>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        var ctxPath = "<%= request.getContextPath() %>";
        var allProjects = [];

        document.addEventListener('DOMContentLoaded', function() {
            loadProjects();
            document.getElementById('btn-add').addEventListener('click', function() { openModal(); });
            document.getElementById('btn-save').addEventListener('click', saveProject);
            document.getElementById('view-list').addEventListener('click', function() { toggleView('list'); });
            document.getElementById('view-timeline').addEventListener('click', function() { toggleView('timeline'); });
            document.getElementById('btn-copy-star').addEventListener('click', function() {
                var text = document.getElementById('star-content').textContent;
                navigator.clipboard.writeText(text).then(function() { alert('已复制到剪贴板'); });
            });
            document.getElementById('btn-ai-fill').addEventListener('click', aiFillAchievement);
        });

        function loadProjects() {
            fetch(ctxPath + '/project/list').then(function(r) { return r.json(); }).then(function(res) {
                if (res.code === 200) { allProjects = res.data; renderAll(); }
            });
        }

        function toggleView(mode) {
            document.getElementById('view-list').classList.toggle('active', mode === 'list');
            document.getElementById('view-timeline').classList.toggle('active', mode === 'timeline');
            document.getElementById('list-view').style.display = mode === 'list' ? '' : 'none';
            document.getElementById('timeline-view').style.display = mode === 'timeline' ? '' : 'none';
        }

        function renderAll() {
            renderListView();
            renderTimelineView();
            document.getElementById('empty-tip').style.display = allProjects.length === 0 ? '' : 'none';
        }

        function renderListView() {
            var c = document.getElementById('list-view');
            if (allProjects.length === 0) { c.innerHTML = ''; return; }
            c.innerHTML = '<table class="table table-hover"><thead><tr><th>项目名称</th><th>角色</th><th>时间</th><th>技术栈</th><th>操作</th></tr></thead><tbody>' +
                allProjects.map(function(p) {
                    var dateRange = (p.startDate || '') + ' ~ ' + (p.endDate || '至今');
                    var techs = (p.techStack || '').split(',').filter(function(t) { return t.trim(); }).map(function(t) { return '<span class="tech-tag">' + escHtml(t.trim()) + '</span>'; }).join('');
                    return '<tr><td><a href="javascript:void(0)" class="text-decoration-none btn-detail" data-id="' + p.id + '">' + escHtml(p.projectName) + '</a></td>' +
                        '<td>' + escHtml(p.projectRole || '-') + '</td><td><span class="project-date">' + dateRange + '</span></td>' +
                        '<td>' + techs + '</td>' +
                        '<td><button class="btn btn-sm btn-outline-primary btn-edit" data-id="' + p.id + '">编辑</button> ' +
                        '<button class="btn btn-sm btn-outline-success btn-star" data-id="' + p.id + '">STAR优化</button> ' +
                        '<button class="btn btn-sm btn-outline-danger btn-del" data-id="' + p.id + '">删除</button></td></tr>';
                }).join('') + '</tbody></table>';
            bindEvents(c);
        }

        function renderTimelineView() {
            var c = document.getElementById('timeline-view');
            if (allProjects.length === 0) { c.innerHTML = ''; return; }
            c.innerHTML = '<div class="timeline">' + allProjects.map(function(p) {
                var dateRange = (p.startDate || '') + ' ~ ' + (p.endDate || '至今');
                var techs = (p.techStack || '').split(',').filter(function(t) { return t.trim(); }).map(function(t) { return '<span class="tech-tag">' + escHtml(t.trim()) + '</span>'; }).join('');
                return '<div class="timeline-item"><div class="card"><div class="card-body">' +
                    '<h6 class="mb-1">' + escHtml(p.projectName) + ' <span class="project-role">' + escHtml(p.projectRole || '') + '</span></h6>' +
                    '<p class="project-date mb-2">' + dateRange + '</p>' +
                    (p.projectDesc ? '<p class="mb-1" style="font-size:14px;color:#555">' + escHtml(p.projectDesc) + '</p>' : '') +
                    (techs ? '<div class="mb-2">' + techs + '</div>' : '') +
                    (p.achievement ? '<p class="mb-1" style="font-size:13px;color:#28a745"><strong>成果：</strong>' + escHtml(p.achievement) + '</p>' : '') +
                    '<div class="mt-2"><button class="btn btn-sm btn-outline-primary btn-edit" data-id="' + p.id + '">编辑</button> ' +
                    '<button class="btn btn-sm btn-outline-success btn-star" data-id="' + p.id + '">STAR优化</button></div>' +
                    '</div></div></div>';
            }).join('') + '</div>';
            bindEvents(c);
        }

        function bindEvents(container) {
            container.querySelectorAll('.btn-edit').forEach(function(b) { b.addEventListener('click', function() { openModal(findProject(this.dataset.id)); }); });
            container.querySelectorAll('.btn-del').forEach(function(b) { b.addEventListener('click', function() { deleteProject(this.dataset.id); }); });
            container.querySelectorAll('.btn-star').forEach(function(b) { b.addEventListener('click', function() { starOptimize(this.dataset.id); }); });
            container.querySelectorAll('.btn-detail').forEach(function(b) { b.addEventListener('click', function() { showDetail(findProject(this.dataset.id)); }); });
        }

        function findProject(id) { return allProjects.find(function(p) { return p.id == id; }); }

        function showDetail(p) {
            if (!p) return;
            var html = '<h5>' + escHtml(p.projectName) + '</h5>' +
                '<p class="text-muted">' + (p.startDate || '') + ' ~ ' + (p.endDate || '至今') + ' | 角色：' + escHtml(p.projectRole || '-') + '</p>' +
                (p.projectDesc ? '<p><strong>项目描述：</strong>' + escHtml(p.projectDesc) + '</p>' : '') +
                (p.personalDuty ? '<p><strong>个人职责：</strong>' + escHtml(p.personalDuty) + '</p>' : '') +
                (p.achievement ? '<p><strong>主要成果：</strong>' + escHtml(p.achievement) + '</p>' : '') +
                (p.techStack ? '<p><strong>技术栈：</strong>' + escHtml(p.techStack) + '</p>' : '') +
                (p.projectLink ? '<p><strong>项目链接：</strong><a href="' + escHtml(p.projectLink) + '" target="_blank">' + escHtml(p.projectLink) + '</a></p>' : '') +
                (p.remark ? '<p><strong>备注：</strong>' + escHtml(p.remark) + '</p>' : '');
            document.getElementById('detail-title').textContent = p.projectName;
            document.getElementById('detail-body').innerHTML = html;
            new bootstrap.Modal(document.getElementById('detailModal')).show();
        }

        function openModal(p) {
            document.getElementById('f-id').value = p ? p.id : '';
            document.getElementById('f-projectName').value = p ? p.projectName : '';
            document.getElementById('f-projectRole').value = p ? (p.projectRole || '') : '';
            document.getElementById('f-startDate').value = p ? (p.startDate || '') : '';
            document.getElementById('f-endDate').value = p ? (p.endDate || '') : '';
            document.getElementById('f-techStack').value = p ? (p.techStack || '') : '';
            document.getElementById('f-projectDesc').value = p ? (p.projectDesc || '') : '';
            document.getElementById('f-personalDuty').value = p ? (p.personalDuty || '') : '';
            document.getElementById('f-achievement').value = p ? (p.achievement || '') : '';
            document.getElementById('f-projectLink').value = p ? (p.projectLink || '') : '';
            document.getElementById('f-remark').value = p ? (p.remark || '') : '';
            document.getElementById('modal-title').textContent = p ? '编辑项目' : '新增项目';
            new bootstrap.Modal(document.getElementById('projectModal')).show();
        }

        function saveProject() {
            var id = document.getElementById('f-id').value;
            var data = {
                projectName: document.getElementById('f-projectName').value,
                projectRole: document.getElementById('f-projectRole').value,
                startDate: document.getElementById('f-startDate').value || null,
                endDate: document.getElementById('f-endDate').value || null,
                techStack: document.getElementById('f-techStack').value,
                projectDesc: document.getElementById('f-projectDesc').value,
                personalDuty: document.getElementById('f-personalDuty').value,
                achievement: document.getElementById('f-achievement').value,
                projectLink: document.getElementById('f-projectLink').value,
                remark: document.getElementById('f-remark').value
            };
            if (!data.projectName) { alert('请输入项目名称'); return; }
            var method = id ? 'PUT' : 'POST';
            if (id) data.id = parseInt(id);
            fetch(ctxPath + '/project', { method: method, headers: { 'Content-Type': 'application/json' }, body: JSON.stringify(data) })
                .then(function(r) { return r.json(); }).then(function(res) {
                    if (res.code === 200) { bootstrap.Modal.getInstance(document.getElementById('projectModal')).hide(); loadProjects(); }
                    else { alert(res.msg); }
                });
        }

        function deleteProject(id) {
            if (!confirm('确定删除该项目经历？')) return;
            fetch(ctxPath + '/project/' + id, { method: 'DELETE' }).then(function(r) { return r.json(); }).then(function(res) {
                if (res.code === 200) loadProjects(); else alert(res.msg);
            });
        }

        function starOptimize(id) {
            var btn = document.querySelector('.btn-star[data-id="' + id + '"]');
            var originalText = btn.textContent;
            btn.disabled = true;
            btn.textContent = '生成中...';

            document.getElementById('star-content').textContent = '正在生成 STAR 格式，请稍候...';
            new bootstrap.Modal(document.getElementById('starModal')).show();
            fetch(ctxPath + '/project/' + id + '/star-optimize', { method: 'POST' })
                .then(function(r) { return r.json(); }).then(function(res) {
                    if (res.code === 200) document.getElementById('star-content').textContent = res.data;
                    else document.getElementById('star-content').textContent = '生成失败：' + res.msg;
                }).catch(function(e) { document.getElementById('star-content').textContent = '请求失败，请稍后重试'; })
                .finally(function() { btn.disabled = false; btn.textContent = originalText; });
        }

        function aiFillAchievement() {
            var projectDesc = document.getElementById('f-projectDesc').value.trim();
            if (!projectDesc) {
                alert('请先填写项目描述');
                return;
            }

            var btn = document.getElementById('btn-ai-fill');
            var originalText = btn.textContent;
            btn.textContent = '生成中...';
            btn.disabled = true;

            var data = {
                projectName: document.getElementById('f-projectName').value.trim(),
                projectRole: document.getElementById('f-projectRole').value.trim(),
                projectDesc: projectDesc,
                personalDuty: document.getElementById('f-personalDuty').value.trim(),
                achievement: document.getElementById('f-achievement').value.trim(),
                techStack: document.getElementById('f-techStack').value.trim()
            };

            fetch(ctxPath + '/project/star-generate', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(data)
            }).then(function(r) { return r.json(); }).then(function(res) {
                if (res.code === 200) {
                    document.getElementById('star-content').textContent = res.data;
                    new bootstrap.Modal(document.getElementById('starModal')).show();
                } else {
                    alert('生成失败：' + res.msg);
                }
            }).catch(function(e) {
                alert('请求失败，请稍后重试');
            }).finally(function() {
                btn.textContent = originalText;
                btn.disabled = false;
            });
        }

        function escHtml(s) { var d = document.createElement('div'); d.textContent = s; return d.innerHTML; }
    </script>
</body>
</html>
