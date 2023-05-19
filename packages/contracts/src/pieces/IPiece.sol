// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

interface IPiece {
    event PieceMoved(uint8 pieceId, uint8 from, uint8 to);
    event PieceTaken(uint8 pieceId, uint8 at, uint8 byPieceId); // TODO ask Norswap about this
    event PiecePromoted(uint8 pieceId, uint8 at);

    // Returns the game ID of the game this piece belongs to.
    function getPieceId() external view returns (uint8);

    // Returns the name of the piece (e.g., "bishop", "knight", etc.)
    function getName() external view returns (string memory);

    // Returns the color of the piece ("white = false" or "black = true").
    function getColor() external view returns (bool);

    // Returns the current position of the piece.
    function getCurrentPosition() external view returns (uint8);

    // Returns if the piece can jump over other pieces (like a knight).
    function canJump() external view returns (bool);

    // Returns if the piece can promote
    function canPromote() external view returns (bool);

    function promotion() external returns (string memory);

    // Returns true if the piece can move to the specified position.
    // This does not take into account the state of the rest of the board (e.g., check situations).
    function canMove(uint8 to) external view returns (bool);

    // Moves the piece to the specified position.
    // Reverts if the move is not valid.
    function move(uint8 to) external;

    function hasMoved() external view returns (bool);  

    // Returns true if the piece can take a piece at the specified position.
    // This does not take into account the state of the rest of the board (e.g., check situations).
    function canTake(uint8 to) external view returns (bool);
}
