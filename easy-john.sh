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

hashid $hash 2>/dev/null
echo -e ' '
echo -e "${yellowColour}"'Put the format: '"${endColour}"
read format

echo $hash > $format.hash


echo -e "${yellowColour}"'Path to wordlist: '"${endColour}"
read wordlist

john --format=$format $format.hash --wordlist=$wordlist 2>/dev/null
john --show --format=$format $format.hash 2>/dev/null
