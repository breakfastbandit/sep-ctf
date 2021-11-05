FROM ubuntu:16.04
RUN apt-get update
RUN apt-get install -y iproute2
RUN apt-get install -y less
RUN apt-get install -y openssh-server
RUN apt-get install -y apache2
RUN apt-get install -y nmap

#Configure SSH and apache
RUN mkdir /var/run/sshd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
EXPOSE 22

RUN mkdir /var/www/dumb/
COPY index.html /var/www/dumb/index.html
COPY dumb.gif /var/www/dumb/dumb.gif
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf
RUN sed -i 's/html/dumb/' /etc/apache2/sites-available/000-default.conf
EXPOSE 80

# Add/configure users then implement challenge flags
RUN useradd -m lloyd
RUN echo 'lloyd:aspen' | chpasswd
COPY flag1.txt /home/lloyd/flag1.txt
RUN chmod go-rwx /usr/bin/passwd

COPY F1@g2.txt /usr/games/F1@g2.txt

RUN echo 'root:maryswanson' | chpasswd
COPY flag3.txt /root/flag3.txt
RUN chmod +rx /root
RUN chmod 000 /root/flag3.txt

RUN chmod +s /bin/cp

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile


WORKDIR /setup
COPY apache2.sh .
COPY sshd.sh .
COPY wrapper.sh .
RUN chmod +x *

CMD ["./wrapper.sh", "-D"]


