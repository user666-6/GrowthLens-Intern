# GrowthLens 实习生智能成长系统 - Agent PRD / Rules

> **版本**: V1.0  
> **日期**: 2026-07-10  
> **适用范围**: 所有代码生成、功能开发、模块扩展  

---

## ① 项目概述

### 1.1 项目名称
GrowthLens 实习生智能成长系统 (GrowthLens Intern)

### 1.2 项目定位
面向实习生群体的一站式职业成长工具，结合大语言模型能力，打造 **「工作记录 → 复盘沉淀 → 目标追踪 → 求职储备」** 完整成长闭环。

### 1.3 核心价值
- **智能记录**: AI辅助生成日报周报，降低记录门槛
- **成长可视化**: 技能雷达图、成果趋势图，直观展现成长轨迹
- **目标闭环**: 从总目标到子任务的完整拆解与进度追踪
- **深度复盘**: 基于工作记录的AI智能复盘，发现问题、优化改进
- **求职赋能**: 面经题库与AI答题指导，助力求职面试

### 1.4 业务模块架构（6+1）

| 模块 | 定位 | 状态 | 核心功能 |
|------|------|------|----------|
| **日报周报管理** | 基础核心模块 | ✅ 已实现 | 日报CRUD、周报聚合生成、AI润色 |
| **成长轨迹追踪** | 成果展示模块 | ✅ 已实现 | 技能管理、项目经历、反馈评价、成长看板 |
| **目标任务管理** | 规划闭环模块 | ✅ 已实现 | 目标拆解、任务追踪、进度可视化、AI智能拆解 |
| **智能复盘分析** | AI亮点模块 | ⚠️ 待补全 | 日/周/月度复盘生成、复盘历史管理 |（缺失：ReviewController、ReviewService、ReviewServiceImpl、ReviewMapper、review/list.jsp）|
| **面经题库管理** | 求职刚需模块 | ✅ 已实现 | 题目分类、刷题练习、AI参考答案 |
| **职场智能助手** | 增值服务模块 | ✅ 已实现 | 自由问答、话术生成、学习规划 |
| **AI服务底座** | 公共能力模块 | ✅ 已实现 | 统一封装大模型调用、提示词模板、调用日志 |

### 1.5 目标用户
- **普通用户** (`role=0`)：实习学生，使用系统进行成长管理
- **系统管理员** (`role=1`)：管理用户、配置AI模板、查看调用日志

### 1.6 项目目标
- 完成实训开发任务，架构规范，功能完整
- 具备 AI 差异化亮点，6大模块形成完整成长闭环
- 代码结构清晰，模块解耦，便于团队协作开发

---

## ② 技术选型

### 2.1 后端技术栈

| 技术 | 版本 | 说明 |
|------|------|------|
| Spring Boot | 3.2.5 | 后端核心框架 |
| MyBatis | 3.0.3 | 持久层框架 |
| PageHelper | 1.4.7 | MyBatis分页插件 |
| MySQL | 8.0+ | 关系型数据库 |
| mysql-connector-j | 8.x | MySQL驱动 |
| HikariCP | 内置 | 数据库连接池 |
| Lombok | 1.18.x | 代码简化工具 |
| JJWT | 0.12.5 | JWT令牌生成与解析 |
| Spring Security Crypto | 6.2.x | BCrypt密码加密 |
| Spring Validation | 内置 | 参数校验 |
| Java | 21 | 编程语言版本 |

### 2.2 前端技术栈

| 技术 | 版本 | 说明 |
|------|------|------|
| JSP | Jakarta版本 | 视图层技术 |
| JSTL | Jakarta版本 | JSP标准标签库 |
| Bootstrap | 5.1.3 | UI框架 |
| 原生JavaScript | ES6+ | 前端交互逻辑 |
| ECharts | 5.x | 图表库（成长看板使用） |

### 2.3 架构模式
- **三层架构**: Controller → Service → Mapper
- **接口风格**: RESTful API，语义化URL，标准HTTP方法
- **鉴权方案**: JWT令牌 + HttpOnly Cookie + 全局拦截器
- **前端渲染**: 服务端渲染（SSR），JSP模板引擎
- **布局模式**: 左侧侧边栏 + 顶部导航 + 右侧主内容区

### 2.4 AI服务集成
- **大模型供应商**: SiliconFlow（硅基流动）
- **兼容格式**: OpenAI API 兼容格式
- **基础URL**: `https://api.siliconflow.cn/v1`
- **调用方式**: RestTemplate 封装 HTTP 请求
- **配置存储**: `ai_system_config` 数据库表（支持动态修改）
- **统一入口**: `AiService` 接口，所有业务模块必须通过此接口调用

### 2.5 核心配置

| 配置项 | 值 | 说明 |
|--------|-----|------|
| 服务端口 | 8080 | 应用监听端口 |
| 上下文路径 | /intern | 项目访问路径前缀 |
| 数据库名 | GrowthLens Intern | 含空格，URL中编码为 `%20` |
| 字符编码 | utf8 | JDBC URL中使用 `characterEncoding=utf8` |
| JWT过期时间 | 604800000ms | 7天 |
| MyBatis映射 | 下划线转驼峰 | `map-underscore-to-camel-case: true` |

---

## ③ 数据模型

### 3.1 数据表总览（15张）

#### 公共基础表（4张）
| 表名 | 说明 | 核心字段 |
|------|------|----------|
| `sys_user` | 用户表 | id, username, password, email, nickname, role, status |
| `ai_prompt_template` | AI提示词模板表 | id, template_name, template_code, template_content, scene_type, status |
| `ai_call_log` | AI调用日志表 | id, user_id, template_id, scene_type, request_content, response_content, call_status, duration |
| `ai_system_config` | AI系统配置表 | id, config_key, config_value, config_name, config_desc, config_type, status |

#### 业务模块表（11张）
| 模块 | 表名 | 说明 | 核心字段 |
|------|------|------|----------|
| 日报周报 | `daily_report` | 日报表 | id, user_id, report_date, today_finish, encounter_problem, tomorrow_plan, status |
| 日报周报 | `weekly_report` | 周报表 | id, user_id, week_year, week_num, week_summary, problem_review, next_week_plan, status |
| 目标任务 | `goal_info` | 目标主表 | id, user_id, goal_name, goal_type, priority, progress, status |
| 目标任务 | `goal_task` | 子任务表 | id, user_id, goal_id, task_name, deadline, sort, status |
| 成长轨迹 | `growth_skill` | 技能表 | id, user_id, skill_name, skill_type, master_level |
| 成长轨迹 | `growth_project` | 项目经历表 | id, user_id, project_name, project_role, achievement, tech_stack |
| 成长轨迹 | `growth_feedback` | 反馈评价表 | id, user_id, feedback_source, feedback_type, feedback_content |
| 智能复盘 | `review_record` | 复盘记录表 | id, user_id, review_type, start_date, end_date, highlights, shortcomings, suggestions, status, ai_call_id |
| 面经题库 | `interview_category` | 面试题分类表 | id, user_id, category_name, category_type, parent_id |
| 面经题库 | `interview_question` | 面试题库表 | id, user_id, category_id, question_title, my_answer, reference_answer, difficulty_level, master_level, is_collected, is_wrong |
| 职场助手 | `chat_record` | 对话记录表 | id, user_id, session_id, scene_type, user_question, ai_answer, is_collected, ai_call_id |

### 3.1.1 已知问题：sys_user 表缺少 role 字段

> **⚠️ 重要警告**：当前项目存在 schema 不一致问题
> - **Java实体类** `SysUser.java` 中有 `role` 属性（用于区分普通用户/管理员）
> - **数据库SQL** `sys_user` 表中**没有** `role` 字段
> - **影响**：角色权限规则无法正常生效
> 
> **建议修复方案**：在数据库中执行以下SQL补充字段：
> ```sql
> ALTER TABLE `sys_user` ADD COLUMN `role` TINYINT DEFAULT 0 COMMENT '角色：0-普通用户，1-管理员';
> UPDATE `sys_user` SET `role` = 0 WHERE `username` = 'huang';
> UPDATE `sys_user` SET `role` = 1 WHERE `username` = 'admin';
> ```

### 3.2 表间关联关系

```
sys_user (用户表)
    │
    ├─ daily_report (user_id)
    ├─ weekly_report (user_id)
    ├─ goal_info (user_id)
    │     └─ goal_task (goal_id)
    ├─ growth_skill (user_id)
    ├─ growth_project (user_id)
    ├─ growth_feedback (user_id)
    ├─ review_record (user_id)
    │     └─ ai_call_log (ai_call_id)
    ├─ interview_category (user_id)
    │     └─ interview_question (category_id)
    ├─ chat_record (user_id)
    │     └─ ai_call_log (ai_call_id)
    └─ ai_call_log (user_id)

ai_system_config (AI系统配置表) - 无外键关联，全局配置
ai_prompt_template (AI提示词模板表) - 无外键关联，被 ai_call_log 引用
```

### 3.3 关键字段说明

#### 用户角色
| 值 | 说明 |
|----|------|
| role=0 | 普通用户 |
| role=1 | 管理员 |

#### 日报状态
| 值 | 说明 |
|----|------|
| status=0 | 草稿 |
| status=1 | 已提交 |

#### 目标状态
| 值 | 说明 |
|----|------|
| status=0 | 已取消 |
| status=1 | 未开始 |
| status=2 | 进行中 |
| status=3 | 已完成 |
| status=4 | 已延期 |

#### AI场景类型
| 值 | 说明 |
|----|------|
| polish | 润色 |
| review | 复盘 |
| answer | 生成答案 |
| summary | 总结 |
| translate | 翻译 |

---

## ④ 业务规则

### 4.1 角色权限规则
- **普通用户** (`role=0`)：仅可操作自有业务数据，可使用所有6大业务模块，可查看个人AI调用日志
- **管理员** (`role=1`)：全量数据管理权限，可管理用户、配置AI模板、查看全部调用日志
- **所有业务接口必须登录鉴权**，未登录返回401

### 4.2 事务一致性规则
- 涉及多表写入的操作必须纳入同一事务（使用 `@Transactional`）
- 典型场景：生成复盘（保存复盘记录 + AI调用日志）、删除目标（删除目标 + 关联任务）
- 异常时全部回滚，保证数据一致性

### 4.3 业务约束规则
- **日报约束**：单用户单日仅可提交一份日报（`user_id + report_date` 唯一），草稿状态可编辑，已提交需撤回
- **周报约束**：同一用户同一周仅可有一份周报（`user_id + week_year + week_num` 唯一）
- **复盘约束**：日度≤1天，周度≤7天，月度≤31天
- **用户约束**：密码必须BCrypt加密，用户名/邮箱唯一，新用户默认 `role=0`
- **AI调用约束**：普通用户单日调用上限100次，失败最多重试2次（间隔3s/6s）

### 4.4 AI调用规则
- **统一入口**：所有AI能力必须通过 `AiService` 接口调用，禁止各模块单独封装
- **日志记录**：所有调用自动记录完整日志（`ai_call_log`），失败统一抛出 `BusinessException`
- **配置管理**：AI配置（API地址、密钥、模型、超时）存储在 `ai_system_config` 表，动态生效
- **异步处理**：耗时较长的AI任务（如复盘生成）使用 `@Async` 异步处理，前端轮询状态

---

## ⑤ 接口规范

### 5.1 接口风格
- **RESTful API**：URL语义化，标准HTTP方法（GET查询、POST新增、PUT修改、DELETE删除）
- **URL前缀**：业务接口无统一前缀，页面跳转与API共用Controller

### 5.2 统一返回格式

```json
{
    "code": 200,
    "msg": "操作成功",
    "data": {}
}
```

| code | 说明 |
|------|------|
| 200 | 成功 |
| 401 | 未授权（未登录或登录过期） |
| 403 | 无权限（管理员接口访问被拒绝） |
| 400 | 参数校验失败 |
| 500 | 业务异常 |

### 5.3 鉴权方式
- **JWT令牌**存储于 **HttpOnly Cookie**（Cookie名称：`token`）
- **全局拦截器** `LoginInterceptor` 统一校验，解析获取 `userId`，查询用户信息存入 `LoginUserHolder`
- **白名单路径**：`/login`、`/user/login`、`/user/register`、静态资源

### 5.4 参数校验
- 所有接口必须做入参合法性校验（`@NotNull`、`@NotBlank`、`@Size`、`@Email`等）
- 业务校验（唯一性、状态检查等）手动实现
- 校验失败返回 `code=400`

### 5.5 分页接口规范
- **请求参数**：`pageNum`（默认1）、`pageSize`（默认10，最大100）
- **返回结构**：`{ list: [], total: 100, pageNum: 1, pageSize: 10, pages: 10 }`
- **实现方式**：使用 PageHelper 插件

### 5.6 典型接口示例

| HTTP方法 | 路径 | 功能 | 参数 |
|----------|------|------|------|
| GET | `/dailyreport/list` | 日报列表 | pageNum, pageSize, startDate, endDate, status |
| POST | `/dailyreport/add` | 新增日报 | reportDate, todayFinish, encounterProblem, tomorrowPlan |
| PUT | `/dailyreport/update` | 更新日报 | id, todayFinish, encounterProblem, tomorrowPlan |
| DELETE | `/dailyreport/delete/{id}` | 删除日报 | id |
| POST | `/ai/polish` | AI润色 | content |
| POST | `/ai/review` | AI复盘 | content |

---

## ⑥ 编码规范

### 6.1 三层架构

| 层级 | 职责 | 位置 |
|------|------|------|
| Controller | 接收请求、参数校验、调用Service、返回结果 | `com.example.growthlens.controller` |
| Service | 封装业务逻辑、事务控制、业务校验 | `com.example.growthlens.service` / `service.impl` |
| Mapper | 数据库CRUD、SQL编写 | `com.example.growthlens.mapper` |

**命名约定**：
- Controller: `[模块名]Controller.java`
- Service接口: `[模块名]Service.java`
- Service实现: `[模块名]ServiceImpl.java`
- Mapper: `[模块名]Mapper.java`
- Entity: 与表名对应，大驼峰（如 `SysUser.java`）

### 6.2 包结构

```
com.example.growthlens/
├── controller/       # 控制器层
├── service/          # Service接口
│   └── impl/         # Service实现类
├── mapper/           # Mapper接口
├── entity/           # 实体类
├── dto/              # 数据传输对象（请求/响应DTO）
├── config/           # 配置类（WebConfig、拦截器等）
├── common/           # 公共组件（Result、异常、工具类）
└── async/            # 异步任务类（@Async方法）
```

### 6.3 注释规范
- 所有类、公共方法、核心字段必须添加中文注释
- 关键业务逻辑添加行内说明
- 实体类注释说明对应数据库表名

### 6.4 安全规范
- **SQL注入防护**：MyBatis SQL写在XML中，参数绑定使用 `#{}`，禁止随意使用 `${}`
- **XSS防护**：用户输入做HTML转义，输出使用 `<c:out>` 标签
- **密码安全**：BCrypt加密存储，返回用户信息时清除 `password` 字段
- **越权防护**：所有业务查询必须加 `user_id` 条件，操作前校验数据归属

### 6.5 异常规范
- **业务异常**：抛出 `BusinessException`，全局处理器捕获返回 `code=500`
- **未授权异常**：抛出 `UnauthorizedException`，返回 `code=401`
- **参数异常**：返回 `code=400`
- **禁止空catch块**，禁止使用异常控制正常业务流程

### 6.6 命名规范

| 类型 | 规则 | 示例 |
|------|------|------|
| 类名 | 大驼峰 | UserController, DailyReportService |
| 方法名 | 小驼峰，动词开头 | getUserById, addDailyReport |
| 变量名 | 小驼峰 | userName, reportDate, isCompleted |
| 常量 | 全大写，下划线分隔 | MAX_PAGE_SIZE |
| 表名 | 小写，下划线分隔 | daily_report, goal_info |
| 字段名 | 小写，下划线分隔 | user_id, report_date |

---

## ⑦ 界面风格

### 7.1 整体风格
- **定位**：简洁专业的后台管理系统风格
- **适配**：优先桌面端
- **主色调**：蓝紫渐变（`#667eea` → `#764ba2`）

### 7.2 布局结构

```
┌────────────────────────────────────────────┐
│           顶部导航栏                        │
├────────┬───────────────────────────────────┤
│        │                                   │
│ 左侧   │      右侧主内容区                  │
│ 侧边栏 │      （卡片、表格、表单等）         │
│        │                                   │
└────────┴───────────────────────────────────┘
```

- **侧边栏宽度**：col-2（约16.67%），渐变紫背景
- **主内容区宽度**：col-10，自适应
- **顶部导航栏**：白色背景，底部边框

### 7.3 组件规范

| 组件 | 规范 |
|------|------|
| 卡片 | 圆角12px，阴影 `0 2px 8px rgba(0,0,0,0.08)`，白色背景 |
| 按钮 | 主按钮渐变紫背景，次按钮白色边框，圆角6px |
| 表格 | Bootstrap table，表头浅灰背景，斑马纹 |
| 表单 | Bootstrap form，必填项红色*号，focus紫色边框 |
| 分页 | Bootstrap pagination，显示首页/上一页/页码/下一页/末页 |

### 7.4 交互规范
- **操作反馈**：成功绿色Toast，失败红色Toast，加载中按钮禁用+loading
- **确认机制**：删除操作二次确认弹窗
- **错误提示**：表单校验错误红色文字，接口错误Toast提示
- **空状态**：展示空状态插图+文字说明+引导按钮

### 7.5 页面模板

所有业务页面必须引入公共布局：

```jsp
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    request.setAttribute("currentMenu", "模块标识");
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>页面标题 - GrowthLens Intern</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="d-flex">
        <jsp:include page="/WEB-INF/jsp/common/sidebar.jsp" />
        <div class="flex-grow-1">
            <jsp:include page="/WEB-INF/jsp/common/header.jsp" />
            <div class="main-content">
                <!-- 页面内容 -->
            </div>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
```

### 7.6 菜单高亮规则

| currentMenu | 模块 |
|-------------|------|
| home | 首页 |
| daily | 日报周报管理 |
| growth | 成长轨迹追踪 |
| goal | 目标任务管理 |
| review | 智能复盘分析 |
| interview | 面经题库管理 |
| chat | 职场智能助手 |
| usermanage | 用户管理 |

---

## 附录：AI服务接口清单

| 方法 | 功能 | 参数 |
|------|------|------|
| `polish(userId, username, content)` | 润色文本 | 用户ID、用户名、待润色内容 |
| `review(userId, username, content)` | 复盘分析 | 用户ID、用户名、待复盘内容 |
| `generateAnswer(userId, username, question)` | 生成答案 | 用户ID、用户名、问题 |
| `summarize(userId, username, content)` | 总结文本 | 用户ID、用户名、待总结内容 |
| `translate(userId, username, content, targetLang)` | 翻译文本 | 用户ID、用户名、内容、目标语言 |
| `callByTemplate(userId, username, templateCode, params)` | 按模板调用 | 用户ID、用户名、模板编码、参数Map |

---

**文档结束**

> 本文档基于 GrowthLens Intern 项目实际代码生成，所有规范与项目现状保持一致，适用于后续所有开发工作。
