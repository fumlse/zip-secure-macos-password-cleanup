#!/bin/bash
set -euo pipefail

echo "正在安装 secure-zip-mac..."

if ! command -v 7zz &>/dev/null && ! command -v 7z &>/dev/null; then
    echo "正在安装 p7zip..."
    brew install p7zip
fi

mkdir -p ~/bin

cp secure_zip.sh ~/bin/secure_zip
chmod +x ~/bin/secure_zip

if [[ ":$PATH:" != *":$HOME/bin:"* ]]; then
    echo "将 ~/bin 添加到 PATH..."
    echo 'export PATH="$HOME/bin:$PATH"' >> ~/.zshrc
    echo "已更新 ~/.zshrc，请运行以下命令或重新打开终端:"
    echo "  source ~/.zshrc"
fi

echo "安装完成！"
echo "使用方法:"
echo "  终端: secure_zip [文件/目录]"
echo "  Finder: 右键 → 服务 → 安全压缩"
