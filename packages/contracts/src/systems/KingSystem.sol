// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import { System } from "@latticexyz/world/src/System.sol";
import { getUniqueEntity } from "@latticexyz/world/src/modules/uniqueentity/getUniqueEntity.sol";
import { StructLibrary } from "../StructLibrary.sol";

import { GameBoard } from "../codegen/Tables.sol";

import { Piece, Color } from "../codegen/Types.sol";

contract KingSystem is System {

    // either from & to = 65 and then we compute on the old position, otherwise we compute on the new position
    function getPseudoLegalKingMoves(uint8 from, uint8 to, uint8 pieceSquare) public view returns (uint8[64] memory) {
        uint8[64] memory moves; // maximum of 8 moves for a king

        uint8 indCnt = 0;
        unchecked {
        for(uint8 i = 0; i < 8; i++){ // once for each direction
            uint8 move = 0;
            if(i == 0){ // up
                move = pieceSquare + 8;
            } else if(i == 1){ // right
                move = pieceSquare + 1;
            } else if(i == 2){ // down
                move = pieceSquare - 8;
            } else if(i == 3){ // left
                move = pieceSquare - 1;
            } else if(i == 4){ // up right
                move = pieceSquare + 9;
            } else if(i == 5){ // down right
                move = pieceSquare - 7;
            } else if(i == 6){ // down left
                move = pieceSquare - 9;
            } else if(i == 7){ // up left
                move = pieceSquare + 7;
            }

            if(move > 63){ // if the move is off the board (move < 0 is not possible because of the uint8 type)
                break;
            }

            if (move == from) { // identical to (GameBoard.get(move).piece == Piece.Empty)
                moves[indCnt] = move;
                indCnt++;
            } else if (move == to) { // depends on the color of the piece
                if (to == pieceSquare) { // we have to get the color from the old position, .get(pieceSquare) would give a wrong result
                    if (GameBoard.get(from).color == GameBoard.get(from).color) {  // same color
                        break;
                    } else {  // different color
                        moves[indCnt] = move;
                        indCnt++;
                        break;
                    }
                } else {
                    if (GameBoard.get(pieceSquare).color == GameBoard.get(from).color) {  // same color
                        break;
                    } else {  // different color
                        moves[indCnt] = move;
                        indCnt++;
                        break;
                    }
                }
            } else {
                // if the square is empty
                if(GameBoard.get(move).piece == Piece.Empty){
                    moves[indCnt] = move;
                    indCnt++;
                } else if(GameBoard.get(move).color != GameBoard.get(pieceSquare).color) {  // if the square contains an enemy piece
                    moves[indCnt] = move;
                    indCnt++;
                    break;
                } else { // if the square has a friendly piece
                    break;
                }
            }
        }
        }
        return moves;
    }
    
}