#!/bin/bash

# --- Konfigurasi awal ---
REPO_URL="https://github.com/script-vpn-premium/scriptbot.git"
TEMP_DIR="/tmp/scriptbot-install"
WHITELIST_URL="https://raw.githubusercontent.com/script-vpn-premium/scriptbot/main/allowed_ips.txt"

# --- Warna ---
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
BLUE='\033[1;34m'
CYAN='\033[1;36m'
RED='\033[0;31m'
NC='\033[0m' # No Color
LINE="${YELLOW}
-------------------------------------------------------------------${NC}"

# --- Fungsi loading spinner ---
loading_spinner() {
  local pid=$!
  local delay=0.1
  local spinstr='|/-\'
  while kill -0 $pid 2>/dev/null; do
    local temp=${spinstr#?}
    printf " [%c]  " "$spinstr"
    spinstr=$temp${spinstr%"$temp"}
    sleep $delay
    printf "\b\b\b\b\b\b"
  done
  wait $pid
}

# --- Ganti mirror APT ke yang cepat ---
echo -ne "${YELLOW}🌐 Mengganti mirror APT ke Biznet untuk kecepatan...${NC}"
(
  if grep -q 'ubuntu' /etc/os-release 2>/dev/null; then
    sed -i 's|http://.*.ubuntu.com|http://mirror.biznetgio.com/ubuntu|g' /etc/apt/sources.list
  elif grep -q 'debian' /etc/os-release 2>/dev/null; then
    sed -i 's|http://deb.debian.org|http://kartolo.sby.datautama.net.id/debian|g' /etc/apt/sources.list
  fi
) & loading_spinner

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
echo -e "${BLUE}🚀 Memulai instalasi script Xray...${NC}"
echo -e "$LINE"

# --- Update sistem dan install dependensi ---
echo -ne "${YELLOW}📦 Update sistem dan install curl & git...${NC}"
(
  apt update -y -o Acquire::ForceIPv4=true && \
  apt upgrade -y --no-install-recommends && \
  apt install -y curl git
) & loading_spinner

# --- Hapus folder lama jika ada ---
echo -ne "${YELLOW}🧹 Menghapus folder sementara lama...${NC}"
(rm -rf "$TEMP_DIR") & loading_spinner

# --- Clone repo ---
echo -ne "${YELLOW}📥 Meng-clone repo: $REPO_URL ...${NC}"
(git clone "$REPO_URL" "$TEMP_DIR") & loading_spinner

# --- Buat folder /etc/xray jika belum ada ---
echo -ne "${YELLOW}📁 Membuat folder /etc/xray...${NC}"
(mkdir -p /etc/xray) & loading_spinner

# --- Pindahkan script ke /etc/xray ---
echo -ne "${YELLOW}📂 Menyalin file script ke /etc/xray...${NC}"
(
  cp "$TEMP_DIR/add-vmess" /etc/xray/
  cp "$TEMP_DIR/add-vless" /etc/xray/
  cp "$TEMP_DIR/add-trojan" /etc/xray/
  cp "$TEMP_DIR/add-ss" /etc/xray/ 2>/dev/null || true
) & loading_spinner

# --- Kasih izin eksekusi ---
echo -ne "${YELLOW}🔐 Memberikan izin eksekusi...${NC}"
(
  chmod +x /etc/xray/add-vmess
  chmod +x /etc/xray/add-vless
  chmod +x /etc/xray/add-trojan
  chmod +x /etc/xray/add-ss 2>/dev/null || true
) & loading_spinner

# --- Buat symlink ke /usr/bin ---
echo -ne "${YELLOW}🔗 Membuat symlink ke /usr/bin...${NC}"
(
  ln -sf /etc/xray/add-vmess /usr/bin/add-vmess
  ln -sf /etc/xray/add-vless /usr/bin/add-vless
  ln -sf /etc/xray/add-trojan /usr/bin/add-trojan
  ln -sf /etc/xray/add-ss /usr/bin/add-ss 2>/dev/null || true
) & loading_spinner

# --- Hapus folder sementara ---
echo -ne "${YELLOW}🧽 Menghapus folder sementara...${NC}"
(rm -rf "$TEMP_DIR") & loading_spinner

# --- Selesai ---
echo -e "$LINE"
echo -e "${GREEN}✅ Instalasi selesai!${NC}"
echo -e "${GREEN}➡️ Gunakan perintah: ${YELLOW}create${GREEN} di bot WA kamu.${NC}"
echo -e "$LINE"