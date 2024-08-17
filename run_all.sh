#!/usr/bin/env bash

set -o errexit

# Guard running the eval/conda activate as it fails when the jax environment has already
# been activated.
if [ "$CONDA_DEFAULT_ENV" != "jax" ]; then
    eval "$(conda shell.bash hook)"
    conda activate jax
fi

if [ "$CONDA_DEFAULT_ENV" != "jax" ]; then
    echo "Could not activate the 'jax' conda environment."
    exit 1
fi

./clean.sh
./build.sh --mode build
./build.sh --mode debug
./install_from_local.sh
./test.sh

