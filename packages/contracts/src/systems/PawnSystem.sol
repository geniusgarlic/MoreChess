// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import { System } from "@latticexyz/world/src/System.sol";
import { getUniqueEntity } from "@latticexyz/world/src/modules/uniqueentity/getUniqueEntity.sol";
import { StructLibrary } from "../StructLibrary.sol";

import { GameBoard, Turn } from "../codegen/Tables.sol";

import { Piece, Color } from "../codegen/Types.sol";

contract PawnSystem is System {

    // either from & to = 65 and then we compute on the old position, otherwise we compute on the new position
    function getPseudoLegalPawnMoves(uint8 from, uint8 to, uint8 pieceSquare) public view returns (uint8[64] memory) {
        uint8[64] memory moves; // maximum of 4 moves for a pawn

        uint8 indCnt = 0;
        unchecked {
            uint8[4] memory moveArray;

            Color pieceColor = GameBoard.get(pieceSquare).color;
            if (from != 65) {
                if (pieceSquare == to) {
                    pieceColor = GameBoard.get(from).color;
                }
            }

            if (pieceColor == Color.White) {
                if (pieceSquare < 16) { // the pawn has not moved yet
                    moveArray = [pieceSquare + 7, pieceSquare + 9, pieceSquare + 8, pieceSquare + 16];
                } else {
                    moveArray = [pieceSquare + 7, pieceSquare + 9, pieceSquare + 8, 66];
                }
            } else {
                if (pieceSquare > 48) { // the pawn has not moved yet
                    moveArray = [pieceSquare - 7, pieceSquare - 9, pieceSquare - 8, pieceSquare - 16];
                } else {
                    moveArray = [pieceSquare - 7, pieceSquare - 9, pieceSquare - 8, 66];
                }
            }

            for (uint8 ind = 0; ind < 4; ind++) {
                if (moveArray[ind] == 66) {
                    break;
                }
                if (ind > 1) { // pawn cannot eat by moving forward
                    if ((GameBoard.get(moveArray[ind]).piece != Piece.Empty && moveArray[ind] != from) || moveArray[ind] == to) {
                        continue;
                    } else {
                        moves[indCnt] = moveArray[ind];
                        indCnt++;
                    }
                } else { // pawn can capture but not move
                    if (moveArray[ind] == from) {
                        continue;
                    } else if (moveArray[ind] == to) {
                        if (GameBoard.get(from).color != pieceColor) {
                            moves[indCnt] = moveArray[ind];
                            indCnt++;
                        }
                    } else {
                        if (GameBoard.get(moveArray[ind]).color != pieceColor) {
                            moves[indCnt] = moveArray[ind];
                            indCnt++;
                        }
                    }
                }
            }
        }
        return moves;
    }
    
}
