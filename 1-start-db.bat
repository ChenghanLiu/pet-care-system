@echo off
chcp 65001 >nul
cd /d %~dp0
echo ==============================
echo 启动 MySQL 数据库
echo ==============================
echo.
docker compose up -d mysql
if errorlevel 1 (
  echo.
  echo 数据库启动失败，请确认 Docker Desktop 已启动。
  pause
  exit /b 1
)
echo.
echo 数据库已启动。
echo 容器名称: pet_system_mysql
echo 端口: 3306
echo.
pause
