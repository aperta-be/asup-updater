#!/bin/bash

# ASUP Debug Report Generator
# This script collects system information and logs for troubleshooting

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Create timestamp for report
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
REPORT_DIR="debug_report_${TIMESTAMP}"
REPORT_FILE="${REPORT_DIR}/debug_report.txt"

# Create report directory
mkdir -p "${REPORT_DIR}"

echo -e "${GREEN}Generating ASUP Debug Report...${NC}"

# Function to write section header
write_section() {
    echo -e "\n=== $1 ===" >> "${REPORT_FILE}"
    echo -e "${YELLOW}Collecting $1...${NC}"
}

# Function to run command and save output
run_command() {
    local cmd="$1"
    local section="$2"
    echo -e "\n--- $section ---" >> "${REPORT_FILE}"
    echo "\$ $cmd" >> "${REPORT_FILE}"
    eval "$cmd" >> "${REPORT_FILE}" 2>&1 || echo -e "${RED}Command failed: $cmd${NC}"
}

# System Information
write_section "System Information"
run_command "uname -a" "System Details"
run_command "date" "Current Date/Time"
run_command "df -h" "Disk Space"
run_command "free -h" "Memory Usage"

# Docker Information
write_section "Docker Information"
run_command "docker version" "Docker Version"
run_command "docker info" "Docker Info"
run_command "docker ps -a" "Docker Containers"
run_command "docker images" "Docker Images"

# PHP Information
write_section "PHP Information"
if command -v php &> /dev/null; then
    run_command "php -v" "PHP Version"
    run_command "php -m" "PHP Modules"
fi

# Git Information
write_section "Git Information"
run_command "git --version" "Git Version"
run_command "git status" "Git Status"
run_command "git remote -v" "Git Remotes"
run_command "git log -n 5" "Recent Git Commits"

# Environment Information
write_section "Environment Information"
# Sanitize sensitive information
run_command "env | grep -v '_TOKEN' | grep -v '_KEY' | grep -v 'HOOK'" "Environment Variables"

# Configuration Files
write_section "Configuration Files"
if [ -f .env.example ]; then
    cp .env.example "${REPORT_DIR}/env.example"
    echo "Copied .env.example" >> "${REPORT_FILE}"
fi

# Check SSH Keys
write_section "SSH Configuration"
run_command "ls -la ssh/" "SSH Directory Contents"
run_command "ssh-keygen -l -f ssh/id_asup.pub 2>/dev/null || echo 'No public key found'" "SSH Key Details"

# Collect Logs
write_section "Log Files"
if [ -d "logs" ]; then
    mkdir -p "${REPORT_DIR}/logs"
    cp logs/* "${REPORT_DIR}/logs/" 2>/dev/null
    echo "Copied log files" >> "${REPORT_FILE}"
fi

# Docker Container Logs
write_section "Docker Logs"
for container in $(docker ps -a --format "{{.Names}}" | grep "asup"); do
    docker logs "$container" > "${REPORT_DIR}/docker_${container}.log" 2>&1
    echo "Collected logs for container: $container" >> "${REPORT_FILE}"
done

# Check for common issues
write_section "Health Checks"

# Check Docker daemon
if ! docker info >/dev/null 2>&1; then
    echo "WARNING: Docker daemon is not running" >> "${REPORT_FILE}"
fi

# Check disk space
DISK_USAGE=$(df -h / | awk 'NR==2 {print $5}' | sed 's/%//')
if [ "$DISK_USAGE" -gt 90 ]; then
    echo "WARNING: Disk usage is above 90%" >> "${REPORT_FILE}"
fi

# Check required files
for file in .env .gitignore composer.json; do
    if [ ! -f "$file" ]; then
        echo "WARNING: Missing required file: $file" >> "${REPORT_FILE}"
    fi
done

# Create archive
tar -czf "debug_report_${TIMESTAMP}.tar.gz" "${REPORT_DIR}"
rm -rf "${REPORT_DIR}"

echo -e "${GREEN}Debug report generated: debug_report_${TIMESTAMP}.tar.gz${NC}"
echo -e "${YELLOW}Please review the report for sensitive information before sharing.${NC}"
echo -e "To share the report:"
echo -e "1. Review the contents"
echo -e "2. Remove any sensitive information"
echo -e "3. Attach to your issue on GitHub/GitLab"