@echo off
chcp 65001 >nul
cd /d %~dp0
echo ==============================
echo 启动后端服务
echo ==============================
echo.
set JAR=target\wine-shop-system-0.0.1-SNAPSHOT.jar
if not exist "%JAR%" (
  echo 未找到后端 jar：%JAR%
  echo 请先确认项目已完成 Maven 打包，且 target 目录中存在该文件。
  pause
  exit /b 1
)
echo 正在启动后端：%JAR%
echo 默认端口：8080
echo.
java -jar "%JAR%"
