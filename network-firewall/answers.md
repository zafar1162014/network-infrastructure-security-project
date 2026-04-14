# Network and Firewall

## Q4.1 Router Interface and Docker Serial

### Commands

```bash
docker ps
docker exec router ip addr show
docker network inspect network-infrastructure-security-project_default
docker network inspect network-infrastructure-security-project_default --format '{{.Id}}'
```

### Expected Output

Container name: router  
Container ID (Docker serial): e4a12f097778  
Interface names: lo and eth0@if19  
Router IP on eth0: 172.18.0.2/16  
Network name: network-infrastructure-security-project_default  
Network serial/ID: 16e4c1aff72bb577e5a96f887f79502e6c70fb4f8f737d92d6cef474fe72b7a5

- Screenshot references:
  - screenshots/01_router_docker_ps.png
  - screenshots/02_router_ip_addr_show.png
  - screenshots/03_network_inspect_id.png

### Procedure

1. Run docker ps and note the router container name or ID.
2. Run docker exec router ip addr show to see the interface names inside the container.
3. Run docker network inspect network-infrastructure-security-project_default to check the network details.
4. Use docker network inspect network-infrastructure-security-project_default --format '{{.Id}}' to print the Docker network ID.

## Q4.2 Capture Telnet Packets

### Wireshark Filter

Capture filter: `tcp port 23`  
Display filter: `tcp.port == 23 && ip.addr == 172.18.0.3 && ip.addr == 172.18.0.4`

### Handshake Packets

Packet 1: SYN from 172.18.0.3 to 172.18.0.4, seq = 3855188913  
Packet 2: SYN, ACK from 172.18.0.4 to 172.18.0.3, seq = 2934371977, ack = 3855188914  
Packet 3: ACK from 172.18.0.3 to 172.18.0.4, seq = 3855188914, ack = 2934371978

- Screenshot references:
  - screenshots/04_telnet_handshake_packets.png
  - screenshots/05_telnet_packet_details.png

## Q4.3 TCP Three-Way Handshake Analysis

### Explanation

- SYN:
  - Host 1 (172.18.0.3) starts the connection by sending SYN with sequence number 3855188913.
- SYN-ACK:
  - Host 2 (172.18.0.4) replies with SYN-ACK using sequence number 2934371977 and acknowledgment 3855188914.
- ACK:
  - Host 1 sends the final ACK with sequence number 3855188914 and acknowledgment 2934371978. That completes the TCP handshake.
- Diagram reference:

```text
Host 1 (172.18.0.3)                                Host 2 (172.18.0.4)
      |                                                    |
  |--------------- SYN, seq = 3855188913 ------------->|
      |                                                    |
  |<--- SYN-ACK, seq = 2934371977, ack = 3855188914 ---|
      |                                                    |
  |----- ACK, seq = 3855188914, ack = 2934371978 ----->|
      |                                                    |
```

The first packet is the SYN from Host 1. The second is the SYN-ACK response from Host 2. The third packet is the final ACK from Host 1, which completes the TCP three-way handshake and opens the telnet session.

## Q4.4 Stateless Rule (router cannot ping IP_1)

### Rule

```bash
iptables -A OUTPUT -p icmp --icmp-type echo-request -d 9.9.8.0 -j DROP
```

- Test evidence:
  ping 9.9.8.0 from the router fails with 100 percent packet loss.
- Brief explanation:
  - This is a stateless firewall rule because it checks each outbound ICMP echo-request packet on its own and drops it immediately. Since the packet never leaves the router, the ping test should time out and show packet loss.

### Verification

1. Run ping 9.9.8.0 on the router.
2. The command should fail or time out.
3. If the rule is active, no echo-reply should be received.

## Q4.5 Stateless Rule (block replies from 8.8.8.8)

### Rule

```bash
iptables -A INPUT -p icmp --icmp-type echo-reply -s 8.8.8.8 -j DROP
```

- Test evidence:
  ping 8.8.8.8 from the router sends echo-requests, but the echo-reply packets are dropped.
- Brief explanation:
  - -A INPUT appends the rule to the inbound chain, -p icmp matches ICMP traffic, --icmp-type echo-reply matches only reply packets, and -s 8.8.8.8 restricts the source address. The DROP target just discards the replies, so the ping test never completes successfully.

### Verification

1. Run ping 8.8.8.8 on the router.
2. The requests leave the router, but the replies are blocked on input.
3. The ping output should show timeouts or 100 percent packet loss.

## Q4.6 Stateful Rules

### Rules

```bash
iptables -P FORWARD DROP
iptables -A FORWARD -s 192.168.60.0/24 -p tcp --dport 23 -m conntrack --ctstate NEW -j DROP
iptables -A FORWARD -d 192.168.60.5 -p tcp --dport 23 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
iptables -A FORWARD -s 192.168.60.5 -p tcp --sport 23 -m conntrack --ctstate ESTABLISHED -j ACCEPT
iptables -A FORWARD -d 192.168.60.0/24 -p tcp --dport 23 -m conntrack --ctstate NEW -j DROP
```

- Evidence for each requirement:
  Requirement 1: Internal hosts cannot start telnet sessions to outside hosts because NEW outbound telnet packets from 192.168.60.0/24 are dropped.  
  Requirement 2: Outside hosts can reach telnet on 192.168.60.5 because NEW and ESTABLISHED packets for that destination are accepted, but other internal hosts are not allowed.  
  Requirement 3: All other forwarded packets are blocked by the default DROP policy.
- Brief explanation:
  - The first rule sets the default forwarding posture to deny by default. The stateful rules then allow only the specific telnet connection to 192.168.60.5 and its return traffic, while blocking any new telnet sessions from internal hosts to outside destinations and any telnet traffic to other internal hosts.

### Rule-by-Rule Explanation

1. iptables -P FORWARD DROP
   - Sets the default forwarding policy to block everything unless a rule allows it.
2. iptables -A FORWARD -s 192.168.60.0/24 -p tcp --dport 23 -m conntrack --ctstate NEW -j DROP
   - Blocks internal hosts from initiating new telnet sessions to outside systems.
3. iptables -A FORWARD -d 192.168.60.5 -p tcp --dport 23 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
   - Allows outside hosts to start telnet to the approved server 192.168.60.5 and keep the connection going.
4. iptables -A FORWARD -s 192.168.60.5 -p tcp --sport 23 -m conntrack --ctstate ESTABLISHED -j ACCEPT
   - Allows return traffic from the telnet server back to the outside client.
5. iptables -A FORWARD -d 192.168.60.0/24 -p tcp --dport 23 -m conntrack --ctstate NEW -j DROP
   - Prevents telnet attempts to any other internal host in the subnet.
