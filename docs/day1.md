# 7 days of GB dev - Day 1

Welcome. In 7 days of GB dev, I will try to make a Gameboy game from scratch. And document the process.

This is not a tutorial on how to do gameboy development. If you want to get into gameboy development, I recommend reading up on https://gbdev.io/ and join the associated discord.


## The PLAN

As this is day 1, we need to have a plan. As 7 days is not a whole lot of time. We need a simple plan.

One of my main goals is to make a complete game. I figured I make a bad version of Tetris.
As there are clearly never enough clones of Tetris on the gameboy...

So, with that out of the way, we will need:

* An title screen
* A difficulty/level selection screen
* Main gameplay
* Music and sound effects
* Falling blocks
* Rotation of falling block
* Game over result

## The work

So, on day 1. We set out to make the general plan and setup our environment.

As environment, I am using:

* vscode: https://code.visualstudio.com/ as editor
* rgbds: https://rgbds.gbdev.io/ as assembler
* gb-starter-kit: https://github.com/ISSOtm/gb-starter-kit as template for the project, to get a start boost with common setup and routines
* bgb: https://bgb.bircd.org/ as emulator, which has an excelent debugger
* aseprite: https://www.aseprite.org/ as pixel image editor

So, I've setup the starterkit (which did not compile with latest rgbds out of the box).
I've made the most ugly title screen placeholder ever, and setup some initial code in intro.asm to load this screen.

The starterkit functions made this relatively easy, but I did need to add something to the Makefile to actually generate a tilemap and de-duplicate the graphics.
As a full screen of tiles is bigger than what fits in VRAM per default. There are 360 8x8 tiles visible on the gameboy screen. You can fit 384 tiles in VRAM, but,
only 256 can be used for the background, unless you pull some mid screen register write trickery. So, much easier to just use the de-duplication function from rgbgfx.

And then I setup the code to crash as soon as you press the start button. Progress!

## Up next

For day 2, I want to work on music. Yes, there is much to do. But, I know how to make gameplay and sprites and graphics and stuff. But sound and music in gameboy is something
I have not touched yet. So it is scratching my itch. I know how to generate simple tones with the first two sound channels of the gameboy audio,
and I looked up some sheet music of the tetris tune. Combined with looking up which frequency is which note, it should be possible to recreate this... I hope. We will see.
