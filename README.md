# bord

## Download for macOS

[Download bord 1.0 for macOS (Apple Silicon and Intel)](https://github.com/adityapatel-sudo/bord/releases/download/v1.0.0/bord-macos-universal.zip)

Requires macOS 14.4 or newer. Unzip the download, drag `bord.app` to Applications, then right-click the app and choose **Open** the first time. The current release is ad-hoc signed and is not notarized by Apple.

## Build from source

Open `bord.xcodeproj` in Xcode, or create the universal release archive from Terminal:

```sh
./scripts/build-release.sh
```

The packaged app will be written to `dist/bord-macos-universal.zip`.

## by aditya patel

![plot](./bord/assets/bord.png)

worked on project for a few weeks Dec 2024

inspired by mspaint and various other drawing tools

cant say the code is amazingly clean, but good enough to work with

have variety of feature ideas, but not sure if i will work on them

## uses

1. quick diagramming
    - open -> digramming time is as fast i could make it

### things i learned

1. swift + ui
    - honestly just started coding and it worked
    - this approach has issues, however, codebase  design standards is shit
    - not too bad swift felt well designed for mvvm
2. graphics
    - didn't delve into metal, but used core graphics for most things
    - transformations, drawing, efficient rendering
    - in the future, might use metal for better performance
    - shouldnt be too hard to fix
3. various other things

## current features

1. drawing
    - freehand lines, normal arrows, and arrows on both ends
    - straight lines and arrows
    - rectangles and ellipses
    - change color and line thickness
2. text
    - move, resize, rotate, duplicate, bold, and italicize text
    - text can also be attached to shapes
3. canvas stuff
    - select, move, duplicate, and erase items
    - resize shapes and text
    - pan and zoom around a larger canvas
    - grid, lined, or blank background
    - hide the ui if it gets in the way

## technical overview

1. swiftui canvas
    - most of the drawing is stored as swiftui `Path` objects
    - one `Canvas` + `GraphicsContext` renders the lines and shapes
    - text is kept as normal swiftui views because editing text directly in a graphics canvas would be annoying
2. mvvm-ish setup
    - `ContentView` puts the canvas and toolbars together
    - `CanvasView` handles rendering and gestures
    - `CanvasItemsViewModel` keeps track of paths, text, selection, colors, and sizes
    - `CanvasModeViewModel` keeps track of the current tool, grid, pan, and zoom
    - `LineModel`, `RectangleModel`, and `TextModel` store the actual things on the canvas
3. build
    - native macos app with no runtime dependencies
    - requires macos 14.4 or newer
    - release is universal, so it runs on both apple silicon and intel macs

## architecture decisions

1. canvas for shapes, views for text
    - paths are much easier to draw together in one graphics context
    - text fields are better as real views because focus, typing, and multiline editing already work
2. drawing state is separate from navigation state
    - canvas items live in one view model
    - pan, zoom, grids, and tool selection live in another
    - makes it less likely that moving around the canvas changes the drawing itself
3. store everything in canvas coordinates
    - the paths do not move when the viewport moves
    - pan gets applied while drawing the screen and translated back while handling input
4. shared drawable protocol
    - lines and shapes both use `DrawableModel`
    - lets selection, movement, color, thickness, duplication, and erasing mostly share the same code

## current limitations

1. drawings are not saved yet
    - core data setup exists from the original project template, but the actual canvas models are still only stored in memory
2. undo is very basic
    - it removes the last drawn item instead of keeping a real command history
3. release signing
    - the github build is ad-hoc signed, not notarized with an apple developer id
