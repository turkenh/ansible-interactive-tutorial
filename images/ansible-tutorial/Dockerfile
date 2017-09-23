FROM turkenh/nutsh:1.0

RUN apk add --no-cache ansible openssh fping

COPY tutorials /tutorials

WORKDIR /root

RUN mkdir -p /root/.ssh && chmod 700 /root/.ssh && mkdir /etc/ansible

COPY images/common/ansible.cfg /etc/ansible/ansible.cfg

COPY ["images/common/id_rsa", "images/common/id_rsa.pub", "/root/.ssh/"]
COPY ["images/common/.vimrc", "images/common/.profile", "/root/"]

RUN chmod 644 /root/.ssh/id_rsa.pub && chmod 600 /root/.ssh/id_rsa

ENTRYPOINT ["nutsh", "run", "/tutorials"]