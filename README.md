# 爱心宠物系统（Docker Desktop 交付说明）

本项目已整理为**全容器化交付方案**。

甲方电脑只需要安装：
- **Docker Desktop**

无需再单独安装：
- Java
- Python
- Windows 版 Nginx

系统运行方式：
- 数据库：Docker 容器
- 后端：Docker 容器
- 前端：Docker 容器
- 通过 `docker compose` 一键启动整个系统

---

## 一、运行前准备

### 仅需安装 Docker Desktop
下载地址：
<https://www.docker.com/products/docker-desktop/>

安装完成后，请先启动 Docker Desktop，并等待其完全启动成功。

---

## 二、项目结构说明

项目根目录中的关键文件：

- `docker-compose.yml`：完整容器编排文件
- `Dockerfile`：后端容器构建文件
- `frontend/Dockerfile`：前端容器构建文件
- `nginx.conf`：前端 Nginx 配置（支持 SPA 路由与接口代理）
- `schema.sql`：数据库表结构初始化文件
- `data_init.sql`：演示数据初始化文件
- `uploads/`：上传文件目录（会挂载到后端容器）
- `0-check-env.bat`：环境检查脚本
- `1-start-all.bat`：一键启动整个系统
- `2-stop-all.bat`：停止整个系统
- `3-reset-db.bat`：重置数据库并重新加载演示数据

---

## 三、快速启动（3 步）

1. 双击 `0-check-env.bat`
2. 双击 `1-start-all.bat`
3. 打开浏览器访问：<http://localhost:5173>

---

## 四、默认访问地址与端口

### 访问地址
- 前端首页：<http://localhost:5173>
- 后端接口：<http://localhost:8080>

### 端口说明
- 前端：`5173`
- 后端：`8080`
- 数据库：`3306`

> 正常使用时，甲方只需要访问前端地址即可。

---

## 五、首次启动（第一次使用）

第一次使用请按以下顺序操作：

### 第一步：检查 Docker 环境
双击运行：
- `0-check-env.bat`

### 第二步：一键启动系统
双击运行：
- `1-start-all.bat`

该脚本会自动：
1. 构建前端镜像
2. 构建后端镜像
3. 启动 MySQL 容器
4. 启动后端容器
5. 启动前端容器

### 第三步：浏览器访问系统
启动成功后，在浏览器打开：
- <http://localhost:5173>

> 提醒：第一次启动通常会稍慢，因为需要构建镜像、初始化数据库并启动所有容器。若第一次启动失败，请确认 Docker Desktop 已完全启动后重试一次。

---

## 六、后续启动（正常使用）

如果系统已经初始化过，后续日常使用时：

1. 双击 `1-start-all.bat`
2. 等待容器启动完成
3. 打开浏览器访问 <http://localhost:5173>

说明：
- 后续启动不会重复初始化数据库
- 不需要重新导入演示数据
- 只有在需要恢复初始演示数据时，才需要执行数据库重置

---

## 七、停止系统

双击运行：
- `2-stop-all.bat`

该脚本会执行：
- `docker compose stop`

作用：
- 停止数据库容器
- 停止后端容器
- 停止前端容器

---

## 八、重置数据库并重新加载演示数据

如果需要恢复为初始演示数据，请双击运行：
- `3-reset-db.bat`

该脚本会执行：
1. `docker compose down -v`
2. 删除 MySQL 数据卷
3. 重新启动全部容器
4. 自动重新导入：
   - `schema.sql`
   - `data_init.sql`

> 注意：此操作会清空数据库中已有内容，请仅在需要恢复初始数据时使用。

---

## 九、默认测试账号

### 管理员账号
- 用户名：`admin`
- 密码：`admin123`

### 普通用户账号
- 用户名：`user1`
- 密码：`123456`

---

## 十、常见问题

### 1. Docker Desktop 没有启动
现象：脚本启动失败，提示无法连接 Docker。

处理方式：
- 先启动 Docker Desktop
- 等待 Docker 完全启动后再运行脚本

---

### 2. 前端页面打不开
现象：浏览器打不开 <http://localhost:5173>

处理方式：
- 确认 `1-start-all.bat` 已执行成功
- 确认 Docker Desktop 正常运行
- 在命令行执行 `docker compose ps`，查看 `frontend`、`backend`、`mysql` 是否都为运行状态

---

### 3. 后端无法连接数据库
现象：后端容器启动后报数据库连接失败。

处理方式：
- 稍等几十秒，MySQL 首次启动可能较慢
- 若仍失败，可重新执行 `1-start-all.bat`
- 必要时执行 `3-reset-db.bat` 重置数据库

---

### 4. 端口被占用
现象：5173、8080 或 3306 启动失败。

处理方式：
- 关闭占用这些端口的软件
- 再重新执行启动脚本

---

### 5. 第一次启动比较慢
现象：首次运行等待时间较长。

原因：
- Docker 需要构建镜像
- MySQL 需要初始化数据库

处理方式：
- 属于正常现象，请耐心等待

---

## 十一、交付说明补充

本次整理未修改：
- 后端业务逻辑
- 前端业务功能逻辑
- 数据库表结构
- 接口语义
- 页面菜单与业务流程

本次主要完成的是：
- 前后端与数据库的全容器化交付改造
- `docker-compose.yml` 完整编排
- 前端 Docker 化静态部署
- 后端 Docker 化运行
- 面向 Windows 的 Docker Desktop 启动说明与脚本整理
