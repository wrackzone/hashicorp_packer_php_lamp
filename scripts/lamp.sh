#!/bin/bash
sleep 30
export DEBIAN_FRONTEND=noninteractive
sudo apt update -y

# Setup Apache 
echo "================================="
echo "Setting APACHE"
echo "================================="
sudo apt-get install apache2 -y

# Setup MySQL server and created one non root user
echo "================================="
echo "Setting MySQL"
echo "================================="
sudo apt-get install mysql-server -y
echo "Running mysql create user script"
sudo mysql -sfu root < "mysql_create_user.sql"

# Setup PHP (default)
echo "================================="
echo "Setting PHP"
echo "================================="
# in case you need a specific PHP version, point to an apt-repository
# like we tried for 7.0 in one of the case
# sudo add-apt-repository ppa:ondrej/php -y
# sudo apt-get install php7.0 libapache2-mod-php7.0 php7.0-mysql -y

sudo apt-get install php \
	libapache2-mod-php \
	php-mysql -y

# Setup FPM (Optional)
echo "================================="
echo "OPTIONAL - FPM"
echo "================================="
sudo apt install php-fpm -y
sudo a2enmod proxy_fcgi setenvif -y
sudo a2enconf php-fpm -y
sudo a2dismod php -y
sudo service apache2 restart -y

# Apache Tuning (Optional)
echo "================================="
echo "OPTIONAL - Apache Tuning ENABLE DISABLE modules and fpm"
echo "================================="
sudo service php-fpm restart -y
sudo a2dismod mpm_prefork -y
sudo a2enmod mpm_event -y
sudo service apache2 restart -y
sudo service php-fpm restart -y

# Setup PHPMyAdmin
echo "================================="
echo "Setup PHPMyAdmin"
echo "================================="
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/internal/skip-preseed boolean true"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/reconfigure-webserver multiselect"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/dbconfig-install boolean false"
sudo apt install phpmyadmin php-mbstring php-gettext -y
sudo a2enmod ssl -y
sudo service apache2 restart -y
sudo service php-fpm restart -y

# MEM CACHED (Optional)
echo "================================="
echo "Setup Memcached"
echo "================================="
sudo apt-get install memcached php-memcached -y


# Generally useful PHP Library 
echo "================================="
echo "Setup CURL"
echo "================================="
sudo apt-get install php-curl \
	php-common \
	php-mbstring \
	php-json \
	php-xml \
	php-bcmath -y

sudo service apache2 restart -y
sudo service php-fpm restart -y

echo "~~~~~~~ ALL DONE ~~~~~~~~"
