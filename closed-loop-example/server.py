# Import necessary modules
from http.server import BaseHTTPRequestHandler, HTTPServer
import json

# Define the request handler class
class SimpleHTTPRequestHandler(BaseHTTPRequestHandler):
    # Handle GET requests
    def do_GET(self):
        # If the request path is /target, send the target thickness
        if self.path.startswith('/target'):
            self.send_response(200)
            self.send_header('Content-type', 'application/json')
            self.end_headers()
            # Define the target thickness
            response = {'target_thickness': 75.0}
            # Send the response as JSON
            self.wfile.write(json.dumps(response).encode('utf-8'))
        elif self.path.startswith('/lines'):
            self.send_response(200)
            self.send_header('Content-type', 'application/json')
            self.end_headers()
            # Define the target thickness
            response = ['line 1','line A','line B','line 123','no line']
            # Send the response as JSON
            self.wfile.write(json.dumps(response).encode('utf-8'))
        # Otherwise, send a 404 Not Found response
        else:
            self.send_response(404)
            self.end_headers()

    # Handle POST requests
    def do_POST(self):
        # If the request path is /data, process the received data
        if self.path.startswith('/data'):
            # Get the length of the POST data
            content_length = int(self.headers['Content-Length'])
            # Read the POST data
            post_data = self.rfile.read(content_length)
            # Parse the JSON data
            data = json.loads(post_data)

            # Print the received data
            print("Received data from Flex device:")
            print(f"  Target Thickness: {data.get('target_thickness')}")
            print(f"  Current Thickness: {data.get('current_thickness')}")
            print(f"  Current Line: {data.get('selected_line')}")

            # Calculate the difference between target and current thickness
            target = data.get('target_thickness', 0.0)
            current = data.get('current_thickness', 0.0)
            difference = current - target

            # Send a success response
            self.send_response(200)
            self.send_header('Content-type', 'application/json')
            self.end_headers()
            # Create the response dictionary including the difference
            response = {
                'status': 'success',
                'message': 'Data received adjusting Coating line',
                'difference': difference
            }
            # Send the response as JSON
            self.wfile.write(json.dumps(response).encode('utf-8'))
        # Otherwise, send a 404 Not Found response
        else:
            self.send_response(404)
            self.end_headers()

    # Handle OPTIONS requests for CORS
    def do_OPTIONS(self):
        self.send_response(200)
        self.send_header('Access-Control-Allow-Origin', '*')
        self.send_header('Access-Control-Allow-Methods', 'GET, POST, OPTIONS')
        self.send_header('Access-Control-Allow-Headers', 'Content-Type')
        self.end_headers()

# Define the function to run the server
def run(server_class=HTTPServer, handler_class=SimpleHTTPRequestHandler, port=8000):
    server_address = ('', port)
    httpd = server_class(server_address, handler_class)
    print(f'Starting httpd server on port {port}...')
    print('Run this server and enter http://<your-ip>:8000 in the app.')
    httpd.serve_forever()

# Run the server if the script is executed directly
if __name__ == '__main__':
    run()
