# escape=`

# Ruby VM with NodeJS 

FROM ruby:2.3
MAINTAINER Bolatan Ibrahim <ehbraheem@gmail.com>

# Install firefox browser
RUN apt-get update -qq && `
  DEBIAN_FRONTEND=noninteractive apt-get install -qq -y `
  iceweasel

# VNC and LXDE server for firefox GUI
RUN apt-get update -qq && `
   DEBIAN_FRONTEND=noninteractive apt-get install -qq -y `
   lxde-core `
   lxterminal `
   tightvncserver
ENV USER root

# Install NodeJS and build tools
RUN apt-get update -qq && `
  DEBIAN_FRONTEND=noninteractive apt-get install -qq -y `
  build-essential `
  nodejs

 
# Install phantomJS for testing
ADD https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-linux-x86_64.tar.bz2 .
RUN tar -xjf phantomjs-2.1.1-linux-x86_64.tar.bz2
RUN mv ./phantomjs-2.1.1-linux-x86_64/bin/phantomjs usr/local/bin
RUN rm -rf ./phantomjs-2.1.1-linux-x86_64
RUN phantomjs --version

# Cleanup repos
RUN rm -rf /var/lib/apt/lists/*

# APP dir within VM
ENV APP_HOME /myapp
RUN mkdir $APP_HOME
WORKDIR $APP_HOME


# Gem management. 
# VM will be rebuild when this files change
ADD Gemfile $APP_HOME
ADD Gemfile.lock $APP_HOME
RUN bundle config --global --jobs 4
RUN bundle install

# use changes to package.json to force Docker not to use the cache
# when we change our application's nodejs dependencies:
ADD package*.json /tmp/package.json
RUN cd /tmp && npm install
RUN mkdir -p $APP_HOME && cp -a /tmp/node_modules $APP_HOME

ENV DISPLAY :0
COPY vnc.sh /usr/local/bin

EXPOSE 3000 5900
