// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import {IPiece} from "./IPiece.sol";

contract Pawn is IPiece{

    uint8 private _currentPosition;
    bool private _color;
    bool private _hasMoved;

    constructor(uint8 startingPosition, bool color) {
        _currentPosition = startingPosition;
        _color = color;
        _hasMoved = false;
    }

    // Returns if the piece can jump over other pieces (like a knight).
    function canJump() public pure override returns (bool){
        return false;
    }

    // Returns if the piece can promote
    function canPromote() public view override returns (bool){
        if (_color == false && _currentPosition >= 56 && _currentPosition <= 63){
            return true;
        }
        else if (_color == true && _currentPosition >= 0 && _currentPosition <= 7){
            return true;
        }
        else{
            return false;
        }
    }

    function promotion() public view override returns (string memory){
        if (!canPromote()){
            revert("Piece cannot be promoted");
        }
        return "Queen"; // TODO
    }

    function getRow(uint8 position) public pure returns (uint8){
        return position / 8;
    }

    function getCol(uint8 position) public pure returns (uint8){
        return position % 8;
    }

    function generatePseudoLegalMoves(bytes32[64] memory board) public view override returns (uint8[] memory) {
        uint8[] memory moves = new uint8[](4); // maximum of 4 moves for a pawn

        if (_color == false) { // piece is white
            if (board[_currentPosition + 8] == 0) {
                moves[0] = _currentPosition + 8;
                if (!_hasMoved) {                     
                    if (board[_currentPosition + 16] == 0) { // if the square two in front of the pawn is empty
                        moves[1] = _currentPosition + 16;
                    }
                }
            }

            if (uint8(board[_currentPosition + 7][0]) == 1) { // if the square to the diagonal left of the pawn is occupied by a black piece
                moves[2] = _currentPosition + 7;
            }
            if (uint8(board[_currentPosition + 9][0]) == 1) { // if the square to the diagonal right of the pawn is occupied by a black piece
                moves[3] = _currentPosition + 9;
            }
        }
        else if (_color == true) {
            if (board[_currentPosition - 8] == 0) {
                moves[0] = _currentPosition - 8;
                if (!_hasMoved) {                     
                    if (board[_currentPosition - 16] == 0) { // if the square two in front of the pawn is empty
                        moves[1] = _currentPosition - 16;
                    }
                }
            }

            if (uint8(board[_currentPosition - 7][0]) == 0) { // TODO: check if this is correct
                moves[2] = _currentPosition - 7;
            }
            if (uint8(board[_currentPosition - 9][0]) == 0) {
                moves[3] = _currentPosition - 9;
            }
        }

        return moves;
    }
}