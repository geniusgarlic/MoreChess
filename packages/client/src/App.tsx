import { useRows } from "@latticexyz/react";
import { useMUD } from "./MUDContext";
import ChessBoard from './ChessBoard';
import { useState, useEffect, useCallback } from "react";

import { Piece, Color } from './enumTypes';

type BoardContent = { type: 'text' | 'img', value: string } | null;

function App() {
  const {
    components: { 
      GameBoard,
      Turn,
      GameOver,
     },
    systemCalls: { 
      startGame,
      movePiece
    },
    network: { storeCache },
  } = useMUD();
  

  const boardData = useRows(storeCache, {table: "GameBoard"});
  const turnData = useRows(storeCache, {table: "Turn"});
  const gameOverData = useRows(storeCache, {table: "GameOver"});

  const [lastClickedSquare, setLastClickedSquare] = useState<number | null>(null);
  const [lastClickedSquares, setLastClickedSquares] = useState<number[]>([]);


  // white + black (pawn, knight, bishop, rook, queen, king) (0 is white pawn, 1 black pawn, 2 white knight, etc.)
  const pieceURLs = [
    "https://upload.wikimedia.org/wikipedia/commons/thumb/4/45/Chess_plt45.svg/1024px-Chess_plt45.svg.png",
    "https://upload.wikimedia.org/wikipedia/commons/thumb/c/c7/Chess_pdt45.svg/1024px-Chess_pdt45.svg.png",
    "https://upload.wikimedia.org/wikipedia/commons/thumb/7/70/Chess_nlt45.svg/1024px-Chess_nlt45.svg.png",
    "https://upload.wikimedia.org/wikipedia/commons/thumb/e/ef/Chess_ndt45.svg/1024px-Chess_ndt45.svg.png",
    "https://upload.wikimedia.org/wikipedia/commons/thumb/b/b1/Chess_blt45.svg/1024px-Chess_blt45.svg.png",
    "https://upload.wikimedia.org/wikipedia/commons/thumb/9/98/Chess_bdt45.svg/1024px-Chess_bdt45.svg.png",
    "https://upload.wikimedia.org/wikipedia/commons/thumb/7/72/Chess_rlt45.svg/1024px-Chess_rlt45.svg.png",
    "https://upload.wikimedia.org/wikipedia/commons/thumb/f/ff/Chess_rdt45.svg/1024px-Chess_rdt45.svg.png",
    "https://upload.wikimedia.org/wikipedia/commons/thumb/1/15/Chess_qlt45.svg/1024px-Chess_qlt45.svg.png",
    "https://upload.wikimedia.org/wikipedia/commons/thumb/4/47/Chess_qdt45.svg/1024px-Chess_qdt45.svg.png",
    "https://upload.wikimedia.org/wikipedia/commons/thumb/4/42/Chess_klt45.svg/1024px-Chess_klt45.svg.png",
    "https://upload.wikimedia.org/wikipedia/commons/thumb/f/f0/Chess_kdt45.svg/1024px-Chess_kdt45.svg.png"
  ];

  const getPieceUrl = (item: any) => { // piece & color are numbers (format is {piece, color})
      if (item.piece == 6) {
        return "";
      }
      return pieceURLs[(item.piece * 2) + item.color];
  };


  // Initialize an 8x8 array with null
  const [board, setBoard] = useState<BoardContent[][]>(Array(8).fill(null).map(() => Array(8).fill(null)));

  const addToBoard = (row: number, col: number, type: 'text' | 'img', value: string) => {
    // Avoid mutating state directly
    const newBoard = JSON.parse(JSON.stringify(board));
    newBoard[row][col] = { type, value };
    return newBoard;
  };

  const clearSquare = (row: number, col: number) => {
    const newBoard = JSON.parse(JSON.stringify(board));
    newBoard[row][col] = null;
    setBoard(newBoard);
  };

  const movePiecePromise = (from: number, to: number) => {
    return new Promise((resolve, reject) => {
      try {
        const result = movePiece(from, to);
        // Here, I'm assuming that movePiece returns some result. 
        // If it's a success indicator, you can check it and call resolve or reject accordingly.
        if (true) { // Modify this line based on the actual return value of movePiece
          resolve(result);
        }
      } catch (error) {
        reject(error);
      }
    });
  };

  const moveTo = (from: number, to: number) => {
    var newBoard = JSON.parse(JSON.stringify(board));
    const fromRow = Math.floor(from / 8);
    const fromCol = from % 8;
    const toRow = Math.floor(to / 8);
    const toCol = to % 8;

    if(!newBoard[fromRow][fromCol]) {
      console.log("error in moveTo: no piece at from square");
      return;
    }

    newBoard = addToBoard(toRow, toCol, 'img', getPieceUrl(boardData[from].value));
    newBoard[fromRow][fromCol] = null;
    console.log(newBoard);
    setBoard(newBoard);
  };

  const clearBoard = () => {
    const newBoard = Array(8).fill(null).map(() => Array(8).fill(null));
    setBoard(newBoard);
  };

  const renderBoardData = () => {
    const newBoard = JSON.parse(JSON.stringify(board));
    
    boardData.forEach((item: any, index: number) => {
      const row = Math.floor(index / 8);
      const col = index % 8;
      const url = getPieceUrl(item.value);
      if (url != "") {
        newBoard[row][col] = { type: 'img', value: getPieceUrl(item.value) };
      }
    });
    setBoard(newBoard);
  };

  useEffect(() => {
    if (lastClickedSquares.length === 2) {
        setLastClickedSquares([]);
        movePiecePromise(lastClickedSquares[0], lastClickedSquares[1])
      .then(() => {
        moveTo(lastClickedSquares[0], lastClickedSquares[1]);
      })
      .catch((error) => {
        console.error('Move failed', error);
      });
        
    }
}, [lastClickedSquares, movePiece, moveTo]);



  return (
    <div className="App">
        <div>
          <ChessBoard 
            renderSquare={(row, col) => {
              const content = board[row][col];
              if (!content) return null;
              if (content.type === 'text') return <p className="text-center text-white">{content.value}</p>;
              if (content.type === 'img') return <img src={content.value} width={75} height={75} alt="" className="h-full w-full object-cover" />;
              return null;
            }}
            onSquareClick={(squareIndex) => {
              if (lastClickedSquares.length === 2) {
                setLastClickedSquares([lastClickedSquares[1], squareIndex]);
              } else {
                setLastClickedSquares([...lastClickedSquares, squareIndex]);
              }
            }}
            lastClickedSquare={lastClickedSquare}
          />
        </div>
        

      <div className="grid absolute left-0">

        <button onClick={() => startGame()}>
          Start Position / Reset
        </button>

        <button onClick={() => renderBoardData()}>
          Start Game
        </button>

        <button onClick={() => {
          console.log(boardData);
          console.log(boardData[60].value);
          }}>
          Log
        </button>

        <button onClick={() => {
          movePiece(8, 16);
          moveTo(8, 16);
        }}>
          Move test
        </button>


        <button onClick={() => {
          console.log(turnData[0].value.turn?"Black":"White");
        }}>
          Turn
        </button>

        <button onClick={() => {
          console.log(gameOverData[0].value.checkmate);
        }}>
          Checkmate ?
        </button>
        
      </div>

    </div>
  );
}
//Checkmate: {gameOverData.value.checkmate}
export default App;