#!/bin/sh

# Global
export DEBIAN_FRONTEND=noninteractive
echo mysql-server mysql-server/root_password password root | debconf-set-selections
echo mysql-server mysql-server/root_password_again password root | debconf-set-selections

# Update system and install packages
apt-get -y update
apt-get -y install python-software-properties
add-apt-repository ppa:ondrej/php5
apt-get -y update
apt-get -y -q install php5 apache2 mysql-server php5-mysql php5-json php5-curl git curl
adduser vagrant www-data

# Configure MySQL
sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mysql/my.cnf

# Install phpMyAdmin
cd /usr/local/src
wget -O phpmyadmin.tgz "http://downloads.sourceforge.net/project/phpmyadmin/phpMyAdmin/4.1.13/phpMyAdmin-4.1.13-english.tar.gz?r=http%3A%2F%2Fwww.phpmyadmin.net%2Fhome_page%2Fdownloads.php"
tar xzvf phpmyadmin.tgz
mv phpMyAdmin-4.1.13-english /var/www/phpmyadmin

# Configure Apache
mkdir /var/www/html

echo '<VirtualHost *:80>
        ServerAdmin webmaster@localhost
        DocumentRoot /var/www/html

        ErrorLog ${APACHE_LOG_DIR}/error.log
        CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>

Alias /phpmyadmin "/var/www/phpmyadmin/"
<Directory "/var/www/phpmyadmin/">
    Order allow,deny
    Allow from all
</Directory>
' > /etc/apache2/sites-available/000-default.conf

a2enmod rewrite

# Compass CSS compiler
gem install compass

# Composer
curl -sS https://getcomposer.org/installer | php -- --install-dir=/bin --filename=composer

# Restart services
service apache2 restart
service mysql restart