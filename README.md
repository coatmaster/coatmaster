# coatmaster Flex

This section contains all applications, examples, and integration resources for the **coatmaster Flex**.

The included materials demonstrate how to develop, customize, and integrate QML-based applications with the Flex platform (OS v7 and newer), including communication with external servers for process control.

---

## 📘 Overview

The **coatmaster Flex** supports custom applications built in QML, allowing developers and partners to:
- Create tailored measurement interfaces.
- Connect to external control systems via HTTP or TCP/IP.
- Automate process feedback and closed-loop control.
- Access device parameters, configurations, and live data through the Flex API.

This folder provides working code examples, documentation, and guides to support your development.

---

## 📂 Folder Structure

| Folder | Description |
|---------|--------------|
| **flex-apps-sdk/** | Contains the closed-loop control demo app, server example, and development documentation. |

---

## ⚙️ Getting Started

### 1. Deploying a Flex Custom App
1. Prepare your application folder (must include `App.qml` at the root).
2. Compress the folder into a `.zip` file.
3. Log into the Coatmaster Flex web interface.
4. Navigate to **Custom Apps → Upload App**, then select your zip file.
5. Launch the app on the device and follow on-screen instructions.

### 2. Running Local Examples
Some apps (like the Closed-Loop example) include a local Python server that simulates an external control system.

```bash
python server.py
```

Then connect the Flex device or simulator to:
```
http://<your-ip>:8000
```

---

## 🧠 Developer Notes

- The main file must be named **`App.qml`**.
- Supported QML components include:
  - `FlexButton`, `FlexTextInput`, `FlexComboBox`, `FlexList`, `FlexCheckbox`, `FlexQmlMeasure`
- For networking:
  - Local requests: `Utils.httpRequest()`
  - External requests: `http://localhost:9883/proxy?target=<your_server_url>`
- Use `FlexDialog` events for measurement triggers and navigation.

---

## 📜 License

**Coatmaster Partner License**  
© 2025 Coatmaster AG. All rights reserved.

This repository and its contents are proprietary and provided for integration and development purposes only.  
Public distribution, sublicensing, or commercial use outside Coatmaster partnership agreements is prohibited.
