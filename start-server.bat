@echo off
echo =========================================
echo 启动本地服务器
echo =========================================

:: 检查Python是否可用
python --version >nul 2>&1
if %errorlevel% equ 0 (
    echo 使用Python启动服务器...
    python -m http.server 8000
) else (
    echo 错误：未找到Python。请安装Python或直接打开index.html文件。
    pause
)
