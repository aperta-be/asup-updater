#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}Setting up ASUP development environment...${NC}"

# Check for required tools
echo -e "\n${YELLOW}Checking required tools...${NC}"
command -v docker >/dev/null 2>&1 || { echo -e "${RED}Docker is required but not installed. Aborting.${NC}" >&2; exit 1; }
command -v git >/dev/null 2>&1 || { echo -e "${RED}Git is required but not installed. Aborting.${NC}" >&2; exit 1; }

# Load environment variables if .env exists
if [ -f .env ]; then
    echo -e "\n${YELLOW}Loading environment variables...${NC}"
    set -a
    source .env
    set +a
else
    echo -e "\n${YELLOW}Creating .env file from template...${NC}"
    cp .env.example .env
    echo -e "${GREEN}Created .env file. Please edit it with your settings.${NC}"
fi

# Generate SSH keys if they don't exist
if [ ! -f ssh/id_asup ] || [ ! -f ssh/id_asup.pub ]; then
    echo -e "\n${YELLOW}Generating SSH keys...${NC}"
    ./scripts/generate-ssh-keys.sh "asup-dev"
fi

# Check PHP versions and Dockerfiles
echo -e "\n${YELLOW}Checking PHP versions and Dockerfiles...${NC}"
for PHP_VERSION in $(cat php_versions); do
    if [ ! -f "Dockerfile-${PHP_VERSION}" ]; then
        echo -e "${RED}Error: Dockerfile-${PHP_VERSION} not found${NC}"
        exit 1
    else
        echo -e "${GREEN}Found Dockerfile for PHP ${PHP_VERSION}${NC}"
    fi
done

# Build Docker images
echo -e "\n${YELLOW}Building Docker images...${NC}"
for PHP_VERSION in $(cat php_versions); do
    echo -e "\n${GREEN}Building image for PHP ${PHP_VERSION}${NC}"
    docker build -t asup:dev-${PHP_VERSION} \
        --build-arg PHP_VERSION=${PHP_VERSION} \
        -f Dockerfile-${PHP_VERSION} .
done

echo -e "\n${GREEN}Setup complete!${NC}"
echo -e "\nNext steps:"
echo -e "1. Edit ${YELLOW}.env${NC} file with your settings (if you haven't already)"
echo -e "2. Add the SSH public key to your Git provider:"
echo -e "   ${YELLOW}cat ssh/id_asup.pub${NC}"
echo -e "3. Run tests with:"
echo -e "   ${YELLOW}./test.sh${NC}"