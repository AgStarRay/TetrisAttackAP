from typing import List, Dict, TYPE_CHECKING
from BaseClasses import Region, Location
from .Locations import LocationData
from .Logic import TetrisAttackLogic

if TYPE_CHECKING:
    from . import TetrisAttackWorld


class TetrisAttackLocation(Location):
    game: str = "Tetris Attack"

    def __init__(self, player: int, name: str = " ", address: int = None, parent=None):
        super().__init__(player, name, address, parent)


def init_areas(world: "TetrisAttackWorld", locations: List[LocationData]) -> None:
    multiworld = world.multiworld
    player = world.player
    logic = TetrisAttackLogic(world)

    locations_per_region = get_locations_per_region(locations)

    regions = [
        create_region(world, player, locations_per_region, "Menu"),
        create_region(world, player, locations_per_region, "Stage Clear"),
    ]

    multiworld.regions += regions

    connect_starting_region(world)

    multiworld.get_region("Menu", player).add_exits(["Stage Clear"],
                                                    {"Stage Clear": lambda state: True})


def create_location(player: int, location_data: LocationData, region: Region) -> Location:
    location = TetrisAttackLocation(player, location_data.name, location_data.code, region)
    location.access_rule = location_data.rule

    return location


def create_region(world: "TetrisAttackWorld", player: int, locations_per_region: Dict[str, List[LocationData]],
                  name: str) -> Region:
    region = Region(name, player, world.multiworld)

    if name in locations_per_region:
        for location_data in locations_per_region[name]:
            location = create_location(player, location_data, region)
            region.locations.append(location)

    return region


def connect_starting_region(world: "TetrisAttackWorld") -> None:
    multiworld = world.multiworld
    player = world.player
    menu = multiworld.get_region("Menu", player)
    starting_region = multiworld.get_region("Stage Clear", player)
    menu.connect(starting_region, "Start Game")


def get_locations_per_region(locations: List[LocationData]) -> Dict[str, List[LocationData]]:
    per_region: Dict[str, List[LocationData]] = {}

    for location in locations:
        per_region.setdefault(location.region, []).append(location)

    return per_region
