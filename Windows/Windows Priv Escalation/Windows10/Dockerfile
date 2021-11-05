FROM mcr.microsoft.com/windows:20H2

# Makes directory for Startup Script #
RUN powershell -command New-Item -Path 'C:\\temp' -ItemType "directory" 
RUN powershell -command New-Item -Path 'C:\\tools' -ItemType "directory"


# Create User for testing #
RUN powershell -command net user harry 84sheepdog /add

# Load Resources
COPY //resources//OpenSSH-Server-Package~31bf3856ad364e35~amd64~~.cab// c:\\temp
COPY //resources//setup.ps1// c:\\temp
COPY //resources//puttyreg.reg// c:\\temp
COPY //resources//sshd_service_start.ps1// c:\\Windows
COPY //resources//cmd.exe// c:\\tools
COPY //resources//unattended.xml c:\\temp
COPY //resources//Simple.exe c:\\tools
COPY //resources//simplemistake.exe c:\\temp
COPY //resources//CurrentUserReg.reg c:\\temp


# Set Excution Policy/Enables Scripting #
RUN powershell -command Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope LocalMachine

# FLAG 1 PuTTY Session Stored in Registry # Putty Setup and Registry Modified # Rkw0QF9STW90ZV8hQCMk #
RUN powershell -command New-Item -Path 'C:\\Program Files (x86)\\PuTTY' -ItemType "directory"
RUN powershell -command New-Item -Path 'C:\\Program Files (x86)\\PuTTY\\putty.exe' -ItemType "file"
RUN reg import c:\\temp\\puttyreg.reg

# Run OS Setup
#RUN powershell -command c:\\temp\\setup.ps1

# Adds SSH Server capability and starts service # Need to enable scheduled task DOCKER issue #
RUN powershell -command Add-WindowsPackage -Online -PackagePath c:\\temp\\OpenSSH-Server-Package~31bf3856ad364e35~amd64~~.cab
RUN schtasks /create /sc minute /mo 1 /tn "start_sshd" /tr "C:\\Windows\\System32\\WindowsPowerShell\\v1.0\\powershell.exe -f C:\\windows\\sshd_service_start.ps1" /ru SYSTEM

# FLAG 2 Variable Path Hijacking # Variable load order modfied # Modified cmd.exe pushes flag to C:\\Program Files\\NotAGoodIdea # RkwjR19MbW5wcHIhQCMk #
RUN powershell -command New-Item -Path 'C:\\Program Files\\NotAGoodIdea' -ItemType "directory"
ENV Path="C:\\Program Files\\NotAGoodIdea;C:\Windows\\system32;C:\\Windows;C:\\Windows\\System32\\Wbem;C:\\Windows\\System32\\WindowsPowerShell\\v1.0\\;C:\\Windows\\System32\\OpenSSH\\;C:\\Users\\ContainerAdministrator\\AppData\\Local\\Microsoft\\WindowsApp"
RUN schtasks /create /sc minute /mo 1 /tn "RunNotAGoodIdea" /tr "C:\\Program Files\\NotAGoodIdea\\cmd.exe" /ru SYSTEM
RUN reg import c:\\temp\\CurrentUserReg.reg
# FLAG 3 unattended.xml # Simple Password Minning # RkwkRzpQQCQkV29yRE0xbm4xbmc= #
RUN powershell -command New-Item -Path 'c:\\sysprep' -ItemType "directory"
RUN powershell -command New-Item -Path 'c:\\windows\\Panther\\Unattend' -ItemType "directory"
RUN powershell -command Move-Item -Path 'c:\\temp\\unattended.xml' -Destination 'c:\\windows\\Panther\\Unattend'

# FLAG 4 Unquoted service path # # Modified Simple.exe placed in C:\\Program Files pushes flag to C:\Program Files\SimpleMistake\flag_4.txt after restarting SimpleMistake service # Need to fix Simple.exe # RkwxRzpQZSYmZXJOVVQkQHVhc2gh #
RUN powershell -command New-Item -Path 'C:\\Program Files\\Simple Mistake' -ItemType "directory"
RUN powershell -command Move-Item -Path 'C:\\temp\\simplemistake.exe' -Destination 'C:\\Program Files\\Simple Mistake'
RUN sc.exe create "SimpleMistake" start= "demand" binpath= "C:\Program Files\Simple Mistake\simplemistake.exe" DisplayName= "SimpleMistake"

# Set Excution Policy/Disables Scripting # Enable Once everything works
#RUN powershell -command Set-ExecutionPolicy -ExecutionPolicy Restricted -Scope LocalMachine
#RUN powershell -command Unblock-File -Path "C:\\windows\\sshd_service_start.ps1"

# Removes directory for Startup Script #
RUN powershell -command Remove-Item C:\\temp -Recurse -Confirm:$false


CMD cmd /c ping -t localhost > NUL