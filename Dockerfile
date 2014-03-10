# Demo application
#
# VERSION               0.2

FROM ubuntu:13.10
MAINTAINER Peter Olsen <polsen@gannett.com>

# Bring Ubuntu up-to-date and install packages for Ruby and Passenger
RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y apt-transport-https build-essential ca-certificates zlib1g-dev libssl-dev libreadline6-dev libyaml-dev libsqlite3-dev libcurl4-openssl-dev git apache2-mpm-worker apache2-threaded-dev libapr1-dev libaprutil1-dev libffi-dev libgdbm-dev nodejs

# Install Passenger
RUN echo "deb https://oss-binaries.phusionpassenger.com/apt/passenger saucy main" > /etc/apt/sources.list.d/passenger.list
RUN chmod 600 /etc/apt/sources.list.d/passenger.list
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 561F9B9CAC40B2F7
RUN apt-get update
RUN apt-get install -y passenger

# Build Ruby 2.1.1 from source
ADD http://cache.ruby-lang.org/pub/ruby/2.1/ruby-2.1.1.tar.gz /tmp/
RUN cd /tmp && \
    tar -xzf ruby-2.1.1.tar.gz && \
    cd ruby-2.1.1 && \
    ./configure && \
    make && \
    make install && \
    cd .. && \
    rm -rf ruby-2.1.1 && \
    rm -f ruby-2.1.1.tar.gz

# Install global Gems
RUN gem install bundler daemon_controller

# Setup up user
RUN addgroup --gid 5000 rails
RUN adduser --disabled-password --gecos "" --uid 5000 --gid 5000 rails

# Install application
# ADD . /opt/docker-demo
RUN cd /opt && git clone https://github.com/pto/docker-demo.git
RUN cd /opt/docker-demo && \
    bundle install && \
    chown -R rails.rails .

# Run the application inside Passenger
RUN cd /opt/docker-demo && git pull
EXPOSE 80
WORKDIR /opt/docker-demo
CMD ["passenger", "start", "--port=80", "--environment=production", "--user=rails"]
