#!/usr/bin/env bash

# Install the local src directory to the test environment, assuming build.sh has been run
# first

set -o errexit
# set -o xtrace

script_dir=$(dirname "$(realpath "$0")")

source $(find $CONDA_PREFIX -type f -name conda_test_env_vars.sh)
# I'm using conda develop here as pip got into trouble with hatch because of pyproject.
# It might be simpler to just create the .pth file manually
conda develop "$script_dir/src"

# remove any installation under site-packages created by conda
set +o errexit
conda remove --force learn-jax -y
exit 0
