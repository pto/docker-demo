# Demo application
#
# VERSION               0.2

FROM polsen/docker-rails
MAINTAINER Peter Olsen <polsen@gannett.com>

RUN cd /opt && \
    git clone https://github.com/pto/docker-demo.git && \
    cd docker-demo && \
    cp config/passenger.conf /etc/apache2/conf.d && \
    cp config/docker-demo.conf /etc/apache2/conf.d && \
    bundle install && \
    chmod 777 log && \
    chown -R www-data.www-data .

EXPOSE 80

CMD ["/bin/bash", "-c", "source /etc/apache2/envvars && exec /usr/sbin/apache2 -DFOREGROUND"]
