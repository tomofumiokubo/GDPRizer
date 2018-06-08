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

command openssl genrsa -f4 2048 > $HOME/scripts/GDPRizedEmail/ExamplePrivateKey"$stamp".key
command openssl rsa -in $HOME/scripts/GDPRizedEmail/ExamplePrivateKey"$stamp".key -pubout > $HOME/scripts/GDPRizedEmail/ExamplePrivateKey"$stamp".pub

{
	while read line; do

# Encrypt the email address and write out to individual files names after that original contents (so you know which cipher text it is for)

	command echo $line | openssl rsautl -encrypt -pubin -inkey $HOME/scripts/GDPRizedEmail/ExamplePrivateKey"$stamp".pub | tee $HOME/scripts/GDPRizedEmail/tmp/"$line"cipher"$stamp".bin | openssl dgst -sha256 $file | awk '{print $0"@exampleregistrar.example"}'  >> $HOME/scripts/GDPRizedEmail/SampleAnonEmail/AnonEmail"$stamp".txt

# Verify that it could be decrypted with the private key.

	command openssl rsautl -decrypt -inkey $HOME/scripts/GDPRizedEmail/ExamplePrivateKey"$stamp".key -in $HOME/scripts/GDPRizedEmail/tmp/"$line"cipher"$stamp".bin >> $HOME/scripts/GDPRizedEmail/SampleDecryptedEmailList/plain2"$stamp".txt

	command rm -rf $HOME/scripts/GDPRizedEmail/tmp/*

	done < $HOME/scripts/GDPRizedEmail/SampleEmailList/plain.txt

}

{

	if diff $HOME/scripts/GDPRizedEmail/SampleEmailList/plain.txt $HOME/scripts/GDPRizedEmail/SampleDecryptedEmailList/plain2"$stamp".txt >/dev/null ; then

	echo Hurray! It matches!

	else

	echo Something is wrong...

	fi

}

# Add the original email address to map the obfuscated email address

Paste $HOME/scripts/GDPRizedEmail/SampleEmailList/plain.txt $HOME/scripts/GDPRizedEmail/SampleAnonEmail/AnonEmail"$stamp".txt > $HOME/scripts/GDPRizedEmail/SampleResult/OriginalAndAnonEmail"$stamp".txt

open $HOME/scripts/GDPRizedEmail/

