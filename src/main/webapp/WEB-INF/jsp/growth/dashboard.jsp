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
    <title>GrowthLens Intern - 成长数据看板</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/echarts@5.4.3/dist/echarts.min.js"></script>
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
        .kpi-card { text-align: center; padding: 24px; cursor: pointer; transition: transform 0.2s; }
        .kpi-card:hover { transform: translateY(-4px); }
        .kpi-card .number { font-size: 36px; font-weight: 700; }
        .kpi-card .label { color: #666; margin-top: 8px; font-size: 14px; }
        .kpi-skill .number { color: #667eea; }
        .kpi-project .number { color: #28a745; }
        .kpi-feedback .number { color: #fd7e14; }
        .chart-container { height: 350px; }
        .sub-nav { margin-bottom: 20px; }
        .sub-nav .nav-link { color: #666; border-radius: 8px; padding: 8px 16px; }
        .sub-nav .nav-link.active { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; }
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
                    <li class="nav-item"><a class="nav-link active" href="<%=request.getContextPath()%>/growth/list">数据看板</a></li>
                    <li class="nav-item"><a class="nav-link" href="<%=request.getContextPath()%>/growth/skill">技能管理</a></li>
                    <li class="nav-item"><a class="nav-link" href="<%=request.getContextPath()%>/growth/project">项目经历</a></li>
                    <li class="nav-item"><a class="nav-link" href="<%=request.getContextPath()%>/growth/feedback">反馈记录</a></li>
                </ul>

                <div class="row" id="kpi-row">
                    <div class="col-md-4">
                        <div class="card kpi-card kpi-skill" onclick="location.href='<%=request.getContextPath()%>/growth/skill'">
                            <div class="number" id="kpi-skill">--</div>
                            <div class="label">技能数量</div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="card kpi-card kpi-project" onclick="location.href='<%=request.getContextPath()%>/growth/project'">
                            <div class="number" id="kpi-project">--</div>
                            <div class="label">项目经历</div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="card kpi-card kpi-feedback" onclick="location.href='<%=request.getContextPath()%>/growth/feedback'">
                            <div class="number" id="kpi-feedback">--</div>
                            <div class="label">反馈记录</div>
                        </div>
                    </div>
                </div>

                <div class="row mt-4">
                    <div class="col-md-6">
                        <div class="card">
                            <div class="card-header">技能等级分布</div>
                            <div class="card-body">
                                <div id="chart-skill-level" class="chart-container"></div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="card">
                            <div class="card-header">技能类型分布</div>
                            <div class="card-body">
                                <div id="chart-skill-type" class="chart-container"></div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="row mt-4">
                    <div class="col-md-6">
                        <div class="card">
                            <div class="card-header">项目成果趋势</div>
                            <div class="card-body">
                                <div id="chart-project-trend" class="chart-container"></div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="card">
                            <div class="card-header">反馈来源分布</div>
                            <div class="card-body">
                                <div id="chart-feedback-source" class="chart-container"></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        var ctxPath = "<%= request.getContextPath() %>";
        var levelLabels = {1: '了解', 2: '熟悉', 3: '掌握', 4: '精通'};
        var typeLabels = {tech: '技术技能', soft: '软技能'};
        var sourceLabels = {'导师': '导师', '同事': '同事', '自评': '自评', '其他': '其他'};

        document.addEventListener('DOMContentLoaded', function() {
            loadDashboard();
        });

        function loadDashboard() {
            fetch(ctxPath + '/stat/dashboard').then(function(r) { return r.json(); }).then(function(res) {
                if (res.code !== 200) return;
                var d = res.data;
                document.getElementById('kpi-skill').textContent = d.skillCount || 0;
                document.getElementById('kpi-project').textContent = d.projectCount || 0;
                document.getElementById('kpi-feedback').textContent = d.feedbackCount || 0;
                renderSkillLevelChart(d.skillLevelDistribution || []);
                renderSkillTypeChart(d.skillTypeDistribution || []);
                renderProjectTrendChart(d.projectMonthTrend || []);
                renderFeedbackSourceChart(d.feedbackSourceDistribution || []);
            }).catch(function(e) { console.error('加载看板数据失败', e); });
        }

        function renderSkillLevelChart(data) {
            var chart = echarts.init(document.getElementById('chart-skill-level'));
            var names = data.map(function(d) { return levelLabels[d.name] || ('等级' + d.name); });
            var values = data.map(function(d) { return d.value; });
            var maxVal = Math.max.apply(null, values.concat([1]));
            chart.setOption({
                tooltip: { trigger: 'item' },
                radar: {
                    indicator: names.map(function(n) { return { name: n, max: maxVal }; })
                },
                series: [{
                    type: 'radar',
                    data: [{ value: values, name: '技能等级', areaStyle: { opacity: 0.3 } }],
                    itemStyle: { color: '#667eea' }
                }]
            });
            window.addEventListener('resize', function() { chart.resize(); });
        }

        function renderSkillTypeChart(data) {
            var chart = echarts.init(document.getElementById('chart-skill-type'));
            var pieData = data.map(function(d) { return { name: typeLabels[d.name] || d.name, value: d.value }; });
            if (pieData.length === 0) pieData = [{ name: '暂无数据', value: 1 }];
            chart.setOption({
                tooltip: { trigger: 'item', formatter: '{b}: {c} ({d}%)' },
                series: [{
                    type: 'pie', radius: ['40%', '70%'],
                    data: pieData,
                    emphasis: { itemStyle: { shadowBlur: 10, shadowOffsetX: 0, shadowColor: 'rgba(0,0,0,0.5)' } },
                    label: { formatter: '{b}\n{d}%' },
                    itemStyle: { color: function(params) { return ['#667eea', '#764ba2', '#28a745', '#fd7e14'][params.dataIndex % 4]; } }
                }]
            });
            window.addEventListener('resize', function() { chart.resize(); });
        }

        function renderProjectTrendChart(data) {
            var chart = echarts.init(document.getElementById('chart-project-trend'));
            var months = data.map(function(d) { return d.month; });
            var counts = data.map(function(d) { return d.count; });
            chart.setOption({
                tooltip: { trigger: 'axis' },
                xAxis: { type: 'category', data: months, axisLabel: { rotate: 30 } },
                yAxis: { type: 'value', minInterval: 1 },
                series: [{
                    type: 'bar', data: counts, name: '项目数量',
                    itemStyle: { color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [{ offset: 0, color: '#667eea' }, { offset: 1, color: '#764ba2' }]) },
                    barWidth: '40%'
                }, {
                    type: 'line', data: counts, name: '趋势',
                    smooth: true, itemStyle: { color: '#28a745' }, lineStyle: { width: 2 }
                }]
            });
            window.addEventListener('resize', function() { chart.resize(); });
        }

        function renderFeedbackSourceChart(data) {
            var chart = echarts.init(document.getElementById('chart-feedback-source'));
            var pieData = data.map(function(d) { return { name: sourceLabels[d.name] || d.name, value: d.value }; });
            if (pieData.length === 0) pieData = [{ name: '暂无数据', value: 1 }];
            chart.setOption({
                tooltip: { trigger: 'item', formatter: '{b}: {c} ({d}%)' },
                series: [{
                    type: 'pie', radius: ['40%', '70%'],
                    data: pieData,
                    emphasis: { itemStyle: { shadowBlur: 10, shadowOffsetX: 0, shadowColor: 'rgba(0,0,0,0.5)' } },
                    label: { formatter: '{b}\n{d}%' },
                    itemStyle: { color: function(params) { return ['#fd7e14', '#667eea', '#28a745', '#764ba2'][params.dataIndex % 4]; } }
                }]
            });
            window.addEventListener('resize', function() { chart.resize(); });
        }
    </script>
</body>
</html>
