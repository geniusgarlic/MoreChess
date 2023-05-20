// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import {IRule} from "./IRule.sol";

contract Classic is IRule{
    bool private _currentColorTurn;

    constructor(bool startingColor) {
        _currentColorTurn = startingColor;
    }

    function startingPosition() public pure override returns (bytes32[64] memory) {
        bytes32[64] memory data;
        for (uint8 i = 0; i < 64; i++) {
            if (i >= 8 && i <= 15) {
                data[i] = "0 Pawn";
            }
            else if (i >= 48 && i <= 55) {
                data[i] = "1 Pawn";
            } 
            else if (i == 0 || i == 7) {
                data[i] = "0 Rook";
            }
            else if (i == 56 || i == 63) {
                data[i] = "1 Rook";
            }
            else if (i == 1 || i == 6) {
                data[i] = "0 Knight";
            }
            else if (i == 57 || i == 62) {
                data[i] = "1 Knight";
            }
            else if (i == 2 || i == 5) {
                data[i] = "0 Bishop";
            }
            else if (i == 58 || i == 61) {
                data[i] = "1 Bishop";
            }
            else if (i == 3) {
                data[i] = "0 Queen";
            }
            else if (i == 59) {
                data[i] = "1 Queen";
            }
            else if (i == 4) {
                data[i] = "0 King";
            }
            else if (i == 60) {
                data[i] = "1 King";
            }
            else {
                data[i] = "";
            }
        }
        return data;
    }

    // returns true if a state corresponds to a finished game
    function isWin() public pure override returns (bool) {
        return false;
    }

    function isDraw() public pure override returns (bool) {
        return false;
    }

    // returns false if it white turn to play, true if it is black turn to play
    function isTurn() public view override returns (bool) {
        return _currentColorTurn;
    }
}