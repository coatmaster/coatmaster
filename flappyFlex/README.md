# Flappy Flex Game

This example is a simple "Flappy Bird" style game adapted for the Coatmaster Flex, demonstrating how to create interactive applications beyond typical measurement UIs.

## Overview

The goal of the game is to navigate a bird through a series of pipes without colliding with them. The game is controlled entirely by the hardware trigger on the Coatmaster Flex.

## How to Play

1.  **Start the Game**: After launching the app, press the hardware trigger to begin.
2.  **Flap**: Press the trigger to make the bird "flap" and gain height.
3.  **Avoid Pipes**: Time your flaps to guide the bird through the gaps in the pipes.
4.  **Restart**: After a "Game Over", press the trigger again to restart and try for a new high score.
5.  **Exit**: Press the hardware back button at any time to close the game.

## Developer Highlights

This example showcases several key concepts for developing custom Flex apps:

-   **Hardware Button Integration**: The game relies entirely on the `Connections` element to respond to `onTriggerPressed` for gameplay and `onKeyBackPressed` to exit.
-   **Game Loop**: A `Timer` with a 16ms interval creates the main game loop, which handles physics, movement, and collision detection.
-   **Game State Management**: A `gameState` property (`"Ready"`, `"Playing"`, `"GameOver"`) controls the application flow and what is displayed on the screen.
-   **Custom Components**: The `Pipe.qml` file defines a reusable component for the pipe obstacles, which is then instantiated multiple times using a `Repeater`.
-   **Dynamic UI**: The UI changes based on the game state, showing start messages, the score, and a "Game Over" screen.
-   **Collision Detection**: Simple bounding box collision detection is implemented in the game loop to check for collisions between the bird and the pipes or screen edges.
