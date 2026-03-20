@echo off
chcp 65001 >nul
cd /d %~dp0
echo ==============================
echo 停止系统
echo ==============================
echo.
echo [1/4] 停止数据库容器...
docker compose stop mysql >nul 2>nul
echo 已执行数据库停止命令。
echo.
echo [2/4] 停止 Nginx...
if exist "nginx\nginx.exe" (
  pushd nginx >nul
  nginx.exe -s quit >nul 2>nul
  popd >nul
)
for /f "tokens=5" %%a in ('netstat -ano ^| findstr :5173 ^| findstr LISTENING') do taskkill /PID %%a /F >nul 2>nul
echo 已尝试停止前端静态服务。
echo.
echo [3/4] 尝试结束 8080 端口占用进程...
for /f "tokens=5" %%a in ('netstat -ano ^| findstr :8080 ^| findstr LISTENING') do taskkill /PID %%a /F >nul 2>nul
echo 已尝试结束 8080 端口进程。
echo.
echo [4/4] 清理完成。
echo 停止操作已完成。
pause
