#!/bin/bash

# Check if a comment/identifier was provided
if [ -z "$1" ]; then
    echo "Usage: $0 <identifier>"
    echo "Example: $0 myproject-asup"
    exit 1
fi

IDENTIFIER=$1
KEY_PATH="./ssh"

# Create SSH directory if it doesn't exist
mkdir -p "$KEY_PATH"

# Generate SSH key pair
ssh-keygen -t ed25519 -C "$IDENTIFIER" -f "$KEY_PATH/id_asup" -N ""

echo "SSH keys generated successfully!"
echo "Public key (add this to your Git provider):"
echo "----------------------------------------"
cat "$KEY_PATH/id_asup.pub"
echo "----------------------------------------"
echo ""
echo "The private key has been saved to $KEY_PATH/id_asup"
echo "Make sure to:"
echo "1. Add the public key to your Git provider"
echo "2. Copy the key contents to your environment variables:"
echo "   SSH_PUBLIC_KEY=\"$(cat "$KEY_PATH/id_asup.pub")\""
echo "   SSH_PRIVATE_KEY=\"$(cat "$KEY_PATH/id_asup")\""
echo ""
echo "IMPORTANT: Do not commit these keys to version control!"