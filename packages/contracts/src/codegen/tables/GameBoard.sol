// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

/* Autogenerated file. Do not edit manually. */

// Import schema type
import { SchemaType } from "@latticexyz/schema-type/src/solidity/SchemaType.sol";

// Import store internals
import { IStore } from "@latticexyz/store/src/IStore.sol";
import { StoreSwitch } from "@latticexyz/store/src/StoreSwitch.sol";
import { StoreCore } from "@latticexyz/store/src/StoreCore.sol";
import { Bytes } from "@latticexyz/store/src/Bytes.sol";
import { Memory } from "@latticexyz/store/src/Memory.sol";
import { SliceLib } from "@latticexyz/store/src/Slice.sol";
import { EncodeArray } from "@latticexyz/store/src/tightcoder/EncodeArray.sol";
import { Schema, SchemaLib } from "@latticexyz/store/src/Schema.sol";
import { PackedCounter, PackedCounterLib } from "@latticexyz/store/src/PackedCounter.sol";

// Import user types
import { Piece, Color } from "./../Types.sol";

bytes32 constant _tableId = bytes32(abi.encodePacked(bytes16(""), bytes16("GameBoard")));
bytes32 constant GameBoardTableId = _tableId;

struct GameBoardData {
  Piece piece;
  Color color;
}

library GameBoard {
  /** Get the table's schema */
  function getSchema() internal pure returns (Schema) {
    SchemaType[] memory _schema = new SchemaType[](2);
    _schema[0] = SchemaType.UINT8;
    _schema[1] = SchemaType.UINT8;

    return SchemaLib.encode(_schema);
  }

  function getKeySchema() internal pure returns (Schema) {
    SchemaType[] memory _schema = new SchemaType[](1);
    _schema[0] = SchemaType.UINT8;

    return SchemaLib.encode(_schema);
  }

  /** Get the table's metadata */
  function getMetadata() internal pure returns (string memory, string[] memory) {
    string[] memory _fieldNames = new string[](2);
    _fieldNames[0] = "piece";
    _fieldNames[1] = "color";
    return ("GameBoard", _fieldNames);
  }

  /** Register the table's schema */
  function registerSchema() internal {
    StoreSwitch.registerSchema(_tableId, getSchema(), getKeySchema());
  }

  /** Register the table's schema (using the specified store) */
  function registerSchema(IStore _store) internal {
    _store.registerSchema(_tableId, getSchema(), getKeySchema());
  }

  /** Set the table's metadata */
  function setMetadata() internal {
    (string memory _tableName, string[] memory _fieldNames) = getMetadata();
    StoreSwitch.setMetadata(_tableId, _tableName, _fieldNames);
  }

  /** Set the table's metadata (using the specified store) */
  function setMetadata(IStore _store) internal {
    (string memory _tableName, string[] memory _fieldNames) = getMetadata();
    _store.setMetadata(_tableId, _tableName, _fieldNames);
  }

  /** Get piece */
  function getPiece(uint8 square) internal view returns (Piece piece) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32(uint256((square)));

    bytes memory _blob = StoreSwitch.getField(_tableId, _keyTuple, 0);
    return Piece(uint8(Bytes.slice1(_blob, 0)));
  }

  /** Get piece (using the specified store) */
  function getPiece(IStore _store, uint8 square) internal view returns (Piece piece) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32(uint256((square)));

    bytes memory _blob = _store.getField(_tableId, _keyTuple, 0);
    return Piece(uint8(Bytes.slice1(_blob, 0)));
  }

  /** Set piece */
  function setPiece(uint8 square, Piece piece) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32(uint256((square)));

    StoreSwitch.setField(_tableId, _keyTuple, 0, abi.encodePacked(uint8(piece)));
  }

  /** Set piece (using the specified store) */
  function setPiece(IStore _store, uint8 square, Piece piece) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32(uint256((square)));

    _store.setField(_tableId, _keyTuple, 0, abi.encodePacked(uint8(piece)));
  }

  /** Get color */
  function getColor(uint8 square) internal view returns (Color color) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32(uint256((square)));

    bytes memory _blob = StoreSwitch.getField(_tableId, _keyTuple, 1);
    return Color(uint8(Bytes.slice1(_blob, 0)));
  }

  /** Get color (using the specified store) */
  function getColor(IStore _store, uint8 square) internal view returns (Color color) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32(uint256((square)));

    bytes memory _blob = _store.getField(_tableId, _keyTuple, 1);
    return Color(uint8(Bytes.slice1(_blob, 0)));
  }

  /** Set color */
  function setColor(uint8 square, Color color) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32(uint256((square)));

    StoreSwitch.setField(_tableId, _keyTuple, 1, abi.encodePacked(uint8(color)));
  }

  /** Set color (using the specified store) */
  function setColor(IStore _store, uint8 square, Color color) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32(uint256((square)));

    _store.setField(_tableId, _keyTuple, 1, abi.encodePacked(uint8(color)));
  }

  /** Get the full data */
  function get(uint8 square) internal view returns (GameBoardData memory _table) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32(uint256((square)));

    bytes memory _blob = StoreSwitch.getRecord(_tableId, _keyTuple, getSchema());
    return decode(_blob);
  }

  /** Get the full data (using the specified store) */
  function get(IStore _store, uint8 square) internal view returns (GameBoardData memory _table) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32(uint256((square)));

    bytes memory _blob = _store.getRecord(_tableId, _keyTuple, getSchema());
    return decode(_blob);
  }

  /** Set the full data using individual values */
  function set(uint8 square, Piece piece, Color color) internal {
    bytes memory _data = encode(piece, color);

    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32(uint256((square)));

    StoreSwitch.setRecord(_tableId, _keyTuple, _data);
  }

  /** Set the full data using individual values (using the specified store) */
  function set(IStore _store, uint8 square, Piece piece, Color color) internal {
    bytes memory _data = encode(piece, color);

    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32(uint256((square)));

    _store.setRecord(_tableId, _keyTuple, _data);
  }

  /** Set the full data using the data struct */
  function set(uint8 square, GameBoardData memory _table) internal {
    set(square, _table.piece, _table.color);
  }

  /** Set the full data using the data struct (using the specified store) */
  function set(IStore _store, uint8 square, GameBoardData memory _table) internal {
    set(_store, square, _table.piece, _table.color);
  }

  /** Decode the tightly packed blob using this table's schema */
  function decode(bytes memory _blob) internal pure returns (GameBoardData memory _table) {
    _table.piece = Piece(uint8(Bytes.slice1(_blob, 0)));

    _table.color = Color(uint8(Bytes.slice1(_blob, 1)));
  }

  /** Tightly pack full data using this table's schema */
  function encode(Piece piece, Color color) internal view returns (bytes memory) {
    return abi.encodePacked(piece, color);
  }

  /** Encode keys as a bytes32 array using this table's schema */
  function encodeKeyTuple(uint8 square) internal pure returns (bytes32[] memory _keyTuple) {
    _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32(uint256((square)));
  }

  /* Delete all data for given keys */
  function deleteRecord(uint8 square) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32(uint256((square)));

    StoreSwitch.deleteRecord(_tableId, _keyTuple);
  }

  /* Delete all data for given keys (using the specified store) */
  function deleteRecord(IStore _store, uint8 square) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32(uint256((square)));

    _store.deleteRecord(_tableId, _keyTuple);
  }
}
