create_nat:
	ip netns add myspace
	ip link add veth1 type veth peer name veth2
	ip link set veth2 netns myspace
	ifconfig veth1 192.168.45.2 netmask 255.255.255.0 up
	ip netns exec myspace ifconfig veth2 192.168.45.3 netmask 255.255.255.0 up
	ip netns exec myspace route add default gw 192.168.45.2
	echo 1 > /proc/sys/net/ipv4/ip_forward
	iptables -t nat -A POSTROUTING -s 192.168.45.0/24 -o eth0 -j MASQUERADE
	iptables -t filter -A FORWARD -i eth0 -o veth1 -j ACCEPT
	iptables -t filter -A FORWARD -o eth0 -i veth1 -j ACCEPT

test_nat:
	ip netns exec myspace wget www.baidu.com -O /dev/null

clean_nat:
	iptables -t filter -D FORWARD -i eth0 -o veth1 -j ACCEPT
	iptables -t filter -D FORWARD -o eth0 -i veth1 -j ACCEPT
	iptables -t nat -D POSTROUTING -s 192.168.45.0/24 -o eth0 -j MASQUERADE
	echo 0 > /proc/sys/net/ipv4/ip_forward
	ip netns exec myspace route delete default gw 192.168.45.2
	ip netns exec myspace ifconfig veth2 down
	ifconfig veth1 down
	ip link delete veth1
	ip netns delete myspace
