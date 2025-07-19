#!/bin/bash
set -euo pipefail

# -------------------------------
# 1. Настройка источников APT (Debian 12 Bookworm)
# -------------------------------
echo "[*] Обновляем /etc/apt/sources.list"
sudo tee /etc/apt/sources.list > /dev/null <<EOF
deb http://ftp.ru.debian.org/debian bookworm main contrib non-free non-free-firmware
deb http://ftp.ru.debian.org/debian bookworm-updates main contrib non-free non-free-firmware
deb http://security.debian.org/debian-security bookworm-security main contrib non-free non-free-firmware
EOF

sudo apt-get update

# -------------------------------
# 2. Сетевые настройки (UFW и SSH)
# -------------------------------
echo "[*] Включаем SSH и UFW"
sudo apt-get install -y ufw openssh-server
sudo systemctl enable --now ssh

sudo ufw allow 22/tcp
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw allow 5000/tcp # для Python Flask приложений
sudo ufw allow 8080/tcp # для Java веб-приложений
sudo ufw allow 9090/tcp # для Prometheus
sudo ufw --force enable

# -------------------------------
# 3. Генерация SSH-ключей (если не существует)
# -------------------------------
if [ ! -f "$HOME/.ssh/id_rsa" ]; then
  echo "[*] Генерируем SSH-ключи..."
  ssh-keygen -t rsa -b 4096 -N "" -f "$HOME/.ssh/id_rsa"
  echo "[*] Публичный ключ:"
  cat "$HOME/.ssh/id_rsa.pub"
else
  echo "[*] SSH-ключи уже существуют, пропускаем генерацию."
fi

# -------------------------------
# 4. Обновление /etc/hosts
# -------------------------------
echo "[*] Обновляем /etc/hosts..."

INTERFACE=$(ip -o -4 addr show | awk '{print $2}' | grep -v 'lo' | while read -r iface; do
    if ip -4 addr show "$iface" | grep -q 'inet 192\.168'; then
        echo "$iface"
        break
    fi
done)

if [ -n "$INTERFACE" ]; then
    IP_ADDR=$(ip -4 -o addr show dev "$INTERFACE" | awk '{print $4}' | cut -d'/' -f1 | head -n1)
    if [ -n "$IP_ADDR" ]; then
        sudo sed -i '/gitlab\.panov\.local$/d' /etc/hosts
        echo "$IP_ADDR gitlab.panov.local" | sudo tee -a /etc/hosts > /dev/null
        echo "[+] Добавлена запись: $IP_ADDR gitlab.panov.local"
    else
        echo "[!] Не удалось определить IP-адрес"
        exit 1
    fi
else
    echo "[!] Не найден подходящий интерфейс с IP 192.168.*"
    exit 1
fi

# -------------------------------
# 5. Установка утилит
# -------------------------------
echo "[*] Установка утилит"
sudo apt-get install -y \
  bash-completion curl etckeeper git jq ssh tmux strace vim net-tools sudo openjdk-17-jre

# -------------------------------
# 6. Установка Docker
# -------------------------------
echo "[*] Установка Docker CE..."

sudo apt-get install -y ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings

curl -fsSL https://download.docker.com/linux/debian/gpg | sudo tee /etc/apt/keyrings/docker.asc > /dev/null
sudo chmod a+r /etc/apt/keyrings/docker.asc

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] \
  https://download.docker.com/linux/debian $(. /etc/os-release && echo "$VERSION_CODENAME") stable" \
  | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

cd gitlab-ce-preparation-via-docker || exit 1
# -------------------------------
# 7. Запуск Docker Compose

echo "[*] Запуск Docker Compose для GitLab CE..."
docker compose up -d

echo "[✔] Установка завершена. Перейдите в папку gitlab-ce-preparation-via-docker и запустите Docker Compose.
