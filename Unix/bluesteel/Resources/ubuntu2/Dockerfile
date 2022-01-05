FROM ubuntu:16.04
RUN apt-get update
RUN apt-get install -y iproute2
RUN apt-get install -y less
RUN apt-get install -y vsftpd
RUN apt-get install -y nmap

#Configure vsftpd
COPY vsftpd /etc/init.d/vsftpd
COPY vsftpd.conf /etc/vsftpd.conf
RUN mkdir -p /var/ftp/pub
COPY flag3.txt /var/ftp/pub/flag3.txt
EXPOSE 20
EXPOSE 21
EXPOSE 10000
EXPOSE 10001

# Add/configure users then implement challenge flags
RUN useradd -m hansel
RUN echo 'hansel:dontyouknowimloco' | chpasswd
RUN usermod -d /var/ftp/pub hansel

RUN chmod go-rwx /usr/bin/passwd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

WORKDIR /setup
COPY ftp.sh .
COPY wrapper.sh .
RUN chmod +x *

CMD ["./wrapper.sh", "-D"]


