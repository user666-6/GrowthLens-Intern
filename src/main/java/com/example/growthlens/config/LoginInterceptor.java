package com.example.growthlens.config;

import com.example.growthlens.common.JwtUtil;
import com.example.growthlens.common.LoginUserHolder;
import com.example.growthlens.entity.SysUser;
import com.example.growthlens.service.UserService;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

/**
 * 登录拦截器
 * 验证用户是否已登录，通过JWT令牌进行鉴权
 * 未登录则：页面请求重定向到登录页，接口请求返回401未授权
 */
@Component
public class LoginInterceptor implements HandlerInterceptor {

    /**
     * JWT令牌在Cookie中的名称
     */
    private static final String COOKIE_TOKEN_NAME = "token";

    /**
     * 登录用户在request域中的key，供JSP页面使用
     */
    private static final String REQUEST_USER_KEY = "loginUser";

    @Autowired
    private JwtUtil jwtUtil;

    @Autowired
    private UserService userService;

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        String token = getTokenFromCookie(request);

        if (token == null || token.isEmpty()) {
            handleUnauthorized(request, response);
            return false;
        }

        if (!jwtUtil.validateToken(token)) {
            handleUnauthorized(request, response);
            return false;
        }

        Long userId = jwtUtil.getUserIdFromToken(token);
        SysUser user = userService.findById(userId);

        if (user == null) {
            handleUnauthorized(request, response);
            return false;
        }

        if (user.getStatus() == 0) {
            handleUnauthorized(request, response);
            return false;
        }

        user.setPassword(null);
        LoginUserHolder.setCurrentUser(user);
        request.setAttribute(REQUEST_USER_KEY, user);
        request.getSession().setAttribute(REQUEST_USER_KEY, user);

        return true;
    }

    @Override
    public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex) throws Exception {
        LoginUserHolder.removeCurrentUser();
    }

    /**
     * 从Cookie中获取JWT令牌
     * @param request HTTP请求对象
     * @return JWT令牌字符串，未找到返回null
     */
    private String getTokenFromCookie(HttpServletRequest request) {
        Cookie[] cookies = request.getCookies();
        if (cookies == null) {
            return null;
        }
        for (Cookie cookie : cookies) {
            if (COOKIE_TOKEN_NAME.equals(cookie.getName())) {
                return cookie.getValue();
            }
        }
        return null;
    }

    /**
     * 处理未授权请求
     * 页面请求重定向到登录页，接口请求返回401未授权
     * @param request HTTP请求对象
     * @param response HTTP响应对象
     */
    private void handleUnauthorized(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String requestUri = request.getRequestURI();
        if (requestUri.startsWith("/api/") || request.getHeader("X-Requested-With") != null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.setContentType("application/json;charset=UTF-8");
            response.getWriter().write("{\"code\":401,\"msg\":\"未登录或登录已过期\",\"data\":null}");
        } else {
            response.sendRedirect(request.getContextPath() + "/login");
        }
    }
}
