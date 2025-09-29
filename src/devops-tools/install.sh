#!/bin/bash
set -e

# Logging mechanism for debugging
LOG_FILE="/tmp/devops-tools-install.log"
log_debug() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') [DEBUG] $*" >> "$LOG_FILE"
}

# Initialize logging
log_debug "=== DEVOPS-TOOLS INSTALL STARTED ==="
log_debug "Script path: $0"
log_debug "PWD: $(pwd)"
log_debug "Environment: USER=$USER HOME=$HOME"

echo "Installing DevOps Tools..."

# Function to execute command with sudo only if needed
run_with_sudo() {
    if [ "$(id -u)" = "0" ]; then
        "$@"
    elif command -v sudo >/dev/null 2>&1; then
        sudo "$@"
    else
        echo "Warning: Not running as root and sudo not available. Trying without sudo..." >&2
        "$@"
    fi
}

# Update package lists
run_with_sudo apt-get update

# Install kubectl
echo "Installing kubectl..."
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/arm64/kubectl"
run_with_sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
rm kubectl

# Install Terraform
echo "Installing Terraform..."
TERRAFORM_VERSION=$(curl -s https://api.github.com/repos/hashicorp/terraform/releases/latest | grep tag_name | cut -d '"' -f 4 | sed 's/v//')
curl -LO "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_arm64.zip"
unzip terraform_${TERRAFORM_VERSION}_linux_arm64.zip
run_with_sudo mv terraform /usr/local/bin/
rm terraform_${TERRAFORM_VERSION}_linux_arm64.zip

# Install AWS CLI v2
echo "Installing AWS CLI v2..."
curl "https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
run_with_sudo ./aws/install
rm -rf aws awscliv2.zip

# Install Helm
echo "Installing Helm..."
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

echo "DevOps tools installation completed successfully!"

log_debug "=== DEVOPS-TOOLS INSTALL COMPLETED ==="
# Auto-trigger build Tue Sep 23 20:03:12 BST 2025
# Auto-trigger build Sun Sep 28 03:45:46 BST 2025
