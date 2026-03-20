@echo off
chcp 65001 >nul
cd /d %~dp0
echo ==============================
echo 启动前端静态页面（Nginx）
echo ==============================
echo.
if not exist "frontend\dist\index.html" (
  echo 未找到前端打包文件：frontend\dist\index.html
  echo 请先确认前端已经完成打包。
  pause
  exit /b 1
)
if not exist "nginx\nginx.exe" (
  echo 未找到 nginx 可执行文件：nginx\nginx.exe
  echo.
  echo 请下载 Windows 版 Nginx，并解压到项目根目录下的 nginx 文件夹中。
  echo 目录示例：
  echo   pet-care-system\nginx\nginx.exe
  echo   pet-care-system\nginx\conf\mime.types
  echo.
  echo 当前项目已提供根目录 nginx.conf，请将其复制为：
  echo   nginx\conf\nginx.conf
  echo.
  pause
  exit /b 1
)
if not exist "nginx\conf\mime.types" (
  echo 未找到 nginx\conf\mime.types
  echo 请确认你放入的是完整 Windows 版 Nginx 发行包。
  pause
  exit /b 1
)
if not exist "nginx\html" mkdir "nginx\html"
xcopy /E /I /Y "frontend\dist\*" "nginx\html\" >nul
copy /Y "nginx.conf" "nginx\conf\nginx.conf" >nul
cd nginx
echo 正在启动 Nginx...
echo 访问地址：http://localhost:5173
echo.
start "pet-care-nginx" nginx.exe
