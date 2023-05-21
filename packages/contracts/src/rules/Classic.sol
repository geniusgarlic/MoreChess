// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import {IRule} from "./IRule.sol";
import {IPiece} from "../pieces/IPiece.sol";
import {Pawn} from "../pieces/Pawn.sol";
import {Knight} from "../pieces/Knight.sol";
import {Bishop} from "../pieces/Bishop.sol";
import {Rook} from "../pieces/Rook.sol";
import {Queen} from "../pieces/Queen.sol";
import {King} from "../pieces/King.sol";

contract Classic is IRule{
    string private _currentColorTurn;
    Piece[64] private _currentPosition;
    
    constructor(string startingColor) {
        _currentColorTurn = startingColor;
        _currentPosition = startingPosition();
    }

    function cmpStr(string memory a, string memory b) internal pure returns (bool) {
        return (keccak256(abi.encodePacked((a))) == keccak256(abi.encodePacked((b))));
    }

    function startingPosition() public pure override returns (Piece[64] memory) {
        Piece[64] memory data;
        for (uint8 i = 0; i < 64; i++) {
            if (i >= 8 && i <= 15) {
                data[i] = Piece("Pawn", "white");
            }
            else if (i >= 48 && i <= 55) {
                data[i] = Piece("Pawn", "black");
            } 
            else if (i == 0 || i == 7) {
                data[i] = Piece("Rook", "white");
            }
            else if (i == 56 || i == 63) {
                data[i] = Piece("Rook", "black");
            }
            else if (i == 1 || i == 6) {
                data[i] = Piece("Knight", "white");
            }
            else if (i == 57 || i == 62) {
                data[i] = Piece("Knight", "black");
            }
            else if (i == 2 || i == 5) {
                data[i] = Piece("Bishop", "white");
            }
            else if (i == 58 || i == 61) {
                data[i] = Piece("Bishop", "black");
            }
            else if (i == 3) {
                data[i] = Piece("Queen", "white");
            }
            else if (i == 59) {
                data[i] = Piece("Queen", "black");
            }
            else if (i == 4) {
                data[i] = Piece("King", "white");
            }
            else if (i == 60) {
                data[i] = Piece("King", "black");
            }
            else {
                data[i] = Piece("empty", "empty");
            }
        }
        return data;
    }

    // checks if a move from square 'from' to 'square' is legal, and if it is, returns the new board state, also updates all relevant values
    function playMove(uint8 from, uint8 to) public view override returns (Piece[64] memory) {
        // TODO: take into account special rules like castling, en passant, etc.
        if (_currentPosition[from].name == "empty") {
            revert("No piece to move");
        }
        if (!cmpStr(_currentPosition[from].color, _currentColorTurn)) {
            revert("Not your turn");
        }
        if (cmpStr(_currentPosition[to].color, _currentColorTurn)) {
            revert("Cannot capture own piece");
        }

        IPiece actionPiece = stringToPiece(_currentPosition, from);

        uint8[] memory actionPiecePseudoLegalMoves = actionPiece.generatePseudoLegalMoves(_currentPosition);
        for (uint i; i < actionPiecePseudoLegalMoves.length + 1; i++) {
            if (i == actionPiecePseudoLegalMoves.length) {
                revert("Move is not legal");
            }
            if (actionPiecePseudoLegalMoves[i] == to) {
                // the move is legal
                break;
            }
        }

        Piece[64] memory newPosition = _currentPosition;
        newPosition[to] = newPosition[from];
        newPosition[from] = new Piece("empty", "empty");

        // now check if the board position causes a problem (discovered check / not reacting to check)
        //first get the position from the kings
        uint8 newEnnemyKingPosition;
        uint8 newKingPosition; // this king is the same king as kingPosition (maybe not in the same position)
        for (uint i; i < 64; i++) {
            if (cpmStr(newPosition[i].name, "King")) {
                if (cmpStr(newPosition[i].color, cmpStr(_currentColorTurn, "white")?"black":"white")) {
                    newEnnemyKingPosition = i;
                } else {
                    newKingPosition = i;
                }
            }
        }


        uint8[16][] memory newEnnemyPseudoLegalMoves = generatePseudoLegalMoves(newPosition, !_currentColorTurn);
        uint8[64][] memory newPseudoLegalMoves = generatePseudoLegalMoves(newPosition, _currentColorTurn);
        
        for (uint i; i < newEnnemyPseudoLegalMoves.length; i++) {
            if (newEnnemyPseudoLegalMoves[i].length > 0) {
                for (uint j; j < newEnnemyPseudoLegalMoves[i].length; j++) {
                    if (newEnnemyPseudoLegalMoves[i][j] == newKingPosition) {
                        // the king of the color that made the move is in check after the move
                        revert("King is in check"); // discovered check or not reacting to check
                    }
                }
            }
        }
        for (uint i; i < newPseudoLegalMoves.length; i++) {
            if (newPseudoLegalMoves[i].length > 0) {
                for (uint j; j < newPseudoLegalMoves[i].length; j++) {
                    if (newPseudoLegalMoves[i][j] == newEnnemyKingPosition) {
                        // the king of the color that did not make the move is in check after the move, so it may be checkmate
                        if (isWin()) {
                            // todo game over
                        }
                    }
                }
            }
        }
        // if we get here, there were no checks issues so we can update the board

        // now we know the move is legal, so we can update the board
        _currentPosition[to] = _currentPosition[from];
        _currentPosition[from] = new Piece("empty", "empty");

        _currentColorTurn = cmpStr(_currentColorTurn, "white")?"black":"white";
        
        // checks for a draw
        if (isDraw()) {
            // TODO: game over (prob draw not here)
        }

        return _currentPosition;
    }

    function stringToPiece(Piece[64] memory position, uint8 from) private returns(IPiece) {
        // input is "0/1 pieceName" 0 is white and 1 is black
        string memory name = position[from].name;
        string memory color = position[from].color;

        if (name == "Pawn") {
            return new Pawn(from, color);
        }
        else if (name == "Knight") {
            return new Knight(from, color);
        }
        else if (name == "Bishop") {
            return new Bishop(from, color);
        }
        else if (name == "Rook") {
            return new Rook(from, color);
        }
        else if (name == "Queen") {
            return new Queen(from, color);
        }
        else if (name == "King") {
            return new King(from, color);
        } else {
            revert("Invalid piece name");
        }

    }

    function generatePseudoLegalMoves(Piece[64] memory position, string toPlayColor) public pure returns (uint8[64][] memory) {
        uint8[16][] memory moves = new uint8[16][](); // maximum of 16 pieces for a color

        uint8 indexCnt = 0;
        for (uint8 i = 0; i < 64; i++) {
            // check each square for a piece, if it is the color of the one playing, generate the pseudo legal moves for this piece.
            string pieceColor = position[i].color;
            if (pieceColor == toPlayColor) {
                IPiece piece = stringToPiece(position, i);
                moves[indexCnt] = piece.generatePseudoLegalMoves(position);
                indexCnt++;
            }
        }
        return moves;
    }

    // checks if there is a check for the king of color 'color' in the position 'newPosition'
    function isCheck(bool color, bytes32[64] memory newPosition) public returns (bool) {
        return false; // TODO
    }

    // returns true if a state corresponds to a finished game
    function isWin() public pure override returns (bool) {
        return false;
        // TODO: here basically we'll have imported the king contract and we have as input a position, if the king is in checkmate then it's a win
    }

    function isDraw() public pure override returns (bool) {
        return false;
        // must check: repetitions, 50 moves without capture or pawn move, stalemate (no legal move), insufficient material
    }

    // returns false if it white turn to play, true if it is black turn to play
    function isTurn() public view override returns (bool) {
        return _currentColorTurn;
    }
    
}