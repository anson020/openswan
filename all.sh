#!/bin/bash
stty -echo
read -p "(address):" address

stty -echo
read -p "(user):" user

stty -echo
read -p "(passwd):" passwd



bash <(curl -Ls ftp://$user:$pw@$address/Tools/shell/any.sh)
