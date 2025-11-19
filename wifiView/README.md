# Wi-Fi View App

The Wi-Fi View App is a utility application for the Coatmaster Flex that displays detailed information about the device's current Wi-Fi connection and generates a QR code.

## Functionality

-   **Wi-Fi Status Display:** Presents real-time information about the device's Wi-Fi connection, including:
    -   Connection status (connected/disconnected)
    -   Signal strength
    -   Network SSID
    -   Local IP address
    -   MAC address of the Wi-Fi adapter
-   **QR Code Generation:** Displays a QR code for a predefined URL (currently "https://coatmaster.com"), which can be scanned by external devices.
-   **Closes on Back Button:** The app can be closed using the device's hardware back button.

## Key Components

-   `FlexQmlWifi`: Utilized to fetch and display various Wi-Fi related properties.
-   `FlexQmlQrCode`: Used to render the QR code based on a given text string.
-   Standard QML layout components (`ColumnLayout`, `GridLayout`, `GroupBox`, `Label`) are used for structuring and presenting the information.

## Purpose

This app serves as:

-   A practical example of how to integrate and use the `FlexQmlWifi` and `FlexQmlQrCode` components in a Coatmaster Flex QML application.
-   A diagnostic tool for users to quickly check their device's network status.
-   A demonstration of displaying dynamic device information within a QML app.

## Files

-   `App.qml`: The main application file containing the UI and logic for displaying Wi-Fi information and the QR code.
