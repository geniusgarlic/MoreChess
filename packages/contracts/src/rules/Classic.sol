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
            if ((i >= 0 && i <= 7) || (i >= 56 && i <= 63)) {
                data[i] = "Pawn";
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