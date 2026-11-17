#!/bin/bash
cd "$(dirname "$0")"
until [ -s job-vec.done ]; do sleep 10; done
exec ./job-fin.sh
