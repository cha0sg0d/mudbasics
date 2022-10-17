import { createWorld } from "@latticexyz/recs";
import { setupDevSystems } from "./setup";
import { createActionSystem, defineCoordComponent, setupMUDNetwork } from "@latticexyz/std-client";
import { defineLoadingStateComponent } from "./components";
import { SystemTypes } from "contracts/types/SystemTypes";
import { SystemAbis } from "contracts/types/SystemAbis.mjs";
import { GameConfig, getNetworkConfig } from "./config";
import { Coord } from "@latticexyz/utils";
import { BigNumber } from "ethers";

/**
 * The Network layer is the lowest layer in the client architecture.
 * Its purpose is to synchronize the client components with the contract components.
 */
export async function createNetworkLayer(config: GameConfig) {
  console.log("Network config", config);

  // --- WORLD ----------------------------------------------------------------------
  const world = createWorld();

  // --- COMPONENTS -----------------------------------------------------------------
  const components = {
    LoadingState: defineLoadingStateComponent(world),
    Position: defineCoordComponent(world, { id: "Position", metadata: { contractId: "ember.component.position" } }),
  };

  // --- SETUP ----------------------------------------------------------------------
  const { txQueue, systems, txReduced$, network, startSync, encoders } = await setupMUDNetwork<
    typeof components,
    SystemTypes
  >(getNetworkConfig(config), world, components, SystemAbis);

  // --- ACTION SYSTEM --------------------------------------------------------------
  const actions = createActionSystem(world, txReduced$);

  // --- API ------------------------------------------------------------------------
  function move(entity: string, position: Coord) {
    console.log(`systems`, systems);
    console.log(`move system contract`, systems["mudwar.system.move"]);
    // Do you need to cast to BigNumber?
    systems["mudwar.system.move"].executeTyped(BigNumber.from(entity), position);
  }
  // --- CONTEXT --------------------------------------------------------------------
  const context = {
    world,
    components,
    txQueue,
    systems,
    txReduced$,
    startSync,
    network,
    actions,
    api: { move },
    dev: setupDevSystems(world, encoders, systems),
  };

  return context;
}
