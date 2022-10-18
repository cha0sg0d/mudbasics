// SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.0;
import "solecs/System.sol";
import { IWorld } from "solecs/interfaces/IWorld.sol";
import { IUint256Component } from "solecs/interfaces/IUint256Component.sol";
import { IComponent } from "solecs/interfaces/IComponent.sol";
import { getAddressById, addressToEntity } from "solecs/utils.sol";
import { Coord, ID as PositionComponentID, PositionComponent } from "../components/PositionComponent.sol";
import { ID as CarriedByComponentID, CarriedByComponent } from "../components/CarriedByComponent.sol";

uint256 constant ID = uint256(keccak256("mudwar.system.move"));

contract MoveSystem is System {
  constructor(IWorld _world, address _components) System(_world, _components) {}

  function execute(bytes memory arguments) public returns (bytes memory) {
    (uint256 entity, Coord memory position) = abi.decode(arguments, (uint256, Coord));

    CarriedByComponent carriedBy = CarriedByComponent(getAddressById(components, CarriedByComponentID));
    require(!carriedBy.has(addressToEntity(msg.sender)), "can not move while being carried");

    PositionComponent positionComponent = PositionComponent(getAddressById(components, PositionComponentID));
    positionComponent.set(entity, position);
  }

  function executeTyped(
    uint256 entity,
    Coord memory position // If value has length 0, the component is removed
  ) public returns (bytes memory) {
    return execute(abi.encode(entity, position));
  }
}
