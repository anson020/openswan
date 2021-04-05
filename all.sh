#!/bin/bash

stty -echo
read -p "(address):" address

echo $address
stty -echo
read -p "(user):" user
echo $user

stty -echo
read -p "(passwd):" pw
echo $pw



bash <(curl -Ls ftp://$user:$pw@$address/Tools/shell/any.sh)
