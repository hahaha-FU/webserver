1. # Verify the File:
   - Ensure the code is saved as `webserver.s` in a directory (e.g., `~/webserver/`).
   - Confirm it matches the provided code or your modified version, using `.intel_syntax noprefix` and targeting port 8080
2. # Create a Test File:
   - In the same directory as `webserver.s`, create a sample HTML file to test the server:
 ```bash
   echo "<html><body><h1>Hello from ASM!</h1></body></html>" > index.html
  ```
3. # Install Required Tools:
   - Ensure you have `nasm` (assembler) and `ld` (linker) installed:
 ```bash
   sudo apt update
   sudo apt install nasm binutils
 ```
4. # Assemble and Link the Code:
   - Assemble `webserver.s` into an object file:
 ```bash
   nasm -f elf64 webserver.s -o webserver.o
 ```
   - Link the object file to create the executable:
 ```bash
   ld webserver.o -o webserver
 ```
5. # Run the Server:
   - Execute the server:
 ```bash
   ./webserver
 ```
   - The server will start listening on `http://localhost:8080`. It runs in the foreground, so keep the terminal open.
6. # Test the Server:
   - Open another terminal or use a browser to test:
    - Browser: Navigate to `http://localhost:8080/index.html`. You should see:
```text
  Hello from ASM!
```
  - or use `curl`:
```text
 curl http://localhost:8080/index.html
```
Expected output:
```bash
HTTP/1.1 200 OK
Content-Type: text/html
Content-Length: 44

<html><body><h1>Hello from ASM!</h1></body></html>
```
- Test a non-existent file:
```bash
curl http://localhost:8080/missing.txt
```
Expected output:
```bash
HTTP/1.1 404 Not Found
Content-Type: text/html
Content-Length: 13

404 Not Found
```
7. # Stop the Server:
   - Press `Ctrl+C` in the terminal running the server to stop it.


