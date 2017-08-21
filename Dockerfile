FROM drydock/u16:arm
MAINTAINER Avi "avi@shippable.com"

ENV DEBIAN_FRONTEND noninteractive

ADD . /home/shippable/appBase

RUN /home/shippable/appBase/install.sh && rm -rf /tmp && mkdir /tmp
