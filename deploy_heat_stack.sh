#!/usr/bin/env bash
# Script to deploy WordPress using Heat template

# Source the OpenRC file
source /opt/stack/devstack/openrc admin admin

# Deploy the Heat stack
STACK_NAME="wordpress-stack"
TEMPLATE_FILE="/home/bacemhlabba/Downloads/openstack/wordpress_heat_template.yaml"

echo "Deploying WordPress stack using Heat..."
openstack stack create -t $TEMPLATE_FILE $STACK_NAME

# Wait for stack to be created
echo "Waiting for stack creation to complete..."
STATUS="CREATE_IN_PROGRESS"
while [ "$STATUS" = "CREATE_IN_PROGRESS" ]; do
  sleep 10
  STATUS=$(openstack stack show $STACK_NAME -f value -c stack_status)
  echo "Current status: $STATUS"
done

# Check if stack was created successfully
if [ "$STATUS" = "CREATE_COMPLETE" ]; then
  # Get the WordPress URL
  WORDPRESS_URL=$(openstack stack output show $STACK_NAME wordpress_url -f value -c output_value)
  
  echo "WordPress stack created successfully!"
  echo "WordPress is accessible at: $WORDPRESS_URL"
  echo "Please visit this URL to complete the WordPress setup."
else
  echo "Stack creation failed with status: $STATUS"
  echo "Check the stack events for details:"
  echo "openstack stack event list $STACK_NAME"
fi
