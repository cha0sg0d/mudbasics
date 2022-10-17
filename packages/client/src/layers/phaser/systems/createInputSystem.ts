import { pixelCoordToTileCoord, tileCoordToPixelCoord } from "@latticexyz/phaserx";
import { defineComponentSystem } from "@latticexyz/recs";
import { tile } from "@latticexyz/utils";
import { NetworkLayer } from "../../network";
import { Sprites } from "../constants";
import { PhaserLayer } from "../types";

export function createInputSystem(network: NetworkLayer, phaser: PhaserLayer) {
  //
  const {
    scenes: {
      Main: { input },
    },
  } = phaser;
  const {
    api: { move },
    network: { connectedAddress },
  } = network;
  input.click$.subscribe((e) => {
    const tileCoord = pixelCoordToTileCoord({ x: e.worldX, y: e.worldY }, 16, 16);
    move(connectedAddress.get()!, tileCoord);
  });
}
