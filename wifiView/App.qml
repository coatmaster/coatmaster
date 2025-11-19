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



    Connections {
        target: FlexDialog

        // needed to be able to close the Dialog
        onKeyBackPressed: {
            FlexDialog.closeDialog();
        }
    }

    FlexQmlWifi{
        id:wifi
    }

    ColumnLayout{
        anchors.fill: parent

        GroupBox{
            title: "Wifi"
            GridLayout{
                columns:2
                Label{
                    text: "connected:"
                }

                Label{
                    text: wifi.connected
                }

                Label{
                    text: "signalStrength:"
                }

                Label{
                    text: wifi.signalStrength
                }

                Label{
                    text: "SSID:"
                }

                Label{
                    text: wifi.ssid
                }


                Label{
                    text: "ipAddress:"
                }

                Label{
                    text: wifi.ipAddress
                }

                Label{
                    text: "macAddress:"
                }

                Label{
                    text: wifi.macAddress
                }
            }
        }

        GroupBox{
            title: ""
            Layout.fillWidth: true
            Layout.fillHeight: true


                FlexQmlQrCode{
                    text: "https://coatmaster.com"
                    backgroundColor: FlexDialog.backgroundColor
                    color: FlexDialog.accentColor
                    anchors.centerIn: parent
                    height: 200
                    width: 200
                }

        }

        Item{
            Layout.fillHeight: true
        }
    }
}

