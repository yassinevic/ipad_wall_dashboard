#!/bin/bash

set -e

REPO="https://raw.githubusercontent.com/yassinevic/ipad_wall_dashboard/main"

echo "[*] Downloading installer..."

curl -fsSL "$REPO/install.sh" -o install.sh || {
    echo "[ERROR] Failed to download install.sh"
    exit 1
}

curl -fsSL "$REPO/setup.tar" -o setup.tar || {
    echo "[ERROR] Failed to download setup.tar"
    exit 1
}

chmod +x install.sh

echo "[OK] Files downloaded"

echo "[*] Starting installer..."
bash install.sh