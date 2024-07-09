# Use Ubuntu 20.04 as the base image
FROM ubuntu:20.04

# Set environment variables to avoid interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Update package lists and install necessary packages
RUN apt-get update && apt-get install -y \
    apache2 \
    php \
    libapache2-mod-php \
    mysql-server \
    php-mysql \
    phpmyadmin \
    && rm -rf /var/lib/apt/lists/*

# Configure MySQL
RUN service mysql start && \
    mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'root'; FLUSH PRIVILEGES;"

# Configure PHPMyAdmin to work with Apache
RUN echo "Include /etc/phpmyadmin/apache.conf" >> /etc/apache2/apache2.conf

# Enable Apache modules and configure permissions
RUN a2enmod rewrite
RUN chown -R www-data:www-data /var/www/html/
RUN chmod -R 755 /var/www/html/

# Expose ports
EXPOSE 80
EXPOSE 3306

# Start Apache and MySQL services
CMD service apache2 start && service mysql start && tail -f /dev/null
