package com.example.growthlens.config;

import com.example.growthlens.common.BusinessException;
import com.example.growthlens.entity.SysUser;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.springframework.web.servlet.HandlerInterceptor;

/**
 * 管理员权限拦截器
 * 验证用户是否具有管理员权限（role=1），非管理员则拒绝访问
 */
public class AdminInterceptor implements HandlerInterceptor {

    private static final String SESSION_USER_KEY = "loginUser";

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        HttpSession session = request.getSession();
        SysUser loginUser = (SysUser) session.getAttribute(SESSION_USER_KEY);
        
        if (loginUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return false;
        }
        
        if (loginUser.getRole() == null || loginUser.getRole() != 1) {
            throw new BusinessException("无权限访问");
        }
        
        return true;
    }
}