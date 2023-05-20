// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import { IPiece } from "./IPiece.sol";

contract Knight is IPiece{

    uint8 private _currentPosition;
    bool private _color;
    bool private _hasMoved;

    constructor(uint8 startingPosition, bool color) {
        _currentPosition = startingPosition;
        _color = color;
    }

    // Returns if the piece can jump over other pieces (like a knight).
    function canJump() public pure override returns (bool){
        return true;
    }

    // Returns if the piece can promote
    function canPromote() public pure override returns (bool){
        return false;
    }

    function promotion() public pure override returns (string memory){
        return "";
    }

    function generatePseudoLegalMoves(bytes32[64] memory board) public view override returns (uint8[] memory) {
        uint8[] memory moves = new uint8[](8); // maximum of 8 moves for a knight
        uint8 indexCnt = 0;
        for(uint8 i = 0; i < 8; i++){
            uint8 move = 0;
            if(i == 0){ // up right
                move = _currentPosition + 17;
            } else if(i == 1){ // right up
                move = _currentPosition + 10;
            } else if(i == 2){ // right down
                move = _currentPosition - 6;
            } else if(i == 3){ // down right
                move = _currentPosition - 15;
            } else if(i == 4){ // down left
                move = _currentPosition - 17;
            } else if(i == 5){ // left down
                move = _currentPosition - 10;
            } else if(i == 6){ // left up
                move = _currentPosition + 6;
            } else if(i == 7){ // up left
                move = _currentPosition + 15;
            }
            if(move > 63 || move < 0){ // if the move is off the board
                continue;
            }
            if(board[move] == 0){ // if the square is empty
                moves[indexCnt] = move;
                indexCnt++;
            } else if((uint8(board[move][0])==0)?false:true == _color){ // if the square has an enemy piece
                moves[indexCnt] = move;
                indexCnt++;
            } else { // if the square has a friendly piece
                continue;
            }
        }
    }
}