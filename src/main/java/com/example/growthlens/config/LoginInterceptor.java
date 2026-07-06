package com.example.growthlens.config;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.springframework.web.servlet.HandlerInterceptor;

/**
 * 登录拦截器
 * 验证用户是否已登录，未登录则跳转到登录页
 */
public class LoginInterceptor implements HandlerInterceptor {

    /**
     * 登录用户在Session中的key
     */
    private static final String SESSION_USER_KEY = "loginUser";

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        HttpSession session = request.getSession();
        // 检查Session中是否存在登录用户
        if (session.getAttribute(SESSION_USER_KEY) == null) {
            // 未登录，跳转到登录页
            response.sendRedirect(request.getContextPath() + "/login");
            return false;
        }
        // 已登录，继续执行
        return true;
    }
}