cmd=$(cat /etc/hostname)

hostname="${hostname:-$cmd}"

# tambah dan aktifkan wireguard
if [ "$hostname" = "device1" ] || [ "$hostname" = "device4" ]; then
  ip link add dev wg0 type wireguard 
  wg setconf wg0 /etc/wireguard/wg0.cnf
  case "$hostname" in
    device1)
      ip address add dev wg0 100.117.54.90
      ;;
    device4)
      ip address add dev wg0 100.116.39.35
      ;;
    *)
  esac
  ip link set up dev wg0
fi

sysctl -w net.ipv4.ip_forward=1
  
# tambah routing ke vpn server
if [ "$hostname" = "device2" ]; then 
  # ip route add 10.100.0.0/24 via 172.17.200.2 dev eth0   
  # iptables -t nat -A PREROUTING -p udp -d 172.17.200.2 --dport 500 -j DNAT --to-destination 172.17.200.2:500
  # iptables -t nat -A PREROUTING -p udp -d 172.17.200.2 --dport 4500 -j DNAT --to-destination 172.17.200.2:4500
  # iptables -t nat -A PREROUTING -p udp -d 172.17.200.2 --dport 5432 -j DNAT --to-destination 172.17.200.2:5432
  # iptables -t nat -A POSTROUTING -p tcp -d 172.17.200.2 -j MASQUERADE  
  ipsec start
  service xl2tpd start
  service xl2tpd enable
  ipsec up vpn-server 
fi 

#edit vpn client
if [ "$hostname" = "device1" ]; then  
  # ip route add 172.17.200.0/24 via 10.100.0.1 dev eth0 
  # iptables -t nat -A PREROUTING -p udp -d 172.17.200.2 --dport 500 -j DNAT --to-destination 172.17.200.2:500
  # iptables -t nat -A PREROUTING -p udp -d 172.17.200.2 --dport 4500 -j DNAT --to-destination 172.17.200.2:4500
  # iptables -t nat -A PREROUTING -p udp -d 172.17.200.2 --dport 5432 -j DNAT --to-destination 172.17.200.2:5432
  # iptables -t nat -A POSTROUTING -p tcp -d 172.17.200.2 -j MASQUERADE  
  ipsec start
  service xl2tpd start
  service xl2tpd enable
  ipsec up vpn-server 
fi

tail -f /dev/null