FROM ubuntu:14.04
MAINTAINER Hasan Turken

RUN apt-get update && apt-get install -y netbase net-tools python openssh-server vim sudo curl python-yaml python-jinja2 python-paramiko python-crypto
RUN mkdir ~/.ssh && ssh-keygen -N "" -t rsa -f ~/.ssh/id_rsa

COPY images/common/id_rsa.pub /root/.ssh/authorized_keys
COPY ["images/common/.vimrc", "images/common/.profile", "./root/"]
COPY images/common/start.sh /start.sh

WORKDIR /root

ENV ALLOW_EXIT true

CMD /start.sh
