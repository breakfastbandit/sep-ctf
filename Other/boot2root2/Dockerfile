FROM ubuntu:latest

# install useful tools
RUN apt-get update
RUN apt-get install sudo vim -y

# install SSH service and run it
RUN apt-get install openssh-server -y
RUN service ssh start
EXPOSE 22

# install ftp and setup
RUN apt-get install -y --no-install-recommends vsftpd
RUN mkdir -p /var/run/vsftpd/empty && mkdir -p /etc/vsftpd && mkdir -p /var/www/html/ftp && mv /etc/vsftpd.conf /etc/vsftpd.orig
EXPOSE 20-21
EXPOSE 65500-65515

# install Apache
RUN apt-get install php libapache2-mod-php -y
RUN apt-get install apache2 -y
EXPOSE 80

# privesc tools
RUN apt-get update --fix-missing && apt-get install binutils -y

# add users
RUN useradd -rm -d /home/jeff -s /bin/bash -u 1000 jeff
RUN echo "jeff:SuperSecretPasswordForJeff" | chpasswd
RUN echo "root:pokemon" | chpasswd

# start the box
ADD docker-entrypoint.sh /usr/local/bin
RUN chmod +x /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT [ "docker-entrypoint.sh" ]
# TODO: only have the entrypoint?
CMD ["/usr/sbin/sshd","-D"]
