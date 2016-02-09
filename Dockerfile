FROM alpine:3.3
RUN echo "http://dl-3.alpinelinux.org/alpine/edge/testing/" >> /etc/apk/repositories && \
    apk --update add php-apache2 curl php-cli php-json php-phar php-openssl phpredis && \
    rm -f /var/cache/apk/* && \
    echo "extension=redis.so" >/etc/php/conf.d/redis.ini && \
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && \
    mkdir mkdir /run/apache2/ && chown -R apache:apache mkdir /run/apache2/

RUN cd /var/www/localhost && \
    curl -q  https://codeload.github.com/sasanrose/phpredmin/tar.gz/v1.0.0 > phpredmin-1.0.0.tar.gz && \
    tar xzf  phpredmin-1.0.0.tar.gz && \
    rm phpredmin-1.0.0.tar.gz && \
    rm -rf htdocs/ && mv phpredmin-1.0.0 htdocs

COPY files/config.php /var/www/localhost/htdocs/config.php
COPY files/run.sh /var/www/localhost/run.sh
RUN mkdir -p -m 0777 /var/www/localhost/htdocs/logs/apache2handler/ && \
    chmod a+x /var/www/localhost/run.sh

RUN sed 's|/var/www/localhost/htdocs|/var/www/localhost/htdocs/public|g' /etc/apache2/httpd.conf >/etc/apache2/httpd-new.conf && \
    mv /etc/apache2/httpd-new.conf /etc/apache2/httpd.conf

EXPOSE 80

WORKDIR /var/www/localhost/htdocs/

ENTRYPOINT ["/var/www/localhost/run.sh"]
