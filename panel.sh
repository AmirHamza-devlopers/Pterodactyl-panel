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
██       ███████  ██  ███████ ██    ██ ███████ ██████       ██████  ██       █████   ██   ██ ███████ ███████ 
██       ██       ██  ██      ██    ██ ██      ██   ██     ██       ██      ██   ██  ██  ██  ██      ██      
██       █████    ██  ███████ ██    ██ █████   ██████      ██   ███ ██      ███████  █████   █████   ███████ 
██       ██       ██       ██ ██    ██ ██      ██   ██     ██    ██ ██      ██   ██  ██  ██  ██           ██ 
███████  ██       ██  ███████  ██████  ███████ ██   ██      ██████  ███████ ██   ██  ██   ██ ███████ ███████
${NC}
"

echo -e "${CYAN}$ascii_art${NC}"
echo -e "${GREEN}🚀 Starting LEISURE PLAYZ Pterodactyl Panel Installation...${NC}"

# Function to display messages with colors
echo_message() {
    echo -e "${CYAN}$1${NC}"
}

echo_message "💥 Do you want to install LEISURE PLAYZ Pterodactyl Panel? (yes/no) 🤔"
read answer

if [ "$answer" != "yes" ]; then
    echo_message "❌ Installation aborted. 💀"
    exit 0
fi

echo_message "⚙️ Installing Dependencies... 🚀"

# Update package list and install dependencies
apt update -y
apt install -y docker-compose git ufw

echo_message "✅ Installed Dependencies ✔️"

echo_message "📂 Installing LEISURE PLAYZ Pterodactyl Panel... 📥"

# Clone and set up Pterodactyl Docker
git clone https://github.com/YoshiWalsh/docker-pterodactyl-panel
cd docker-pterodactyl-panel || { echo_message "❌ Failed to change directory"; exit 1; }

# Start the panel
docker-compose up -d

echo_message "✅ LEISURE PLAYZ Pterodactyl Panel Installed ✔️"

echo_message "🚀 Configuring Firewall & Ports... 🔥"

# Allow required ports (Default: 80, 443 for Web Panel)
ufw allow 80/tcp
ufw allow 443/tcp
ufw allow 2022/tcp  # Change if using a different SSH port
ufw allow 8080/tcp  # Change if Pterodactyl runs on a different port

# Enable firewall (If disabled)
ufw --force enable

echo_message "✅ Firewall & Port Configuration Applied ✔️"

echo_message "🚀 Restarting Services... 🔄"

# Restart Docker containers to apply changes
docker-compose restart

# Wait a few seconds
sleep 5

# Check running containers
docker ps

echo_message "✅ Services Restarted ✔️"

echo_message "🚀 Creating Admin User for LEISURE PLAYZ Pterodactyl Panel... 🔥"

# Execute user creation command
docker exec -it docker-pterodactyl-panel_php-fpm_1 php artisan p:user:make

echo_message "🎉 LEISURE PLAYZ Pterodactyl Panel Installed & Configured Successfully! 🌐"

echo_message "🌎 Access the panel via your server's IP on port 80 or 443."
echo_message "🔔 Subscribe to: https://youtube.com/@leisureplayz 💻💡"
