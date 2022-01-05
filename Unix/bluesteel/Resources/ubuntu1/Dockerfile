FROM ubuntu:16.04
RUN apt-get update
RUN apt-get install -y iproute2
RUN apt-get install -y less
RUN apt-get install -y openssh-server
RUN apt-get install -y apache2
RUN apt-get install -y nmap
RUN apt-get install -y netcat
RUN apt-get install -y steghide

#Configure SSH and apache
RUN mkdir /var/run/sshd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
EXPOSE 22

RUN mkdir /var/www/bluesteel/
COPY index.html /var/www/bluesteel/index.html
COPY computer.gif /var/www/bluesteel/computer.gif
COPY mugatu.jpg /var/www/bluesteel/mugatu.jpg
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf
RUN sed -i 's/html/bluesteel/' /etc/apache2/sites-available/000-default.conf
EXPOSE 80

# Add/configure users then implement challenge flags
RUN useradd -m jacobim
RUN echo 'jacobim:pianokeynecktie' | chpasswd
COPY flag1.txt /home/jacobim/flag1.txt
RUN chmod +r /home/jacobim/flag1.txt
COPY Vesuvius /tmp/Vesuvius
RUN chmod go-rwx /usr/bin/passwd

RUN useradd -m hansel
RUN echo 'hansel:dontyouknowimloco' | chpasswd
COPY flag2.txt /home/hansel/flag2.txt
RUN chmod 700 /home/hansel

RUN useradd -m derek
RUN echo 'derek:orangemochafrappuccino' | chpasswd
COPY flag4.txt /home/derek/but/why/male/models/flag4.txt
RUN chmod 700 /home/derek

RUN echo 'root:whymalemodels' | chpasswd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile


WORKDIR /setup
COPY apache2.sh .
COPY sshd.sh .
COPY wrapper.sh .
RUN chmod +x *

CMD ["./wrapper.sh", "-D"]


