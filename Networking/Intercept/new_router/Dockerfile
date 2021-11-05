FROM kalilinux/kali

RUN apt-get update
RUN apt-get install -y ssh sudo
RUN apt-get install -y net-tools iproute2 iputils-ping
RUN apt-get install -y less man vim
RUN apt-get install -y tcpdump
RUN apt-get install -y netcat-traditional
RUN apt-get install -y iptables scapy
RUN service ssh start
EXPOSE 22

RUN useradd -rm -d /home/admin -s /usr/bin/bash -g root -G sudo -u 1000 admin
RUN echo "admin:2830746031" | chpasswd

ADD docker-entrypoint.sh /usr/local/bin
RUN chmod +x /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT [ "docker-entrypoint.sh" ]
CMD ["/usr/sbin/sshd", "-D"]

