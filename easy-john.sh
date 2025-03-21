#!/bin/bash
# Author: kxisxr
# Colores
GREEN="\e[0;32m\033[1m"
END="\033[0m\e[0m"
RED="\e[0;31m\033[1m"
BLUE="\e[0;34m\033[1m"
YELLOW="\e[0;33m\033[1m"
PURPLE="\e[0;35m\033[1m"
TURQUOISE="\e[0;36m\033[1m"
GRAY="\e[0;37m\033[1m"

# Solicitar el hash
echo -e "${YELLOW}Introduce el hash: ${END}"
read -r hash

echo -e '\nAnalizando el hash...\n'
formats=$(hashid "$hash" | grep -v 'Analyzing' | awk '{print $2}' | tr '-' ' ' | sed 's/ //g' | xargs | tr ' ' '|')

if [[ -z "$formats" ]]; then
    echo -e "${RED}No se encontraron formatos probables.${END}"
    exit 1
fi

# Mostrar formatos probables
echo -e "${YELLOW}Formatos probables:${END}\n"
john_formats=$(john --list=formats | tr ' ' '\n' | grep -iE "$formats" | sort -r)

if [[ -z "$john_formats" ]]; then
    echo -e "${RED}No se encontraron formatos compatibles con John the Ripper.${END}"
    exit 1
fi

echo "$john_formats"
echo -e '\n'

# Solicitar el formato
echo -e "${YELLOW}Introduce el formato a usar:${END}"
read -r format
echo "$hash" > "$format.hash"

echo -e '\n${YELLOW}Selecciona la lista de palabras:${END}\n'
options=("rockyou.txt" \
         "xato-net-10000.txt" \
         "top-20-common-SSH-passwords.txt" \
         "md5decryptor-uk.txt" \
         "000webhost.txt")

for i in "${!options[@]}"; do
    echo -e "${GREEN}$((i+1)).- ${options[$i]}${END}"
done

echo -e "\n${GRAY}Selecciona una opción (1-5):${END}"
read -r choice

# Validar la elección
if ! [[ "$choice" =~ ^[1-5]$ ]]; then
    echo -e "${RED}Selección no válida.${END}"
    exit 1
fi

# Definir rutas de diccionarios
declare -A wordlists
wordlists=(
    [1]="/home/root/Desktop/rockyou.txt"
    [2]="/usr/share/wordlists/SecLists/Passwords/xato-net-10-million-passwords-10000.txt"
    [3]="/usr/share/wordlists/SecLists/Passwords/Common-Credentials/top-20-common-SSH-passwords.txt"
    [4]="/usr/share/wordlists/SecLists/Passwords/Leaked-Databases/md5decryptor-uk.txt"
    [5]="/usr/share/wordlists/SecLists/Passwords/Leaked-Databases/000webhost.txt"
)

wordlist=${wordlists[$choice]}

# Ejecutar John
echo -e "\n${YELLOW}Iniciando ataque con ${wordlist}...${END}"
john --format="$format" "$format.hash" --wordlist="$wordlist" >/dev/null 2>&1

# Mostrar resultados
echo -e "\n${YELLOW}Resultados:${END}"
john --show --format="$format" "$format.hash" 2>/dev/null
