import { getComponentValue } from "@latticexyz/recs";
import { awaitStreamValue } from "@latticexyz/utils";
import { ClientComponents } from "./createClientComponents";
import { SetupNetworkResult } from "./setupNetwork";

export type SystemCalls = ReturnType<typeof createSystemCalls>;

export function createSystemCalls(
  { worldSend, txReduced$, singletonEntity }: SetupNetworkResult,
  { GameBoard, Turn, GameOver }: ClientComponents
) {
  const startGame = async () => {
    const tx = await worldSend("startGame", []);
    await awaitStreamValue(txReduced$, (txHash) => txHash === tx.hash);
  };

  const movePiece = async (from: number, to: number) => {
    const tx = await worldSend("movePiece", [from, to]);
    await awaitStreamValue(txReduced$, (txHash) => txHash === tx.hash);
  };

  return {
    startGame, movePiece
  };
}
