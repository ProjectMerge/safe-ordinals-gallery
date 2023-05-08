# Safe ordinals gallery: Creating An Enjoyable Experience
================================================================================

[![License: AGPL](https://img.shields.io/badge/license-AGPL-blue.svg)](https://)
[![About TEAM](https://img.shields.io/badge/wiki-the%20team-4aa087.svg)](https://github.com/ProjectMerge/safe-ordinals-gallery/wiki/)
[![GitHub Discussions](https://img.shields.io/badge/ask-%20on%20github-4d6a91.svg)](https://github.com/ProjectMerge/safe-ordinals-gallery/discussions)
[![Twitter](https://img.shields.io/badge/follow%20on%20Twitter-@rocketbotpro-00acee.svg)](https://twitter.com/rocketbotpro)
[![Telegram](https://img.shields.io/badge/Join%20Telegram-ProjectMerge-00acee.svg)](https://t.me/ProjectMergeCommunity)
[![Discord](https://img.shields.io/badge/Join%20Discord-RocketBot-00acee.svg)](https://discord.gg/eA2JcKB6zC)
[![Corporate Sponsor](https://img.shields.io/badge/backed-by%20MergeBCDG%20USA%20LLC-4aa087.svg)](https://mergebcdg.com/)

Safe ordinals gallery is an AI-Powered App for images inscribed on the Decentralized Bitcoin blockchain. Ordinals protocol enable users to send and receive Satoshis (smallest monetary unit of a Bitcoin) that encapusulate data to them. This data can be in the form of text, images, audio etc.  

## Description

Ordinals best features are immutability and censorship resistance. Unfortunately not all images are safe for the work place or third party platform. Only days after the launch of the Bitcoin based Ordinals protocol, its creator had to deal with their first shock pornographic image, which has been inscribed into the blockchain. Safe ordinals gallery aims to automate the process of eliminating the following materials. 
- `porn` - pornography images
- `hentai` - hentai images, but also includes pornographic drawings
- `sexy` - sexually explicit images, but not pornography. Think nude photos, playboy, bikini, etc.
- `drawings` - safe for work drawings (including anime)
- `words` - optical character recognition(OCR) of words safe to use at work
- - obscenity, profanity, & vulgar speech

To get a first impression, you are welcome to play with our [public demo](https://).

## Prerequisites

- Docker

```bash
$ mkdir -p $HOME/myData
...or if you are on Windows, edit docker-compose.yml and replace $HOME/myData with /c/myData
```

## Getting Started ##

### Running it locally ###

```bash
$ git clone https://github.com/ProjectMerge/safe-ordinals-gallery.git ord_gallery
$ cd ord_gallery
$ docker-compose up -d
```

### Running it on the web ###

```bash
$ git clone https://github.com/ProjectMerge/safe-ordinals-gallery.git ord_gallery
$ cd ord_gallery
$ Edit ./Caddyfile and replace "domain.com" with your domain name
$ docker-compose -f docker-compose-net.yml up -d
```

## Update current build
```bash
$ git pull
$ docker-compose rm -s -v (-f docker-compose-net.yml)
$ docker-compose up -d --build (-f docker-compose-net.yml)
```

## Support Our Mission 💎 ##

**Team RocketBot is 100% self-funded and independent.** Your [continued support](https://) helps us [provide more features to the public](https://), release [regular updates](https://), and remain independent!

- [GitHub Sponsors](https://) is priced in USD and also offers [one-time donations](https://link.photoprism.app/donate)
- [Patreon](https://) is priced in Euro and also offers yearly payments
- Stripe will be available this year, so you can sign up directly in the app

You are [welcome to contact us](https://) for change requests, membership questions, and business partnerships.


## Credits

Code by: [M1chlCZ](https://github.com/M1chlCZ)

Model, snippets of logic: https://github.com/photoprism/photoprism

Tensorflow-GO: https://github.com/galeone/tfgo

OCR: https://github.com/otiai10/gosseract
