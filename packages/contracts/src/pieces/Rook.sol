// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import { IPiece } from "./IPiece.sol";

contract Rook is IPiece{

    uint8 private _currentPosition;
    bool private _color;
    bool private _hasMoved;

    constructor(uint8 startingPosition, bool color) {
        _currentPosition = startingPosition;
        _color = color;
    }

    // Returns if the piece can jump over other pieces (like a knight).
    function canJump() public pure override returns (bool){
        return false;
    }

    // Returns if the piece can promote
    function canPromote() public pure override returns (bool){
        return false;
    }

    function promotion() public pure override returns (string memory){
        return "";
    }

    function generatePseudoLegalMoves(bytes32[64] memory board) public view override returns (uint8[] memory) {
        uint8[] memory moves = new uint8[](14); // maximum of 14 moves for a rook
        for(uint8 i = 0; i < 4; i++){ // once for each direction
            for(uint8 j = 0; j < 7; j++){ // the piece can travel a maximum distance of 7 squares
                uint8 move = 0;
                if(i == 0){ // up
                    move = _currentPosition + (j + 1) * 8;
                } else if(i == 1){ // right
                    move = _currentPosition + (j + 1);
                } else if(i == 2){ // down
                    move = _currentPosition - (j + 1) * 8;
                } else if(i == 3){ // left
                    move = _currentPosition - (j + 1);
                }
                if(move > 63 || move < 0){ // if the move is off the board
                    break;
                }
                if(board[move] == 0){ // if the square is empty
                    moves[j] = move;
                } else if((uint8(board[move][0])==0)?false:true == _color){ // if the square has an enemy piece
                    moves[j] = move;
                    break;
                } else { // if the square has a friendly piece
                    break;
                }
            }
        }
    }
}