#
#--------------------------------------------------------------------------
# Image Setup
#--------------------------------------------------------------------------
#

FROM nginx:alpine

MAINTAINER Cheney Veron <cheneyveron@live.cn>

RUN mkdir -p /var/www
VOLUME /var/www

# Copy confs
RUN rm -rf /etc/nginx/nginx.conf \
	&& mkdir -p /etc/nginx/rewrite
ADD conf/nginx.conf /etc/nginx/nginx.conf
ADD conf/vhost-ssl.conf /etc/nginx/vhost-ssl.conf
ADD conf/vhost.conf /etc/nginx/vhost.conf
COPY conf/rewrite/* /etc/nginx/rewrite/
ADD scripts/start.sh /start.sh
RUN chmod +x /start.sh

#SSH && Git
RUN apk add --no-cache openssh git bash

#Cron
RUN apk add --no-cache --virtual cron 
ADD scripts/backup.sh /usr/bin/backup.sh
ADD scripts/git-clean /usr/bin/git-clean
RUN chmod +x /usr/bin/backup.sh \
	&& chmod +x /usr/bin/git-clean \
    && echo "0 0 * * * bash /usr/bin/backup.sh > /dev/null 2>&1" >> /etc/crontabs/root \
	&& echo "20 0 * * * apk update 2>&1" >> /etc/crontabs/root \
    && chmod 0644 /etc/crontabs/root

#letsencrypt
RUN apk add --no-cache certbot

VOLUME /etc/letsencrypt
VOLUME /var/lib/letsencrypt

RUN echo '30 2 * * 1 /usr/bin/certbot renew --force-renew --renew-hook "/usr/sbin/nginx -s reload"' >> /var/spool/cron/crontabs/root \
	&& echo "# Empty Line" >> /etc/crontabs/root

CMD ["/start.sh"]