// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

// Sets the winning condition, how the turns are handled (+ maybe time)
interface IRule {

    struct Piece {
        string name;
        string color;
    }

    // event when a turn is over, the boolean corresponds to the color of the player who just played
    event TurnIsOver(bool isFinished);

    // returns the starting position of the game
    function startingPosition() external view returns (Piece[64] memory);

    // returns true if a state corresponds to a finished game
    function isWin() external view returns (bool);

    function isDraw() external view returns (bool);

    // returns false if it white turn to play, true if it is black turn to play
    function isTurn() external view returns (bool);

    // plays a move and returns the new board / returns an error if the move is not legal
    function playMove(uint8 from, uint8 to) external returns (Piece[64] memory);
}
