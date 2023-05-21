// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import {IPiece} from "./IPiece.sol";

contract Pawn is IPiece{

    uint8 private _currentSquare;
    string private _color;
    bool private _hasMoved;

    constructor(uint8 startingPosition, string memory color) {
        _currentSquare = startingPosition;
        _color = color;
        _hasMoved = false;
    }

    function getColor() public view returns (string memory) {
        return _color;
    }

    // Returns if the piece can jump over other pieces (like a knight).
    function canJump() public pure override returns (bool){
        return false;
    }

    // Returns if the piece can promote
    function canPromote() public view override returns (bool){
        if (keccak256(abi.encodePacked(_color)) == keccak256(abi.encodePacked("white")) && _currentSquare >= 56 && _currentSquare <= 63){
            return true;
        }
        else if (keccak256(abi.encodePacked(_color)) == keccak256(abi.encodePacked("black")) && _currentSquare >= 0 && _currentSquare <= 7){
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

    function generatePseudoLegalMoves(Piece[64] memory board) public view override returns (uint8[] memory) {
        uint8[] memory moves = new uint8[](4); // maximum of 4 moves for a pawn

        if (keccak256(abi.encodePacked(_color)) == keccak256(abi.encodePacked("white"))) { // piece is white
            if (keccak256(abi.encodePacked(board[_currentSquare + 8].name)) == keccak256(abi.encodePacked("empty"))) { // square in front of pawn is empty
                moves[0] = _currentSquare + 8;
                if (!_hasMoved) {                     
                    if (keccak256(abi.encodePacked(board[_currentSquare + 16].name)) == keccak256(abi.encodePacked("empty"))) { // if the square two in front of the pawn is empty
                        moves[1] = _currentSquare + 16;
                    }
                }
            }

            if (keccak256(abi.encodePacked(board[_currentSquare + 7].color)) == keccak256(abi.encodePacked("black"))) { // if the square to the diagonal left of the pawn is occupied by a black piece
                moves[2] = _currentSquare + 7;
            }
            if (keccak256(abi.encodePacked(board[_currentSquare + 9].color)) == keccak256(abi.encodePacked("black"))) { // if the square to the diagonal right of the pawn is occupied by a black piece
                moves[3] = _currentSquare + 9;
            }
        }
        else if (keccak256(abi.encodePacked(_color)) == keccak256(abi.encodePacked("black")))  {
            if (keccak256(abi.encodePacked(board[_currentSquare - 8].name)) == keccak256(abi.encodePacked("empty"))) {
                moves[0] = _currentSquare - 8;
                if (!_hasMoved) {                     
                    if (keccak256(abi.encodePacked(board[_currentSquare - 16].name)) == keccak256(abi.encodePacked("empty"))) { // if the square two in front of the pawn is empty
                        moves[1] = _currentSquare - 16;
                    }
                }
            }

            if (keccak256(abi.encodePacked(board[_currentSquare - 7].color)) == keccak256(abi.encodePacked("white"))) {
                moves[2] = _currentSquare - 7;
            }
            if (keccak256(abi.encodePacked(board[_currentSquare - 9].color)) == keccak256(abi.encodePacked("white"))) {
                moves[3] = _currentSquare - 9;
            }
        }

        return moves;
    }
}