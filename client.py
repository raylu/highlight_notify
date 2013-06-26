#!/usr/bin/env python

# vim: set noet sw=4 ts=4:

import socket
import sys

from sh import notify_send

ip = socket.gethostbyname_ex('raylu.net')[2][0]
addr = (ip, 61221)
s = socket.create_connection(addr)
while True:
	data = s.recv(1024)
	print('sending', data)
	notify_send(data, t=5000)
