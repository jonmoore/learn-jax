#!/usr/bin/env bash

# Run hatch env prune as hatch clean doesn't clean fully.  Not sure to what extent this is
# "by design", e.g. if it's a choice not to clean envs or if it can't clean artefacts
# created by other tools.  Anyhow, the net effect is that hatch clean leaves the workspace
# dirty.

hatch -vv clean

hatch -vv env prune

# 'purge-all' cleans conda build's the work and test intermediates, and also previously
# built packages.
conda build purge-all
conda clean --all -y
coverage erase


