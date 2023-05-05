# Safe ordinals gallery: Creating An Enjoyable Experience
================================================================================

[![License: AGPL](https://img.shields.io/badge/license-AGPL-blue.svg)](https://)
[![About TEAM](https://img.shields.io/badge/wiki-the%20team-4aa087.svg)](https://github.com/ProjectMerge/safe-ordinals-gallery/wiki/)
[![GitHub Discussions](https://img.shields.io/badge/ask-%20on%20github-4d6a91.svg)](https://github.com/ProjectMerge/safe-ordinals-gallery/discussions)
[![Twitter](https://img.shields.io/badge/follow%20on%20Twitter-@rocketbotpro-00acee.svg)](https://twitter.com/rocketbotpro)
[![Telegram](https://img.shields.io/badge/Join%20Telegram-ProjectMerge-00acee.svg)](https://t.me/ProjectMergeCommunity)
[![Discord](https://img.shields.io/badge/Join%20Discord-RocketBot-00acee.svg)](https://discord.gg/eA2JcKB6zC)
[![Corporate Sponsor](https://img.shields.io/badge/backed-by%20MergeBCDG%20USA%20LLC-4aa087.svg)](https://mergebcdg.com/)

## Description

Ordinals best features are immutability and censorship resistance. Unfortunately not all images are safe for the work place or third party platform. Only days after the launch of the Bitcoin based Ordinals protocol, its creator had to deal with their first shock pornographic image, which has been inscribed into the blockchain. Safe ordinals gallery aims to automate the process. 
- `porn` - pornography images
- `hentai` - hentai images, but also includes pornographic drawings
- `sexy` - sexually explicit images, but not pornography. Think nude photos, playboy, bikini, etc.
- `neutral` - safe for work neutral images of everyday things and people
- `drawings` - safe for work drawings (including anime)

## Prerequisites

- Docker

## Build

```bash
$ git clone https://github.com/ProjectMerge/safe-ordinals-gallery.git ord_gallery
$ cd ord_gallery
$ docker-compose up -d

## Update current build

$ git pull
$ docker-compose rm -s -v

## Results



## Credits

Model, snippets of logic: https://github.com/photoprism/photoprism
Tensorflow-GO: https://github.com/galeone/tfgo
OCR: https://github.com/otiai10/gosseract
