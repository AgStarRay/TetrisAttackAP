# Tetris Attack AP
Archipelago mod for Tetris Attack. Requires the USA version of the Super Nintendo ROM to play.

# Install
These instructions assume that you have Archipelago installed already ([install](https://archipelago.gg/tutorial/Archipelago/setup_en)).

Go to the [releases](https://github.com/AgStarRay/TetrisAttackAP/releases/latest) to grab the .apworld, then double click or drag into the custom_worlds folder.

After the custom apworld is installed, click Generate Template Options in ArchipelagoLauncher.exe to get an up-to-date base template yaml file. You can also run ArchipelagoOptionsCreator.exe where Tetris Attack should show up as one of the options, then click Export Options for the yaml file.

There, after generating a multiworld ([click here for instructions on generation and hosting](https://archipelago.gg/tutorial/Archipelago/setup_en)), click Open Patch in the Archipelago launcher and select the .aptatk file (as well as the original ROM if it's the first time). You can also run the .aptatk file itself, but make sure it is extracted from the output zip file first (otherwise the game will take place in a temp folder you won't easily find).

After a compatible emulator opens (such as Bizhawk), load the Connector.lua script from Archipelago/SNI/lua to connect to the SNI client (Tools > Lua Console; File > Open Session > select the Connector.lua file). For different emulators, instructions may vary.

Source code was written for 0.6.4, but it was also tested on 0.6.3, doesn't seem to work prior to 0.6.3. To avoid compatibility issues, try to have your Archipelago version match the one that the seed was generated with, especially if yours is older.

# Items
In the menu, the number of items you have received is shown at the bottom next to "CONNECTED!".

### Progression Items
Based on Stage Clear mode:
- **0 to 6** Stage Clear Round Gates, can't play any stages without them
- **0 to 30** Stage Clear (progressive) Stage unlocks, can't play the individual stages without them
- Stage Clear Last Stage, only exists if Round 6 is in the starter pack, required to clear the mode

If ! Panels are added to Stage Clear, a number of Stage Clear ! Panels items equal to the number of checks are added **(1 to 100 sets)**

Based on Puzzle mode:
- **0 to 6** Puzzle Level Gates, can't play any puzzles without them
- **0 to 60** Puzzle Stage (progressive) unlocks, can't play the individual puzzles without them
- **0 to 6** Puzzle Extra Level Gates
- **0 to 60** Puzzle Extra Stage (progressive) unlocks

Based on Vs. mode:
- **0 to 12** Vs. (progressive) Stage unlocks, can't fight certain characters without their stages
- Mt. Wickedness Gate, can't access stages 9 to 12 without it

### Filler Items
- **Any number of** Stage Clear points, values are based on Chains and Combos; the score counter never goes down except when you get a Game Over or quit a stage
- **0 or 8** Playable characters in Vs.; they're in your party forever
  - (Later on, there may be an option to have these 8 characters replace the Mt. Wickedness Gate, turning them into progression items)

### Traps
- **0 to 30** Stage Clear Special Stages, operates as a trap where you must win or lose against Bowser; effectively a deathlink threat or simply a time waster

# Locations
If you have multiple goals, you must clear all of them before your world is considered done.

The menu is changed to show in-game trackers. The number at the top right shows how many checks you have collected in any one mode.

Locations will be marked with the Archipelago symbol if they have not been collected. If another player auto-collects it, a fanfare sound will play in the menu and get rid of the symbol. The game will try to skip anything you've already cleared yourself to help with pacing. Checks that you are not allowed to make will have a lock symbol. The Vs. stage selector may show an additional lock if you don't have the Mt. Wickedness Gate.

### Stage Clear
- **0, 5, or 6** Round Clears, obtained after clearing the fifth stage of each round; note that all 5 Stage Clears are needed locally even if their checks have been collected
- **0 or 30** Stage Clears, obtained after getting under the clear line
- Victory condition: deplete Bowser's HP in the Last Stage; Last Stage is typically accessible after the Round 6 Clear
- If ! Panels are added, a check is sent every X panels cleared **1 to 100 times**
  - Two more panels will appear to guarantee it being possible; if the panels per check is 1 or 2, it is possible to skip logic
  - To help with pacing, ! Panels will appear more aggressively if the player has a large backlog

### Puzzle
- **0 or 6** Round Clears, obtained after clearing all 10 puzzles of a level; note that all 10 clears are needed locally even if their checks have been collected
- **0 or 6** Extra Round Clears, obtained after clearing all 10 puzzles of an extra level
- **0 to 120** Puzzle Clears and Extra Puzzle clears, obtained after clearing the board completely of all panels
- Victory condition: Level 6 Clear and/or Extra Level 6 Clear, based on mode

### Vs.
- **10 to 12** Stage clears, obtained after defeating the opponent in a Vs. stage
  - A minimum difficulty may be set, stage 11 typically requires at least Normal and stage 12 typically requires Hard or V.Hard
- **8** Free characters, obtained after defeating the opponent in one of the first 8 Vs. stages
- All Friends Normal Again, obtained after clearing the first 8 Vs. stages which would normally allow access to Mt. Wickedness; note that all 8 stage clears are needed locally even if their checks have been collected or you have all 8 friends already
- Victory condition: beat the last stage, typically according to vanilla clear condition such as Stage 10 in Easy and Stage 12 in Hard

# Contributing
If you want to contribute to the development, there is a bit of setup involved.

You need the following tools:
- Asar
- DiztinGUIsh

Open the ROM in DiztinGUIsh, then import all the labels from Labels USA.csv, then export. This should give you an export folder, which you should put in the same folder as the Patch.asm file. Now you should be good to re-assemble with Asar by running `asar.exe Patch.asm`.
