#!/usr/bin/env bash

# Report on locations of some relevant files

set -o xtrace
set -o errexit

find ~ -type d -name learn_jax
find ~ -type f -name jmjax.py
find ~ -type f -name conda_test_runner.sh
find ~ -type f -name conda_test_env_vars.sh
