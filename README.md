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
```
install.sh → main installer script
setup.tar  → payload (scripts + configs)
```

---

## 🚀 Installation

### 1. Copy files to your iPad
Place the files in :
```
/var/root
```
Make sure you have:
- `install.sh`
- `setup.tar`

---

### 2. Give execution permission
```bash
chmod +x install.sh
```

### 3. Run installer
```bash
bash install.sh
```

---

## 🧰 Dependencies
The installer will attempt to fetch the following via Cydia/offline sources:
- `socat`
- `Insomnia` (keep-awake tweak)
- `bash` (if not already present)

---

## 📋 Usage
Once installed, services start automatically on boot.
To manually restart the dispatcher:
```bash
launchctl unload /Library/LaunchDaemons/com.dispatcher.socat.plist
launchctl load /Library/LaunchDaemons/com.dispatcher.socat.plist

```

---

## ⚠️ Notes
- Requires a jailbroken iPad
- Tested on iPad 3 with legacy firmware
- Not responsible for any damage to your device

---

## 📄 License
free free free
