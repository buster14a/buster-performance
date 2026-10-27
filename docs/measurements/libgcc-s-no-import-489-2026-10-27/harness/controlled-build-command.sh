#!/bin/bash
set -eu
./build.sh
sha256sum build/compiler src/buster/compiler/runtime.c src/buster/compiler/bind.c
