// SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.0;
import "solecs/System.sol";
import { getAddressById, addressToEntity } from "solecs/utils.sol";
import { LibUtils } from "std-contracts/libraries/LibUtils.sol";
import { Coord, ID as PositionComponentID, PositionComponent } from "../components/PositionComponent.sol";
import { CarriedByComponent, ID as CarriedByComponentID } from "../components/CarriedByComponent.sol";

uint256 constant ID = uint256(keccak256("system.Catch"));

contract CatchSystem is System {
  constructor(IWorld _world, address _components) System(_world, _components) {}

  function execute(bytes memory arguments) public returns (bytes memory) {
    Coord memory targetPosition = abi.decode(arguments, (Coord));

    PositionComponent position = PositionComponent(getAddressById(components, PositionComponentID));

    // Sender must be next to target position
    Coord memory senderPosition = position.getValue(addressToEntity(msg.sender));
    require(LibUtils.manhattan(senderPosition, targetPosition) == 1, "must be adjacent to catch");

    // Find entities at the target position
    uint256[] memory entities = position.getEntitiesWithValue(targetPosition);
    require(entities.length > 0, "no entities at this position");

    CarriedByComponent carriedBy = CarriedByComponent(getAddressById(components, CarriedByComponentID));
    // Remove all entities from the position component that are near msg.sender's position component.
    // Catch all the entities
    for (uint256 i; i < entities.length; i++) {
      position.remove(entities[i]);
      // Each entity is now carried by msg.msg.sender
      carriedBy.set(entities[i], addressToEntity(msg.sender));
    }
  }

  function executeTyped(Coord memory targetPosition) public returns (bytes memory) {
    return execute(abi.encode(targetPosition));
  }
}
