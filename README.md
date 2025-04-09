# Local Layering

Build and deploy simple immutable customizations locally.

## Usage

1. Clone this repo
2. Make changes to the `Containerfile`
3. Run `build.sh`

## About

Most users won't need to layer packages when they use images like [bazzite](https://github.com/ublue-os/bazzite)
or [aurora](https://github.com/ublue-os/aurora) because they include everything and the kitchen sink.

But, if you're like me, forging your own path using one of the base images, you may need to layer packages that
those images would traditionally include (or more, or less).

This repo is similar to [image-template](https://github.com/ublue-os/image-template), but it just aims to build
and deploy an image locally and _nothing more_. I simply didn't feel like messing with github actions, image signing,
or needlessly building images outside of times I don't want to update. I also don't need ISOs because I'm already
on a Fedora ostree based system.

## Why

ublue and fedora is moving to `bootc` soon which won't have local layering, though this may appear back in the 
future with [fedora/bootc#4](https://gitlab.com/fedora/bootc/tracker/-/issues/4). I wanted to get ahead of this by 
making my own "custom image", but without all the hassle of the things mentioned above. 
