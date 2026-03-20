@echo off
chcp 65001 >nul
cd /d %~dp0
echo ==============================
echo 启动爱心宠物系统（全容器）
echo ==============================
echo.
docker compose up -d --build
if errorlevel 1 (
  echo.
  echo 启动失败，请确认 Docker Desktop 已启动并重试。
  pause
  exit /b 1
)
echo.
echo 系统已启动。
echo 前端访问地址：http://localhost:5173
echo 后端接口地址：http://localhost:8080
echo 数据库端口：3306
echo.
pause
