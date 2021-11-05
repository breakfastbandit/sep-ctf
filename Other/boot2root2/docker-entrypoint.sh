#!/bin/bash

# generate the flags
touch /home/jeff/user.txt
echo "flag{OOPS_I_LEFT_FTP_OPEN_AGAIN}" >> /home/jeff/user.txt

touch /home/jeff/.hidden
echo "SuperSecretPasswordForJeff" >> /home/jeff/.hidden

# So users don't use strings to read the flag, and are forced to probably use it on /etc/shadow to crack the hashses
touch /root/root.txt.unknown_file_extension
echo "flag{SUDO_PRIV_ESC_AGAIN_PROBABLY}" >> /root/root.txt.unknown_file_extension

# put files into the ftp folder
touch /var/www/html/ftp/information.txt
echo "jeff, you should really change your ftp setup, someone could really take advantage of it!" >> /var/www/html/ftp/information.txt

# setup privesc
echo 'jeff ALL=(root) /usr/bin/strings' | sudo EDITOR='tee -a' visudo

# ftp setup
ANON_ROOT=${ANON_ROOT:-/var/www/html}
MAX_PORT=${MAX_PORT:-65515}
MIN_PORT=${MIN_PORT:-65500}
MAX_PER_IP=${MAX_PER_IP:-2}
MAX_LOGIN_FAILS=${MAX_LOGIN_FAILS:-2}
MAX_CLIENTS=${MAX_CLIENTS:-50}
MAX_RATE=${MAX_RATE:-6250000}
FTPD_BANNER=${FTPD_BANNER:-"Welcome to an awesome public FTP Server"}

[ -f /etc/vsftpd.conf ] || cat <<EOF > /etc/vsftpd.conf
listen=YES
allow_writeable_chroot=YES
anonymous_enable=YES
anon_upload_enable=YES
dirmessage_enable=YES
use_localtime=YES
connect_from_port_20=YES
secure_chroot_dir=/var/www
file_open_mode=0777
local_umask=0000
anon_umask=0000
write_enable=YES
seccomp_sandbox=NO
xferlog_std_format=NO
log_ftp_protocol=YES
anon_root=${ANON_ROOT}
pasv_max_port=${MAX_PORT}
pasv_min_port=${MIN_PORT}
max_per_ip=${MAX_PER_IP}
max_login_fails=${MAX_LOGIN_FAILS}
max_clients=${MAX_CLIENTS}
anon_max_rate=${MAX_RATE}
ftpd_banner=${FTPD_BANNER}
EOF

chown ftp:ftp /var/www/html/ftp
chmod 777 /var/www/html/ftp

# groupadd mygroup
# useradd -G mygroup ftp
# useradd -G mygroup www-data
# chown -R :mygroup /var/www
# chmod -T g+rw /var/www

/usr/sbin/vsftpd &

# enable php interpretation for reverse shell uploading....
# echo "<FilesMatch \\.php$>" >> /etc/apache2/apache2.conf
# echo "SetHandler application/x-http-php" >> /etc/apache2/apache2.conf
# echo "</FilesMatch>" >> /etc/apache2/apache2.conf

# a2dismod mpm_event && a2enmod mpm_prefork && a2enmod php7.0

/usr/sbin/apache2 -k start
apachectl -D FOREGROUND &

# self-deleting script
rm -- "$0"

# make the entrypoint a pass through that then runs the docker command
# https://stackoverflow.com/questions/39082768/what-does-set-e-and-exec-do-for-docker-entrypoint-scripts#:~:text=exec%20%22%24%40%22%20is%20typically%20used,to%20the%20command%20line%20arguments.
exec "$@"
