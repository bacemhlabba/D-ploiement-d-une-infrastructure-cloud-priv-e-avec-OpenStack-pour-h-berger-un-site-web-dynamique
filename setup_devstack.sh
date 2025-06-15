#!/usr/bin/env bash

# Setup script for DevStack installation

# Deactivate any active virtual environment
if [[ -n "$VIRTUAL_ENV" ]]; then
  echo "Deactivating virtual environment: $VIRTUAL_ENV"
  deactivate
fi

# Create a stack user as recommended by DevStack
echo "Checking if stack user exists..."
if ! id -u stack >/dev/null 2>&1; then
  echo "Creating stack user..."
  sudo useradd -s /bin/bash -d /opt/stack -m stack
  
  # Give stack user sudo privileges
  echo "Adding sudo privileges to stack user..."
  echo "stack ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/stack
fi

# Copy DevStack to stack user home directory
echo "Copying DevStack to stack user home directory..."
sudo mkdir -p /opt/stack
sudo cp -R /home/bacemhlabba/Downloads/openstack/devstack /opt/stack/
sudo chown -R stack:stack /opt/stack

# Copy our local.conf to the stack user's devstack directory
echo "Copying local.conf to stack user's devstack directory..."
sudo cp /home/bacemhlabba/Downloads/openstack/devstack/local.conf /opt/stack/devstack/

# Switch to stack user and run stack.sh
echo "Switching to stack user and running stack.sh..."
sudo su - stack -c "cd /opt/stack/devstack && ./stack.sh"

echo "DevStack installation complete!"
