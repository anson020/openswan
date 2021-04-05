#!/bin/bash
stty -echo #
read -p "(?):" ?
stty echo
echo
bash <(curl -Ls https://raw.githubusercontent.com/anson020/openswan/main/$?.sh)
