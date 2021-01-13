# Example of multi-client echo server
# www.solusipse.net

import socket
import thread

def open_new_client(connection, addr)
    print("Connected to client %s, port %s", addr)

    # Loop until connection closed
    while True:
        # Read data
        data = connection.recv(1024)

        # Check if read unsuccessful 
        if not data: break

        # Send data back to sender (echo)
        connection.send(data)

    # Close the connection if break from loop
    connection.shutdown(1)
    connection.close()

def listen():
    # Setup the socket
    connection = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    connection.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)

    # Bind to an address and port to listen on
    HOST = '192.168.0.10'
    PORT = 50000
    connection.bind((HOST, PORT))
    connection.listen(10)
    print("Server opened on %s, port %s", HOST, PORT)

    # Loop forever, accepting all connections in new thread
    while True:
        new_conn, new_addr = connection.accept()
        thread.start_new_thread(open_new_client,(new_conn, new_addr))

if __name__ == "__main__":
    try:
        listen()
    except KeyboardInterrupt:
        pass