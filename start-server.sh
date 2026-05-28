#!/bin/bash

echo "========================================="
echo "启动本地服务器"
echo "========================================="

# 检查Python是否可用
if command -v python3 &> /dev/null; then
    echo "使用Python3启动服务器..."
    python3 -m http.server 8000
elif command -v python &> /dev/null; then
    echo "使用Python启动服务器..."
    python -m SimpleHTTPServer 8000
else
    echo "错误：未找到Python。请安装Python或使用其他方式启动服务器。"
    exit 1
fi
