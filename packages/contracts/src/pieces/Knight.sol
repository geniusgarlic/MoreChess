// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import { IPiece } from "./IPiece.sol";

contract Knight is IPiece{

    uint8 private _currentSquare;
    string private _color;
    bool private _hasMoved;

    constructor(uint8 startingPosition, string memory color) {
        _currentSquare = startingPosition;
        _color = color;
    }

    function getColor() public view returns (string memory) {
        return _color;
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

    function generatePseudoLegalMoves(Piece[64] memory board) public view override returns (uint8[] memory) {
        uint8[] memory moves = new uint8[](8); // maximum of 8 moves for a knight
        uint8 indexCnt = 0;
        for(uint8 i = 0; i < 8; i++){
            uint8 move = 0;
            if(i == 0){ // up right
                move = _currentSquare + 17;
            } else if(i == 1){ // right up
                move = _currentSquare + 10;
            } else if(i == 2){ // right down
                move = _currentSquare - 6;
            } else if(i == 3){ // down right
                move = _currentSquare - 15;
            } else if(i == 4){ // down left
                move = _currentSquare - 17;
            } else if(i == 5){ // left down
                move = _currentSquare - 10;
            } else if(i == 6){ // left up
                move = _currentSquare + 6;
            } else if(i == 7){ // up left
                move = _currentSquare + 15;
            }
            if(move > 63 || move < 0){ // if the move is off the board
                continue;
            }

            bytes32 compColor = keccak256(abi.encodePacked(board[move].color));
            bool compOppColor = (compColor == keccak256(abi.encodePacked("white")));
            // if the square is empty
            if(keccak256(abi.encodePacked(board[move].name)) == keccak256(abi.encodePacked("empty"))){
                moves[indexCnt] = move;
                indexCnt++;
            } else if(compColor == (compOppColor ? keccak256(abi.encodePacked("white")) : keccak256(abi.encodePacked("white")))) {
                // if the square has an enemy piece
                moves[indexCnt] = move;
                indexCnt++;
            }
        }
        return moves;
        }
    }
}