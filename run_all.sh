#!/usr/bin/env bash

set -o errexit

./init.sh
./clean.sh
./build.sh --mode build
./test-conda.sh
./install_from_local.sh
./test-local.sh

