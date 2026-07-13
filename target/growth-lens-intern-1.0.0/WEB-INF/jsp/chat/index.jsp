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
    <title>GrowthLens Intern - 职场自由问答</title>
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
        .chat-container {
            display: flex;
            flex-direction: column;
            height: 70vh;
        }
        .chat-messages {
            flex: 1;
            overflow-y: auto;
            padding: 20px;
            background-color: #f8f9fa;
            border-radius: 8px;
            margin-bottom: 16px;
        }
        .message {
            margin-bottom: 16px;
            display: flex;
        }
        .message.user {
            justify-content: flex-end;
        }
        .message.ai {
            justify-content: flex-start;
        }
        .message-content {
            max-width: 70%;
            padding: 12px 16px;
            border-radius: 12px;
            line-height: 1.6;
            white-space: pre-wrap;
            word-wrap: break-word;
        }
        .message.user .message-content {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-bottom-right-radius: 4px;
        }
        .message.ai .message-content {
            background-color: white;
            color: #333;
            border: 1px solid #e9ecef;
            border-bottom-left-radius: 4px;
        }
        .chat-input-area {
            display: flex;
            gap: 12px;
        }
        .chat-input-area textarea {
            flex: 1;
            resize: none;
            border-radius: 8px;
            border: 1px solid #dee2e6;
            padding: 12px;
        }
        .chat-input-area button {
            align-self: flex-end;
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
        .quick-questions {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            margin-bottom: 16px;
        }
        .quick-question {
            padding: 6px 14px;
            background-color: #e9ecef;
            border-radius: 20px;
            cursor: pointer;
            font-size: 14px;
            transition: all 0.3s;
        }
        .quick-question:hover {
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
                                <a class="nav-link active" href="<%= request.getContextPath() %>/chat/index">自由问答</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="<%= request.getContextPath() %>/chat/script">话术生成</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="<%= request.getContextPath() %>/chat/plan">学习规划</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="<%= request.getContextPath() %>/chat/history">历史记录</a>
                            </li>
                        </ul>

                        <div class="quick-questions">
                            <span class="quick-question" onclick="sendQuickQuestion('如何向导师请教问题？')">如何向导师请教问题？</span>
                            <span class="quick-question" onclick="sendQuickQuestion('实习第一天应该注意什么？')">实习第一天应该注意什么？</span>
                            <span class="quick-question" onclick="sendQuickQuestion('如何高效完成每日工作？')">如何高效完成每日工作？</span>
                            <span class="quick-question" onclick="sendQuickQuestion('职场沟通有哪些技巧？')">职场沟通有哪些技巧？</span>
                        </div>

                        <div class="chat-container">
                            <div class="chat-messages" id="chatMessages">
                                <div class="message ai">
                                    <div class="message-content">
                                        你好！我是你的职场智能助手，有什么职场问题都可以问我哦~
                                    </div>
                                </div>
                            </div>
                            <div class="chat-input-area">
                                <textarea id="questionInput" rows="3" placeholder="请输入你的问题..." onkeydown="handleKeyDown(event)"></textarea>
                                <button class="btn btn-primary" onclick="sendMessage()">发送</button>
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
        var sessionId = null;

        function handleKeyDown(event) {
            if (event.key === 'Enter' && !event.shiftKey) {
                event.preventDefault();
                sendMessage();
            }
        }

        function sendQuickQuestion(question) {
            document.getElementById('questionInput').value = question;
            sendMessage();
        }

        function sendMessage() {
            var input = document.getElementById('questionInput');
            var btn = document.querySelector('.chat-input-area button');
            var question = input.value.trim();
            if (!question) return;

            btn.disabled = true;
            btn.textContent = '发送中...';

            addMessage(question, 'user');
            input.value = '';

            var loadingId = addLoadingMessage();

            var formData = new FormData();
            formData.append('question', question);
            if (sessionId) {
                formData.append('sessionId', sessionId);
            }

            fetch(ctxPath + '/chat/free', {
                method: 'POST',
                body: formData
            }).then(function(response) {
                return response.json();
            }).then(function(result) {
                removeMessage(loadingId);
                if (result.code === 200) {
                    addMessage(result.data, 'ai');
                } else {
                    addMessage('抱歉，出错了：' + result.msg, 'ai');
                }
            }).catch(function(error) {
                removeMessage(loadingId);
                addMessage('抱歉，网络错误，请稍后重试', 'ai');
            }).finally(function() {
                btn.disabled = false;
                btn.textContent = '发送';
            });
        }

        function addMessage(content, type) {
            var container = document.getElementById('chatMessages');
            var msgDiv = document.createElement('div');
            msgDiv.className = 'message ' + type;
            msgDiv.id = 'msg-' + Date.now();

            var contentDiv = document.createElement('div');
            contentDiv.className = 'message-content';
            contentDiv.textContent = content;

            msgDiv.appendChild(contentDiv);
            container.appendChild(msgDiv);
            container.scrollTop = container.scrollHeight;

            return msgDiv.id;
        }

        function addLoadingMessage() {
            var container = document.getElementById('chatMessages');
            var msgDiv = document.createElement('div');
            msgDiv.className = 'message ai';
            msgDiv.id = 'loading-' + Date.now();

            var contentDiv = document.createElement('div');
            contentDiv.className = 'message-content';
            contentDiv.textContent = '正在思考中...';

            msgDiv.appendChild(contentDiv);
            container.appendChild(msgDiv);
            container.scrollTop = container.scrollHeight;

            return msgDiv.id;
        }

        function removeMessage(id) {
            var msg = document.getElementById(id);
            if (msg) {
                msg.remove();
            }
        }
    </script>
</body>
</html>
