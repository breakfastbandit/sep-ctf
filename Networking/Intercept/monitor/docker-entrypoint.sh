#!/bin/bash

# generate the flag
touch /home/monitor/flag.txt
echo "flag{NOT_YET_IMPLEMENTED}" >> /home/monitor/flag.txt
ip route add 172.22.0.0/24 via 172.22.1.254

# self-deleting script
rm -- "$0"

# make the entrypoint a pass through that then runs the docker command
# https://stackoverflow.com/questions/39082768/what-does-set-e-and-exec-do-for-docker-entrypoint-scripts#:~:text=exec%20%22%24%40%22%20is%20typically%20used,to%20the%20command%20line%20arguments.
exec "$@"
