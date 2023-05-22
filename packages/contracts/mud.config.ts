import { mudConfig } from "@latticexyz/world/register";

export default mudConfig({
  enums: {
    Piece: ["Pawn", "Knight", "Bishop", "Rook", "Queen", "King", "Empty"],
    Color: ["White", "Black", "Empty"],
  },
  tables: {
    GameBoard: {
      keySchema: {square: "uint8"},
      schema: {
        piece: "Piece",
        color: "Color",
      },
    },
    Turn : {
      keySchema: {},
      schema: {turn: "Color"},
    }
  },
  modules: [
    {
      name: "UniqueEntityModule",
      root: true,
      args: [],
    }
  ]
});
