#!/usr/bin/env bash

VERSION=$(hatch version)
if [ $? -ne 0 ]; then
    echo "Error: calling 'hatch version' failed."
    exit 1
fi

if [ -z "$VERSION" ]; then
    echo "Error: VERSION is empty after calling 'hatch version'"
    exit 1
fi

export VERSION

echo running conda-build with VERSION set to "$VERSION"
conda build conda.recipe/
