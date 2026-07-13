 一句话简介
GrowthLens Intern 是一款面向实习生的智能成长管理系统，通过 AI 赋能帮助实习生进行目标管理、日报周报记录、技能追踪和自我复盘。

技术栈
分类               技术             版本 
框架         Spring Boot     3.2.5 
语言         Java                  21
数据库     MySQL             8.0+
ORM       MyBatis           3.0.3 
分页         PageHelper     1.4.7 
认证         JJWT               0.12.5
视图        JSP + JSTL          - 
构建         Maven             3.6+

5 分钟快速开始 
1. 环境准备
确保已安装：

- JDK 21+
- MySQL 8.0+
- Maven 3.6+
2. 创建数据库 
CREATE DATABASE `GrowthLens Intern` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
3. 导入数据
执行 SQL 文件： growthlens intern.sql
mysql -u root -p "GrowthLens Intern" < "src/main/resources/sql/growthlens intern.sql"
4. 配置数据库连接（可选）
修改配置文件 application.yml ：
spring:
  datasource:
    url: jdbc:mysql://localhost:3306/GrowthLens%20Intern?useUnicode=true&characterEncoding=utf8&serverTimezone=Asia/Shanghai
    username: root
    password: 123456 
5. 启动项目 
cd "GrowthLens Intern"
mvn spring-boot:run
6. 访问系统
- 访问地址 ： http://localhost:8080/intern/login
- 服务端口 ：8080
- 上下文路径 ： /intern 7. 测试账号
角色               用户名          密码 
普通用户        huang      123456 
管理员           admin       123456

目录结构说明

GrowthLens Intern/
├── src/main/java/com/example/growthlens/
│   ├── common/              # 通用工具类
│   │   ├── BusinessException.java      # 业务异常
│   │   ├── GlobalExceptionHandler.java # 全局异常处理
│   │   ├── JwtUtil.java                # JWT工具
│   │   ├── LoginUserHolder.java        # 用户上下文
│   │   └── Result.java                 # 统一响应封装
│   │
│   ├── config/              # 配置类
│   │   ├── AdminInterceptor.java       # 管理员拦截器
│   │   ├── LoginInterceptor.java       # 登录拦截器
│   │   └── WebConfig.java              # Web配置
│   │
│   ├── controller/          # 控制器层
│   │   ├── AiController.java           # AI服务接口
│   │   ├── DailyReportController.java  # 日报周报管理
│   │   ├── GoalController.java         # 目标管理
│   │   ├── GrowthSkillController.java  # 技能管理
│   │   ├── InterviewController.java    # 面试题库
│   │   └── UserController.java         # 用户管理
│   │
│   ├── entity/              # 实体类
│   │   ├── DailyReport.java            # 日报实体
│   │   ├── WeeklyReport.java           # 周报实体
│   │   ├── GoalInfo.java               # 目标实体
│   │   ├── GrowthSkill.java            # 技能实体
│   │   └── SysUser.java                # 用户实体
│   │
│   ├── mapper/              # 数据访问层
│   │   ├── DailyReportMapper.java      # 日报Mapper
│   │   ├── WeeklyReportMapper.java     # 周报Mapper
│   │   └── UserMapper.java             # 用户Mapper
│   │
│   ├── service/             # 业务服务层
│   │   ├── impl/                       # 服务实现
│   │   ├── DailyReportService.java     # 日报服务接口
│   │   ├── WeeklyReportService.java    # 周报服务接口
│   │   └── AiService.java              # AI服务接口
│   │
│   └── GrowthLensApplication.java      # 启动类
│
├── src/main/resources/
│   ├── application.yml                 # 应用配置
│   ├── mapper/                         # MyBatis XML映射
文件
│   └── sql/growthlens intern.sql       # 数据库初始化脚本
│
├── src/main/webapp/WEB-INF/jsp/        # JSP视图模板
│   ├── dailyreport/                    # 日报周报页面
│   ├── goal/                           # 目标管理页面
│   ├── growth/                         # 成长中心页面
│   ├── interview/                      # 面试题库页面
│   ├── common/                         # 公共组件（header/
sidebar）
│   ├── login.jsp                       # 登录页
│   └── index.jsp                       # 首页
│
└── pom.xml                             # Maven依赖配置
```