#!/bin/bash

set -e

# Build boot.img and boot.sig, this is root filesystem and such itself
cd ../secure_boot_rpi4
rm -fr .nerves _build boot.img boot.sig
/usr/bin/time -o inner-time.txt mix compile

espeak-ng "Inner build completed"