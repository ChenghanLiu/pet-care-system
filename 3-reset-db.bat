@echo off
chcp 65001 >nul
cd /d %~dp0
echo ==============================
echo 重置数据库并重新加载演示数据
echo ==============================
echo.
echo 该操作会删除 MySQL 数据卷并重新初始化数据。
set /p CONFIRM=请输入 Y 确认继续： 
if /I not "%CONFIRM%"=="Y" (
  echo 已取消。
  pause
  exit /b 0
)
docker compose down -v
if errorlevel 1 (
  echo 数据卷删除失败，请确认 Docker Desktop 正常运行。
  pause
  exit /b 1
)
docker compose up -d --build
echo.
echo 数据库已重置，系统已重新启动。
echo 前端访问地址：http://localhost:5173
echo.
pause
