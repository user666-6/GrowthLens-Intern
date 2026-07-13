@echo off
echo ============================================
echo   GrowthLens Intern 启动脚本
echo ============================================
echo.

set "WAR_FILE=growth-lens-intern-1.0.0.war"
set "PORT=8080"

echo 正在启动 GrowthLens Intern 服务...
echo 端口: %PORT%
echo.

java -jar "%WAR_FILE%" --server.port=%PORT%

pause