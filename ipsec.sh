#!/bin/bash

read -p "(name):" name
echo $name

read -p "(eth0ip):" leftip
 echo $leftip

read -p "(rightip):" rightip
 echo $rightip

read -p "(rightid):" rightid
 echo $rightid

read -p "(rightsubnet):" rightsubnet
 echo $rightsubnet


cat >> /etc/ipsec.conf<<EOF

conn vpn-to-$name
    ##phase 1##
    authby=secret
    auto=start
    ikev2=insist
    ike=aes256-sha256;modp2048  
    keyexchange=ike           
    ikelifetime=86400
    
    ##phase 2##
    phase2=esp
    phase2alg=aes256-sha256
    compress=no
    pfs=no
    type=tunnel
    keylife=43200
    
  left=$leftip
  #leftid=@openswan
  leftsubnet=0.0.0.0/0 
  leftnexthop=%defaultroute
  
  right=$rightip
  rightid=$rightid
  rightsubnet=$rightsubnet
  
EOF
