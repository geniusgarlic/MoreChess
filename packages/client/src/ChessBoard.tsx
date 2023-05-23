import React from 'react';

type ChessBoardProps = {
  renderSquare: (row: number, col: number) => JSX.Element | null;
  onSquareClick: (index: number) => void;
  lastClickedSquare: number | null;
}

const ChessBoard: React.FC<ChessBoardProps> = ({ renderSquare, onSquareClick, lastClickedSquare }) => {
  const rows = new Array(8).fill(null);
  const cols = new Array(8).fill(null);

  const handleClick = (rowIndex: number, colIndex: number) => {
    onSquareClick(rowIndex * 8 + colIndex);
  };

return (
    <div className="inline-grid grid-cols-8 box-border">
      {rows.map((_, rowIndex) => 
        cols.map((_, colIndex) => (
          <div 
            key={`${(7-rowIndex) * 8 + colIndex}`} 
            className={`h-20 w-20 box-content border-2 ${((rowIndex + colIndex) % 2 === 0) ? 'bg-white border-gray-300' : 'bg-gray-700 border-gray-300'}
              ${(7-rowIndex) * 8 + colIndex === lastClickedSquare ? 'border-2 border-indigo-600' : ''}`}
            onClick={() => {
              handleClick(7 - rowIndex, colIndex);
            }}
          >
            {renderSquare(7 - rowIndex, colIndex)}
          </div>
        ))
      )}
    </div>
  );
}

export default ChessBoard;
