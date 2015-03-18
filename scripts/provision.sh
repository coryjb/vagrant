#!/bin/sh

# Global
export DEBIAN_FRONTEND=noninteractive
echo mysql-server mysql-server/root_password password root | debconf-set-selections
echo mysql-server mysql-server/root_password_again password root | debconf-set-selections

# Update system and install packages
apt-get -y update
add-apt-repository ppa:ondrej/php5
apt-get -y -q install python-software-properties php5 apache2 mysql-server php5-mysql php5-json php5-curl php5-gd php5-imagick php5-intl git curl ruby rubygems imagemagick vim php5-apcu
adduser vagrant www-data

# Configure MySQL
sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mysql/my.cnf
mysql -p"root" -u root -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'root';"

# Install phpMyAdmin
cd /usr/local/src
wget -O phpmyadmin.tgz "http://downloads.sourceforge.net/project/phpmyadmin/phpMyAdmin/4.1.13/phpMyAdmin-4.1.13-english.tar.gz?r=http%3A%2F%2Fwww.phpmyadmin.net%2Fhome_page%2Fdownloads.php"
tar xzvf phpmyadmin.tgz
mv phpMyAdmin-4.1.13-english /var/www/phpmyadmin

# Configure Apache
sed -i 's/www-data/vagrant/g' /etc/apache2/envvars
mkdir /var/www/html

echo '<VirtualHost *:80>
        ServerAdmin webmaster@localhost
        DocumentRoot /var/www/html

        <Directory "/var/www">
            Options Indexes FollowSymLinks MultiViews
            AllowOverride all
            Order allow,deny
            Allow from all
        </Directory>

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

echo 'zend_extension=xdebug.so
xdebug.default_enable = 1
xdebug.idekey = "vagrant"
xdebug.remote_enable = 1
xdebug.remote_autostart = 0
xdebug.remote_port = 9000
xdebug.remote_handler=dbgp
xdebug.remote_log="/var/log/xdebug/xdebug.log"
xdebug.remote_host=192.168.33.1' > /etc/php5/mods-available/xdebug.ini

# Compass CSS compiler
gem install compass
ln -s /usr/local/bin/compass /usr/bin/compass

# Composer
curl -sS https://getcomposer.org/installer | php -- --install-dir=/bin --filename=composer

# Restart services
service apache2 restart
service mysql restart
