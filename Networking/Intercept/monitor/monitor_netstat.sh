#!/usr/bin/bash

my_ip='172.22.1.14'
remote_ip='172.22.0.8'
remote_user='monitor'
remote_pass='monitors_gonna_monit'

touch $remote_ip.old;
# Capture the netstat column headers to initialize the netstat log file
netstat -tuna | grep "^Proto" | sed "s/^/$(TZ=EST date +'%Y-%m-%d %H:%M:%S EST')    Netstat Host::   /" > netstat.log

while true; do
	# Telnet to $remote_ip and execute these commands.
	(
		sleep 2; echo "$remote_user"; 
		sleep 2; echo "$remote_pass"; 
		sleep 2; echo "netstat -tuna"; # yum tuna
		sleep 2; echo "exit";
		sleep 2;
	) | telnet $remote_ip 2>>errors.log | grep -v "$my_ip" | grep "ESTABLISHED" > $remote_ip.new;

	# Take the output and compare it to previous baseline, write differences into netstat.log
	line_header=$(printf "$(TZ=EST date +"%Y-%m-%d %H:%M:%S EST") %15s:: " $remote_ip)
	diff --suppress-common-lines $remote_ip.old $remote_ip.new | grep -e "^<" -e "^>" | sed "s/^/$line_header/" >> netstat.log;
	mv $remote_ip.new $remote_ip.old
	sleep 30;
done;

