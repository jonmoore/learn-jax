#!/usr/bin/env bash

set -o xtrace
set -o errexit

rm conda-lock.yml
conda-lock -f environment.yml -p linux-64
