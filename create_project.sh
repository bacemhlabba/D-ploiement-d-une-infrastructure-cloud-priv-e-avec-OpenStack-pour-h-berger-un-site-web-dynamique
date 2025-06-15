#!/usr/bin/env bash
# Script to create OpenStack project and users

# Source the OpenRC file to get admin credentials
source /opt/stack/devstack/openrc admin admin

# Create a new project
PROJECT_NAME="webapp-project"
echo "Creating project: $PROJECT_NAME"
openstack project create --description "Web Application Project" $PROJECT_NAME

# Create a new user
USER_NAME="webapp-user"
USER_PASSWORD="webapppass"
echo "Creating user: $USER_NAME"
openstack user create --project $PROJECT_NAME --password $USER_PASSWORD $USER_NAME

# Assign admin role to the user in the project
echo "Assigning admin role to $USER_NAME in $PROJECT_NAME"
openstack role add --user $USER_NAME --project $PROJECT_NAME admin

# Create a security group for web traffic
echo "Creating security group for web traffic"
openstack security group create webapp-sg --description "Web application security group"

# Add rules to allow SSH, HTTP, and HTTPS
echo "Adding rules to security group"
openstack security group rule create --protocol tcp --dst-port 22 webapp-sg
openstack security group rule create --protocol tcp --dst-port 80 webapp-sg
openstack security group rule create --protocol tcp --dst-port 443 webapp-sg
openstack security group rule create --protocol icmp webapp-sg

echo "Project and user setup complete!"
