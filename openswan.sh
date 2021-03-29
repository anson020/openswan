
#!/bin/bash
yum install openswan lsof -y 

sed -i 's/net.ipv4.ip_forward = 0/net.ipv4.ip_forward = 1/g' /etc/sysctl.conf
sed -i 's/net.ipv4.conf.default.rp_filter = 1/net.ipv4.conf.default.rp_filter = 0/g' /etc/sysctl.conf

cat >> /etc/sysctl.conf<<EOF
net.ipv4.ip_forward = 1
net.ipv4.conf.default.rp_filter = 0
net.ipv4.conf.eth0.rp_filter = 0 
net.ipv4.conf.all.rp_filter = 0
net.ipv4.conf.ip_vti0.rp_filter = 0
EOF


sysctl -p
sysctl -a | egrep "ipv4.*(accept|send)_redirects" | awk -F "=" '{print $1"= 0"}' >> /etc/sysctl.conf
service ipsec restart
chkconfig ipsec on

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

read -p "(psk):" psk
echo $psk

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

cat >> /etc/ipsec.secrets<<EOF
0.0.0.0 0.0.0.0: PSK "$psk" 
EOF


chmod +x /etc/rc.d/rc.local

cat >> /etc/rc.d/rc.local<<EOF
iptables --table nat --append POSTROUTING --out-interface eth0 --jump MASQUERADE
EOF

iptables --table nat --append POSTROUTING --out-interface eth0 --jump MASQUERADE
service ipsec restart

ipsec verify
