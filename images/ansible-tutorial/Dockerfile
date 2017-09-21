FROM turkenh/nutsh

RUN apk add --no-cache ansible openssh

COPY tutorials /tutorials

WORKDIR /root

RUN mkdir -p /root/.ssh && mkdir /etc/ansible

COPY images/common/ansible.cfg /etc/ansible/ansible.cfg

COPY ["images/common/id_rsa", "images/common/id_rsa.pub", "/root/.ssh/"]
COPY ["images/common/.vimrc", "images/common/.profile", "/root/"]

ENTRYPOINT ["nutsh", "run", "/tutorials"]