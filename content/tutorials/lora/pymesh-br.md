---
title: "Pymesh Border Router"
aliases:
    - tutorials/lora/pymesh-br.html
    - tutorials/lora/pymesh-br.md
---


{{% hint style="info" %}}	
These API's are currently only available in the latest RC builds.
{{% /hint %}}

The following script exemplifies the declaration of a Border Router inside Pymesh.

The Border Router is a role of a Pymesh node that can forward the Pymesh internal data to the Cloud.  This is accomplished with the following steps:

- declare the BR network address prefix, like `2001:dead:beef:cafe::/64`.
 - in this particular script, as example the node which has LoRa MAC as value `8` will set BR interface.
 - in a more practical usecase, the BR should be enabled if Wifi/BLE/Cellular connections are setup.

- all the nodes within the Pymesh will create a random IPv6 unicast address with this prefix.

- if a node sends data to an IPv6 which is external (like `1:2:3::4`), this UDP datagram will be routed to the BR.

- BR will receive the UDP datagrams for external with an appended header, which contains:
 - MAGIC byte: `0xBB`
 - IPv6 destination as bytearray (16 bytes)
 - port destination as 2 bytes (1-65535 values).
- the IPv6 destination is important so BR could actually route (forward) the UDP datagram content to the right interface (Wifi/BLE/cellular).

After this script is executed, some example of testing:

- send data to the cloud

  `eid_socket.sendto("01234567890123456789", ("1::2", 1235))`

- send data to the EID ipv6 of another Node inside Pymesh

 `eid_socket.sendto("0123456789", ("fdde:ad00:beef:0:4623:91c8:64b2:d9ec", 1235))`
 
- send data to the Leader

 `eid_socket.sendto("0123456789", ("fdde:ad00:beef:0:0:ff:fe00:fc00", 1235))`

- send data to the RLOC of another Node inside Pymesh

 `eid_socket.sendto("0123456789", ("fdde:ad00:beef:0:0:ff:fe00:6800", 1235))`



## Border Router example

- Source: [https://github.com/pycom/pycom-libraries/blob/master/lib/lora_mesh/main_border_router.py](https://github.com/pycom/pycom-libraries/blob/master/lib/lora_mesh/main_border_router.py)
- `Loramesh` micropython library is available at [https://github.com/pycom/pycom-libraries/blob/master/lib/lora\_mesh/loramesh.py](https://github.com/pycom/pycom-libraries/blob/master/lib/lora_mesh/loramesh.py).

```python

from network import LoRa
import ubinascii
from loramesh import Loramesh
import pycom
import time
import socket
import struct

BORDER_ROUTER_HEADER_FORMAT = '!BHHHHHHHHH'
BORDER_ROUTER_MAGIC_BYTE = 0xBB

pycom.wifi_on_boot(False)
pycom.heartbeat(False)
border_router_net = "2001:dead:beef:cafe::/64"

lora = LoRa(mode=LoRa.LORA, region=LoRa.EU868, bandwidth=LoRa.BW_125KHZ, sf=7)
#mesh = lora.Mesh()
MAC = str(ubinascii.hexlify(lora.mac()))[2:-1]
print("LoRa MAC: %s"%MAC)

mesh = Loramesh(lora)

# waiting until it connected to Mesh network
while True:
    mesh.led_state()
    print("%d: State %s, single %s"%(time.time(), mesh.cli('state'), mesh.cli('singleton')))
    time.sleep(2)
    if not mesh.is_connected():
        continue

    print('Neighbors found: %s'%mesh.neighbors())
    print('IPs: %s'%mesh.mesh.ipaddr())
    break

sockets = []
#add BR for a certain MAC address
# or in a certain condition (Wifi/BLE/cellular connection to Internet)
if int(MAC, 16) == 8:
    if len(mesh.mesh.border_router()) == 0:
        mesh.mesh.border_router(border_router_net, 0)
        print("Set Border Router with prefix %s"%border_router_net)

    # create UDP socket for Border Router interface
    br_socket = socket.socket(socket.AF_LORA, socket.SOCK_RAW)
    myport = 1234
    print("Please wait until BR gets propagated to the Leader ...")
    while True:
        ip = mesh.ip(border_router_net)
        if ip is not None:
            br_socket.bind((ip, myport))
            print("Created socked for (%s, %d)"%(ip, myport))
            break
        time.sleep(1)
    sockets.append(br_socket)

eid_socket = socket.socket(socket.AF_LORA, socket.SOCK_RAW)
myport = 1235
#ip = mesh.ip()# ipv6 EID
ip = "::" # in this case, socket can be bind just on a port, like: eid_socket.bind(myport)
if ip is not None:
    eid_socket.bind((ip, myport))
    #eid_socket.bind(myport)
    print("Created socked for (%s, %d)"%(ip, myport))
sockets.append(eid_socket)

# handler responsible for receiving packets on UDP Pymesh socket
def receive_pack(sockets):
    # listen for incoming packets on all sockets
    while True:
        is_new_data = False
        for sock in sockets:
            # check if data received on all sockets
            rcv_data, rcv_addr = sock.recvfrom(128)
            if len(rcv_data) > 0:
                is_new_data = True
                break # out of for sock
        if not is_new_data:
            break # out of while True
        rcv_ip = rcv_addr[0]
        rcv_port = rcv_addr[1]
        print('Incoming %d bytes from %s (port %d)'%(len(rcv_data), rcv_ip, rcv_port))

        #check if data is for the external of the Pymesh (for The Cloud)
        if rcv_data[0] == BORDER_ROUTER_MAGIC_BYTE and len(rcv_data) >= struct.calcsize(BORDER_ROUTER_HEADER_FORMAT):
            br_header = struct.unpack(BORDER_ROUTER_HEADER_FORMAT, rcv_data)
            print("IP dest: %x:%x:%x:%x:%x:%x:%x:%x (port %d)"%(
                br_header[1],br_header[2],br_header[3],br_header[4],
                br_header[5],br_header[6],br_header[7],br_header[8], br_header[9]))
            rcv_data = rcv_data[struct.calcsize(BORDER_ROUTER_HEADER_FORMAT):]

        print(rcv_data)

        # send some ACK
        if  not rcv_data.startswith("ACK"):
            print("Sent ACK back")
            sock.sendto('ACK', (rcv_ip, rcv_port))

mesh.mesh.rx_cb(receive_pack, sockets)

print('IPs: %s'%mesh.mesh.ipaddr())
print('BRs: %s'%mesh.mesh.border_router())

"""
Example of usage:
* send data to the cloud
eid_socket.sendto("01234567890123456789", ("1::2", 1235))
* send data to the EID ip of another Node inside Pymesh
eid_socket.sendto("0123456789", ("fdde:ad00:beef:0:4623:91c8:64b2:d9ec", 1235))
* send data to the Leader
eid_socket.sendto("0123456789", ("fdde:ad00:beef:0:0:ff:fe00:fc00", 1235))
* send data to the RLOC of another Node inside Pymesh
eid_socket.sendto("0123456789", ("fdde:ad00:beef:0:0:ff:fe00:6800", 1235))
"""

```
