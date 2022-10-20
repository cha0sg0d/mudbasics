// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;
import "solecs/System.sol";
import { IWorld } from "solecs/interfaces/IWorld.sol";
import { getAddressById } from "solecs/utils.sol";

import { console } from "forge-std/console.sol";

import { BarePositionComponent, ID as BarePositionComponentID, Coord } from "../components/BarePositionComponent.sol";

uint256 constant ID = uint256(keccak256("system.BareMove"));

contract BareMoveSystem is System {
  constructor(IWorld _world, address _components) System(_world, _components) {}

  function execute(bytes memory arguments) public returns (bytes memory) {
    (uint256 entity, Coord memory targetPosition) = abi.decode(arguments, (uint256, Coord));

    BarePositionComponent position = BarePositionComponent(getAddressById(components, BarePositionComponentID));
    uint256 gas = gasleft();
    position.set(entity, targetPosition);
    uint256 gasUsed = gas - gasleft();
    console.log("setting bare position component used %s gas", gasUsed);
  }

  function executeTyped(uint256 entity, Coord memory targetPosition) public returns (bytes memory) {
    return execute(abi.encode(entity, targetPosition));
  }
}
