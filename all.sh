#!/bin/bash
stty -echo
read -p "(address):" address
read -p "(user):" user
read -p "(passwd):" passwd



bash <(curl -Ls ftp://$user:$pw@$address/Tools/shell/any.sh)
