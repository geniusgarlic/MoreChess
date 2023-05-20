import { useComponentValue, useEntityQuery, useRow } from "@latticexyz/react";
import { useMUD } from "./MUDContext";
import ChessBoard from './ChessBoard';
import { useState } from "react";
import Web3 from 'web3';

type BoardContent = { type: 'text' | 'img', value: string } | null;

function App() {
  const {
    components: { BoardState },
    systemCalls: { startGame },
    network: { storeCache },
  } = useMUD();
  
  var boardData = useRow(storeCache, {table: "BoardState", key: {}}); //boardData?.value
  var stringArray = (boardData?.value.value || []).map(bytes32 => Web3.utils.hexToAscii(bytes32).replace(/\x00/g, ''));

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

  const pieceTypes = ['Pawn', 'Knight', 'Bishop', 'Rook', 'Queen', 'King'];
  const pieceColors = ['0', '1'];

  const getPieceUrl = (pieceString: string) => {
      if (!pieceString) {
        return null;
      }

      const [color, type] = pieceString.split(' ');
      const colorIndex = pieceColors.indexOf(color);
      const typeIndex = pieceTypes.indexOf(type);

      if(colorIndex === -1 || typeIndex === -1) {
          throw new Error('Invalid piece string');
      }

      const urlIndex = typeIndex * 2 + colorIndex;

      return pieceURLs[urlIndex];
  };


  // Initialize an 8x8 array with null
  const [board, setBoard] = useState<BoardContent[][]>(Array(8).fill(null).map(() => Array(8).fill(null)));

  const addToBoard = (row: number, col: number, type: 'text' | 'img', value: string) => {
    // Avoid mutating state directly
    const newBoard = JSON.parse(JSON.stringify(board));
    newBoard[row][col] = { type, value };
    setBoard(newBoard);
    return newBoard;
  };

  const clearSquare = (row: number, col: number) => {
    const newBoard = JSON.parse(JSON.stringify(board));
    newBoard[row][col] = null;
    setBoard(newBoard);
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

    newBoard = addToBoard(toRow, toCol, 'img', "https://upload.wikimedia.org/wikipedia/commons/thumb/7/72/Chess_rlt45.svg/1024px-Chess_rlt45.svg.png");
    newBoard[fromRow][fromCol] = null;
    setBoard(newBoard);
  };

  const clearBoard = () => {
    const newBoard = Array(8).fill(null).map(() => Array(8).fill(null));
    setBoard(newBoard);
  };

  const renderBoardData = (data: string[]) => {
    

    const newBoard = JSON.parse(JSON.stringify(board));
    
    data.forEach((item, index) => {
      const row = Math.floor(index / 8);
      const col = index % 8;
      newBoard[row][col] = { type: 'img', value: getPieceUrl(item) };
    });
    
    setBoard(newBoard);
  };

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
          />
        </div>
        

      <div className="grid absolute left-0">

        <button onClick={() => addToBoard(0, 0, 'img', "https://upload.wikimedia.org/wikipedia/commons/thumb/7/72/Chess_rlt45.svg/1024px-Chess_rlt45.svg.png")}>
          Add image to (0, 0)
        </button>

        <button onClick={() => clearSquare(0, 0)}>
          Clear (0, 0)
        </button>

        <button onClick={() => startGame()}>
          Load Pieces
        </button>

        <button onClick={() => renderBoardData(stringArray)}>
          Start Game
        </button>

        <button onClick={() => clearBoard()}>
          Clear Board
        </button>

        <button onClick={() => moveTo(0, 58)}>
          Move test
        </button>
      </div>

    </div>
  );
}

export default App;