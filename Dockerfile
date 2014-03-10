# Demo application
#
# VERSION               0.2

FROM phusion/passenger-ruby21
MAINTAINER Peter Olsen <polsen@gannett.com>

RUN apt-get update && apt-get install -y libsqlite3-dev nodejs

ADD . /home/app
RUN cd /home/app && \
    bundle install && \
    rake assets:precompile && \
    chown -R app.app /home/app

ADD docker/key.pub /tmp/my_key
RUN cat /tmp/my_key >>/root/.ssh/authorized_keys && \
    rm -f /tmp/my_key && chmod 600 /root/.ssh/authorized_keys

RUN rm -f /etc/service/nginx/down

ADD docker/webapp.conf /etc/nginx/sites-enabled/webapp.conf
RUN rm /etc/nginx/sites-enabled/default

RUN LC_ALL=C DEBIAN_FRONTEND=noninteractive dpkg-reconfigure openssh-server

EXPOSE 80
CMD ["/sbin/my_init"]
