#!/bin/bash

# generate the flag
sudo -u monitor touch /home/monitor/flag1.txt
echo "flag{AT_LEAST_ITS_NOT_A_NETCAT_SHELL}" >> /home/monitor/flag1.txt

# secure jimmy's home folder and generate the next hint
chmod 700 /home/jimmy
sudo -u jimmy touch /tmp/note.txt
echo -e "DONT FORGET!! MUCH IMPORTANT\nfinish configuring new router when I get back\n\nwhy doesn't it respond to pings?  arp seems to be working fine\nuser: admin\npass: 2830746031\n\n\nalso...why are all of our routers imaged with kali?  Maybe we should use something less ludricous like alpine" > /tmp/note.txt

# player arpscans attached subnets to find host, then can see adjacent MAC address to realize a different IP is next to attacker box.
# port scan from attacker or netcat loop scan from netadmin reveals non-standard ssh port open.  
# hint to capture SMTP traffic - another message from bob, by the way I figured out how to ssh into docker container
# it generates a new ssh key each time it spins up, so use UserKnownHostsFile=/dev/null and some other option
# actually I just aliased that to ssh so now I use it all the time, much more efficient

#ip route change default via 172.22.0.254
ip route add 172.22.1.0/24 via 172.22.0.254

# Automatically background's itself
busybox telnetd -l /bin/login

# Add in the whitelisted source IP (the previous IP belonging to monitor)
iptables -A INPUT -p tcp -s 172.22.1.9 --dport 23 -j ACCEPT
iptables -A INPUT -p tcp -j REJECT --reject-with tcp-reset

# TODO: Some other ways to deny access, maybe more difficult?  What about telnet allowed hosts file?
# Th DROP action messes with telnet - it keeps trying for a bit then gives up and the script hangs.  Can't find a timeout feature
# iptables -A INPUT -p tcp --dport 23 -j DROP
# iptables -A INPUT -p tcp --dport 23 -j REJECT --reject-with icmp-port-unreachable
# iptables -A INPUT -p tcp --dport 23 -j REJECT --reject-with icmp-host-unreachable
# iptables -A INPUT -p tcp --dport 23 -j REJECT --reject-with icmp-admin-prohibited


# self-deleting script
rm -- "$0"

# make the entrypoint a pass through that then runs the docker command
# https://stackoverflow.com/questions/39082768/what-does-set-e-and-exec-do-for-docker-entrypoint-scripts#:~:text=exec%20%22%24%40%22%20is%20typically%20used,to%20the%20command%20line%20arguments.
exec "$@"
