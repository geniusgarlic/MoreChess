// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import { System } from "@latticexyz/world/src/System.sol";
import { getUniqueEntity } from "@latticexyz/world/src/modules/uniqueentity/getUniqueEntity.sol";
import { StructLibrary } from "../StructLibrary.sol";

import { IWorld} from "../codegen/world/IWorld.sol";

import { Piece, Color } from "../codegen/Types.sol";

import { GameBoard } from "../codegen/Tables.sol";
import { Turn } from "../codegen/Tables.sol";

import { PawnSystem } from "./PawnSystem.sol";
import { KnightSystem } from "./KnightSystem.sol";
import { BishopSystem } from "./BishopSystem.sol";
import { RookSystem } from "./RookSystem.sol";
import { QueenSystem } from "./QueenSystem.sol";
import { KingSystem } from "./KingSystem.sol";

contract GameSystem is System {

    function startGame() public {
        Turn.set(Color.White);
        for (uint8 i = 0; i < 64; i++) {
            if (i >= 8 && i <= 15) {
                GameBoard.setPiece(i, Piece.Pawn);
                GameBoard.setColor(i, Color.White);
            }
            else if (i >= 48 && i <= 55) {
                GameBoard.setPiece(i, Piece.Pawn);
                GameBoard.setColor(i, Color.Black);
            } 
            else if (i == 0 || i == 7) {
                GameBoard.setPiece(i, Piece.Rook);
                GameBoard.setColor(i, Color.White);
            }
            else if (i == 56 || i == 63) {
                GameBoard.setPiece(i, Piece.Rook);
                GameBoard.setColor(i, Color.Black);
            }
            else if (i == 1 || i == 6) {
                GameBoard.setPiece(i, Piece.Knight);
                GameBoard.setColor(i, Color.White);
            }
            else if (i == 57 || i == 62) {
                GameBoard.setPiece(i, Piece.Knight);
                GameBoard.setColor(i, Color.Black);
            }
            else if (i == 2 || i == 5) {
                GameBoard.setPiece(i, Piece.Bishop);
                GameBoard.setColor(i, Color.White);
            }
            else if (i == 58 || i == 61) {
                GameBoard.setPiece(i, Piece.Bishop);
                GameBoard.setColor(i, Color.Black);
            }
            else if (i == 3) {
                GameBoard.setPiece(i, Piece.Queen);
                GameBoard.setColor(i, Color.White);
            }
            else if (i == 59) {
                GameBoard.setPiece(i, Piece.Queen);
                GameBoard.setColor(i, Color.Black);
            }
            else if (i == 4) {
                GameBoard.setPiece(i, Piece.King);
                GameBoard.setColor(i, Color.White);
            }
            else if (i == 60) {
                GameBoard.setPiece(i, Piece.King);
                GameBoard.setColor(i, Color.Black);
            }
            else {
                GameBoard.setPiece(i, Piece.Empty);
                GameBoard.setColor(i, Color.Empty);
            }
        }
    }

    function getBoard() private view returns (Piece[64] memory, Color[64] memory) {
        Piece[64] memory boardPieces;
        Color[64] memory boardColors;
        for (uint8 i = 0; i < 64; i++) {
            boardPieces[i]= GameBoard.get(i).piece;
            boardColors[i]= GameBoard.get(i).color;
        }
        return (boardPieces, boardColors);
    }

    function getPseudoLegalMoves(Piece piece, uint8 from, uint8 to, uint8 pieceSquare) private view returns (uint8[64] memory) {
        uint8[64] memory moves;
        if (piece == Piece.Pawn) {
            moves = IWorld(_world()).getPseudoLegalPawnMoves(from, to, pieceSquare);
        } else if (piece == Piece.Knight) {
            moves = IWorld(_world()).getPseudoLegalKnightMoves(from, to, pieceSquare);
        } else if (piece == Piece.Bishop) {
            moves = IWorld(_world()).getPseudoLegalBishopMoves(from, to, pieceSquare);
        } else if (piece == Piece.Rook) {
            moves = IWorld(_world()).getPseudoLegalRookMoves(from, to, pieceSquare);
        } else if (piece == Piece.Queen) {
            moves = IWorld(_world()).getPseudoLegalQueenMoves(from, to, pieceSquare);
        } else if (piece == Piece.King) {
            moves = IWorld(_world()).getPseudoLegalKingMoves(from, to, pieceSquare);
        } else {
            revert("Piece not recognized");
        }
        return moves;
    }

    function movePiece(uint8 from, uint8 to) public {
        Piece[64] memory boardPieces;
        Color[64] memory boardColors;
        (boardPieces, boardColors) = getBoard();
        Color turnColor = Turn.get();

        if (boardPieces[from] == Piece.Empty) {
            revert("No piece to move");
        }
        if (boardColors[from] != turnColor)  {
            revert("Not your turn");
        }
        if (boardColors[to] == turnColor) {
            revert("Cannot capture own piece");
        }

        Piece movingPiece = boardPieces[from];

        uint8[64] memory movingPiecePseudoLegalMoves = getPseudoLegalMoves(movingPiece, 65, 65, from);
        for (uint i = 0; i < 65; i++) {
            if (movingPiecePseudoLegalMoves[i] == to) {
                //move is pseudo legal (meaning the piece can move / capture that square, but maybe there is a check that prevents it)
                break;
            }
            if (i == 64) {
                revert("Move is not pseudo legal");
            }
        }

        // todo remove new and just modify existing arrays
        boardPieces[to] = movingPiece;
        boardColors[to] = turnColor;
        boardPieces[from] = Piece.Empty;
        boardColors[from] = Color.Empty;

        // now check if the board position causes a problem (discovered check / not reacting to check)
        //first get the position from the kings
        uint8 newEnnemyKingPosition;
        uint8 newKingPosition; // this king is the same king as kingPosition (maybe not in the same position)
        for (uint8 i = 0; i < 64; i++) {
            if (boardPieces[i] == Piece.King) {
                if (boardColors[i] == turnColor) {
                    newKingPosition = i;
                } else {
                    newEnnemyKingPosition = i;
                }
            }
        }

        uint8[64][16] memory newEnnemyPseudoLegalMoves; // 16 pieces
        uint8[64][16] memory newPseudoLegalMoves;

        uint8 ind = 0;
        uint8 indEnnemy = 0;
        for (uint8 i = 0; i < 64; i++) {
            if (boardPieces[i] != Piece.Empty) {
                if (boardColors[i] == turnColor) {
                    newPseudoLegalMoves[ind] = getPseudoLegalMoves(boardPieces[i], from, to, i);
                    ind++;
                } else {
                    newEnnemyPseudoLegalMoves[indEnnemy] = getPseudoLegalMoves(boardPieces[i], from, to, i);
                    indEnnemy++;
                }
                if (ind == 16 && indEnnemy == 16) {
                    break;
                }
            }
        }
        
        for (uint i = 0; i < 16; i++) {
            for (uint j = 0; j < 64; j++) {
                if (newEnnemyPseudoLegalMoves[i][j] == newKingPosition) {
                    // the king of the color that made the move is in check after the move
                    revert("King is in check"); // =  discovered check or not reacting to check
                }
            }
        }
        for (uint i = 0; i < 16; i++) {
            for (uint j = 0; j < 64; j++) {
                if (newPseudoLegalMoves[i][j] == newEnnemyKingPosition) {
                    // the king of the color that did not make the move is in check after the move, so it may be checkmate
                    // if (isWin()) {
                    //     // todo game over
                    // }
                    break;
                }
            }
        }

        // now we know the move is legal, so we can update the board
        Turn.set(turnColor == Color.White ? Color.Black : Color.White);
        GameBoard.setPiece(to, movingPiece);
        GameBoard.setColor(to, turnColor);
        GameBoard.setPiece(from, Piece.Empty);
        GameBoard.setColor(from, Color.Empty);
    }
}
