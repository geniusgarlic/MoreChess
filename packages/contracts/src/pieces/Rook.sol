// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import { IPiece } from "./IPiece.sol";

contract Rook is IPiece{

    uint8 private _id;
    uint8 private _currentPosition;
    bool private _color;
    bool private _hasMoved;
    string public url;

    constructor(uint8 startingPosition, bool color, string memory url) {
        _id = startingPosition;
        _currentPosition = startingPosition;
        _color = color;
        url = url;
    }

    // Returns the game ID of the game this piece belongs to.
    function getPieceId() public view override returns (uint8){
        return _id;
    }

    // Returns the name of the piece (e.g., "bishop", "knight", etc.)
    function getName() public pure override returns (string memory){
        return "Rook";
    }

    // Returns the color of the piece ("white = False" or "black = True").
    function getColor() public view override returns (bool){
        return _color;
    }

    // Returns the current position of the piece.
    function getCurrentPosition() public view override returns (uint8){
        return _currentPosition;
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

    function getRow(uint8 position) public pure returns (uint8){
        return position / 8;
    }

    function getCol(uint8 position) public pure returns (uint8){
        return position % 8;
    }

    // Returns true if the piece can move to the specified position.
    // This does not take into account the state of the rest of the board (e.g., check situations).
    function canMove(uint8 to) public view override returns (bool) {
        if (getRow(_currentPosition) == getRow(to) || getCol(_currentPosition) == getCol(to)) {
            return true;
        }
        return false;
    }

    // Moves the piece to the specified position.
    // Reverts if the move is not valid.
    function move(uint8 to) external {
        if (canMove(to) == false){
            revert("Invalid move");
        }
        emit PieceMoved(_id, _currentPosition, to);
        _currentPosition = to;
        _hasMoved = true;
    }

    function hasMoved() public view returns (bool) {
        return _hasMoved;
    }

    // Returns true if the piece can take a piece at the specified position.
    // This does not take into account the state of the rest of the board (e.g., check situations, pieces in between).
    function canTake(uint8 to) external view returns (bool){
        return canMove(to);
    }
}