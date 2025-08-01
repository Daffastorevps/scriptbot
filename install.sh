#!/bin/bash

# Ganti ini dengan URL GitHub kamu kalau bukan public repo
REPO_URL="https://github.com/script-vpn-premium/scriptbot.git"
TEMP_DIR="/tmp/scriptbot-install"

# Update sistem dan install dependensi
apt update && apt upgrade -y
apt install curl git -y

# Hapus folder lama kalau ada
rm -rf $TEMP_DIR

# Clone repo ke /tmp
git clone $REPO_URL $TEMP_DIR

# Buat folder /etc/xray jika belum ada
mkdir -p /etc/xray

# Pindahkan script ke /etc/xray
cp $TEMP_DIR/add-vmess /etc/xray/
cp $TEMP_DIR/add-vless /etc/xray/
cp $TEMP_DIR/add-trojan /etc/xray/
cp $TEMP_DIR/add-ss /etc/xray/ 2>/dev/null # aman kalau tidak ada

# Kasih izin eksekusi
chmod +x /etc/xray/add-vmess
chmod +x /etc/xray/add-vless
chmod +x /etc/xray/add-trojan
chmod +x /etc/xray/add-ss 2>/dev/null

# Bikin symlink ke /usr/bin biar bisa langsung ketik perintah
ln -sf /etc/xray/add-vmess /usr/bin/add-vmess
ln -sf /etc/xray/add-vless /usr/bin/add-vless
ln -sf /etc/xray/add-trojan /usr/bin/add-trojan
ln -sf /etc/xray/add-ss /usr/bin/add-ss 2>/dev/null

# Hapus folder clone sementara
rm -rf $TEMP_DIR

echo "✅ Instalasi selesai!"
echo "➡️ Gunakan: add-vmess | add-vless | add-trojan | add-ss"