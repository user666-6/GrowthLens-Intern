package com.example.growthlens.common;

import com.example.growthlens.entity.SysUser;
import io.jsonwebtoken.*;
import io.jsonwebtoken.security.Keys;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import javax.crypto.SecretKey;
import java.nio.charset.StandardCharsets;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

/**
 * JWT工具类
 * 提供JWT令牌的生成、解析、校验等功能
 */
@Component
public class JwtUtil {

    /**
     * JWT签名密钥，从配置文件读取
     */
    @Value("${jwt.secret}")
    private String secret;

    /**
     * JWT令牌过期时间（毫秒），从配置文件读取
     */
    @Value("${jwt.expire-time}")
    private Long expireTime;

    /**
     * 获取签名密钥
     * @return SecretKey对象
     */
    private SecretKey getSigningKey() {
        byte[] keyBytes = secret.getBytes(StandardCharsets.UTF_8);
        return Keys.hmacShaKeyFor(keyBytes);
    }

    /**
     * 生成JWT令牌
     * @param user 用户对象，从中提取userId、username、role
     * @return JWT令牌字符串
     */
    public String generateToken(SysUser user) {
        Map<String, Object> claims = new HashMap<>();
        claims.put("userId", user.getId());
        claims.put("username", user.getUsername());
        claims.put("role", user.getRole());

        Date now = new Date();
        Date expiryDate = new Date(now.getTime() + expireTime);

        return Jwts.builder()
                .claims(claims)
                .subject(user.getUsername())
                .issuedAt(now)
                .expiration(expiryDate)
                .signWith(getSigningKey(), Jwts.SIG.HS256)
                .compact();
    }

    /**
     * 解析JWT令牌，获取Claims对象
     * @param token JWT令牌字符串
     * @return Claims对象，包含令牌中的所有声明信息
     * @throws BusinessException 令牌校验失败时抛出
     */
    public Claims parseToken(String token) {
        try {
            return Jwts.parser()
                    .verifyWith(getSigningKey())
                    .build()
                    .parseSignedClaims(token)
                    .getPayload();
        } catch (JwtException e) {
            throw new BusinessException(401, "令牌无效或已过期");
        }
    }

    /**
     * 校验令牌是否有效（未过期、签名正确）
     * @param token JWT令牌字符串
     * @return 有效返回true，无效返回false
     */
    public boolean validateToken(String token) {
        try {
            Claims claims = parseToken(token);
            return !claims.getExpiration().before(new Date());
        } catch (Exception e) {
            return false;
        }
    }

    /**
     * 从令牌中获取用户ID
     * @param token JWT令牌字符串
     * @return 用户ID
     */
    public Long getUserIdFromToken(String token) {
        Claims claims = parseToken(token);
        return claims.get("userId", Long.class);
    }

    /**
     * 从令牌中获取用户名
     * @param token JWT令牌字符串
     * @return 用户名
     */
    public String getUsernameFromToken(String token) {
        Claims claims = parseToken(token);
        return claims.get("username", String.class);
    }

    /**
     * 从令牌中获取用户角色
     * @param token JWT令牌字符串
     * @return 用户角色
     */
    public Integer getRoleFromToken(String token) {
        Claims claims = parseToken(token);
        return claims.get("role", Integer.class);
    }

    /**
     * 获取令牌过期时间（毫秒）
     * @return 过期时间
     */
    public Long getExpireTime() {
        return expireTime;
    }
}
