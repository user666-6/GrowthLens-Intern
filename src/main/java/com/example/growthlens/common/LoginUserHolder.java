package com.example.growthlens.common;

import com.example.growthlens.entity.SysUser;

/**
 * 登录用户上下文工具类
 * 基于ThreadLocal存储当前登录用户信息，供整个请求链路使用
 */
public class LoginUserHolder {

    /**
     * ThreadLocal存储当前登录用户
     */
    private static final ThreadLocal<SysUser> THREAD_LOCAL = new ThreadLocal<>();

    /**
     * 设置当前登录用户
     * @param user 用户对象
     */
    public static void setCurrentUser(SysUser user) {
        THREAD_LOCAL.set(user);
    }

    /**
     * 获取当前登录用户
     * @return 用户对象，未登录返回null
     */
    public static SysUser getCurrentUser() {
        return THREAD_LOCAL.get();
    }

    /**
     * 移除当前登录用户
     * 必须在请求结束后调用，防止内存泄漏和线程复用数据错乱
     */
    public static void removeCurrentUser() {
        THREAD_LOCAL.remove();
    }

    /**
     * 获取当前登录用户ID
     * @return 用户ID，未登录返回null
     */
    public static Long getCurrentUserId() {
        SysUser user = THREAD_LOCAL.get();
        return user != null ? user.getId() : null;
    }

    /**
     * 获取当前登录用户角色
     * @return 用户角色，未登录返回null
     */
    public static Integer getCurrentUserRole() {
        SysUser user = THREAD_LOCAL.get();
        return user != null ? user.getRole() : null;
    }

    /**
     * 判断当前用户是否为管理员
     * @return 是管理员返回true，否则返回false
     */
    public static boolean isAdmin() {
        SysUser user = THREAD_LOCAL.get();
        return user != null && user.getRole() != null && user.getRole() == 1;
    }
}
