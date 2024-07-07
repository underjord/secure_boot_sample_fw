#!/bin/bash

set -e

./rebuild_inner.sh
./rebuild_outer.sh
./build.sh

espeak-ng "Full rebuild completed"