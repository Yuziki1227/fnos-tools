#!/bin/bash

# 运行提示信息
echo "飞牛小助手 - 更简易的Shell工具"
echo "该脚本用于修改飞牛OS的网页默认端口号。"
echo "运行此脚本需要一定的基础知识，修改后可能会出现一系列问题。"
read -p "继续么? (输入Y继续): " consent

# 检查用户是否同意运行
if [ "$consent" != "Y" ]; then
  echo "用户不同意运行脚本，退出。"
  exit 1
fi

# 提示用户输入新的端口号
read -p "请输入新的网页端口号: " new_port

# 检查输入是否为空
if [ -z "$new_port" ]; then
  echo "端口号不能为空。"
  exit 1
fi

# 检查端口号是否是数字
if ! [[ "$new_port" =~ ^[0-9]+$ ]]; then
  echo "端口号必须是数字。"
  exit 1
fi

# 旧端口号
old_port=8000

# 切换到 root 用户并修改端口号
sudo -i <<EOF
# 修改 nginx.conf 文件中的端口号
sed -i "s/$old_port/$new_port/g" /usr/trim/nginx/conf/nginx.conf

# 检查 sed 命令是否成功
if [ $? -ne 0 ]; then
  echo "修改端口号失败，请检查文件路径和权限。"
  exit 1
fi

# 重启 Nginx 服务
/usr/trim/nginx/sbin/nginx -s reload

# 检查 Nginx 是否成功重启
if [ $? -ne 0 ]; then
  echo "Nginx 重启失败，请检查配置文件是否正确。"
  exit 1
fi

echo "端口号修改成功，Nginx 已重启。"
EOF
