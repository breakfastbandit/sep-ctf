Windows Privelege Escalation Lab

You may need to run docker-compose disable-v2 to if you recieve "not implemented" error. Then run docker-compose build.

SSH into the box using user:harry pass:84sheepdog at 172.16.10.10 over port 2222. Find the flags using Windows Privelege Escalation techniques. All the tools needed already uploaded to box check c:\tools . Flags have been encoded in base64.

Simple tips and tricks. https://sushant747.gitbooks.io/total-oscp-guide/content/privilege_escalation_windows.html

Whats been implemented so far:
Three flags relating to Windows OS privelege escalation. 

Future updates:
Write up,
Fix Unquoted Service Path exploit,
Obfuscated Docker,
Icacls permissions


** Spoilers **
Look in Dockerfile for anwsers.

