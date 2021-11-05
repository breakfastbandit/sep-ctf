FROM ubuntu:latest

RUN apt-get update
RUN apt-get install -y openssh-server sudo
RUN apt-get install -y net-tools iproute2 iputils-ping
RUN apt-get install -y less man vim
RUN apt-get install -y tcpdump
RUN apt-get install -y netcat
RUN apt-get install -y busybox-static iptables
RUN service ssh start
EXPOSE 22 
EXPOSE 23

RUN useradd -rm -d /home/jimmy -s /bin/bash -g root -G sudo -u 1000 jimmy
RUN echo "jimmy:PB&J_Sandwiches" | chpasswd

RUN useradd -rm -d /home/monitor -s /bin/bash -u 1001 monitor
RUN echo "monitor:monitors_gonna_monit" | chpasswd

ADD note.txt /tmp
RUN chmod 700 /home/jimmy
RUN chown jimmy:root /tmp/note.txt

ADD docker-entrypoint.sh /usr/local/bin
RUN chmod +x /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT [ "docker-entrypoint.sh" ]
CMD ["/usr/sbin/sshd", "-D"]
