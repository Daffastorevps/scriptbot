#!/bin/bash

# --- Konfigurasi awal ---
REPO_URL="https://github.com/script-vpn-premium/scriptbot.git"
TEMP_DIR="/tmp/scriptbot-install"
WHITELIST_FILE="scriptbot/allowed_ips.txt"

# --- Ambil IP publik VPS ---
MY_IP=$(curl -s ipv4.icanhazip.com)

# --- Tampilkan IP VPS ---
echo "🌐 IP VPS Kamu: $MY_IP"
echo ""

# --- Tampilkan isi whitelist jika ada ---
if [[ -f "$WHITELIST_FILE" ]]; then
  echo "📋 Daftar IP yang diizinkan:"
  cat "$WHITELIST_FILE"
else
  echo "⚠️ File whitelist belum ditemukan: $WHITELIST_FILE"
  echo "   Silakan buat file tersebut dan isi dengan IP yang diizinkan."
  exit 1
fi

echo ""

# --- Cek apakah IP saat ini terdaftar ---
if grep -q "$MY_IP" "$WHITELIST_FILE"; then
  echo "✅ IP kamu diizinkan. Lanjut ke instalasi..."
else
  echo "❌ IP kamu belum terdaftar. Hubungi admin untuk akses."
  exit 1
fi

echo ""
read -p "❓ Lanjut install script bot? (y/n): " confirm
if [[ "$confirm" != "y" ]]; then
  echo "❌ Instalasi dibatalkan."
  exit 1
fi

echo "🚀 Memulai instalasi..."

# --- Update sistem dan install dependensi ---
apt update && apt upgrade -y
apt install curl git -y

# --- Bersihkan folder lama ---
rm -rf $TEMP_DIR

# --- Clone repo dari GitHub ---
git clone $REPO_URL $TEMP_DIR

# --- Pastikan folder Xray ada ---
mkdir -p /etc/xray

# --- Salin script ke /etc/xray ---
cp $TEMP_DIR/add-vmess /etc/xray/
cp $TEMP_DIR/add-vless /etc/xray/
cp $TEMP_DIR/add-trojan /etc/xray/
cp $TEMP_DIR/add-ss /etc/xray/ 2>/dev/null

# --- Beri izin eksekusi ---
chmod +x /etc/xray/add-vmess
chmod +x /etc/xray/add-vless
chmod +x /etc/xray/add-trojan
chmod +x /etc/xray/add-ss 2>/dev/null

# --- Buat symlink agar bisa dipanggil langsung ---
ln -sf /etc/xray/add-vmess /usr/bin/add-vmess
ln -sf /etc/xray/add-vless /usr/bin/add-vless
ln -sf /etc/xray/add-trojan /usr/bin/add-trojan
ln -sf /etc/xray/add-ss /usr/bin/add-ss 2>/dev/null

# --- Bersihkan folder sementara ---
rm -rf $TEMP_DIR

# --- Output selesai ---
echo ""
echo "✅ Instalasi selesai!"
echo "🛡️ IP kamu ($MY_IP) sudah terdaftar dan diizinkan."
echo "➡️ Gunakan perintah: add-vmess / add-vless / add-trojan"