#!/bin/bash

# Telegram Desktop installation script for Debian and Kali Linux

set -e

# Check for root
if [[ $EUID -ne 0 ]]; then
    echo "❌ Please run this script as root (e.g., sudo ./install_telegram.sh)"
    exit 1
fi

echo "🔍 Detecting distribution..."
DISTRO=$(lsb_release -is 2>/dev/null || grep '^ID=' /etc/os-release | cut -d= -f2 | tr -d '"')

if [[ "$DISTRO" != "Debian" && "$DISTRO" != "Kali" ]]; then
    echo "❌ Unsupported distribution: $DISTRO"
    exit 1
fi

echo "✅ Distribution: $DISTRO"

# Set install directory
INSTALL_DIR="/opt/telegram"
BIN_LINK="/usr/local/bin/telegram"

echo "📥 Downloading Telegram..."
wget -O /tmp/tsetup.tar.xz https://telegram.org/dl/desktop/linux

echo "📂 Extracting files..."
mkdir -p "$INSTALL_DIR"
tar -xf /tmp/tsetup.tar.xz -C "$INSTALL_DIR" --strip-components=1

echo "🔗 Creating launcher link..."
ln -sf "$INSTALL_DIR/Telegram" "$BIN_LINK"

# Create .desktop file for GUI menu entry
echo "🖥️ Creating desktop entry..."
cat << EOF > /usr/share/applications/telegram.desktop
[Desktop Entry]
Name=Telegram Desktop
Comment=Telegram messaging app
Exec=$BIN_LINK
Icon=$INSTALL_DIR/telegram.png
Terminal=false
Type=Application
Categories=Network;InstantMessaging;
StartupWMClass=Telegram
EOF

echo "✅ Telegram has been installed successfully. You can run it with: telegram"
