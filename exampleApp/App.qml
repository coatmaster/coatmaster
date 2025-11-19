// Import necessary QML modules for UI, layouts, and controls.
import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
// Import the JavaScript utility library for making HTTP requests.
import "../lib/utils.js" as Utils
import "../lib"
// Import the custom Flex UI components.
import FlexUi 1.0


// The root item of the application.
Item {
    id: app
    // A property to track if the app is busy loading data.
    property bool isLoading: false
    anchors.fill: parent
    property string appId: ""

    // --- FlexQmlMeasure: Handles all measurement logic ---
    FlexQmlMeasure {
        id: measureItem
        // This signal is triggered when a new measurement is completed.
        onNewMeasurement: function (measurement) {
            if (measurement && 'displayStatus' in measurement) {
                var displayStatus = measurement.displayStatus;
                // Set the color of the result text based on the status.
                if ('colourCode' in displayStatus && displayStatus.colourCode) {
                    resultThicknessText.color = displayStatus.colourCode.trim();
                } else {
                    resultThicknessText.color = FlexDialog.foregroundColor;
                }
                // Display the thickness if available.
                if ('showThickness' in displayStatus && displayStatus.showThickness === true) {
                    resultThicknessText.text = measurement.thicknessString + " " + FlexDialog.unit;
                    messageItem.text = "";
                } else {
                    resultThicknessText.text = "-.-";
                }
                // Display any additional status text.
                if ('text' in displayStatus && displayStatus.text) {
                    messageItem.text = displayStatus.text;
                }
            } else {
                resultThicknessText.text = "-.-";
            }
        }

        // This signal is triggered if an error occurs during measurement.
        onError: function(message) {
            messageItem.text = message;
        }
    }

    // --- Connections: Handle global device events ---
    Connections {
        target: FlexDialog
        // Trigger a measurement when the hardware trigger is pressed.
        onTriggerPressed: {
            measureItem.measure();
        }
        // Close the app when the hardware back button is pressed.
        onKeyBackPressed: {
            FlexDialog.closeDialog();
        }
    }

    Image {
        anchors.fill: parent
        source: "coatmasterFlex.png"
        fillMode: Image.PreserveAspectCrop
        asynchronous: true
        opacity: 0.3
    }

    // A busy indicator that is visible when the app is loading or measuring.
    BusyIndicator {
        anchors.centerIn: parent
        running: app.isLoading || measureItem.busy
        visible: running
        z: 2 // Ensure it's on top of other elements.
    }

    // --- Component Initialization ---
    Component.onCompleted: {
        // Set loading to true while we fetch initial data.
        app.isLoading = true;

        // Fetch the list of configurations from the server.
        Utils.httpRequest("GET", "/api/v1/configurations").then(function (data) {
            // Map the server response to the format needed by the ListModel.
            var modelData = data.map(q => ({
                                               "id": q.id,
                                               "name": q.name,
                                               "isMeasureValid": q.isMeasureValid,
                                               "isReadOnly": q.isReadOnly
                                           }));
            // Append each item to the ListModel for the ComboBox.
            modelData.forEach(q => {if(q.isMeasureValid){appListModel.append(q)}});
            // Set loading to false now that data is loaded.
            app.isLoading = false;
            // Set the initial selection in the ComboBox.
            appListView.currentIndex = 0
        });

        // Populate a local model for the FlexList.
        lineModel.append({"value": 1, "name": "line A"});
        lineModel.append({"value": 2, "name": "line B"});
        lineModel.append({"value": 3, "name": "line C"});
    }

    // --- Data Models ---
    ListModel { id: appListModel }
    ListModel { id: lineModel }

    // --- UI Layout ---
    GridLayout {
        columns: 2
        anchors.fill: parent

        Text {
            text: "demo app"
            Layout.row: 0; Layout.column: 0; Layout.columnSpan: 2
            font.pointSize: 24
            horizontalAlignment: Qt.AlignHCenter
            Layout.fillWidth: true
        }

        // Text to display the measurement result.
        Text {
            id: resultThicknessText
            text: ""
            Layout.row: 1; Layout.column: 0; Layout.columnSpan: 2
            font.pointSize: 44; font.bold: true
            horizontalAlignment: Qt.AlignHCenter
            Layout.fillWidth: true
        }

        // A list displaying the 'lineModel'.
        FlexList {
            id: appListView
            navigationRow: 0; navigationColumn: 0
            Layout.row: 2; Layout.column: 0; Layout.columnSpan: 2
            Layout.fillWidth: true; Layout.fillHeight: true
            model: lineModel
            textRole: "name"
            onSelected: function (index, app) {
                // This is where you would handle a selection event from the list.
            }
        }

        FlexComboBox {
            id: myCombobox
            navigationRow: 1; navigationColumn: 0
            Layout.row: 3; Layout.column: 0; Layout.columnSpan: 2
            Layout.fillWidth: true
            currentIndex: 0
            model: appListModel
            textRole: "name"
            // When an item is selected, update the appId on the measureItem.
            onSelected: function (index, app) {
                measureItem.appId = app.id
            }
        }

        // An input field for text.
        FlexTextInput {
            navigationRow: 2; navigationColumn: 0
            Layout.row: 4; Layout.column: 0
            Layout.fillWidth: true
            text: "standard input"
        }

        // A checkbox.
        FlexCheckbox {
            id: checkBox
            navigationRow: 2; navigationColumn: 1
            Layout.row: 4; Layout.column: 1
        }

        // A dropdown to select a measurement configuration.


        FlexComboBox {
            id: myCombobox_simple
            navigationRow: 3; navigationColumn: 0
            Layout.row: 5; Layout.column: 0; Layout.columnSpan: 2
            Layout.fillWidth: true
            currentIndex: 0
            model: ["a", "b", "c"] // simple list model dont set textRole
            //textRole: "name"
            // When an item is selected, update the appId on the measureItem.
            onSelected: function (index, item) {

            }
        }

        // An input field for numbers.
        FlexTextInput {
            navigationRow: 4; navigationColumn: 0
            Layout.row: 6; Layout.column: 0
            Layout.fillWidth: true
            keyboardType: "numeric"
            text: "345.56"
        }

        // A button to trigger a measurement manually.
        FlexButton {
            navigationRow: 4; navigationColumn: 1
            Layout.row: 6; Layout.column: 1
            text: "measure"
            // The button is only enabled if a configuration has been selected.
            enabled: measureItem.appId >= 0
            onClicked: {
                measureItem.measure();
            }
        }

        // Display the currently selected appId for debugging/info.
        Text { text: "current appId:"; Layout.row: 7; Layout.column: 0 }
        Text { text: measureItem.appId; Layout.row: 7; Layout.column: 1 }

        // A text area for displaying messages or errors.
        Text {
            id: messageItem
            text: ""
            Layout.row: 8; Layout.column: 0; Layout.columnSpan: 2
            wrapMode: Text.Wrap
            Layout.fillWidth: true
        }
    }
}
