#!/bin/sh
if [ `id -u` -ge 10000 ]; then
    cat /etc/passwd | sed -e "s/^app:/builder:/" > /tmp/passwd
    echo "app:x:`id -u`:`id -g`:,,,:/home/app:/bin/sh" >> /tmp/passwd
    cat /tmp/passwd > /etc/passwd
    rm /tmp/passwd
fi

kopf run --standalone -m strimziregistryoperator.handlers --namespace myproject --verbose
