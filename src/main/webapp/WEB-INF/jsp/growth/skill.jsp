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
    <title>GrowthLens Intern - 技能管理</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif; background-color: #f8f9fa; }
        .sidebar { min-height: 100vh; background: linear-gradient(180deg, #667eea 0%, #764ba2 100%); padding: 0; }
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
        .skill-card { padding: 16px; margin-bottom: 12px; border-radius: 10px; background: white; box-shadow: 0 1px 4px rgba(0,0,0,0.06); transition: transform 0.2s; }
        .skill-card:hover { transform: translateY(-2px); box-shadow: 0 4px 12px rgba(0,0,0,0.1); }
        .skill-name { font-size: 16px; font-weight: 600; color: #333; }
        .skill-type-badge { font-size: 12px; padding: 2px 8px; border-radius: 12px; }
        .badge-tech { background-color: #e8f0fe; color: #667eea; }
        .badge-soft { background-color: #fce8e6; color: #e8453c; }
        .level-dots { display: inline-flex; gap: 4px; margin-top: 4px; }
        .level-dot { width: 10px; height: 10px; border-radius: 50%; background-color: #ddd; transition: background-color 0.3s; }
        .level-dot.filled { background-color: #667eea; }
        .level-label { font-size: 12px; color: #888; margin-left: 8px; }
        .filter-bar { display: flex; gap: 12px; align-items: center; margin-bottom: 16px; }
        .search-input { max-width: 240px; }
    </style>
</head>
<body>
    <div class="d-flex">
        <jsp:include page="/WEB-INF/jsp/common/sidebar.jsp" />
        <div class="flex-grow-1">
            <jsp:include page="/WEB-INF/jsp/common/header.jsp" />
            <div class="main-content">
                <ul class="nav sub-nav">
                    <li class="nav-item"><a class="nav-link" href="<%=request.getContextPath()%>/growth/list">数据看板</a></li>
                    <li class="nav-item"><a class="nav-link active" href="<%=request.getContextPath()%>/growth/skill">技能管理</a></li>
                    <li class="nav-item"><a class="nav-link" href="<%=request.getContextPath()%>/growth/project">项目经历</a></li>
                    <li class="nav-item"><a class="nav-link" href="<%=request.getContextPath()%>/growth/feedback">反馈记录</a></li>
                </ul>

                <div class="card">
                    <div class="card-header d-flex justify-content-between align-items-center">
                        <span>技能管理</span>
                        <button class="btn btn-primary btn-sm" id="btn-add">+ 新增技能</button>
                    </div>
                    <div class="card-body">
                        <div class="filter-bar">
                            <select class="form-select form-select-sm" id="filter-type" style="width:140px">
                                <option value="">全部类型</option>
                                <option value="tech">技术技能</option>
                                <option value="soft">软技能</option>
                            </select>
                            <input type="text" class="form-control form-control-sm search-input" id="search-name" placeholder="搜索技能名称...">
                            <button class="btn btn-sm btn-outline-secondary" id="btn-filter">筛选</button>
                        </div>
                        <div id="skill-list"></div>
                        <div class="text-center text-muted py-4" id="empty-tip" style="display:none">暂无技能数据，点击右上角新增</div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="skillModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="modal-title">新增技能</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <form id="skillForm">
                        <input type="hidden" id="f-id">
                        <div class="mb-3">
                            <label class="form-label">技能名称 <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" id="f-skillName" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">技能类型</label>
                            <select class="form-select" id="f-skillType">
                                <option value="tech">技术技能</option>
                                <option value="soft">软技能</option>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">掌握等级</label>
                            <select class="form-select" id="f-masterLevel">
                                <option value="1">1 - 了解</option>
                                <option value="2">2 - 熟悉</option>
                                <option value="3">3 - 掌握</option>
                                <option value="4">4 - 精通</option>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">掌握时间</label>
                            <input type="date" class="form-control" id="f-masterDate">
                        </div>
                        <div class="mb-3">
                            <label class="form-label">备注</label>
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
        var levelMap = {1:'了解', 2:'熟悉', 3:'掌握', 4:'精通'};
        var typeMap = {tech:'技术技能', soft:'软技能'};
        var allSkills = [];

        document.addEventListener('DOMContentLoaded', function() {
            loadSkills();
            document.getElementById('btn-add').addEventListener('click', function() { openModal(); });
            document.getElementById('btn-save').addEventListener('click', saveSkill);
            document.getElementById('btn-filter').addEventListener('click', renderList);
            document.getElementById('search-name').addEventListener('input', renderList);
            document.getElementById('filter-type').addEventListener('change', renderList);
        });

        function loadSkills() {
            fetch(ctxPath + '/skill/list').then(function(r) { return r.json(); }).then(function(res) {
                if (res.code === 200) { allSkills = res.data; renderList(); }
            });
        }

        function renderList() {
            var type = document.getElementById('filter-type').value;
            var keyword = document.getElementById('search-name').value.trim().toLowerCase();
            var filtered = allSkills.filter(function(s) {
                if (type && s.skillType !== type) return false;
                if (keyword && s.skillName.toLowerCase().indexOf(keyword) === -1) return false;
                return true;
            });
            var container = document.getElementById('skill-list');
            var emptyTip = document.getElementById('empty-tip');
            if (filtered.length === 0) { container.innerHTML = ''; emptyTip.style.display = ''; return; }
            emptyTip.style.display = 'none';
            container.innerHTML = filtered.map(function(s) {
                var dots = '';
                for (var i = 1; i <= 4; i++) { dots += '<span class="level-dot' + (i <= s.masterLevel ? ' filled' : '') + '"></span>'; }
                var typeBadge = s.skillType === 'soft' ? '<span class="skill-type-badge badge-soft">软技能</span>' : '<span class="skill-type-badge badge-tech">技术技能</span>';
                return '<div class="skill-card d-flex justify-content-between align-items-center">' +
                    '<div><span class="skill-name">' + escHtml(s.skillName) + '</span> ' + typeBadge +
                    '<div class="level-dots mt-1">' + dots + '<span class="level-label">' + (levelMap[s.masterLevel] || '') + '</span></div>' +
                    (s.remark ? '<div class="text-muted" style="font-size:12px;margin-top:4px">' + escHtml(s.remark) + '</div>' : '') +
                    '</div>' +
                    '<div class="d-flex gap-1"><button class="btn btn-sm btn-outline-primary btn-edit" data-id="' + s.id + '">编辑</button>' +
                    '<button class="btn btn-sm btn-outline-danger btn-del" data-id="' + s.id + '">删除</button></div></div>';
            }).join('');
            container.querySelectorAll('.btn-edit').forEach(function(b) { b.addEventListener('click', function() { openModal(findSkill(this.dataset.id)); }); });
            container.querySelectorAll('.btn-del').forEach(function(b) { b.addEventListener('click', function() { deleteSkill(this.dataset.id); }); });
        }

        function findSkill(id) { return allSkills.find(function(s) { return s.id == id; }); }

        function openModal(skill) {
            document.getElementById('f-id').value = skill ? skill.id : '';
            document.getElementById('f-skillName').value = skill ? skill.skillName : '';
            document.getElementById('f-skillType').value = skill ? skill.skillType : 'tech';
            document.getElementById('f-masterLevel').value = skill ? skill.masterLevel : '1';
            document.getElementById('f-masterDate').value = skill ? (skill.masterDate || '') : '';
            document.getElementById('f-remark').value = skill ? (skill.remark || '') : '';
            document.getElementById('modal-title').textContent = skill ? '编辑技能' : '新增技能';
            new bootstrap.Modal(document.getElementById('skillModal')).show();
        }

        function saveSkill() {
            var id = document.getElementById('f-id').value;
            var data = {
                skillName: document.getElementById('f-skillName').value,
                skillType: document.getElementById('f-skillType').value,
                masterLevel: parseInt(document.getElementById('f-masterLevel').value),
                masterDate: document.getElementById('f-masterDate').value || null,
                remark: document.getElementById('f-remark').value
            };
            if (!data.skillName) { alert('请输入技能名称'); return; }
            var url = id ? ctxPath + '/skill' : ctxPath + '/skill';
            var method = id ? 'PUT' : 'POST';
            if (id) data.id = parseInt(id);
            fetch(url, { method: method, headers: { 'Content-Type': 'application/json' }, body: JSON.stringify(data) })
                .then(function(r) { return r.json(); }).then(function(res) {
                    if (res.code === 200) { bootstrap.Modal.getInstance(document.getElementById('skillModal')).hide(); loadSkills(); }
                    else { alert(res.msg); }
                });
        }

        function deleteSkill(id) {
            if (!confirm('确定删除该技能？')) return;
            fetch(ctxPath + '/skill/' + id, { method: 'DELETE' }).then(function(r) { return r.json(); }).then(function(res) {
                if (res.code === 200) loadSkills(); else alert(res.msg);
            });
        }

        function escHtml(s) { var d = document.createElement('div'); d.textContent = s; return d.innerHTML; }
    </script>
</body>
</html>
