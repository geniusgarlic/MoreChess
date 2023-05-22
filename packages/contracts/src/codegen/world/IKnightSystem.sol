// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

/* Autogenerated file. Do not edit manually. */

interface IKnightSystem {
  function getPseudoLegalKingnightMoves(
    uint8 from,
    uint8 to,
    uint8 pieceSquare
  ) external view returns (uint8[64] memory);
}