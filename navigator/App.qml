// Import necessary QML modules for UI, layouts, and controls.
import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
// Import the JavaScript utility library for making HTTP requests.
import "../lib/utils.js" as Utils
import "../lib"
// Import the custom Flex UI components.
import FlexUi 1.0

Item {
    id: app
    anchors.fill: parent
    property string appId: ""

    property int configurationId: -1
    property int blockId: -1

    Component {
        id: mainComponent
        ColumnLayout {
            anchors.fill: parent

            onVisibleChanged: {
                if(visible){
                    startButton.isFocused = true
                }
            }

            Component.onCompleted: {
                Utils.get("/api/v1/configurations").then(function(data) {
                    configurationsModel.clear();
                    data.forEach(function(config) {
                        configurationsModel.append(config);
                    });

                    if(configurationsModel.count>0){
                        configurationComboBox.currentIndex = 0
                    }
                }).catch(function(error) {
                    console.log("Failed to load configurations:", error);
                });
            }

            Text {
                text: "Measurement Plan"
                font.pointSize: 15
                horizontalAlignment: Qt.AlignHCenter
                Layout.fillWidth: true
            }

            FlexComboBox {
                id: configurationComboBox
                navigationRow: 0; navigationColumn: 0
                Layout.fillWidth: true
                model: configurationsModel
                textRole: "name"
                onSelected: function(index, item) {
                    app.configurationId = item.id;
                    blocksComboBox.enabled = true;
                    startButton.enabled = false;
                    blocksModel.clear();

                    var path = "/api/v1/samples?configId=" + item.id;
                    Utils.get(path).then(function(data) {
                        data.forEach(function(block) {
                            blocksModel.append(block);
                        });

                        if(blocksModel.count > 0){
                            blocksComboBox.currentIndex = 0;
                        }
                    }).catch(function(error) {
                        console.log("Failed to load blocks:", error);
                    });
                }
            }

            FlexComboBox {
                id: blocksComboBox
                navigationRow: 1; navigationColumn: 0
                Layout.fillWidth: true
                model: blocksModel
                textRole: "name"
                enabled: false // Disabled until a configuration is selected
                onSelected: function(index, item) {
                    startButton.enabled = true;
                    startButton.isFocused = true
                    app.blockId = item.id
                }
            }

            Item{
                Layout.fillHeight: true
            }

            FlexButton {
                id: startButton
                navigationRow: 2; navigationColumn: 0
                text: "Start Measurement"
                enabled: false // Disabled until a block is selected
                onClicked: {
                    var component = stackView.push(measurementComponent, {"appId": app.configurationId, "blockId": blockId,"currentPointIndex":0});
                    component.finished.connect(function() {
                        var poppedItem = stackView.pop();
                        if(poppedItem){
                            poppedItem.destroy()
                        }
                    });
                }
            }
        }
    }

    Component {
        id: measurementComponent
        Item {
            id: measureApp

            property string appId: ""
            property string blockId: ""

            property int currentPointIndex: 0
            property var currentPoint: staticMeasurementPointsModel.get(currentPointIndex)

            onVisibleChanged: {
                if(visible){
                    nextButton.isFocused = true
                }
            }

            Component.onCompleted: {
               nextButton.isFocused = true
            }

            Connections {
                target: FlexDialog
                function onTriggerPressed() {
                    measureItem.measure(measureApp.blockId);
                }
            }

            ListModel {
                id: staticMeasurementPointsModel
                ListElement { name: "Point 1"; image: "point1.jpg"; thickness: "-.-" }
                ListElement { name: "Point 2"; image: "point2.jpg"; thickness: "-.-" }
                ListElement { name: "Point 3"; image: "point3.jpg"; thickness: "-.-" }
                ListElement { name: "Point 4"; image: "point4.jpg"; thickness: "-.-" }
                ListElement { name: "Point 5"; image: "point5.jpg"; thickness: "-.-" }
            }

            signal finished()

            FlexPopupDialog {
                id: successPopup
                title: "Success"
                text: "All measurements completed successfully."
                //height:200 //just a test for the size
                onAccepted: {
                    measureApp.finished()
                }
            }

            FlexQmlMeasure {
                id: measureItem
                appId: measureApp.appId
                onNewMeasurement: function (measurement) {
                    if (measurement && 'displayStatus' in measurement) {
                        var displayStatus = measurement.displayStatus;
                        if ('showThickness' in displayStatus && displayStatus.showThickness === true) {
                            var point = staticMeasurementPointsModel.get(measureApp.currentPointIndex);
                            point.thickness = measurement.thicknessString + " " + FlexDialog.unit;
                            staticMeasurementPointsModel.set(measureApp.currentPointIndex, point);
                            measureApp.currentPoint = staticMeasurementPointsModel.get(measureApp.currentPointIndex);
                            if(areAllPointsMeasured()){
                                successPopup.open()
                            } //else {
                              //  measureApp.nextPoint()
                            //}
                        }
                    }
                }
                onError: function(message) {
                    var messageItem = gridLayout.findChildByName("messageItem");
                    if (messageItem) {
                        messageItem.text = message;
                    }
                }
            }

            function areAllPointsMeasured() {
                for (var i = 0; i < staticMeasurementPointsModel.count; i++) {
                    var point = staticMeasurementPointsModel.get(i);
                    if (point.thickness === "-.-") {
                        return false;
                    }
                }
                return true;
            }

            function nextPoint(){
                if (measureApp.currentPointIndex < staticMeasurementPointsModel.count - 1) {
                    measureApp.currentPointIndex++;
                } else {
                    measureApp.currentPointIndex = 0;
                }
                measureApp.currentPoint = staticMeasurementPointsModel.get(measureApp.currentPointIndex);
            }

            function previousPoint(){
                if (measureApp.currentPointIndex > 0) {
                    measureApp.currentPointIndex--;
                } else {
                    measureApp.currentPointIndex = staticMeasurementPointsModel.count - 1;
                }
                measureApp.currentPoint = staticMeasurementPointsModel.get(measureApp.currentPointIndex);
            }

            ColumnLayout {
                id: gridLayout
                anchors.fill: parent

                Label {
                    text: measureApp.currentPoint.name
                    font.pointSize: 24
                    horizontalAlignment: Qt.AlignHCenter
                    Layout.fillWidth: true
                }
                Image {
                    source: measureApp.currentPoint.image
                    fillMode: Image.PreserveAspectFit
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                }

                Label {
                    id: thicknessLabel
                    text: measureApp.currentPoint.thickness
                    font.pointSize: 24; font.bold: true
                    horizontalAlignment: Qt.AlignHCenter
                    Layout.fillWidth: true
                }

                Label {
                    id: messageItem
                    objectName: "messageItem"
                    text: ""
                    wrapMode: Text.Wrap
                    Layout.fillWidth: true
                }

                RowLayout{
                    FlexButton {
                        id: prevButton
                        navigationRow: 0; navigationColumn: 0
                        text: "Previous"
                        onClicked: {
                            measureApp.previousPoint()
                        }
                    }
                    Item{
                       Layout.fillWidth: true
                    }
                    FlexButton {
                        id: nextButton
                        navigationRow: 0; navigationColumn: 1
                        text: "Next"
                        onClicked: {
                           measureApp.nextPoint()
                        }
                    }
                }
            }
        }
    }

    Connections {
        target: FlexDialog
        function onKeyBackPressed() {
            if (stackView.depth > 1) {
                stackView.pop();
            } else {
                FlexDialog.closeDialog();
            }
        }
    }

    ListModel { id: configurationsModel }
    ListModel { id: blocksModel }

    StackView {
        id: stackView
        anchors.fill: parent
        initialItem: mainComponent
    }
}
