#!/bin/bash

# Check if Homebrew is installed
if ! command -v brew &> /dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Install Git if not already installed
if ! command -v git &> /dev/null; then
    echo "Installing Git..."
    brew install git
fi

# Install GPG if not already installed
if ! command -v gpg &> /dev/null; then
    echo "Installing GPG..."
    brew install gnupg
fi

# Verify installations
echo "Verifying installations..."

# Check Git
if command -v git &> /dev/null; then
    echo "Git installed successfully. Version: $(git --version)"
else
    echo "Git installation failed."
fi

# Check SSH (comes pre-installed on macOS)
if command -v ssh &> /dev/null; then
    echo "SSH is available. Version: $(ssh -V 2>&1)"
else
    echo "SSH not found. This is unusual for macOS."
fi

# Check GPG
if command -v gpg &> /dev/null; then
    echo "GPG installed successfully. Version: $(gpg --version | head -n 1)"
else
    echo "GPG installation failed."
fi

echo "Installation process completed."