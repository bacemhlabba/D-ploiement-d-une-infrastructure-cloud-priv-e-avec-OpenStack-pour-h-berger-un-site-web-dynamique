#!/usr/bin/env bash
# Script to deploy a VM and set up networking

# Source the OpenRC file for our project
source /opt/stack/devstack/openrc admin admin

# Create a basic network
NETWORK_NAME="webapp-network"
SUBNET_NAME="webapp-subnet"
ROUTER_NAME="webapp-router"
echo "Creating network: $NETWORK_NAME"
openstack network create $NETWORK_NAME

# Create subnet
echo "Creating subnet: $SUBNET_NAME"
openstack subnet create --network $NETWORK_NAME --subnet-range 192.168.100.0/24 --gateway 192.168.100.1 $SUBNET_NAME

# Create router
echo "Creating router: $ROUTER_NAME"
openstack router create $ROUTER_NAME

# Connect router to subnet
echo "Connecting router to subnet"
openstack router add subnet $ROUTER_NAME $SUBNET_NAME

# Connect router to external network
echo "Connecting router to external network"
openstack router set --external-gateway ext-net $ROUTER_NAME

# Create a keypair for SSH access
KEY_NAME="webapp-key"
echo "Creating keypair: $KEY_NAME"
openstack keypair create $KEY_NAME > ~/webapp-key.pem
chmod 600 ~/webapp-key.pem

# Find the Ubuntu image
IMAGE_ID=$(openstack image list | grep -i ubuntu | head -1 | awk '{print $2}')
if [ -z "$IMAGE_ID" ]; then
  echo "No Ubuntu image found. Creating one..."
  # Download a small Ubuntu cloud image
  wget https://cloud-images.ubuntu.com/minimal/releases/focal/release/ubuntu-20.04-minimal-cloudimg-amd64.img
  
  # Upload to OpenStack
  openstack image create --disk-format qcow2 --container-format bare --public --file ubuntu-20.04-minimal-cloudimg-amd64.img "Ubuntu 20.04 Minimal"
  
  # Get the image ID
  IMAGE_ID=$(openstack image list | grep "Ubuntu 20.04 Minimal" | awk '{print $2}')
fi

# Find flavor (m1.small should be created by DevStack)
FLAVOR_ID=$(openstack flavor list | grep m1.small | awk '{print $2}')

# Deploy VM
VM_NAME="webapp-vm"
echo "Deploying VM: $VM_NAME"
openstack server create --flavor $FLAVOR_ID --image $IMAGE_ID --key-name $KEY_NAME --network $NETWORK_NAME --security-group webapp-sg $VM_NAME

# Wait for VM to be active
echo "Waiting for VM to become active..."
STATUS="BUILD"
while [ "$STATUS" != "ACTIVE" ]; do
  sleep 5
  STATUS=$(openstack server show $VM_NAME -f value -c status)
  echo "Current status: $STATUS"
done

# Create and assign floating IP
echo "Creating and assigning floating IP"
FLOATING_IP=$(openstack floating ip create ext-net -f value -c floating_ip_address)
openstack server add floating ip $VM_NAME $FLOATING_IP

echo "VM deployment complete!"
echo "VM is accessible at: $FLOATING_IP"
echo "Use the webapp-key.pem file to SSH into the VM: ssh -i ~/webapp-key.pem ubuntu@$FLOATING_IP"
