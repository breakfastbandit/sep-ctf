FROM kalilinux/kali

RUN apt-get update
RUN apt-get install -y ssh sudo less man vim
RUN apt-get install -y net-tools iproute2 iputils-ping
RUN apt-get install -y tcpdump netcat-traditional iptables scapy telnet
RUN apt-get install 
RUN service ssh start
EXPOSE 22

RUN useradd -rm -d /home/attacker -s /usr/bin/bash -g root -G sudo -u 1000 attacker
RUN echo "attacker:attacker" | chpasswd

ADD docker-entrypoint.sh /usr/local/bin
RUN chmod +x /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT [ "docker-entrypoint.sh" ]
CMD ["/usr/sbin/sshd", "-D"]

