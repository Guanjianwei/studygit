#!/bin/bash
ipt='/sbin/iptables'
$ipt -F
$ipt -P INPUT   DROP
$ipt -P OUTPUT  ACCEPT
$ipt -P FORWARD ACCEPT
$ipt -A INPUT  -p tcp --dport 22 -j ACCEPT
$ipt -A INPUT  -p tcp --dport 80 -j ACCEPT
$ipt -A INPUT -m state --state ESTABLISHED -j ACCEPT
$ipt -A INPUT  -p icmp -j ACCEPT
$ipt -A INPUT  -i lo -j ACCEPT
