#!/bin/bash

# Check if the script is being run as root
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root or with sudo."
    exit 1
fi

# Colors for output
CYAN='\033[0;36m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Function to display messages with colors
echo_message() {
    echo -e "${CYAN}$1${NC}"
}

# Print starting message
echo_message "🚀 Starting Panel Setup..."

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo_message "${RED}❌ Docker is not installed. Please install Docker first.${NC}"
    exit 1
fi

# Check if Docker Compose is installed
if ! command -v docker-compose &> /dev/null; then
    echo_message "${RED}❌ Docker Compose is not installed. Installing Docker Compose...${NC}"
    sudo apt-get install -y docker-compose
fi

# Navigate to the panel directory (update with the correct path)
cd /path/to/docker-pterodactyl-panel || { echo_message "${RED}❌ Failed to navigate to the panel directory.${NC}"; exit 1; }

# Pull latest Docker images and rebuild containers
echo_message "⚙️ Pulling latest Docker images and rebuilding containers..."
docker-compose pull
docker-compose build

# Start Docker containers in detached mode
echo_message "⚙️ Starting Docker containers..."
docker-compose up -d

# Check Docker containers status
echo_message "📦 Checking Docker containers status..."
docker ps

# Check if the panel container is running and show any error messages
panel_container_name="docker-pterodactyl-panel_php-fpm_1"
if ! docker ps | grep -q "$panel_container_name"; then
    echo_message "${RED}❌ The Pterodactyl Panel container is not running. Please check the logs for errors.${NC}"
    docker logs "$panel_container_name"
    exit 1
fi

# Check if the port is open (5080) and accessible
echo_message "🔍 Checking if port 5080 is open..."
if ! nc -zv 127.0.0.1 5080; then
    echo_message "${RED}❌ Port 5080 is not accessible. Please check your firewall and port forwarding settings.${NC}"
    exit 1
fi

# Display the access URL
echo_message "🔗 You can access your panel at: http://<your_server_ip>:5080"

# Print a completion message
echo_message "✅ Panel should now be up and running!"
