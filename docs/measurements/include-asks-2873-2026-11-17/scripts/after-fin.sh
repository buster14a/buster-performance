#!/bin/bash
cd "$(dirname "$0")"
until [ -s job-fin.done ]; do sleep 10; done
exec ./job-threshold.sh
