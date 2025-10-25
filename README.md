# Tetris Attack AP
Archipelago mod for Tetris Attack. Requires the USA version of the ROM to play.

Go to the [releases](https://github.com/AgStarRay/TetrisAttackAP/releases/latest) to grab the .apworld, then double click or drag into the custom_worlds folder. There, after generating a multiworld, click Open Patch in the Archipelago launcher and select the .aptatk file (as well as the original ROM if it's the first time). You can also run the .aptatk file itself, but make sure it is unzipped first.
After a compatible emulator opens, load the Connector.lua script from Archipelago/SNI/lua to connect to the SNI client.

Source code was written for 0.6.4, but it was also tested on 0.6.3, doesn't seem to work prior to 0.6.3. To avoid compatibility issues, try to have your Archipelago version match the one that the seed was generated with, especially if yours is older.

# Contributing
If you want to contribute to the development, there is a bit of setup involved.

You need the following tools:
- Asar
- DiztinGUIsh

Open the ROM in DiztinGUIsh, then import all the labels from Labels USA.csv, then export. This should give you an export folder, which you should put in the same folder as the Patch.asm file. Now you should be good to re-assemble with Asar by running `asar.exe Patch.asm`.
