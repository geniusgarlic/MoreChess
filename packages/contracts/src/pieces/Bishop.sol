// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import { IPiece } from "./IPiece.sol";

contract Bishop is IPiece{

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
        return false;
    }

    // Returns if the piece can promote
    function canPromote() public pure override returns (bool){
        return false;
    }

    function promotion() public pure override returns (string memory){
        return "";
    }

    function generatePseudoLegalMoves(Piece[64] memory board) public view override returns (uint8[] memory) {
        uint8[] memory moves = new uint8[](13); // maximum of 13 moves for a bishop
        for(uint8 i = 0; i < 4; i++){ // once for each direction
            for(uint8 j = 0; j < 7; j++){ // the piece can travel a maximum distance of 7 squares
                uint8 move = 0;
                if(i == 0){ // up and right
                    move = _currentSquare + (j + 1) * 9;
                } else if(i == 1){ // down and right
                    move = _currentSquare - (j + 1) * 7;
                } else if(i == 2){ // down and left
                    move = _currentSquare - (j + 1) * 9;
                } else if(i == 3){ // up and left
                    move = _currentSquare + (j + 1) * 7;
                }
                if(move > 63 || move < 0){ // if the move is off the board
                    break;
                }
                bytes32 compColor = keccak256(abi.encodePacked(board[move].color));
                bool compOppColor = (compColor == keccak256(abi.encodePacked("white")));
                // if the square is empty
                if(keccak256(abi.encodePacked(board[move].name)) == keccak256(abi.encodePacked("empty"))){
                    moves[j] = move;
                } else if(compColor == (compOppColor ? keccak256(abi.encodePacked("white")) : keccak256(abi.encodePacked("white")))) {
                    // if the square has an enemy piece
                    moves[j] = move;
                    break;
                } else { // if the square has a friendly piece
                    break;
                }
            }
        }
        return moves;
    }
}