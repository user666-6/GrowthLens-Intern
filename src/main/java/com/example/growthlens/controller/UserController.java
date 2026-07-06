package com.example.growthlens.controller;

import com.example.growthlens.common.Result;
import com.example.growthlens.entity.SysUser;
import com.example.growthlens.service.UserService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

/**
 * 用户控制器
 * 处理用户相关的HTTP请求
 */
@RestController
@RequestMapping("/user")
public class UserController {

    @Autowired
    private UserService userService;

    /**
     * 登录用户在Session中的key
     */
    private static final String SESSION_USER_KEY = "loginUser";

    /**
     * 用户登录接口
     */
    @PostMapping("/login")
    public Result<SysUser> login(@RequestParam String username, @RequestParam String password, HttpSession session) {
        SysUser user = userService.login(username, password);
        // 将用户信息存入Session
        session.setAttribute(SESSION_USER_KEY, user);
        return Result.success("登录成功", user);
    }

    /**
     * 用户注册接口
     */
    @PostMapping("/register")
    public Result<SysUser> register(@RequestBody SysUser user) {
        SysUser newUser = userService.register(user);
        return Result.success("注册成功", newUser);
    }

    /**
     * 用户退出登录
     */
    @PostMapping("/logout")
    public Result<?> logout(HttpSession session) {
        // 清除Session中的用户信息
        session.removeAttribute(SESSION_USER_KEY);
        return Result.success("退出成功");
    }

    /**
     * 获取当前登录用户信息
     */
    @GetMapping("/info")
    public Result<SysUser> getUserInfo(HttpSession session) {
        SysUser user = (SysUser) session.getAttribute(SESSION_USER_KEY);
        return Result.success(user);
    }

    /**
     * 更新用户信息
     */
    @PutMapping("/update")
    public Result<SysUser> update(@RequestBody SysUser user, HttpSession session) {
        userService.update(user);
        // 更新Session中的用户信息
        SysUser updatedUser = userService.findById(user.getId());
        updatedUser.setPassword(null);
        session.setAttribute(SESSION_USER_KEY, updatedUser);
        return Result.success("更新成功", updatedUser);
    }

    /**
     * 删除用户
     */
    @DeleteMapping("/delete/{id}")
    public Result<?> delete(@PathVariable Long id) {
        userService.deleteById(id);
        return Result.success("删除成功");
    }
}