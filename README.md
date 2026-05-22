# 📱 iPad Wall Dashboard (Jailbreak Setup)

Turn an old iPad into a smart home wall dashboard / automation terminal using a lightweight jailbreak-based system.

This project installs background services, TCP automation, and system utilities to keep an old iPad running as an always-on control panel.

---

## ⚡ Features

- 🔄 Auto-start services after reboot
- 🌐 TCP dispatcher using `socat`
- 🧠 Lightweight shell-based automation
- 📟 Designed for old iPads (iPad 3 / legacy devices)
- 🔋 Always-on behavior using Insomnia
- 🧩 Fully offline installation

---

## 📦 Project Files
install.sh → main installer script
setup.tar → payload (scripts + configs)


---

## 🚀 Installation

### 1. Copy files to your iPad

Place the files in a directory such as:
/var/mobile/steup/

Make sure you have:
- install.sh
- setup.tar

---

### 2. Give execution permission

```bash
chmod +x install.sh

3. Run installer


bash install.sh
