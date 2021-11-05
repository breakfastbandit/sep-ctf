#!/usr/bin/bash
# Based on some code that was based on pipework by jpetazzo

# Note: ip link complains when creating interface names greater than 15 characters.  TODO: add a test for this
# Note container_ipaddr can be tac (-) for none.  container_ifname can be tac (-) to autogenerate
container_name=$1; container_ipaddr=$2; container_ifname=$3; local_bridge=$4
pid=$(docker inspect --format '{{ .State.Pid }}' "$container_name")

# Allow autogenerating container interface name by using tac - 
if test "$container_ifname" == "-" ; then
    container_ifprefix=eth # TODO: could allow them to specify like "eth*" at terminal
    for container_ifname in ${container_ifprefix}{0..999}; do 
        nsenter -t "$pid" -n ip link show "$container_ifname" >/dev/null 2>&1 || break; 
        done; 
fi

local_ifname="v${container_ifname}l${pid}"
guest_ifname="v${container_ifname}g${pid}"
echo "([$pid] $container_name ==+ $container_ipaddr / $container_ifname / $guest_ifname) <===> ($local_ifname <===> $local_bridge +== host)"

# Ensure local_ifname and local_bridge parameters are up and running
if ip link show "$local_ifname" >/dev/null 2>&1 ; then
    echo "$local_ifname already exists, recreating..."
    ip link del "$local_ifname"
fi
if ! ip link show "$local_bridge" >/dev/null 2>&1 ; then
    echo "$local_bridge doesn't exist, creating..."
    ip link add "$local_bridge" type bridge
fi
mtu=$(ip link show $local_bridge | awk '{print $5}')
ip link add name "$local_ifname" mtu "$mtu" type veth peer name "$guest_ifname" mtu "$mtu"
ip link set "$local_ifname" master "$local_bridge"
ip link set "$local_ifname" up
ip link set "$local_bridge" up
ip link set "$guest_ifname" netns "$pid"

# Add an IP address inside the container unless they specified no IP with -
if ! test "$container_ipaddr" == "-" ; then
    nsenter -t "$pid" -n ip addr add "$container_ipaddr" dev "$guest_ifname"
fi
nsenter -t "$pid" -n ip link set "$guest_ifname" name "$container_ifname"
nsenter -t "$pid" -n ip link set "$container_ifname" up



# another idea to autocalculate the next name and prefix
# ip -o link show | awk -F'[ @:]' '{print $3}'

# ip netns seems to expect a NAME rather than PID, which is complicated to get for docker containers.  They seem to be kind of anonymously tracked by nsid (index in current namespace) rather than name
# ip netns exec "$pid" ip link set "$guest_ifname" name "$container_ifname"
# ip netns exec "$pid" ip link set "$container_ifname" up
# nsenter does the trick.  see also lsns