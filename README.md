# My Local Images

This repo is a fork of [Local-Image-Template](https://github.com/RedTopper/Local-Image-Template) with my 
configurations for different machines.

The Containerfiles for each of my devices ***do not live in this branch***. Use the branch switcher in the top left
of this repo or the links below to switch to my individual machines!

## Branch List

 * [machine/desktop](https://github.com/RedTopper/My-Local-Images/tree/machine/desktop): My desktop configuration
 * [machine/laptop](https://github.com/RedTopper/My-Local-Images/tree/machine/laptop): My work laptop configuration

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
