# world/mygame/__init__.py

import os
from typing import Tuple, List, Set

import settings
import typing
import threading
from BaseClasses import Region, Location, Entrance, Item, ItemClassification, MultiWorld
from worlds.AutoWorld import World
from .Logic import stage_clear_round_gates_included, stage_clear_progressive_unlocks_included, \
    stage_clear_individual_unlocks_included
from .Options import TetrisAttackOptions, StarterPack  # the options we defined earlier
from .Items import item_table, get_items, filler_item_names  # data used below to add items to the World
from .Locations import get_locations, location_table, TetrisAttackLocation  # same as above
from .Regions import init_areas
from .Rom import get_base_rom_path, patch_rom, TATKProcedurePatch, USAHASH
from .Rules import set_stage_clear_round_clear_rules, set_stage_clear_individual_clear_rules, set_goal_rules
from .Client import TetrisAttackSNIClient


class TetrisAttackItem(Item):
    game = "Tetris Attack"


class TetrisAttackSettings(settings.Group):
    class RomFile(settings.SNESRomPath):
        """File name of the Tetris Attack (USA) 1.0 ROM"""
        description = "Tetris Attack (USA) (En,Ja).sfc ROM File"
        copy_to = "TetrisAttack.sfc"
        md5s = [USAHASH]

    rom_file: RomFile = RomFile("Tetris Attack (USA) (En,Ja).sfc")


class TetrisAttackWorld(World):
    """Tetris Attack is a frantic rising blocks puzzle game. Match 3 or more same-colored panels in a row horizontally or vertically to clear them.
    Match 4 or more simultaneously for a Combo. Match more panels after the previous ones clear out for a Chain.
    In Stage Clear, each round has a set of successive stages.
    In Puzzle, all panels in each board must be fully cleared out using limited moves.
    In Vs, perform Chains and Combos to attack."""
    game = "Tetris Attack"  # name of the game/world
    options_dataclass = TetrisAttackOptions  # options the player can set
    options: TetrisAttackOptions  # typing hints for option results
    settings: typing.ClassVar[TetrisAttackSettings]  # will be automatically assigned from type hint
    topology_present = True  # show path to required location checks in spoiler

    item_name_to_id = {item: item_table[item].code for item in item_table if item_table[item].code is not None}
    location_name_to_id = {location: location_table[location].code for location in location_table if location_table[location].code is not None}

    # Items can be grouped using their names to allow easy checking if any item
    # from that group has been collected. Group names can also be used for !hint
    item_name_groups = {
    }

    rom_name: bytearray
    world_version: int = 2

    def __init__(self, multiworld: MultiWorld, player: int):
        self.rom_name_available_event = threading.Event()
        super().__init__(multiworld, player)

    def generate_early(self) -> None:
        if stage_clear_round_gates_included(self):
            self.multiworld.push_precollected(
                self.create_item(f"Stage Clear Round {self.options.starter_pack + 1} Gate"))
        if stage_clear_progressive_unlocks_included(self):
            for _ in range(5):
                self.multiworld.push_precollected(
                    self.create_item(f"Stage Clear Progressive Round {self.options.starter_pack + 1} Unlock"))
        elif stage_clear_individual_unlocks_included(self):
            self.multiworld.push_precollected(self.create_item(f"Stage Clear {self.options.starter_pack + 1}-1 Unlock"))
            self.multiworld.push_precollected(self.create_item(f"Stage Clear {self.options.starter_pack + 1}-2 Unlock"))
            self.multiworld.push_precollected(self.create_item(f"Stage Clear {self.options.starter_pack + 1}-3 Unlock"))
            self.multiworld.push_precollected(self.create_item(f"Stage Clear {self.options.starter_pack + 1}-4 Unlock"))
            self.multiworld.push_precollected(self.create_item(f"Stage Clear {self.options.starter_pack + 1}-5 Unlock"))

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

    def get_item_pool(self) -> List[Item]:
        pool: List[Item] = []

        item_data_dict = get_items(self)
        for name, data in item_data_dict.items():
            for _ in range(data.amount):
                item = self.create_item(name)
                pool.append(item)

        return pool

    def create_items(self) -> None:
        pool = self.get_item_pool()
        self.generate_filler(pool)
        self.multiworld.itempool += pool

    def generate_filler(self, pool: List[Item]) -> None:
        unfilled_locations = self.multiworld.get_unfilled_locations(self.player)
        deficit = 1 if self.options.starter_pack == StarterPack.option_stage_clear_round_6 else 0
        for _ in range(len(unfilled_locations) - len(pool) - deficit):
            item = self.create_item(self.get_filler_item_name())
            pool.append(item)

    def get_filler_item_name(self) -> str:
        return self.multiworld.random.choice(filler_item_names)

    def create_item(self, name: str) -> TetrisAttackItem:
        data = item_table[name]
        return TetrisAttackItem(name, data.classification, data.code, self.player)

    def create_event(self, event: str) -> TetrisAttackItem:
        data = item_table[event]
        return TetrisAttackItem(event, data.classification, None, self.player)

    def set_rules(self) -> None:
        set_stage_clear_round_clear_rules(self)
        set_stage_clear_individual_clear_rules(self)
        set_goal_rules(self)
