#!/bin/bash
# ------------------------------------------------------------------
# [Title] Production Server Setup Script
# [Description] Prepares an Amazon Linux 2023 / Ubuntu server for Microservices
# [Author] DevOps Team
# ------------------------------------------------------------------

set -e # Exit immediately if a command exits with a non-zero status

echo ">>> Starting Production Server Setup..."

# 1. Update System
echo ">>> Updating Packages..."
sudo yum update -y || sudo apt-get update -y

# 2. Install Common DevOps Tools
echo ">>> Installing Critical Tools (curl, git, jq, etc)..."
sudo yum install -y curl git jq htop || sudo apt-get install -y curl git jq htop

# 3. Create Application User (Security Best Practice)
# NEVER run apps as root.
APP_USER="app_user"
if id "$APP_USER" &>/dev/null; then
    echo ">>> User $APP_USER already exists. Skipping..."
else
    echo ">>> Creating user: $APP_USER"
    sudo useradd -m -s /bin/bash $APP_USER
fi

# 4. Create Standard Directory Structure
# /opt/ is standard for optional software packages/apps
APP_DIR="/opt/devops-platform"
echo ">>> Creating Application Directory at $APP_DIR..."
sudo mkdir -p $APP_DIR
sudo chown -R $APP_USER:$APP_USER $APP_DIR
sudo chmod 755 $APP_DIR

# 5. Kernel Tuning (Example: Increase File Descriptors for high-load apps)
echo ">>> Tuning ulimits..."
# This would strictly be done via /etc/security/limits.conf in real prod, 
# but showing the concept here.
sudo sh -c 'echo "* soft nofile 65535" >> /etc/security/limits.conf'
sudo sh -c 'echo "* hard nofile 65535" >> /etc/security/limits.conf'

echo ">>> Setup Complete! Ready for CI/CD Agent or Docker."
