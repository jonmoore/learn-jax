#!/usr/bin/env bash

set -o xtrace
set -o errexit

# Initialize mode variable
mode=""

# Display usage information
display_help() {
    echo "Usage: $0 --mode <build|debug|dirty|dev>"
    echo "Options:"
    echo "  -m, --mode <mode>   Set the build mode (build, debug, dirty, or dev)"
    echo "  -h, --help      Show this help message"
    exit 0
}

# Parse command-line arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
        -m|--mode)
            shift
            if [[ -z "$mode" ]]; then
                mode="$1"
            else
                echo "Error: --mode can only be set once."
                exit 1
            fi
            ;;
         -h|--help)
            display_help
            ;;
         *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
    shift
done

# Validate that --mode is set
if [[ -z "$mode" ]]; then
    echo "Error: --mode must be set to 'build', 'debug', or 'build-dirty'."
    exit 1
fi

script_dir=$(dirname "$(realpath "$0")")
source "$script_dir/functions.sh"
jm_activate "jax"

if ! VERSION=$(hatch version); then
    echo "Error: calling 'hatch version' failed."
    exit 1
fi

if [ -z "$VERSION" ]; then
    echo "Error: VERSION is empty after calling 'hatch version'"
    exit 1
fi

export VERSION

echo running with VERSION set to "$VERSION"

# conda build options
#  --no-test             Do not test the package.
#  -b, --build-only      Only run the build, without any post processing or
#                        testing. Implies --no-test and --no-anaconda-upload.
#  --dirty               Do not remove work directory or _build environment.
#
# conda debug: https://docs.conda.io/projects/conda-build/en/stable/user-guide/recipes/debugging.html
case "$mode" in
    build)
        conda build --dirty conda.recipe
        ;;
    debug)
        conda debug conda.recipe
        ;;
    *)
        echo "Unknown mode: $mode"
        exit 1
        ;;
esac
