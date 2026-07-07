package com.example.growthlens.controller;

import com.example.growthlens.common.Result;
import com.example.growthlens.entity.SysUser;
import com.example.growthlens.service.UserService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

/**
 * 个人中心控制器
 * 处理个人信息管理相关的页面跳转和数据操作
 */
@Controller
@RequestMapping("/user/profile")
public class UserProfileController {

    @Autowired
    private UserService userService;

    private static final String SESSION_USER_KEY = "loginUser";

    /**
     * 跳转到个人信息详情页
     */
    @GetMapping("/info")
    public String info(HttpSession session, Model model) {
        SysUser loginUser = (SysUser) session.getAttribute(SESSION_USER_KEY);
        SysUser user = userService.findById(loginUser.getId());
        model.addAttribute("user", user);
        return "user/profile/info";
    }

    /**
     * 跳转到编辑个人信息页面
     */
    @GetMapping("/edit")
    public String edit(HttpSession session, Model model) {
        SysUser loginUser = (SysUser) session.getAttribute(SESSION_USER_KEY);
        SysUser user = userService.findById(loginUser.getId());
        model.addAttribute("user", user);
        return "user/profile/edit";
    }

    /**
     * 提交编辑个人信息
     */
    @PostMapping("/edit")
    @ResponseBody
    public Result<SysUser> editSubmit(
            @RequestParam(required = false) String nickname,
            @RequestParam(required = false) String email,
            @RequestParam(required = false) String phone,
            @RequestParam(required = false) String avatar,
            HttpSession session) {

        SysUser loginUser = (SysUser) session.getAttribute(SESSION_USER_KEY);
        
        SysUser user = new SysUser();
        user.setId(loginUser.getId());
        user.setNickname(nickname);
        user.setEmail(email);
        user.setPhone(phone);
        user.setAvatar(avatar);
        
        userService.update(user);
        SysUser updatedUser = userService.findById(loginUser.getId());
        session.setAttribute(SESSION_USER_KEY, updatedUser);
        
        return Result.success("修改成功", updatedUser);
    }

    /**
     * 跳转到修改密码页面
     */
    @GetMapping("/password")
    public String password() {
        return "user/profile/password";
    }

    /**
     * 提交修改密码
     */
    @PostMapping("/password")
    @ResponseBody
    public Result<?> changePassword(
            @RequestParam String oldPassword,
            @RequestParam String newPassword,
            @RequestParam String confirmPassword,
            HttpSession session) {

        if (!newPassword.equals(confirmPassword)) {
            return Result.error("两次输入的新密码不一致");
        }
        if (newPassword.length() < 6) {
            return Result.error("密码长度不能少于6位");
        }

        SysUser loginUser = (SysUser) session.getAttribute(SESSION_USER_KEY);
        userService.changePassword(loginUser.getId(), oldPassword, newPassword);
        
        session.removeAttribute(SESSION_USER_KEY);
        
        return Result.success("密码修改成功，请重新登录");
    }
}