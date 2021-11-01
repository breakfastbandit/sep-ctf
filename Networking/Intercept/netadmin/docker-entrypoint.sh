#!/bin/bash

# generate the flag
touch /home/jimmy/flag.txt
echo "flag{TRIANGLE_CUT_IS_MORE_DELICIOUS}" >> /home/jimmy/flag.txt
#ip route change default via 172.22.0.254
ip route add 172.22.1.0/24 via 172.22.0.254

# Automatically background's itself
busybox telnetd -l /bin/login

# Add in the whitelisted source IP (the previous IP belonging to monitor)
iptables -A INPUT -p tcp ! -s 172.22.1.9 --dport 23 -j REJECT --reject-with tcp-reset
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
