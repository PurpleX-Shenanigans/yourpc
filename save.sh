#!/bin/bash

# ==============================================================================
# CONFIGURATION
# ==============================================================================
CONTAINER_NAME="cloud-pc-kde"
IMAGE_NAME="my-custom-pc:latest"

CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

show_banner() {
    clear
    echo -e "${CYAN}====================================================${NC}"
    echo -e "${CYAN}        💾 YOURPC AUTOMATED AUTO-SAVE & COMMIT      ${NC}"
    echo -e "${CYAN}====================================================${NC}"
}

commit_now() {
    if ! [ "$(docker ps -q -f name=${CONTAINER_NAME})" ]; then
        echo -e "${RED}[!] Active container '${CONTAINER_NAME}' is not running.${NC}"
        return 1
    fi

    echo -e "[$(date +'%T')] ${YELLOW}Saving current session state to '${IMAGE_NAME}'...${NC}"
    docker commit ${CONTAINER_NAME} ${IMAGE_NAME} >/dev/null 2>&1

    if [ $? -eq 0 ]; then
        echo -e "[$(date +'%T')] ${GREEN}✓ System state saved successfully!${NC}"
        # Update desktop.sh to use the image if needed
        if [ -f "desktop.sh" ]; then
            sed -i "s|^IMAGE=.*|IMAGE=\"${IMAGE_NAME}\"|" desktop.sh 2>/dev/null
        fi
        return 0
    else
        echo -e "[$(date +'%T')] ${RED}[-] Failed to save container state.${NC}"
        return 1
    fi
}

start_auto_save() {
    show_banner
    echo -e " Enter auto-save interval in minutes (Default: 12 minutes):"
    read -p " Interval [10-15]: " INTERVAL_MIN
    INTERVAL_MIN=${INTERVAL_MIN:-12}

    # Convert minutes to seconds
    INTERVAL_SEC=$((INTERVAL_MIN * 60))

    show_banner
    echo -e "${GREEN}✓ Auto-Save is active!${NC}"
    echo -e "  Saving environment every ${YELLOW}${INTERVAL_MIN} minutes${NC}."
    echo -e "  Press ${RED}Ctrl + C${NC} anytime to stop auto-save loop.\n"
    echo -e "${CYAN}----------------------------------------------------${NC}"

    # First immediate save
    commit_now

    # Periodic loop
    while true; do
        sleep ${INTERVAL_SEC}
        echo -e "\n${CYAN}----------------------------------------------------${NC}"
        commit_now
    done
}

# ==============================================================================
# MAIN MENU
# ==============================================================================
chmod +x "$0" 2>/dev/null

show_banner
echo -e " Choose auto-save mode:"
echo -e "  ${GREEN}1)${NC} Start Auto-Save Loop (Runs continuously every 10–15 mins)"
echo -e "  ${GREEN}2)${NC} Save Environment ONCE (Instant snapshot)"
echo -e "  ${GREEN}3)${NC} Exit"
echo -e "${CYAN}----------------------------------------------------${NC}"
read -p "Enter choice [1-3]: " choice

case $choice in
    1)
        start_auto_save
        ;;
    2)
        show_banner
        commit_now
        ;;
    3)
        echo -e "\nExiting."
        exit 0
        ;;
    *)
        echo -e "\n${RED}Invalid option.${NC}"
        exit 1
        ;;
esac
