# Syscall HTTP Server

A simple HTTP server written in x86-64 Linux Assembly using system calls. It handles GET requests, serves files from the current directory, and supports concurrent connections via forking.

## Features
- Handles GET requests, serving files based on the URL path.
- Returns HTTP 200 OK for valid files and 404 Not Found for missing files.
- Uses system calls: `socket`, `bind`, `listen`, `accept`, `read`, `write`, `open`, `close`, `fork`, `exit`.
- Listens on port 8080 (no root privileges required).
- Serves `index.html` by default for requests to `/`.

## Requirements
- Linux system
- `nasm` (Netwide Assembler)
- `ld` (GNU Linker)

## Build
Assemble and link the code:
```bash
nasm -f elf64 advanced_webserver.s -o advanced_webserver.o
ld advanced_webserver.o -o advanced_webserver
```

## Run
1. Create a test file (e.g., `index.html`) in the same directory:
   ```bash
   echo "<html><body><h1>Hello from ASM!</h1></body></html>" > index.html
   ```
2. Run the server:
   ```bash
   ./advanced_webserver
   ```

## Test
Use a browser or `curl` to test:
- For a valid file:
  ```bash
  curl http://localhost:8080/index.html
  ```
  Expected output:
  ```
  HTTP/1.1 200 OK
  Content-Type: text/html
  Content-Length: 44

  <html><body><h1>Hello from ASM!</h1></body></html>
  ```
- For a missing file:
  ```bash
  curl http://localhost:8080/missing.txt
  ```
  Expected output:
  ```
  HTTP/1.1 404 Not Found
  Content-Type: text/html
  Content-Length: 13

  404 Not Found
  ```

## Limitations
- Maximum file size: 4096 bytes (larger files are truncated).
- No path traversal protection (e.g., vulnerable to `../../etc/passwd`).
- Assumes `text/html` content type for all files.
- Only handles GET requests (POST not implemented).
- Single read for requests (512-byte limit) and files (4096-byte limit).

## Notes
- The server listens on port 8080 to avoid requiring root privileges.
- Stop the server with `Ctrl+C`.
- For GitHub, ensure `advanced_webserver.s`, `index.html`, and this `README.md` are included.
