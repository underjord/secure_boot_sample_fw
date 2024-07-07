#!/bin/bash

set -e

cd ../secure_outer_rpi4
rm -fr .nerves _build images/boot.img images/boot.sig
cp ../secure_boot_rpi4/boot.img ./images/boot.img
cp ../secure_boot_rpi4/boot.sig ./images/boot.sig
/usr/bin/time -o outer-time.txt mix compile

espeak-ng "Outer build completed"