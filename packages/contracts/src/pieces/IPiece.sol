// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

interface IPiece {
    // event PieceMoved(uint8 pieceId, uint8 from, uint8 to);
    // event PieceTaken(uint8 pieceId, uint8 at, uint8 byPieceId); // TODO ask Norswap about this
    // event PiecePromoted(uint8 pieceId, uint8 at);

    // Returns if the piece can jump over other pieces (like a knight).
    function canJump() external view returns (bool);

    // Returns if the piece can promote
    function canPromote() external view returns (bool);

    function promotion() external view returns (string memory);

    // returns all the pseudo-legal moves for the piece (= all the squares this piece could go to)
    function generatePseudoLegalMoves(bytes32[64] memory) external view returns (uint8[] memory);
}
