from typing import Dict, TYPE_CHECKING
from BaseClasses import Region, Location
from .Locations import LocationData, TetrisAttackLocation
from .Logic import stage_clear_round_accessible, puzzle_level_accessible

if TYPE_CHECKING:
    from . import TetrisAttackWorld


def init_areas(world: "TetrisAttackWorld", locations: Dict[str, LocationData]) -> None:
    multiworld = world.multiworld
    player = world.player

    locations_per_region = get_locations_per_region(locations)

    regions = [
        create_region(world, player, locations_per_region, "Menu"),
        create_region(world, player, locations_per_region, "Stage Clear"),
        create_region(world, player, locations_per_region, "SC Round 1"),
        create_region(world, player, locations_per_region, "SC Round 2"),
        create_region(world, player, locations_per_region, "SC Round 3"),
        create_region(world, player, locations_per_region, "SC Round 4"),
        create_region(world, player, locations_per_region, "SC Round 5"),
        create_region(world, player, locations_per_region, "SC Round 6"),
        create_region(world, player, locations_per_region, "Puzzle"),
        create_region(world, player, locations_per_region, "Puzzle L1"),
        create_region(world, player, locations_per_region, "Puzzle L2"),
        create_region(world, player, locations_per_region, "Puzzle L3"),
        create_region(world, player, locations_per_region, "Puzzle L4"),
        create_region(world, player, locations_per_region, "Puzzle L5"),
        create_region(world, player, locations_per_region, "Puzzle L6"),
        create_region(world, player, locations_per_region, "Secret L1"),
        create_region(world, player, locations_per_region, "Secret L2"),
        create_region(world, player, locations_per_region, "Secret L3"),
        create_region(world, player, locations_per_region, "Secret L4"),
        create_region(world, player, locations_per_region, "Secret L5"),
        create_region(world, player, locations_per_region, "Secret L6"),
    ]

    multiworld.regions += regions

    menu = multiworld.get_region("Menu", player)
    stage_clear_region = multiworld.get_region("Stage Clear", player)
    menu.connect(stage_clear_region, "Select Stage Clear")
    puzzle_region = multiworld.get_region("Puzzle", player)
    menu.connect(puzzle_region, "Select Puzzle")
    for x in range(1, 7):
        round_region = multiworld.get_region(f"SC Round {x}", player)
        stage_clear_region.connect(round_region, f"Select Round {x}",
                                   lambda state, n=x: stage_clear_round_accessible(world, state, n))
        level_region = multiworld.get_region(f"Puzzle L{x}", player)
        puzzle_region.connect(level_region, f"Select Puzzle L{x}",
                                   lambda state, n=x: puzzle_level_accessible(world, state, n))
        level_region = multiworld.get_region(f"Secret L{x}", player)
        puzzle_region.connect(level_region, f"Select Secret Puzzle L{x}",
                                   lambda state, n=x + 6: puzzle_level_accessible(world, state, n))


def create_location(player: int, name: str, location_data: LocationData, region: Region) -> Location:
    location = TetrisAttackLocation(player, name, location_data.code, region)
    location.access_rule = location_data.rule
    return location


def create_region(world: "TetrisAttackWorld", player: int, locations_per_region: Dict[str, Dict[str, LocationData]],
                  region_name: str) -> Region:
    region = Region(region_name, player, world.multiworld)

    if region_name in locations_per_region:
        for name, data in locations_per_region[region_name].items():
            location = create_location(player, name, data, region)
            region.locations.append(location)

    return region


def get_locations_per_region(locations: Dict[str, LocationData]) -> Dict[str, Dict[str, LocationData]]:
    per_region: Dict[str, Dict[str, LocationData]] = {}

    for name, data in locations.items():
        per_region.setdefault(data.region, dict())[name] = data

    return per_region
