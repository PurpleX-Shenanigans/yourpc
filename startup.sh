#!/bin/bash

# Configuration
CONTAINER_NAME="cloud-pc-kde"
PORT=3000
IMAGE="lscr.io/linuxserver/webtop:ubuntu-kde"

echo "=========================================="
echo "      Starting KDE Cloud Desktop          "
echo "=========================================="

# 1. Stop and remove any existing instance
if [ "$(docker ps -aq -f name=${CONTAINER_NAME})" ]; then
    echo "[+] Cleaning up previous desktop container..."
    docker stop ${CONTAINER_NAME} >/dev/null 2>&1
    docker rm ${CONTAINER_NAME} >/dev/null 2>&1
fi

# 2. Spin up the KDE Plasma container
echo "[+] Starting KDE Plasma container..."
docker run -d \
  --name ${CONTAINER_NAME} \
  --restart unless-stopped \
  -p ${PORT}:3000 \
  -e CUSTOM_USER="cloudpc" \
  -e PASSWORD="in-isthebest" \
  ${IMAGE}

if [ $? -ne 0 ]; then
    echo "[-] Failed to start Docker container."
    exit 1
fi

echo "[+] Desktop container started on local port ${PORT}."

# 3. Expose via Cloudflare Tunnel (trycloudflared)
echo "[+] Setting up HTTPS public URL via Cloudflare Tunnel..."
if ! command -v cloudflared &> /dev/null; then
    echo "[!] cloudflared not found. Installing temporarily..."
    wget -q https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb
    sudo dpkg -i cloudflared-linux-amd64.deb >/dev/null 2>&1
    rm cloudflared-linux-amd64.deb
fi

echo "=========================================="
echo " Access your desktop using the URL below: "
echo "=========================================="

# Start tunnel and output public URL
cloudflared tunnel --url http://localhost:${PORT}

# Keep-alive loop to prevent Codespaces idle timeout
while true; do
  echo "here's your latte, that would be 26 dollars. cash or apple pay?"
  sleep 100
done
