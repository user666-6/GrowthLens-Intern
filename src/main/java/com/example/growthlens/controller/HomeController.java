package com.example.growthlens.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

/**
 * 首页控制器
 * 处理页面跳转请求
 */
@Controller
public class HomeController {

    /**
     * 首页跳转
     */
    @GetMapping({"/", "/index"})
    public String index() {
        return "index";
    }

    /**
     * 登录页跳转
     */
    @GetMapping("/login")
    public String login() {
        return "login";
    }
}