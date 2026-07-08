package com.example.growthlens.common;

/**
 * 未授权异常类
 * 用于封装用户未登录或登录已过期的异常情况
 */
public class UnauthorizedException extends RuntimeException {

    public UnauthorizedException(String message) {
        super(message);
    }
}
