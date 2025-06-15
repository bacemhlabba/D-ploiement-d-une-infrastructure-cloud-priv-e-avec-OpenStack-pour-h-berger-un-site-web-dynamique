#!/usr/bin/env bash
# Script to check the status of OpenStack services

# Source the OpenRC file
source /opt/stack/devstack/openrc admin admin

echo "===== OpenStack Services Status ====="
echo

# Check Nova services
echo "----- Nova Services -----"
openstack compute service list
echo

# Check Neutron services
echo "----- Neutron Services -----"
openstack network agent list
echo

# Check Volume services
echo "----- Cinder Services -----"
openstack volume service list
echo

# Check Glance service
echo "----- Glance Service -----"
openstack image list | head
echo

# Check networks
echo "----- Networks -----"
openstack network list
echo

# Check Keystone services
echo "----- Identity Services -----"
openstack endpoint list | head
echo

# Check Heat services
echo "----- Orchestration Services -----"
openstack orchestration service list
echo

echo "===== OpenStack Services Check Complete ====="
