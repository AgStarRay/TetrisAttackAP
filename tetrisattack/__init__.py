# world/mygame/__init__.py

import os
from typing import Tuple, List, Set

import settings
import typing
import threading
from BaseClasses import Region, Location, Entrance, Item, ItemClassification, MultiWorld
from worlds.AutoWorld import World
from .Options import TetrisAttackOptions  # the options we defined earlier
from .Items import item_table, stage_clear_filler  # data used below to add items to the World
from .Locations import get_locations  # same as above
from .Regions import init_areas
from .Rom import get_base_rom_path, patch_rom, TATKProcedurePatch, USAHASH
from .Rules import set_stage_clear_whole_round_rules
from .Client import TetrisAttackSNIClient


class TetrisAttackItem(Item):
    game = "Tetris Attack"


class TetrisAttackLocation(Location):
    game = "Tetris Attack"


class TetrisAttackSettings(settings.Group):
    class RomFile(settings.SNESRomPath):
        """File name of the Tetris Attack (USA) 1.0 ROM"""
        description = "Tetris Attack (USA) (En,Ja).sfc ROM File"
        copy_to = "TetrisAttack.sfc"
        md5s = [USAHASH]

    rom_file: RomFile = RomFile("Tetris Attack (USA) (En,Ja).sfc")


class TetrisAttackWorld(World):
    """Tetris Attack is a frantic rising blocks puzzle game. Match 3 or more same-colored panels in a row horizontally or vertically to clear them out.
    Match 4 or more simultaneously for a Combo, and match more panels after the previous ones clear out for a Chain.
    In Stage Clear, each round has a set of successive stages.
    In Puzzle, all panels in each board must be fully cleared out.
    In Vs, create Chains and Combos to attack."""
    game = "Tetris Attack"  # name of the game/world
    options_dataclass = TetrisAttackOptions  # options the player can set
    options: TetrisAttackOptions  # typing hints for option results
    settings: typing.ClassVar[TetrisAttackSettings]  # will be automatically assigned from type hint
    topology_present = True  # show path to required location checks in spoiler

    item_name_to_id = {item: item_table[item].code for item in item_table}
    location_name_to_id = {location.name: location.code for location in get_locations(None)}

    # Items can be grouped using their names to allow easy checking if any item
    # from that group has been collected. Group names can also be used for !hint
    item_name_groups = {
    }

    rom_name: bytearray
    world_version: int = 1

    def __init__(self, multiworld: MultiWorld, player: int):
        self.rom_name_available_event = threading.Event()
        super().__init__(multiworld, player)

    def generate_early(self) -> None:
        starting_round = ["Stage Clear Round 1", "Stage Clear Round 2", "Stage Clear Round 3",
                          "Stage Clear Round 4", "Stage Clear Round 5", "Stage Clear Round 6"]
        self.multiworld.push_precollected(self.create_item(starting_round[self.options.starter_pack]))

    def generate_output(self, output_directory: str) -> None:
        try:
            patch = TATKProcedurePatch(player=self.player, player_name=self.player_name)
            patch_rom(self, patch)

            self.rom_name = patch.name

            patch.write(os.path.join(output_directory,
                                     f"{self.multiworld.get_out_file_name_base(self.player)}{patch.patch_file_ending}"))
        except Exception:
            raise
        finally:
            self.rom_name_available_event.set()  # make sure threading continues and errors are collected

    def modify_multidata(self, multidata: dict):
        import base64
        # wait for self.rom_name to be available.
        self.rom_name_available_event.wait()
        rom_name = getattr(self, "rom_name", None)
        # we skip in case of error, so that the original error in the output thread is the one that gets raised
        if rom_name:
            new_name = base64.b64encode(bytes(self.rom_name)).decode()
            multidata["connect_names"][new_name] = multidata["connect_names"][self.multiworld.player_name[self.player]]

    def create_regions(self) -> None:
        init_areas(self, get_locations(self))

    def get_item_pool(self, excluded_items: Set[str]) -> List[Item]:
        pool: List[Item] = []

        for name, data in item_table.items():
            if name not in excluded_items:
                for _ in range(data.amount):
                    item = self.create_item(name)
                    pool.append(item)

        return pool

    def get_excluded_items(self) -> Set[str]:
        excluded_items: Set[str] = set()

        starting_round = ["Stage Clear Round 1", "Stage Clear Round 2", "Stage Clear Round 3",
                          "Stage Clear Round 4", "Stage Clear Round 5", "Stage Clear Round 6"]

        excluded_items.add(starting_round[self.options.starter_pack])
        if self.options.starter_pack != 5:
            excluded_items.add("Stage Clear Last Stage")
        excluded_items.add("Stage Clear Completion")

        return excluded_items

    def create_items(self) -> None:
        pool = self.get_item_pool(self.get_excluded_items())
        # self.generate_filler(pool)
        self.multiworld.itempool += pool

    def generate_filler(self, pool: List[Item]) -> None:
        unfilled_locations = self.multiworld.get_unfilled_locations(self.player)
        for _ in range(len(unfilled_locations) - len(pool)):
            item = self.create_item(self.get_filler_item_name())
            pool.append(item)

    def create_item(self, name: str) -> TetrisAttackItem:
        data = item_table[name]
        return TetrisAttackItem(name, data.classification, data.code, self.player)

    def create_event(self, event: str) -> TetrisAttackItem:
        data = item_table[event]
        return TetrisAttackItem(event, data.classification, None, self.player)

    def set_rules(self) -> None:
        set_stage_clear_whole_round_rules(self)
        self.get_location("Stage Clear Last Stage Clear").place_locked_item(
            self.create_event("Stage Clear Completion")
        )
        if self.options.starter_pack != 5:
            self.get_location("Stage Clear Round 6 Clear").place_locked_item(
                self.create_item("Stage Clear Last Stage")
            )

        self.multiworld.completion_condition[self.player] = lambda state: state.has("Stage Clear Completion",
                                                                                    self.player)
