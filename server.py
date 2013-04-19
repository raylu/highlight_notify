#!/usr/bin/env python3

import errno
import os
import socket
import threading

path = '/home/raylu/irssi'
connections = set()
def read_and_send():
	while True:
		with open(path, 'r') as f:
			data = f.read()
		to_remove = []
		for c in connections:
			try:
				c.sendall(bytes(data, 'utf-8'))
			except socket.error:
				to_remove.append(c)
		for c in to_remove:
			connections.remove(c)
			c.close()

def main():
	try:
		os.mkfifo(path)
	except OSError as e:
		if e.errno != errno.EEXIST:
			raise

	t = threading.Thread(target=read_and_send)
	t.daemon = True
	t.start()

	listen_addr = ('', 61221)
	s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
	s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
	s.bind(listen_addr)
	s.listen(1)
	while True:
		conn, addr = s.accept()
		print('got connection from', addr)
		conn.settimeout(3)
		connections.add(conn)

if __name__ == '__main__':
	main()
