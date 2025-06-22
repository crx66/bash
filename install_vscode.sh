#!/bin/bash

# VS Code installation script for Debian and Kali Linux

set -e

# Check for root permissions
if [[ $EUID -ne 0 ]]; then
    echo "❌ Please run this script as root (e.g., sudo ./install_vscode.sh)"
    exit 1
fi

echo "🔍 Detecting distribution..."
DISTRO=$(lsb_release -is 2>/dev/null || grep '^ID=' /etc/os-release | cut -d= -f2 | tr -d '"')

if [[ "$DISTRO" != "Debian" && "$DISTRO" != "Kali" ]]; then
    echo "❌ Unsupported distribution: $DISTRO"
    exit 1
fi

echo "✅ Distribution: $DISTRO"

# Install required packages
echo "📦 Installing dependencies..."
apt update
apt install -y wget gpg apt-transport-https software-properties-common

# Import Microsoft GPG key
echo "🔑 Adding Microsoft GPG key..."
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > /usr/share/keyrings/microsoft.gpg

# Add VS Code repository
echo "📁 Adding VS Code repository..."
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/microsoft.gpg] https://packages.microsoft.com/repos/code stable main" \
    > /etc/apt/sources.list.d/vscode.list

# Install VS Code
echo "📥 Installing Visual Studio Code..."
apt update
apt install -y code

echo "✅ Visual Studio Code installation complete. Run it with: code"
