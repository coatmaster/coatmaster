# Navigator App

The Navigator App is a guided measurement application for the Coatmaster Flex. It's designed to walk an operator through a predefined sequence of measurement points on a specific part, ensuring that all required measurements are taken consistently.

## Workflow

The application consists of two main screens: a selection screen and a measurement screen.

### 1. Selection Screen

1.  **Select Configuration:** The user is first presented with a dropdown menu to select the appropriate measurement configuration for the part they are about to measure.
2.  **Select Block/Sample:** Once a configuration is chosen, a second dropdown is populated with a list of available blocks or samples associated with that configuration.
3.  **Start Measurement:** After selecting the specific block, the "Start Measurement" button becomes active. Pressing it takes the user to the measurement screen.

### 2. Measurement Screen

This screen guides the operator through the actual measurement process:

1.  **Visual Guidance:** The screen displays an image and a name for the current measurement point (e.g., "Point 1").
2.  **Navigation:** The operator can use the "Next" and "Previous" buttons to cycle through the different measurement points.
3.  **Taking a Measurement:** To measure a point, the operator aims the device at the location shown in the image and presses the hardware trigger.
4.  **Live Feedback:** The measured thickness value is immediately displayed on the screen for the corresponding point, replacing the "-.-" placeholder.
5.  **Completion:** After a measurement is taken for every point in the sequence, a success popup appears, confirming that the process is complete. Accepting the popup returns the user to the initial selection screen.

## Key Features

- **Guided Workflow:** Ensures that operators follow a standardized measurement procedure.
- **Visual Aids:** Uses images to clearly indicate where each measurement should be taken.
- **Dynamic Data:** Loads measurement configurations and sample lists directly from the device's API.
- **Interactive UI:** Provides clear navigation and real-time feedback on measurement status and results.
- **Multi-Page Structure:** Uses a `StackView` to create a clean, step-by-step user experience.

## Files

- `App.qml`: The core application file containing all UI and logic.
- `point1.jpg` - `point5.jpg`: The images corresponding to each measurement point in the sequence.
