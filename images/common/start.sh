#!/bin/sh
service ssh start > /dev/null && \
service rsyslog start > /dev/null && \
while ! "${ALLOW_EXIT}" ; do script -q -c "/bin/bash -l" /dev/null ; done && \
script -q -c "/bin/bash -l" /dev/null && \
script -q -c "tail -f /dev/null"
