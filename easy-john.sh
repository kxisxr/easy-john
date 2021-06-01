#!/bin/bash

greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"

echo -e "${yellowColour}"'Put the hash: '"${endColour}"
read hash

echo -e ' '
hashid $hash | head -n 4 | grep -v 'Analyzing' 2>/dev/null
echo -e ' '

echo -e "${yellowColour}"'Probable formats... '"${endColour}"
var2=$(hashid $hash | head -n 4 | grep -v 'Analyzing' | awk '{print $2}' | tr '-' ' ' | sed 's/\ //g' | xargs | tr ' ' '|')
john --list=formats | xargs | tr ' ' '\n' | grep -i -E $var2 | tr ',' ' ' | sort -r

echo -e ' '
echo -e "${yellowColour}"'Put the format: '"${endColour}"
read format
echo $hash > $format.hash
echo -e ' '

echo -e "${yellowColour}"'Path to wordlist: '"${endColour}"
echo -e ' '
echo -e "${redColour}"'1.- rockyou.txt '"${endColour}"
echo -e "${greenColour}"'2.- xato-net-10000.txt '"${endColour}"
echo -e "${purpleColour}"'3.- top-20-common-SSH-passwords.txt '"${endColour}"
echo -e "${blueColour}"'4.- md5decryptor-uk.txt '"${endColour}"
echo -e "${grayColour}"'5.- 000webhost.txt '"${endColour}"
echo -e ' '

echo -e "${grayColour}"'Select the wordlist...'"${endColour}"

read $wordlist

if [ $wordlist==1 ]
then
john --format=$format $format.hash --wordlist=/home/root/Desktop/rockyou.txt >/dev/null 2>&1

elif [ $wordlist==2 ]
then
john --format=$format $format.hash --wordlist=/usr/share/wordlists/SecLists/Passwords/xato-net-10-million-passwords-10000.txt >/dev/null 2>&1

elif [ $wordlist==3 ]
then
john --format=$format $format.hash --wordlist=/usr/share/wordlists/SecLists/Passwords/Common-Credentials/top-20-common-SSH-passwords.txt >/dev/null 2>&1

elif [ $wordlist==4 ]
then
john --format=$format $format.hash --wordlist=/usr/share/wordlists/SecLists/Passwords/Leaked-Databases/md5decryptor-uk.txt >/dev/null 2>&1

elif [ $wordlist==5 ]
then
john --format=$format $format.hash --wordlist=/usr/share/wordlists/SecLists/Passwords/Leaked-Databases/000webhost.txt >/dev/null 2>&1
fi

echo -e ' '
john --show --format=$format $format.hash 2>/dev/null



