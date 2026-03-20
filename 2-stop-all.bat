@echo off
chcp 65001 >nul
cd /d %~dp0
echo ==============================
echo 停止爱心宠物系统（全容器）
echo ==============================
echo.
docker compose stop
echo.
echo 已执行停止命令。
pause
