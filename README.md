# Syscall HTTP Server

A simple HTTP server written entirely in **x86-64 Linux Assembly** using syscalls.

## Features
- Handles **GET** and **POST** requests.
- Forks each connection for **concurrent handling**.
- Uses only syscalls: `socket`, `bind`, `listen`, `accept`, `read`, `write`, `open`, `close`, `fork`, `exit`.

## Build & Run
```bash
as -o advanced_webserver.o advanced_webserver.s && ld -o advanced_webserver advanced_webserver.o 
sudo ./advanced_webserver
