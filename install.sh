#!/bin/bash

############ COLORS ############
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

LOG_FILE="install.log"

############ LOGGING ############
log() {
    echo -e "$1" | tee -a "$LOG_FILE"
}

info() {
    log "${CYAN}[INFO]${NC} $1"
}

ok() {
    log "${GREEN}[OK]${NC} $1"
}

warn() {
    log "${YELLOW}[WARN]${NC} $1"
}

fail() {
    log "${RED}[FAIL]${NC} $1"
    rollback
    exit 1
}

info "Checking dependencies..."

if check_dependency bc; then
    ok "bc already installed"
else
    warn "bc not found, installing..."

    if [ -f "bc_*.deb" ]; then
        run "dpkg -i bc_*.deb"
        ok "bc installed successfully"
    else
        warn "bc .deb not found, trying apt-get..."

        if command -v apt-get >/dev/null 2>&1; then
            run "apt-get update"
            run "apt-get install -y bc"
            ok "bc installed via apt"
        else
            fail "No way to install bc (missing deb + apt-get)"
        fi
    fi
fi

############ SPINNER ############
spinner() {
    local pid=$1
    local msg=$2
    local spin='|/-\'
    i=0

    echo -ne "${CYAN}$msg ${NC}"

    while kill -0 $pid 2>/dev/null; do
        i=$(( (i+1) %4 ))
        printf "\b${spin:$i:1}"
        sleep 0.1
    done
    echo -e "\b ${GREEN}done${NC}"
}

############ PROGRESS BAR ############
progress_bar() {
    local width=30

    echo -ne "["

    for ((i=0; i<width; i++)); do
        echo -ne "█"
        sleep 0.05
    done

    echo -e "]"
}

############ ROLLBACK STACK ############
ROLLBACK_CMDS=()

add_rollback() {
    ROLLBACK_CMDS+=("$1")
}

rollback() {
    warn "Running rollback..."
    for ((i=${#ROLLBACK_CMDS[@]}-1; i>=0; i--)); do
        eval "${ROLLBACK_CMDS[$i]}" 2>/dev/null
    done
    warn "Rollback complete"
}

run() {
    info "$1"
    eval "$1" &
    pid=$!
    spinner $pid "$1"
    wait $pid
    if [ $? -ne 0 ]; then
        fail "Command failed: $1"
    fi
}

############ HEADER ############
clear
echo -e "${GREEN}"
echo "===================================="
echo "   iOS Jailbreak Installer PRO"
echo "===================================="
echo -e "${NC}"

info "Starting installation..."
progress_bar 1

############ 1. EXTRACT ############
if [ -f "setup.tar" ]; then
    run "tar -xvf setup.tar"
    ok "Archive extracted"
else
    fail "setup.tar missing"
fi

############ 2. PERMISSIONS ############
for f in battery.sh dispatcher.sh unlock.sh; do
    if [ -f "$f" ]; then
        run "chmod +x $f"
        add_rollback "chmod -x $f"
        ok "$f ready"
    else
        warn "$f not found"
    fi
done

############ 3. PLIST INSTALL ############
if [ -f "com.dispatcher.socat.plist" ]; then

    run "cp com.dispatcher.socat.plist /Library/LaunchDaemons/"
    add_rollback "rm -f /Library/LaunchDaemons/com.dispatcher.socat.plist"

    run "chmod 644 /Library/LaunchDaemons/com.dispatcher.socat.plist"
    run "chown root:wheel /Library/LaunchDaemons/com.dispatcher.socat.plist"

    ok "LaunchDaemon installed"
else
    fail "plist missing"
fi

############ 4. PACKAGES ############
PACKAGES=(
"nodelete-net.angelxwind.airspeaker.deb"
"socat_1.7.1.1-3_iphoneos-arm.deb"
"com.imalc.insomnia_6.0.1_iphoneos-arm.deb"
)

for pkg in "${PACKAGES[@]}"; do
    if [ -f "$pkg" ]; then
        run "dpkg -i $pkg"
        ok "$pkg installed"
    else
        warn "$pkg missing"
    fi
done

############ 5. RELOAD ############
run "launchctl unload /Library/LaunchDaemons/com.dispatcher.socat.plist 2>/dev/null || true"
run "launchctl load /Library/LaunchDaemons/com.dispatcher.socat.plist"

############ DONE ############
echo ""
echo -e "${GREEN}===================================="
echo " INSTALL COMPLETE"
echo "====================================${NC}"
echo -e "${CYAN}Log saved to: $LOG_FILE${NC}"
echo -e "${YELLOW}Reboot recommended${NC}"