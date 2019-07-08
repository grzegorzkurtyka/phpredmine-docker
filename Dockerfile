FROM alpine:3.10
RUN echo "http://dl-3.alpinelinux.org/alpine/3.10/testing/" >> /etc/apk/repositories
RUN apk --update add redis php7-apache2 curl php7-cli php7-json php7-phar php7-openssl php7-iconv php7-pecl-redis && \
    rm -f /var/cache/apk/*
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN cd /var/www/localhost && \
    curl -q  https://codeload.github.com/sasanrose/phpredmin/tar.gz/v1.2.3 > phpredmin-1.2.3.tar.gz && \
    tar xzf  phpredmin-1.2.3.tar.gz && \
    rm phpredmin-1.2.3.tar.gz && \
    rm -rf htdocs/ && mv phpredmin-1.2.3 htdocs

COPY files/config.php /var/www/localhost/htdocs/config.php
COPY files/run.sh /var/www/localhost/run.sh
RUN mkdir -p -m 0777 /var/www/localhost/htdocs/logs/apache2handler/ && \
    chmod a+x /var/www/localhost/run.sh

RUN sed 's|/var/www/localhost/htdocs|/var/www/localhost/htdocs/public|g' /etc/apache2/httpd.conf >/etc/apache2/httpd-new.conf && \
    echo "ServerName localhost" >> /etc/apache2/httpd-new.conf && \
    mv /etc/apache2/httpd-new.conf /etc/apache2/httpd.conf

EXPOSE 80

WORKDIR /var/www/localhost/htdocs/

CMD ["/var/www/localhost/run.sh"]
