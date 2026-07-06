package com.example.growthlens.service.impl;

import com.example.growthlens.common.BusinessException;
import com.example.growthlens.entity.SysUser;
import com.example.growthlens.mapper.UserMapper;
import com.example.growthlens.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

/**
 * 用户业务逻辑实现类
 * 实现用户相关的业务操作
 */
@Service
public class UserServiceImpl implements UserService {

    @Autowired
    private UserMapper userMapper;

    @Autowired
    private BCryptPasswordEncoder passwordEncoder;

    @Override
    public SysUser findByUsername(String username) {
        return userMapper.findByUsername(username);
    }

    @Override
    public SysUser findById(Long id) {
        return userMapper.findById(id);
    }

    @Override
    public SysUser login(String username, String password) {
        SysUser user = userMapper.findByUsername(username);
        // 用户不存在
        if (user == null) {
            throw new BusinessException("用户名或密码错误");
        }
        // 用户已禁用
        if (user.getStatus() == 0) {
            throw new BusinessException("用户已被禁用，请联系管理员");
        }
        // 密码验证
        if (!passwordEncoder.matches(password, user.getPassword())) {
            throw new BusinessException("用户名或密码错误");
        }
        // 登录成功，不返回密码
        user.setPassword(null);
        return user;
    }

    @Override
    public SysUser register(SysUser user) {
        // 检查用户名是否已存在
        if (userMapper.findByUsername(user.getUsername()) != null) {
            throw new BusinessException("用户名已存在");
        }
        // 检查邮箱是否已存在
        if (userMapper.findByEmail(user.getEmail()) != null) {
            throw new BusinessException("邮箱已被注册");
        }
        // 密码加密
        user.setPassword(passwordEncoder.encode(user.getPassword()));
        // 设置默认状态为启用
        user.setStatus(1);
        // 插入用户
        userMapper.insert(user);
        // 返回用户信息（不含密码）
        user.setPassword(null);
        return user;
    }

    @Override
    public void update(SysUser user) {
        // 检查用户是否存在
        if (userMapper.findById(user.getId()) == null) {
            throw new BusinessException("用户不存在");
        }
        // 如果密码有更新，重新加密
        if (user.getPassword() != null && !user.getPassword().isEmpty()) {
            user.setPassword(passwordEncoder.encode(user.getPassword()));
        }
        userMapper.update(user);
    }

    @Override
    public void deleteById(Long id) {
        if (userMapper.findById(id) == null) {
            throw new BusinessException("用户不存在");
        }
        userMapper.deleteById(id);
    }
}