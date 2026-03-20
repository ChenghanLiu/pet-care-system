@echo off
chcp 65001 >nul
echo ==============================
echo 爱心宠物系统 - 环境检查
echo ==============================
echo.
echo [1/1] 检查 Docker ...
docker --version >nul 2>nul
if errorlevel 1 (
  echo 未检测到 Docker，请先安装并启动 Docker Desktop。
) else (
  docker --version
)
echo.
pause
