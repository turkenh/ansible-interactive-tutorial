FROM turkenh/nutsh:1.0

RUN apk add --no-cache ansible openssh fping curl

WORKDIR /root

RUN mkdir -p /root/.ssh && chmod 700 /root/.ssh && mkdir /etc/ansible

COPY common/ansible.cfg /etc/ansible/ansible.cfg

COPY ["common/id_rsa", "common/id_rsa.pub", "/root/.ssh/"]
COPY ["common/.vimrc", "common/.profile", "/root/"]

RUN chmod 644 /root/.ssh/id_rsa.pub && chmod 600 /root/.ssh/id_rsa

ENTRYPOINT ["nutsh", "run", "/tutorials"]