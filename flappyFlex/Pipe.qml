import QtQuick 2.15

Item {
    id: pipeRoot
    width: 50
    height: parent ? parent.height : 272

    property int gapSize: 100
    property int gapCenter: 136  // Default center position

    // Expose pipe components for collision detection
    property alias topPipe: topPipe
    property alias bottomPipe: bottomPipe

    function randomizeHeight() {
        // Keep gap center between 25% and 75% of screen height
        var minCenter = pipeRoot.height * 0.25
        var maxCenter = pipeRoot.height * 0.75
        pipeRoot.gapCenter = Math.floor(Math.random() * (maxCenter - minCenter)) + minCenter
    }

    // Top Pipe - extends from screen top down to gap
    Image {
        id: topPipe
        source: "pipe.png"
        width: pipeRoot.width
        height: gapCenter - (gapSize / 2)
        x: 0
        y: 0
        rotation: 180
        transformOrigin: Item.Center
        fillMode: Image.Stretch
        visible: height > 0
    }

    // Bottom Pipe - extends from gap down to screen bottom
    Image {
        id: bottomPipe
        source: "pipe.png"
        width: pipeRoot.width
        height: pipeRoot.height - (gapCenter + gapSize / 2)
        x: 0
        y: gapCenter + (gapSize / 2)
        fillMode: Image.Stretch
        visible: height > 0
    }

    Component.onCompleted: {
        randomizeHeight()
    }
}
