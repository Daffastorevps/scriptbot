#!/bin/bash

# --- Konfigurasi awal ---
REPO_URL="https://github.com/script-vpn-premium/scriptbot.git"
TEMP_DIR="/tmp/scriptbot-install"
WHITELIST_URL="https://raw.githubusercontent.com/script-vpn-premium/scriptbot/main/allowed_ips.txt"

# --- Warna ---
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# --- Garis Biasa ---
LINE="${YELLOW}-------------------------------------------------------------------------------------------------------${NC}"

# --- Ambil IP publik VPS ---
MY_IP=$(curl -s ipv4.icanhazip.com)

echo -e "$LINE"
echo -e "🌐 ${YELLOW}IP VPS Kamu:${NC} $MY_IP"
echo -e "🔍 ${YELLOW}Mengecek izin akses...${NC}"
echo -e "$LINE"

# --- Cek apakah IP diizinkan ---
if curl -s "$WHITELIST_URL" | grep -q "$MY_IP"; then
  echo -e "✅ ${YELLOW}IP kamu terdaftar di whitelist.${NC}"
else
  echo -e "❌ ${YELLOW}Maaf, IP kamu ($MY_IP) tidak terdaftar di whitelist.${NC}"
  echo -e "➡️ ${YELLOW}Hubungi admin 6285888801241 untuk mendaftarkan IP kamu.${NC}"
  echo -e "$LINE"
  exit 1
fi

echo -e "$LINE"

# Warna
GREEN='\033[0;32m'
BLUE='\033[1;34m'
CYAN='\033[1;36m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Variabel
REPO_URL="https://github.com/example/repo" # Ganti dengan repo kamu
TEMP_DIR="/tmp/script-xray"

echo -e "${CYAN}-------------------------------------------------------------------------------------------------------${NC}"
echo -e "${BLUE}🚀 Memulai instalasi script Xray...${NC}"
echo -e "${CYAN}-------------------------------------------------------------------------------------------------------${NC}"

# --- Update sistem dan install dependensi ---
echo -e "${YELLOW}📦 Update sistem dan install curl & git...${NC}"
apt update && apt upgrade -y
apt install curl git -y

# --- Hapus folder lama jika ada ---
echo -e "${YELLOW}🧹 Menghapus folder sementara lama...${NC}"
rm -rf $TEMP_DIR

# --- Clone repo ---
echo -e "${YELLOW}📥 Meng-clone repo: $REPO_URL ...${NC}"
git clone $REPO_URL $TEMP_DIR

# --- Buat folder /etc/xray jika belum ada ---
echo -e "${YELLOW}📁 Membuat folder /etc/xray...${NC}"
mkdir -p /etc/xray

# --- Pindahkan script ke /etc/xray ---
echo -e "${YELLOW}📂 Menyalin file script ke /etc/xray...${NC}"
cp $TEMP_DIR/add-vmess /etc/xray/
cp $TEMP_DIR/add-vless /etc/xray/
cp $TEMP_DIR/add-trojan /etc/xray/
cp $TEMP_DIR/add-ss /etc/xray/ 2>/dev/null

# --- Kasih izin eksekusi ---
echo -e "${YELLOW}🔐 Memberikan izin eksekusi...${NC}"
chmod +x /etc/xray/add-vmess
chmod +x /etc/xray/add-vless
chmod +x /etc/xray/add-trojan
chmod +x /etc/xray/add-ss 2>/dev/null

# --- Buat symlink biar bisa dijalankan dari mana saja ---
echo -e "${YELLOW}🔗 Membuat symlink ke /usr/bin...${NC}"
ln -sf /etc/xray/add-vmess /usr/bin/add-vmess
ln -sf /etc/xray/add-vless /usr/bin/add-vless
ln -sf /etc/xray/add-trojan /usr/bin/add-trojan
ln -sf /etc/xray/add-ss /usr/bin/add-ss 2>/dev/null

# --- Hapus folder sementara ---
echo -e "${YELLOW}🧽 Menghapus folder sementara...${NC}"
rm -rf $TEMP_DIR

# --- Selesai ---
echo -e "${CYAN}-------------------------------------------------------------------------------------------------------${NC}"
echo -e "${GREEN}✅ Instalasi selesai!${NC}"
echo -e "${GREEN}➡️  Gunakan perintah: ${YELLOW}create${GREEN} di bot WA kamu.${NC}"
echo -e "${CYAN}-------------------------------------------------------------------------------------------------------${NC}"
