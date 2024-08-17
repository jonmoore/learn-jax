#!/usr/bin/env bash

set -o errexit

# Run the working tree's local copy of the tests, assuming build.sh has been run first

# This will activate the test env created during the build and then run pytest locally
source $(find ~ -type f -name conda_test_env_vars.sh)
cd $(dirname "$(realpath "$0")")
pytest tests
