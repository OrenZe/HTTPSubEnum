#!/bin/bash

echo
echo '**************************************'
echo '*            By abc                  *'
echo '**************************************'
echo ''
echo 'Which Network and Subnet are you want to scan? {Exa.: 172.16.101.0/24}'
read netS
#Check if the input is IP
defaulIP='192.16.101.0/24'
if [[ $netS =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\/.[0-9]{1,2}+ ]]; then
	net=$netS
# My checks - Class Subnet
elif [[ $netS == 2 ]]; then
	net='192.168.232.0/24'
	echo 'Deafult 2 is choosen'
else
	net='172.16.101.0/24'
	echo 'Input not good, Start scanning Default' $defaultIP
fi
# Scaning the network: looking for HTTP servies, so check for tiltle and servers
echo '*******************************'
echo 'Start checking for HTTP Server in' $net
# Run nmap on custom ports and output HTTP titles and OS
nmap -p20-23,2121,2222,2555,80,88,280,443,445,513,514,591,2480,5000,5104,5800,5900,6000,8008,8222,8280,8081,8000,8080,8887,8888,9080 -sS $net -Pn --script http-tit*,http-serv* > HTTPTitles
echo -e '******* Scan complete *********'
echo -e 'Full result in file: HTTPTitles'
echo -e 'Print http open port and titles'
# cat the output file and show the relevant http Titles
cat HTTPTitles | grep open.*http -B9 -A7
echo '*******************************'
# Open firefox to this page ..
echo '*******************************'
echo '** Open Firefox to particular IP and Port **'
echo '*******************************'
# Continue investigation on suspicious IP
echo 'Which ip to open?'
read ip
echo 'Which port?'
read port
echo 'Open firefox to' $ip 'port' $port
firefox --new-tab $ip':'$port &
#Start deep scan on this IP
echo '*******************************'
echo 'Start deep enumerate this page'
echo '*******************************'
nmap -p$port --script http-comm*,http-tit*,http-meth*,http-vu*,http-enum*,http-site*,http-serv* -sC $ip > HTTPEnum
echo ''
echo '*******************************'
echo 'Done, result can find in file: HTTPEnum'
echo -e '*********** Head HTTPEnum ******'
cat HTTPEnum | head -15
echo -e '*********** Tail -5 HTTPEnum ******'
cat HTTPEnum | tail -5
echo '*******************************'
echo '*******************************'
echo $ip':'$port 'checked'
echo '' > $ip':'$port
echo '*******************************'
# Run nikto
echo -e 'start nikto to check for Vulns in' $ip
nikto -h http://$ip:$port
echo 'Done nikto'
echo '*******************************'
echo -e 'start gobuster for enumerate' $ip
# Run gobuster
gobuster -u $ip:$port -w /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt -x php,txt
echo 'Done gobuster!'
echo $ip':'$port 'is scaned'
