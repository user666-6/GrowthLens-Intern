package com.example.growthlens.controller;

import com.example.growthlens.common.JwtUtil;
import com.example.growthlens.common.LoginUserHolder;
import com.example.growthlens.common.Result;
import com.example.growthlens.entity.SysUser;
import com.example.growthlens.service.UserService;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.io.IOException;

/**
 * 用户控制器
 * 处理用户相关的HTTP请求
 */
@RestController
@RequestMapping("/user")
public class UserController {

    @Autowired
    private UserService userService;

    @Autowired
    private JwtUtil jwtUtil;

    /**
     * JWT令牌在Cookie中的名称
     */
    private static final String COOKIE_TOKEN_NAME = "token";

    /**
     * 用户登录接口
     * 登录成功后生成JWT令牌并写入HttpOnly Cookie
     */
    @PostMapping("/login")
    public Result<SysUser> login(@RequestParam String username, @RequestParam String password,
                                  HttpServletResponse response) {
        SysUser user = userService.login(username, password);
        String token = jwtUtil.generateToken(user);
        
        Cookie cookie = new Cookie(COOKIE_TOKEN_NAME, token);
        cookie.setHttpOnly(true);
        cookie.setPath("/");
        cookie.setMaxAge((int) (jwtUtil.getExpireTime() / 1000));
        response.addCookie(cookie);
        
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
     * 清除Cookie中的JWT令牌，并重定向到登录页
     */
    @PostMapping("/logout")
    public void logout(HttpServletRequest request, HttpServletResponse response) throws IOException {
        Cookie cookie = new Cookie(COOKIE_TOKEN_NAME, "");
        cookie.setHttpOnly(true);
        cookie.setPath("/");
        cookie.setMaxAge(0);
        response.addCookie(cookie);
        
        response.sendRedirect(request.getContextPath() + "/login");
    }

    /**
     * 获取当前登录用户信息
     * 从LoginUserHolder中获取当前登录用户
     */
    @GetMapping("/info")
    public Result<SysUser> getUserInfo() {
        SysUser user = LoginUserHolder.getCurrentUser();
        return Result.success(user);
    }

    /**
     * 更新用户信息
     */
    @PutMapping("/update")
    public Result<SysUser> update(@RequestBody SysUser user) {
        userService.update(user);
        SysUser updatedUser = userService.findById(user.getId());
        updatedUser.setPassword(null);
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
