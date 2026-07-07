package com.example.growthlens.controller;

import com.example.growthlens.common.Result;
import com.example.growthlens.entity.SysUser;
import com.example.growthlens.service.UserService;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

/**
 * 用户管理控制器
 * 处理管理员端用户管理相关的页面跳转和数据操作
 */
@Controller
@RequestMapping("/user/manage")
public class UserManageController {

    @Autowired
    private UserService userService;

    @Autowired
    private BCryptPasswordEncoder passwordEncoder;

    /**
     * 跳转到用户列表页
     */
    @GetMapping("/list")
    public String list(
            @RequestParam(defaultValue = "1") Integer pageNum,
            @RequestParam(defaultValue = "10") Integer pageSize,
            @RequestParam(required = false) String username,
            @RequestParam(required = false) String nickname,
            @RequestParam(required = false) Integer status,
            Model model) {

        PageHelper.startPage(pageNum, pageSize);
        PageInfo<SysUser> pageInfo = new PageInfo<>(userService.findByCondition(username, nickname, status));
        
        model.addAttribute("pageInfo", pageInfo);
        model.addAttribute("username", username);
        model.addAttribute("nickname", nickname);
        model.addAttribute("status", status);
        
        return "user/manage/list";
    }

    /**
     * 跳转到新增用户页面
     */
    @GetMapping("/add")
    public String add() {
        return "user/manage/add";
    }

    /**
     * 新增用户提交
     */
    @PostMapping("/add")
    @ResponseBody
    public Result<SysUser> addSubmit(
            @RequestParam String username,
            @RequestParam String password,
            @RequestParam(required = false) String nickname,
            @RequestParam(required = false) String email,
            @RequestParam(required = false) String phone,
            @RequestParam(defaultValue = "1") Integer status) {

        SysUser user = new SysUser();
        user.setUsername(username);
        user.setPassword(passwordEncoder.encode(password));
        user.setNickname(nickname);
        user.setEmail(email);
        user.setPhone(phone);
        user.setStatus(status);
        
        userService.register(user);
        return Result.success("新增成功", user);
    }

    /**
     * 跳转到编辑用户页面
     */
    @GetMapping("/edit/{id}")
    public String edit(@PathVariable Long id, Model model) {
        SysUser user = userService.findById(id);
        model.addAttribute("user", user);
        return "user/manage/edit";
    }

    /**
     * 编辑用户提交
     */
    @PostMapping("/edit")
    @ResponseBody
    public Result<SysUser> editSubmit(
            @RequestParam Long id,
            @RequestParam(required = false) String nickname,
            @RequestParam(required = false) String email,
            @RequestParam(required = false) String phone,
            @RequestParam Integer status) {

        SysUser user = new SysUser();
        user.setId(id);
        user.setNickname(nickname);
        user.setEmail(email);
        user.setPhone(phone);
        user.setStatus(status);
        
        userService.update(user);
        SysUser updatedUser = userService.findById(id);
        return Result.success("修改成功", updatedUser);
    }

    /**
     * 删除用户
     */
    @PostMapping("/delete/{id}")
    @ResponseBody
    public Result<?> delete(@PathVariable Long id) {
        userService.deleteById(id);
        return Result.success("删除成功");
    }

    /**
     * 切换用户状态
     */
    @PostMapping("/status/{id}")
    @ResponseBody
    public Result<?> toggleStatus(@PathVariable Long id) {
        SysUser user = userService.findById(id);
        Integer newStatus = user.getStatus() == 1 ? 0 : 1;
        userService.updateStatus(id, newStatus);
        return Result.success(newStatus == 1 ? "已启用" : "已禁用");
    }

    /**
     * 校验用户名是否已存在
     */
    @PostMapping("/checkUsername")
    @ResponseBody
    public Result<Boolean> checkUsername(@RequestParam String username) {
        SysUser user = userService.findByUsername(username);
        return Result.success(user == null);
    }

    /**
     * 校验邮箱是否已存在
     */
    @PostMapping("/checkEmail")
    @ResponseBody
    public Result<Boolean> checkEmail(@RequestParam String email) {
        if (email == null || email.isEmpty()) {
            return Result.success(true);
        }
        SysUser user = userService.findByUsername(email);
        return Result.success(user == null);
    }
}