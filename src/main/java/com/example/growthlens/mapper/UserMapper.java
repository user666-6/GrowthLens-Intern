package com.example.growthlens.mapper;

import com.example.growthlens.entity.SysUser;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.util.List;

/**
 * 用户数据访问层
 * 只负责数据库CRUD操作，不包含业务逻辑
 */
@Mapper
public interface UserMapper {

    /**
     * 根据用户名查询用户
     */
    @Select("SELECT * FROM sys_user WHERE username = #{username}")
    SysUser findByUsername(@Param("username") String username);

    /**
     * 根据用户ID查询用户
     */
    @Select("SELECT * FROM sys_user WHERE id = #{id}")
    SysUser findById(@Param("id") Long id);

    /**
     * 根据邮箱查询用户
     */
    @Select("SELECT * FROM sys_user WHERE email = #{email}")
    SysUser findByEmail(@Param("email") String email);

    /**
     * 插入用户
     */
    int insert(SysUser user);

    /**
     * 更新用户
     */
    int update(SysUser user);

    /**
     * 根据ID删除用户
     */
    int deleteById(@Param("id") Long id);

    /**
     * 查询所有用户
     */
    List<SysUser> findAll();

    /**
     * 条件分页查询用户
     */
    List<SysUser> findByCondition(@Param("username") String username, @Param("nickname") String nickname, @Param("status") Integer status);
}