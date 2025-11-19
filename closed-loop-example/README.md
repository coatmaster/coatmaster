# Closed-Loop Control Example

This example demonstrates how to create a closed-loop feedback system between a Coatmaster Flex custom app and an external control system, simulated by a simple Python server.

## Overview

The application allows a user to:
1.  Take a thickness measurement on the Coatmaster Flex.
2.  Send the measurement data, along with a target thickness and a selected production line, to a Python web server.
3.  Receive a response from the server, which could be used to trigger adjustments in a production environment (e.g., adjusting coating line parameters).

This showcases a practical use case for integrating the Coatmaster Flex into an automated process control workflow.

## Components

-   **`app.qml`**: A QML application for the Coatmaster Flex. It provides the user interface for setting a target, taking measurements, and sending data to the server.
-   **`server.py`**: A simple Python HTTP server that acts as the external control system. It receives data from the QML app, processes it, and sends a response back.

## How to Run the Example

### 1. Start the Python Server

First, run the Python server on a computer that is on the same network as your Coatmaster Flex.

```bash
python server.py
```

The server will start on port 8000. Note the IP address of the computer running the server.

### 2. Deploy the QML App

Package the `closed-loop-example` directory into a `.zip` file and upload it to your Coatmaster Flex via the web interface, as described in the main documentation.

### 3. Configure and Use the App

1.  Launch the "Closed Loop Example" app on your Coatmaster Flex.
2.  You will be prompted to enter the server URL. Enter the IP address and port of your Python server (e.g., `http://192.168.1.100:8000`).
3.  Press "Connect".
4.  On the main screen, you can:
    -   Select a measurement application.
    -   Select a production line.
    -   Set a target thickness.
    -   Take a measurement using the device trigger.
5.  Press the "Send Data" button to send the latest measurement and parameters to the Python server.
6.  A popup will display the server's response, showing the calculated difference and a status message. The terminal running the `server.py` script will print the data it receives.