#!/usr/bin/env bash
# Script to create and attach a volume to the VM

# Source the OpenRC file
source /opt/stack/devstack/openrc admin admin

# Create volume
VOLUME_NAME="webapp-data"
VOLUME_SIZE=10  # 10GB
echo "Creating volume: $VOLUME_NAME"
openstack volume create --size $VOLUME_SIZE $VOLUME_NAME

# Wait for volume to be available
echo "Waiting for volume to become available..."
STATUS="creating"
while [ "$STATUS" != "available" ]; do
  sleep 5
  STATUS=$(openstack volume show $VOLUME_NAME -f value -c status)
  echo "Current volume status: $STATUS"
done

# Attach volume to VM
VM_NAME="webapp-vm"
echo "Attaching volume to VM: $VM_NAME"
openstack server add volume $VM_NAME $VOLUME_NAME

echo "Volume created and attached successfully!"
echo ""
echo "To prepare the volume on the VM:"
echo "  1. SSH into the VM"
echo "  2. Run: sudo fdisk -l  # to identify the attached volume (e.g., /dev/vdb)"
echo "  3. Run: sudo mkfs.ext4 /dev/vdb  # format the volume"
echo "  4. Run: sudo mkdir -p /var/www/wordpress-data  # create a mount point"
echo "  5. Run: sudo mount /dev/vdb /var/www/wordpress-data  # mount the volume"
echo "  6. Run: echo '/dev/vdb /var/www/wordpress-data ext4 defaults 0 0' | sudo tee -a /etc/fstab  # for auto-mounting"
