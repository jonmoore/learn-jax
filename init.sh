#!/usr/bin/env bash

set -o errexit
set -o xtrace

conda-lock install -n jax conda-lock.yml
