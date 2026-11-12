#!/bin/bash
cd $(dirname $0)
./build.sh main-0af27a30 && ./time.sh main-0af27a30 && ./repeat.sh main-0af27a30 && ./annotate.sh main-0af27a30
