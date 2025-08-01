#!/bin/bash
# Installer Script VPN Xray: VMess, VLESS, Trojan

REPO="https://raw.githubusercontent.com/script-vpn-premium/scriptbot/main"
TARGET="/usr/bin"

echo "🚀 Mengunduh dan memasang script..."

# Download semua script
wget -q -O $TARGET/add-vmess $REPO/add-vmess
wget -q -O $TARGET/add-vless $REPO/add-vless
wget -q -O $TARGET/add-trojan $REPO/add-trojan

# Beri izin agar bisa dieksekusi
chmod +x $TARGET/add-vmess
chmod +x $TARGET/add-vless
chmod +x $TARGET/add-trojan

echo ""
echo "✅ Instalasi selesai!"
echo "🔧 Jalankan dengan:"
echo "• add-vmess"
echo "• add-vless"
echo "• add-trojan"