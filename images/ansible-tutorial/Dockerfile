FROM turkenh/nutsh

RUN apk add --no-cache ansible

COPY tutorials /tutorials

WORKDIR /root

RUN mkdir -p /root/.ssh

COPY ["images/common/id_rsa", "images/common/id_rsa.pub", "/root/.ssh/"]
COPY ["images/common/.vimrc", "images/common/.profile", "/root/"]

ENTRYPOINT ["nutsh", "run", "/tutorials"]