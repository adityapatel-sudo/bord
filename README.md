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
