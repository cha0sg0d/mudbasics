import { tileCoordToPixelCoord } from "@latticexyz/phaserx";
import { defineComponentSystem } from "@latticexyz/recs";
import { NetworkLayer } from "../../network";
import { Sprites } from "../constants";
import { PhaserLayer } from "../types";

export function createPositionSystem(network: NetworkLayer, phaser: PhaserLayer) {
  //
  const {
    world,
    components: { Position },
  } = network;

  const {
    scenes: {
      Main: { objectPool, config },
    },
  } = phaser;
  defineComponentSystem(world, Position, (update) => {
    //
    const sprite = objectPool.get(update.entity, "Sprite");
    const position = update.value[0];
    const texture = config.sprites[Sprites.Donkey];
    if (!position) {
      return objectPool.remove(update.entity);
    }
    const pixelPosition = tileCoordToPixelCoord(position, 16, 16);
    sprite.setComponent({
      id: Position.id,
      once: (gameObject) => {
        gameObject.setPosition(pixelPosition.x, pixelPosition.y);
        gameObject.setTexture(texture.assetKey, texture.frame);
      },
    });
  });
}
