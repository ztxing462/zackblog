#!/bin/bash

# 腾讯云服务器部署脚本
# 使用方法：chmod +x deploy.sh && ./deploy.sh

# 配置服务器信息
SERVER_IP="your_server_ip"
SERVER_USER="your_username"
SERVER_PATH="/path/to/your/blog"

# 构建项目
echo "开始构建项目..."
npm run build || exit 1

# 检查构建是否成功
if [ -d "dist" ]; then
    echo "项目构建成功！"
else
    echo "项目构建失败，未找到dist目录！" >&2
    exit 1
fi

# 部署到服务器
echo "开始部署到服务器 $SERVER_IP..."

# 使用rsync同步文件（推荐）
# 如果服务器没有安装rsync，也可以使用scp
# scp -r dist/* $SERVER_USER@$SERVER_IP:$SERVER_PATH

rsync -avz --delete dist/ $SERVER_USER@$SERVER_IP:$SERVER_PATH

# 检查部署是否成功
if [ $? -eq 0 ]; then
    echo "部署成功！"
    echo "请确保Nginx配置正确，并重启Nginx服务以应用更改。"
    echo "Nginx重启命令：ssh $SERVER_USER@$SERVER_IP 'sudo systemctl restart nginx'"
else
    echo "部署失败！" >&2
    exit 1
fi

# 可选：清理构建文件
echo "清理构建文件..."
rm -rf dist

# 提示完成
echo "部署流程已完成！"

# 检查网站是否可访问
echo "正在检查网站是否可访问..."
curl -Is http://$SERVER_IP | head -n 1
if [ $? -eq 0 ]; then
    echo "网站IP访问正常！"
else
    echo "警告：网站IP访问异常，请检查服务器配置。" >&2
fi

# 如果已配置域名，检查域名是否可访问
DOMAIN="zengtx.cloud"
echo "正在检查域名 $DOMAIN 是否可访问..."
curl -Is http://$DOMAIN | head -n 1
if [ $? -eq 0 ]; then
    echo "域名访问正常！"
else
    echo "警告：域名访问异常，请检查DNS配置和Nginx配置。" >&2
fi