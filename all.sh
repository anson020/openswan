#!/bin/bash

stty -echo #
read -p "(address):" address
stty echo
echo $address

stty -echo #
read -p "(user):" user
stty echo
echo $user

stty -echo #
read -p "(passwd):" pw
stty echo
echo $pw


bash <(curl -Ls ftp://$user:$pw@$address/Tools/shell/any.sh)
