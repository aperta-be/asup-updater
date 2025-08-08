#!/bin/bash
# ##################################################
# Build Docker images for all PHP versions using unified Dockerfile.
# ##################################################

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Default Dockerfile to use
DOCKERFILE="Dockerfile"

# Check if unified Dockerfile exists
if [ ! -f "$DOCKERFILE" ]; then
    echo -e "${RED}Error: $DOCKERFILE not found${NC}"
    echo "Please ensure the unified Dockerfile exists in the project root."
    exit 1
fi

echo -e "${GREEN}Building ASUP Docker images using unified Dockerfile...${NC}"

# Build for each PHP version
for v in $(cat php_versions); do
    echo -e "\n${YELLOW}Building image for PHP ${v}...${NC}"
    
    # Generate test .env file for each PHP version
    source scripts/generate-env.sh "develop-${v}" 2>/dev/null || true
    
    # Build with unified Dockerfile and PHP version as build arg
    echo "Using docker build with: -t asup:dev-$v --build-arg PHP_VERSION=$v"
    
    if docker build -t asup:dev-$v --build-arg PHP_VERSION=$v -f $DOCKERFILE .; then
        echo -e "${GREEN}✓ Successfully built asup:dev-$v${NC}"
    else
        echo -e "${RED}✗ Failed to build asup:dev-$v${NC}"
        exit 1
    fi
done

echo -e "\n${GREEN}All Docker images built successfully!${NC}"
echo -e "\nBuilt images:"
docker images | grep "asup.*dev-" | while read line; do
    echo -e "  ${GREEN}✓${NC} $line"
done
