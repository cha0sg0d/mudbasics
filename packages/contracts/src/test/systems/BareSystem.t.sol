// SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.0;

import "../MudTest.t.sol";
import { BareMoveSystem, ID as BareMoveSystemID } from "../../systems/BareMoveSystem.sol";
import { BarePositionComponent, ID as BarePositionComponentID, Coord } from "../../components/BarePositionComponent.sol";

contract BareSystemTest is MudTest {
  function testExecute() public {
    uint256 entity = 1;
    Coord memory coord = Coord(12, 34);
    BareMoveSystem(system(BareMoveSystemID)).executeTyped(entity, coord);
    BarePositionComponent positionComponent = BarePositionComponent(component(BarePositionComponentID));
    Coord memory position = positionComponent.getValue(entity);
    assertEq(position.x, coord.x);
    assertEq(position.y, coord.y);
  }

  function testSetVsUpdateCoord() public {
    uint256 entity = 1;
    Coord memory coord1 = Coord(12, 34);
    Coord memory coord2 = Coord(13, 34);
    uint256 gas = gasleft();
    BareMoveSystem(system(BareMoveSystemID)).executeTyped(entity, coord1);
    BareMoveSystem(system(BareMoveSystemID)).executeTyped(entity, coord2);
  }
}
