# Local Layering

Build and deploy simple immutable customizations locally.

## Usage

1. Clone this repo
2. Make changes to the `Containerfile`
3. Run `build.sh`

## About

Most users won't need to layer packages when they use images like [bazzite](https://github.com/ublue-os/bazzite)
or [aurora](https://github.com/ublue-os/aurora) because they include everything _and_ the kitchen sink.

But, if you're like me, forging your own path using one of the base images, you may need to layer packages that
those images would traditionally include (or more, or less).

This repo is similar to [image-template](https://github.com/ublue-os/image-template), but it just aims to build
and deploy an image locally and nothing more. I didn't want to mess with GitHub actions, image signing,
or building cloud images that I'll only ever use on a single computer.

I also want this to be easy to "audit" by keeping the build script and Containerfiles as easy to read as possible.
The Containerfile is split into multiple layers to take advantage of layer caching, and dnf5 is instructed to keep
RPM caches to reduce hitting the mirrors on rebuilds.

## Why

ublue and fedora is moving to `bootc` soon which won't have local layering, though this may appear back in the 
future with [fedora/bootc#4](https://gitlab.com/fedora/bootc/tracker/-/issues/4). I wanted to get ahead of this by 
making my own "custom image", but without all the hassle of the things mentioned above. 
