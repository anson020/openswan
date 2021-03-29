#!/bin/bash

read -p "(name):" NAME
echo $NAME

read -p "(eth0ip):" LIFTIP
 echo $LIFTIP

read -p "(PSK):" PSK
echo $PSK

read -p "(RIGHTIP):" RIGHTIP
 echo $RIGHTIP

read -p "(RIGHTID):" RIGHTID
 echo $RIGHTID

read -p "(RIGHTSUBNET):" RIGHTSUBNET
 echo $RIGHTSUBNET

cat >> /etc/ipsec.conf<<EOF

conn vpn-to-$NAME
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
    
  left=$LIFTIP
  #leftid=@openswan
  leftsubnet=0.0.0.0/0 
  leftnexthop=%defaultroute
  
  right=$RIGHTIP
  rightid=$RIGHTID
  rightsubnet=$RIGHTSUBNET
EOF
