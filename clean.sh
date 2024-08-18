#!/usr/bin/env bash

set -o errexit
set -o xtrace

script_dir=$(dirname "$(realpath "$0")")
source "$script_dir/functions.sh"
jm_activate "jax"

# Run hatch env prune as hatch clean doesn't clean fully.  Not sure to what extent this is
# by design.  Anyhow, the net effect is that hatch clean leaves the workspace dirty.

hatch -vv clean

hatch -vv env prune

# 'purge-all' cleans conda build's the work test intermediates, and also previously
# built packages.
conda build purge-all
conda clean --all -y

coverage erase


