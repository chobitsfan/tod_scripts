import socket
import select

def rc4_crypt(data, key):
	"""RC4 algorithm"""
	x = 0
	box = range(256)
	for i in range(256):
		x = (x + box[i] + ord(key[i % len(key)])) % 256
		box[i], box[x] = box[x], box[i]
	x = y = 0
	out = []
	for char in data:
		x = (x + 1) % 256
		y = (y + box[x]) % 256
		box[x], box[y] = box[y], box[x]
		out.append(chr(ord(char) ^ box[(box[x] + box[y]) % 256]))
	return ''.join(out)

def main():
	enc_key = 'itrie400'
	server = ('140.96.178.37', 8090)
	listen_mavproxy = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
	listen_mavproxy.bind(('127.0.0.1', 14550))
	fwd_sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
	fwd_sock.sendto('hello', server)
	poller = select.poll()
	poller.register(listen_mavproxy, select.POLLIN | select.POLLPRI)
	poller.register(fwd_sock, select.POLLIN | select.POLLPRI)
	fd_to_sock = {listen_mavproxy.fileno():listen_mavproxy, fwd_sock.fileno():fwd_sock}
	while True:
		try:
			events = poller.poll()
		except KeyboardInterrupt:
			break
		for fd, flag in events:
			sock = fd_to_sock[fd]
			if sock == listen_mavproxy:
				data, mavproxy = sock.recvfrom(1024)
				enc_txt = rc4_crypt(data, enc_key) 
				fwd_sock.sendto(enc_txt, server)
			else:
				data, server = sock.recvfrom(1024)
				plain_txt = rc4_crypt(data, enc_key)
				listen_mavproxy.sendto(plain_txt, mavproxy)
	listen_mavproxy.close()

main()
