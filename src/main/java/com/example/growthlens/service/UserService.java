package com.example.growthlens.service;

import com.example.growthlens.entity.SysUser;

/**
 * 用户业务逻辑接口
 * 定义用户相关的业务操作方法
 */
public interface UserService {

    /**
     * 根据用户名查询用户
     */
    SysUser findByUsername(String username);

    /**
     * 根据用户ID查询用户
     */
    SysUser findById(Long id);

    /**
     * 用户登录
     * @param username 用户名
     * @param password 密码
     * @return 登录成功返回用户信息，失败返回null
     */
    SysUser login(String username, String password);

    /**
     * 用户注册
     * @param user 用户信息
     * @return 注册成功返回用户信息
     */
    SysUser register(SysUser user);

    /**
     * 更新用户信息
     */
    void update(SysUser user);

    /**
     * 删除用户
     */
    void deleteById(Long id);
}