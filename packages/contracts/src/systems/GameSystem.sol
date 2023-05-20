// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import { System } from "@latticexyz/world/src/System.sol";
import { IRule } from "../rules/IRule.sol";
import { Classic } from "../rules/Classic.sol";
import { getUniqueEntity } from "@latticexyz/world/src/modules/uniqueentity/getUniqueEntity.sol";

import { BoardState } from "../codegen/Tables.sol";

contract GameSystem is System {

    function startGame() public {
        IRule _ruleSet = new Classic(false);
        bytes32[64] memory boardData = _ruleSet.startingPosition();
        
        BoardState.set(boardData);
    }

    function getBoard() public view returns (bytes32[64] memory) {
        return BoardState.get();
    }
    
}
