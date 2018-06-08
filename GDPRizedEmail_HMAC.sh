#!/usr/bin/bash

mkdir $HOME/scripts/GDPRizedEmail/
mkdir $HOME/scripts/GDPRizedEmail/tmp/
mkdir $HOME/scripts/GDPRizedEmail/SampleAnonEmail/
mkdir $HOME/scripts/GDPRizedEmail/SampleEmailList/
mkdir $HOME/scripts/GDPRizedEmail/SampleResult/
mkdir $HOME/scripts/GDPRizedEmail/SampleDecryptedEmailList/

LC_ALL=C
LANG=C

# set time as variable

stamp=$(date +%m%d%Y%H%M%S)

# Remove as needed as this is an example.

cat > $HOME/scripts/GDPRizedEmail/SampleEmailList/plain.txt << EOF
dog.cat@example.com
dogcat@example.com
dcat@example.com
d-cat@example.com
dooogcat@example.com
EOF

# Generate 2 random strings and add the current time MMDDYYhhmmss (best effort... adjust as needed or substitute it with an TRNG)

stamp=$(date +%m%d%Y%H%M%S)
rand1=$(openssl rand -base64 32)
echo First psuedo-random string is $rand1
rand2=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 64)
echo Second psuedo-random string is $rand2
result=$rand1$rand2$stamp
echo Concatenated psuedo-random string is $result

# Generate a key based on the random strings

key=$(echo $result | openssl dgst -sha512)
echo $key > $HOME/scripts/GDPRizedEmail/key"$stamp".txt

# Obfuscate email address then add the email suffix

{
	while read line; do

echo $line | openssl dgst -sha256 -hmac $key | awk '{print $0"@exampleregistrar.example"}' >> $HOME/scripts/GDPRizedEmail/SampleAnonEmail/AnonEmail"$stamp".txt


	done < $HOME/scripts/GDPRizedEmail/SampleEmailList/plain.txt

}

# Add the original email address to map the obfuscated email address

Paste $HOME/scripts/GDPRizedEmail/SampleEmailList/plain.txt $HOME/scripts/GDPRizedEmail/SampleAnonEmail/AnonEmail"$stamp".txt > $HOME/scripts/GDPRizedEmail/SampleResult/OriginalAndAnonEmail"$stamp".txt

open $HOME/scripts/GDPRizedEmail/
