#!/usr/bin/env bash
# Script to set up WordPress on the VM

# This script should be run on the VM after it's created

# Update system packages
sudo apt-get update -y
sudo apt-get upgrade -y

# Install Apache, MySQL, PHP
sudo apt-get install -y apache2 mysql-server php libapache2-mod-php php-mysql

# Configure MySQL
sudo mysql -e "CREATE DATABASE wordpress DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;"
sudo mysql -e "CREATE USER 'wordpressuser'@'localhost' IDENTIFIED BY 'password';"
sudo mysql -e "GRANT ALL ON wordpress.* TO 'wordpressuser'@'localhost';"
sudo mysql -e "FLUSH PRIVILEGES;"

# Download and configure WordPress
cd /tmp
wget https://wordpress.org/latest.tar.gz
tar -xzvf latest.tar.gz
sudo cp -a /tmp/wordpress/. /var/www/html/
sudo chown -R www-data:www-data /var/www/html/
sudo chmod -R 755 /var/www/html/

# Create WordPress configuration file
sudo cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php
sudo sed -i "s/database_name_here/wordpress/" /var/www/html/wp-config.php
sudo sed -i "s/username_here/wordpressuser/" /var/www/html/wp-config.php
sudo sed -i "s/password_here/password/" /var/www/html/wp-config.php

# Generate WordPress salts
SALTS=$(curl -s https://api.wordpress.org/secret-key/1.1/salt/)
SEARCH="put your unique phrase here"
sudo sed -i "/#@-/,/#@+/c\\$SALTS" /var/www/html/wp-config.php

# Restart Apache
sudo systemctl restart apache2

echo "WordPress installation complete!"
echo "Visit http://YOUR_VM_IP to complete the WordPress setup."
