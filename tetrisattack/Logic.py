from typing import TYPE_CHECKING

if TYPE_CHECKING:
    from . import TetrisAttackWorld


class TetrisAttackLogic:
    player: int

    def __init__(self, world: "TetrisAttackWorld") -> None:
        self.player = world.player
