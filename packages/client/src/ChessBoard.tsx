import React from 'react';

type ChessBoardProps = {
  renderSquare: (row: number, col: number) => JSX.Element | null;
}

const ChessBoard: React.FC<ChessBoardProps> = ({ renderSquare }) => {
  const rows = new Array(8).fill(null);
  const cols = new Array(8).fill(null);

  return (
    <div className="inline-grid grid-cols-8 box-border">
      {rows.map((_, rowIndex) => 
        cols.map((_, colIndex) => (
          <div 
            key={`${rowIndex}-${colIndex}`} 
            className={`h-20 w-20 border-2 box-content ${((rowIndex + colIndex) % 2 === 0) ? 'bg-white' : 'bg-black'}`}
          >
            {renderSquare(7 - rowIndex, colIndex)}
          </div>
        ))
      )}
    </div>
  );
}

export default ChessBoard;
