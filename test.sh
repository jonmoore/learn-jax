#!/usr/bin/env bash

set -o xtrace
set -o errexit

# Run the tests, assuming build.sh has been run first

# This will activate the test env created during the build and then run pytest etc. as
# normal
. $(find ~ -type f -name conda_test_runner.sh)
