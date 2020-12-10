FROM ubuntu:18.04
RUN apt-get update && apt-get install -y locales && rm -rf /var/lib/apt/lists/* \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG en_US.utf8
# Install PHP extensions and dependencies

RUN DEBIAN_FRONTEND=noninteractive apt-get update -q \
    && DEBIAN_FRONTEND=noninteractive apt-get install -qq -y \
      curl \
      git \
      vim \
      zip \
      apache2 \
      php7.2 \
      php7.2-apcu \
      php7.2-bcmath \
      php7.2-bz2 \
      php7.2-curl \
      php7.2-gd \
      php7.2-intl \
      php7.2-imagick \
      php7.2-mysql \
      php7.2-xsl \
      php7.2-xml \
      php7.2-zip \
      php7.2-sockets \
      php7.2-mbstring \
    && a2enmod rewrite && a2enmod headers \
    && apt-get clean && rm -rf /var/lib/apt/lists/*


# Update Php Settings
RUN sed -E -i -e 's/max_execution_time = 30/max_execution_time = 120/' /etc/php/7.2/cli/php.ini \
 && sed -E -i -e 's/max_execution_time = 30/max_execution_time = 120/' /etc/php/7.2/apache2/php.ini \
 && sed -E -i -e 's/memory_limit = 128M/memory_limit = 512M/' /etc/php/7.2/cli/php.ini \
 && sed -E -i -e 's/memory_limit = 128M/memory_limit = 512M/' /etc/php/7.2/apache2/php.ini \
 && sed -E -i -e 's/post_max_size = 8M/post_max_size = 100M/' /etc/php/7.2/cli/php.ini \
 && sed -E -i -e 's/post_max_size = 8M/post_max_size = 100M/' /etc/php/7.2/apache2/php.ini \
 && sed -E -i -e 's/short_open_tag = Off/short_open_tag = On/' /etc/php/7.2/apache2/php.ini \
 && sed -E -i -e 's/short_open_tag = Off/short_open_tag = On/' /etc/php/7.2/cli/php.ini \
 && sed -E -i -e 's/upload_max_filesize = 2M/upload_max_filesize = 100M/' /etc/php/7.2/apache2/php.ini \
 && sed -E -i -e 's/upload_max_filesize = 2M/upload_max_filesize = 100M/' /etc/php/7.2/cli/php.ini


WORKDIR /var/www/html
RUN rm index.html
COPY appbclinic.conf /etc/apache2/sites-available/
RUN a2dissite 000-default \
    && a2ensite appbclinic.conf \
    && service apache2 restart
COPY . .
#RUN php composer.phar install
#now start the server
CMD ["/usr/sbin/apachectl", "-D", "FOREGROUND"]
EXPOSE 80
