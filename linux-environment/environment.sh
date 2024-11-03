#!/bin/bash

# 检查是否以 sudo 权限运行
if [ "$EUID" -ne 0 ]; then
    echo "错误：请使用 sudo 权限运行此脚本。"
    exit 1
fi

# 获取当前脚本所在目录
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
GNOME_PLUGIN_DIR="$SCRIPT_DIR/gone_extensions"
ADB_PATH="/home/$SUDO_USER/Android/Sdk/platform-tools"

# 配置环境变量
echo "export ADB=$ADB_PATH" >> /home/$SUDO_USER/.bashrc
echo "export PATH=\$ADB:\$PATH" >> /home/$SUDO_USER/.bashrc
source /home/$SUDO_USER/.bashrc

adb version
echo "环境变量配置成功！"
    

# 更新系统
sudo apt update && sudo apt upgrade -y

# 安装 OpenJDK
sudo apt install openjdk-17-jdk -y


# 安装 Android Studio (使用 Toolbox)
wget https://download-cdn.jetbrains.com/toolbox/jetbrains-toolbox-2.4.2.32922.tar.gz
tar -xzf jetbrains-toolbox-2.4.2.32922.tar.gz
./jetbrains-toolbox &

# 等待 Toolbox 启动并创建必要的目录
sleep 10

# 获取 JetBrains Toolbox 安装路径
TOOLBOX_PATH=$(find ~/ -name "jetbrains-toolbox" -type f | head -n 1)

# 创建桌面启动器
AUTOSTART_DIR="$HOME/.config/autostart"
mkdir -p $AUTOSTART_DIR

cat <<EOF > $AUTOSTART_DIR/jetbrains-toolbox.desktop
[Desktop Entry]
Type=Application
Name=JetBrains Toolbox
Exec=$TOOLBOX_PATH
Icon=$HOME/.local/share/JetBrains/Toolbox/bin/toolbox.svg
Comment=JetBrains Toolbox
Categories=Development;
X-GNOME-Autostart-enabled=true
EOF

# 确保文件可执行
chmod +x $AUTOSTART_DIR/jetbrains-toolbox.desktop
echo "JetBrains Toolbox 已添加到开机启动。"


# 为 shs 目录下的所有 .sh 文件设置可执行权限
chmod +x $SCRIPT_DIR/shs/*.sh
echo "所有脚本已设置为可执行。"

# 复制自定义脚本到用户目录并设置为可执行
# 替换 /path/to/your/scripts 为脚本实际路径
cp -r $SCRIPT_DIR/shs/*.sh /home/$SUDO_USER
chmod 777 /home/$SUDO_USER/*.sh
chmod +x /home/$SUDO_USER/*.sh
echo "所有脚本已复制到。/home/$SUDO_USER/"




# 复制 GNOME Tweaks 插件（假设插件在当前目录下）
# 替换 /path/to/your/plugins 为插件实际路径
PLUGIN_DIR="$HOME/.local/share/gnome-shell/"
mkdir -p $PLUGIN_DIR
cp -r $GNOME_PLUGIN_DIR/* $PLUGIN_DIR
echo "所有GNOME Plugins已复制到。$PLUGIN_DIR/"


# 安装 GNOME Tweaks
sudo apt install gnome-tweaks -y


# 提示用户重启以应用所有更改
echo "请重启计算机以应用所有更改。"

# sudo -i  切到root账号下
# cp -r /src /dest 复制文件夹
# chmod -R 777 dir/* 解锁目录dir下的所有内容