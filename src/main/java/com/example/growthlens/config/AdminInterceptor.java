package com.example.growthlens.config;

import com.example.growthlens.common.BusinessException;
import com.example.growthlens.common.LoginUserHolder;
import com.example.growthlens.entity.SysUser;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

/**
 * 管理员权限拦截器
 * 验证用户是否具有管理员权限（role=1），非管理员则拒绝访问
 */
@Component
public class AdminInterceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        SysUser loginUser = LoginUserHolder.getCurrentUser();
        
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
