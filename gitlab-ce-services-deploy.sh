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
sudo systemctl enable --now ssh # включаем autostart SSH

sudo ufw allow 20/tcp ## для ssh
sudo ufw allow 22/tcp ## для ssh
sudo ufw allow 2424/tcp # для GitLab SSH
sudo ufw allow 80/tcp # для GitLab server
sudo ufw allow 5000/tcp # для Python Flask приложений
sudo ufw allow 8080/tcp # для Java веб-приложений
sudo ufw allow 9090/tcp # для Prometheus
sudo ufw allow 8081/tcp # для cAdvisor
sudo ufw allow 5001/tcp # для Docker Registry
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
# 4. Установка утилит
# -------------------------------
echo "[*] Установка необходимых утилит"
sudo apt-get install -y \
  bash-completion curl etckeeper jq ssh tmux strace vim net-tools sudo openjdk-17-jre openssh-server 

# -------------------------------
# 5. Установка Docker
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
# -------------------------------
# 6. Запуск Docker Compose
sleep 15
echo "[*] Запуск Docker Compose для GitLab CE..."
docker compose up -d

echo "[✔] Установка завершена. Проверьте доступность GitLab по адресу http://gitlab.panov.local:8088"
echo "[✔] Для входа в GitLab используйте: root/lazypeon"