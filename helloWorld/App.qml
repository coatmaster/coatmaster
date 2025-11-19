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

    Text {
        text: "Hello World"
        anchors.centerIn: parent
    }

    Connections {
        target: FlexDialog

        // needed to be able to close the Dialog
        onKeyBackPressed: {
            FlexDialog.closeDialog();
        }
    }
}

