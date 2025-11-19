import QtQuick 2.15
import FlexUi 1.0


// The root item for the game.
Item {
    id: root
    anchors.fill: parent
    clip: true

    // --- Game Properties ---
    property string gameState: "Ready" // "Ready", "Playing", "GameOver"
    property bool gameRunning: gameState === "Playing"
    property real gravity: 0.15
    property real jumpVelocity: -3.5
    property real backgroundSpeed: 1.5
    property real pipeSpeed: 1.5
    property int score: 0
    property string appId: ""
    property bool canRestart: false

    // --- Functions ---
    function restartGame() {
        // Reset bird
        bird.y = root.height / 2;
        bird.velocityY = 0;

        // Reset pipes
        for (var i = 0; i < pipeRepeater.count; i++) {
            var pipe = pipeRepeater.itemAt(i);
            pipe.x = root.width + (i * 200);
            pipe.randomizeHeight();
            pipe.scored = false;
        }

        // Reset score
        score = 0;

        // Change state
        gameState = "Playing";
    }


    // --- Parallax Background ---
    Image {
        id: background1
        source: "background.png"
        y: 0
        x: 0
        width: root.width
        height: root.height
        fillMode: Image.PreserveAspectCrop
    }
    Image {
        id: background2
        source: "background.png"
        y: 0
        x: root.width
        width: root.width
        height: root.height
        fillMode: Image.PreserveAspectCrop
    }

    // --- Pipes ---
    Repeater {
        id: pipeRepeater
        model: 3
        delegate: Pipe {
            id: pipe
            property bool scored: false
            x: root.width + (index * 200)
        }
    }

    // --- The Bird ---
    Image {
        id: bird
        source: "bird.png"
        x: 50 // Adjusted for narrower screen
        y: root.height / 2
        width: 18 // Smaller bird for easier gameplay
        height: 34 // Height maintaining aspect ratio (18:34 ≈ 40:75)
        property real velocityY: 0
    }

    // --- UI Messages ---
    Text {
        id: scoreText
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 15
        font.pointSize: 18
        font.bold: true
        color: "white"
        text: score
        visible: gameState === "Playing" || gameState === "GameOver"
    }
    Text { // "Get Ready" message
        anchors.centerIn: parent
        font.pointSize: 16
        color: "white"
        text: "Press Trigger to Start"
        visible: gameState === "Ready"
        wrapMode: Text.WordWrap
        width: parent.width * 0.8
        horizontalAlignment: Text.AlignHCenter
    }
    Rectangle { // Game Over screen
        anchors.fill: parent
        color: "#80000000" // Semi-transparent black
        visible: gameState === "GameOver"

        Text {
            anchors.centerIn: parent
            font.pointSize: 18
            color: "white"
            text: canRestart ? "Game Over\nScore: " + score + "\nPress Trigger to Restart" : "Game Over\nScore: " + score
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap
            width: parent.width * 0.9
        }
    }

    // --- Game Over Timer ---
    Timer {
        id: gameOverTimer
        interval: 1000  // 1 second
        repeat: false
        onTriggered: {
            canRestart = true;
        }
    }

    // --- Game Loop ---
    Timer {
        id: gameLoop
        interval: 16
        running: true  // Always running to show background
        repeat: true
        onTriggered: {
            // Always animate background
            background1.x -= backgroundSpeed;
            background2.x -= backgroundSpeed;
            if (background1.x <= -root.width) {
                background1.x = background2.x + root.width;
            }
            if (background2.x <= -root.width) {
                background2.x = background1.x + root.width;
            }

            // Only update game physics when playing
            if (gameRunning) {
                bird.velocityY += gravity;
                bird.y += bird.velocityY;
            }

            // Only update pipes and collision when playing
            if (gameRunning) {
                for (var i = 0; i < pipeRepeater.count; i++) {
                    var pipe = pipeRepeater.itemAt(i);
                    pipe.x -= pipeSpeed;

                    // Collision detection with proper pipe references
                    if (bird.x < pipe.x + pipe.width && bird.x + bird.width > pipe.x) {
                        if (bird.y < pipe.topPipe.y + pipe.topPipe.height || bird.y + bird.height > pipe.bottomPipe.y) {
                            gameState = "GameOver";
                            canRestart = false;
                            gameOverTimer.start();
                            return;
                        }
                    }

                    if (pipe.x + pipe.width < bird.x && !pipe.scored) {
                        score++;
                        pipe.scored = true;
                    }

                    // Reposition pipe when it goes off screen
                    if (pipe.x < -pipe.width) {
                        // Find the rightmost pipe position
                        var rightmostX = 0;
                        for (var j = 0; j < pipeRepeater.count; j++) {
                            var otherPipe = pipeRepeater.itemAt(j);
                            if (otherPipe && otherPipe !== pipe && otherPipe.x > rightmostX) {
                                rightmostX = otherPipe.x;
                            }
                        }
                        pipe.x = rightmostX + 200;
                        pipe.randomizeHeight();
                        pipe.scored = false;
                    }
                }

                if (bird.y >= root.height - bird.height || bird.y <= 0) {
                    gameState = "GameOver";
                    canRestart = false;
                    gameOverTimer.start();
                }
            }
        }
    }

    // --- Connections: Handle global device events ---
    Connections {
        target: FlexDialog
        onKeyBackPressed: { FlexDialog.closeDialog(); }
        onTriggerPressed: {
            if (gameState === "Ready") {
                restartGame();
            } else if (gameState === "Playing") {
                bird.velocityY = jumpVelocity;
            } else if (gameState === "GameOver" && canRestart) {
                restartGame();
            }
        }
    }
}
