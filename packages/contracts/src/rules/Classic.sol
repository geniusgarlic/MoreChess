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
    bool private _currentColorTurn;
    bytes32[64] private _currentPosition;

    constructor(bool startingColor) {
        _currentColorTurn = startingColor;
        _currentPosition = startingPosition();
    }

    function startingPosition() public pure override returns (bytes32[64] memory) {
        bytes32[64] memory data;
        for (uint8 i = 0; i < 64; i++) {
            if (i >= 8 && i <= 15) {
                data[i] = "0 Pawn";
            }
            else if (i >= 48 && i <= 55) {
                data[i] = "1 Pawn";
            } 
            else if (i == 0 || i == 7) {
                data[i] = "0 Rook";
            }
            else if (i == 56 || i == 63) {
                data[i] = "1 Rook";
            }
            else if (i == 1 || i == 6) {
                data[i] = "0 Knight";
            }
            else if (i == 57 || i == 62) {
                data[i] = "1 Knight";
            }
            else if (i == 2 || i == 5) {
                data[i] = "0 Bishop";
            }
            else if (i == 58 || i == 61) {
                data[i] = "1 Bishop";
            }
            else if (i == 3) {
                data[i] = "0 Queen";
            }
            else if (i == 59) {
                data[i] = "1 Queen";
            }
            else if (i == 4) {
                data[i] = "0 King";
            }
            else if (i == 60) {
                data[i] = "1 King";
            }
            else {
                data[i] = "";
            }
        }
        return data;
    }

    // checks if a move from square 'from' to 'square' is legal, and if it is, returns the new board state, also updates all relevant values
    function playMove(uint8 from, uint8 to) public returns (bytes32[64] memory) {
        // TODO: take into account special rules like castling, en passant, etc.
        IPiece actionPiece = stringToPiece(from);

        if (actionPiece.getColor() != _currentColorTurn) {
            revert("Not your turn");
        }
        if (!actionPiece.canMove(to)) {
            revert("Piece cannot move to that square");
        }
        if (!actionPiece.canTake(to)) {
            revert("Piece cannot take that square");
        }

        // now check if the board position causes a problem (discovered check / not reacting to check)
        //discovered check

        // not reacting to check

        // now we know the move is legal, so we can update the board
        _currentPosition[to] = _currentPosition[from];
        _currentPosition[from] = "";

        _currentColorTurn = !_currentColorTurn;
        
        // checks for a win
        if (isWin()) {
            // TODO: game over
        }

        return _currentPosition;
    }

    function stringToPiece(bytes32[64] memory position, uint8 from) private returns(IPiece) {
        // input is "0/1 pieceName" 0 is white and 1 is black
        bytes32 pieceName = position[from];
        bool color = pieceName[0] == "0" ? false : true;
        string memory name = string(abi.encodePacked(pieceName[2:]));

        if (keccak256(bytes(name)) == keccak256(bytes("Pawn"))) {
            return new Pawn(from, color);
        }
        else if (keccak256(bytes(name)) == keccak256(bytes("Knight"))) {
            return new Knight(from, color);
        }
        else if (keccak256(bytes(name)) == keccak256(bytes("Bishop"))) {
            return new Bishop(from, color);
        }
        else if (keccak256(bytes(name)) == keccak256(bytes("Rook"))) {
            return new Rook(from, color);
        }
        else if (keccak256(bytes(name)) == keccak256(bytes("Queen"))) {
            return new Queen(from, color);
        }
        else if (keccak256(bytes(name)) == keccak256(bytes("King"))) {
            return new King(from, color);
        }
        else {
            revert("Invalid piece name");
        }

    }

    function generatePseudoLegalMoves(bytes32[64] memory position, bool color) public pure returns (uint8[64][] memory) {
        uint8[64][] memory moves = new uint8[64][]();

        for (uint8 i = 0; i < 64; i++) {
            // check each square for a piece, if it is the color of the one playing, generate the pseudo legal moves for this piece.
            bool pieceColor = position[i][0] == "0" ? false : true;
            if (pieceColor == color) {
                IPiece piece = stringToPiece(position, i);
                moves[i] = piece.generatePseudoLegalMoves(position);
            }
            // TODO J'ETAIS ICI ET JE PENSE QUE JE DOIS GENERER LES PSEUDOLEGAUX DE L'AUTRE COULEUR AVEC LE NVEAU STATE PR VOIR SI IL Y A ECHEC
            // JE PARLE BIEN DE LE FAIRE DANS LA FONCTION D'AU DESSUS PLAYMOVE
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