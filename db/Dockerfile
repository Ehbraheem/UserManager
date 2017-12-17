# Docker Image for MongoDB



FROM ubuntu:16.04
MAINTAINER Bolatan Ibrahim <ehbraheem@gmail.com>

RUN sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 2930ADAE8CAF5059EE73BB4B58712A2291FA4AD5

RUN echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.6 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.6.list

RUN sudo apt-get update && sudo apt-get install -y mongodb-org

ENV DATA_DIR /data/db
RUN mkdir -p $DATA_DIR
RUN chown -R mongodb:mongodb $DATA_DIR
ADD mongod.conf /etc/mongodb.conf
ADD mongodb.pem /etc/ssl/certs/mongodb.pem

VOLUME [$DATA_DIR]

EXPOSE 27017

ENTRYPOINT ["usr/bin/mongod", "--config", "/etc/mongodb.conf"]