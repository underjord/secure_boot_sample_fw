#!/bin/bash

set -e

cd ../sec_fw
MIX_TARGET=secure_cm4 /usr/bin/time -o build-time.txt mix firmware

espeak-ng "Firmware build completed"