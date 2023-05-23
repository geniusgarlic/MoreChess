// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

/* Autogenerated file. Do not edit manually. */

import { Piece, Color } from "./../Types.sol";

interface IGameSystem {
  function startGame() external;

  function getBoard() external view returns (Piece[64] memory, Color[64] memory);

  function movePiece(uint8 from, uint8 to) external;
}
