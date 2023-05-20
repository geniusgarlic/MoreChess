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
  //console.log(boardData?.value.value);
  let stringArray: string[] = (boardData?.value.value || []).map(bytes32 => Web3.utils.hexToAscii(bytes32).replace(/\x00/g, ''));  


  // Initialize an 8x8 array with null
  const [board, setBoard] = useState<BoardContent[][]>(Array(8).fill(null).map(() => Array(8).fill(null)));

  const addToBoard = (row: number, col: number, type: 'text' | 'img', value: string) => {
    // Avoid mutating state directly
    const newBoard = JSON.parse(JSON.stringify(board));
    newBoard[row][col] = { type, value };
    setBoard(newBoard);
  };

  const clearSquare = (row: number, col: number) => {
    const newBoard = JSON.parse(JSON.stringify(board));
    newBoard[row][col] = null;
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
      newBoard[row][col] = { type: 'text', value: item };
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

        <button onClick={() => addToBoard(0, 0, 'img', "https://upload.wikimedia.org/wikipedia/commons/thumb/4/45/Chess_plt45.svg/1024px-Chess_plt45.svg.png")}>
          Add image to (0, 0)
        </button>

        <button onClick={() => clearSquare(0, 0)}>
          Clear (0, 0)
        </button>

        <button onClick={() => {startGame(); renderBoardData(stringArray);}}>
          Start Game
        </button>

        <button onClick={() => clearBoard()}>
          Clear Board
        </button>
      </div>

    </div>
  );
}

export default App;