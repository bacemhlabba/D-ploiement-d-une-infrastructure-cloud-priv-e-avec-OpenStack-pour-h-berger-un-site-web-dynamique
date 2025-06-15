#!/usr/bin/env bash
# Main orchestration script for OpenStack deployment

echo "============================================="
echo "    OpenStack Private Cloud Deployment"
echo "============================================="
echo

# Function to check if a command executed successfully
check_status() {
    if [ $? -eq 0 ]; then
        echo "✓ Success: $1"
        return 0
    else
        echo "✗ Error: $1 failed"
        return 1
    fi
}

# Show menu and get user choice
show_menu() {
    echo "What would you like to do?"
    echo "1) Install OpenStack with DevStack"
    echo "2) Create Project and User"
    echo "3) Deploy Virtual Machine"
    echo "4) Create and Attach Storage Volume"
    echo "5) Deploy WordPress using Heat (automated)"
    echo "6) Check OpenStack Services Status"
    echo "7) Execute All Steps in Sequence"
    echo "8) Exit"
    echo
    read -p "Enter your choice [1-8]: " choice
    echo
    return $choice
}

# 1) Install OpenStack
install_openstack() {
    echo "===== Installing OpenStack ====="
    echo "This will take 30-45 minutes..."
    ./setup_devstack.sh
    check_status "OpenStack installation" || return 1
    echo
}

# 2) Create Project
create_project() {
    echo "===== Creating Project and User ====="
    ./create_project.sh
    check_status "Project creation" || return 1
    echo
}

# 3) Deploy VM
deploy_vm() {
    echo "===== Deploying Virtual Machine ====="
    ./deploy_vm.sh
    check_status "VM deployment" || return 1
    echo
}

# 4) Create and attach volume
create_volume() {
    echo "===== Creating Storage Volume ====="
    ./create_volume.sh
    check_status "Volume creation" || return 1
    echo
}

# 5) Deploy with Heat
deploy_heat() {
    echo "===== Deploying WordPress with Heat ====="
    ./deploy_heat_stack.sh
    check_status "Heat deployment" || return 1
    echo
}

# 6) Check services
check_services() {
    echo "===== Checking OpenStack Services ====="
    ./check_services.sh
    check_status "OpenStack services check" || return 1
    echo
}

# 7) Execute all steps
execute_all() {
    install_openstack && \
    create_project && \
    deploy_vm && \
    create_volume && \
    deploy_heat
    
    if [ $? -eq 0 ]; then
        echo "✓ All steps completed successfully!"
    else
        echo "✗ Process failed. Check the logs for details."
    fi
    echo
}

# Main logic
while true; do
    show_menu
    choice=$?
    
    case $choice in
        1)
            install_openstack
            ;;
        2)
            create_project
            ;;
        3)
            deploy_vm
            ;;
        4)
            create_volume
            ;;
        5)
            deploy_heat
            ;;
        6)
            check_services
            ;;
        7)
            execute_all
            ;;
        8)
            echo "Exiting..."
            exit 0
            ;;
        *)
            echo "Invalid choice. Please enter a number between 1 and 8."
            ;;
    esac
    
    echo "Press Enter to continue..."
    read
    clear
done
