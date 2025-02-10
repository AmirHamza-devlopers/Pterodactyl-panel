#!/bin/bash

# Check for root privileges
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root or with sudo."
    exit 1
fi

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# ASCII Art
ascii_art="
${CYAN}  
██╗     ███████╗████████╗███████╗██╗██████╗ ███████╗██╗   ██╗
██║     ██╔════╝╚══██╔══╝██╔════╝██║██╔══██╗╚════██║██║   ██║
██║     █████╗     ██║   █████╗  ██║██████╔╝   ██╔══╝ ██║   ██║
██║     ██╔══╝     ██║   ██╔══╝  ██║██╔═══╝    ██║     ██║   ██║
██████╗ ███████╗   ██║   ███████╗██║██║        ██║     ╚██████╔╝
╚═════╝ ╚══════╝   ╚═╝   ╚══════╝╚═╝╚═╝        ╚═╝      ╚═════╝
${NC}
"

echo -e "${CYAN}$ascii_art${NC}"
echo -e "${GREEN}🚀 Starting Pterodactyl Panel Installation...${NC}"

# Function to display messages with colors
echo_message() {
    echo -e "${CYAN}$1${NC}"
}

echo_message "💥 Do you want to install Pterodactyl Panel (yes/no)? 🤔"
read answer

if [ "$answer" != "yes" ]; then
    echo_message "❌ Installation aborted. 💀"
    exit 0
fi

echo_message "⚙️ Installing Dependencies... 🚀"

# Update package list and install dependencies
sudo apt update
sudo apt install -y docker-compose git

echo_message "✅ Installed Dependencies ✔️"

echo_message "📂 Installing Pterodactyl Panel... 📥"

# Clone and set up Pterodactyl Docker
git clone https://github.com/YoshiWalsh/docker-pterodactyl-panel
cd docker-pterodactyl-panel || { echo_message "❌ Failed to change directory"; exit 1; }
docker-compose up -d

echo_message "✅ Pterodactyl Panel Installed ✔️"

echo_message "🚀 Finalizing Setup... 🔥"

# Check running containers
docker ps

# Execute user creation command
docker exec -it docker-pterodactyl-panel_php-fpm_1 php artisan p:user:make

echo_message "🎉 Pterodactyl Panel Installed Successfully! 🌐"

# Subscribe Message with emojis
echo -e "${GREEN}🔔 Subscribe to: ${CYAN}https://youtube.com/@leisureplayz ${GREEN}💻💡${NC}"
