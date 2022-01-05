A first foray into some MitM concepts.

Flag1: We have managed to compromise a small router in a target network, and have been monitoring SMTP traffic passing through it.  Just today, we captured an email conversation of interest.  Read and act on it.  The router's credentials are attacker:attacker (don't let the fact that it's a kali box break the immersion...).  Message to follow:

    --------------------------------------
    From: bob@lowsec.net
    To: jimmy@lowsec.net
    Subject: Netstat/telnet script broken?

    Hey Jimmy, so the automated netstat monitoring logs seem to be broken for only your 
    workstation.  I was thinking maybe the monitoring server finally received a new DHCP IP?  
    ...cause a know you're the only one paranoid enough to lock down telnet by source IP.  
    I mean come on, who else could possibly be rooting around in our network?  Lol

    Anyway, the monitoring server doesn't have a GUI and I'm not sure I can debug this with 
    tcpdump.  More of a wireshark guy myself.  But I did notice the output of that awesome 
    netstat monitoring script I wrote keeps saying connection refused, so I figure the issue 
    must be the telnet step.  

    But yeah, let me know.  I don't really want to mess with the DHCP configuration on the 
    monitoring server to get the old IP back.  That sounds like real person work.  

    --------------------------------------
    From: jimmy@lowsec.net
    To: bob@lowsec.net
    Subject: [Automated Reply] RE: Netstat/telnet script broken?

    Jimmy is out of office.  Please direct all network admin questions to Bob.  He is very 
    knowledgeable and will be glad to assist.  

    --------------------------------------
    From: bob@lowsec.net
    To: jimmy@lowsec.net
    Subject: RE: Netstat/telnet script broken?

    Oh, great.  Thanks for that by the way, you know I don't know jack about how you set this 
    crazy network up.  Guess it'll have to wait till you get back.  

    --------------------------------------

