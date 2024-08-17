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
    # leaving only things that are working as intended or under active dev
    # commenting things that are still not working as desired,
    build)
        conda build --dirty conda.recipe
        ;;
    #     conda install -y --use-local learn-jax
    # dirty)
    #     conda build --dirty conda.recipe
    #     conda install -y --use-local learn-jax
    #     ;;
    # dev)
    #     #        conda build --build-only --dirty conda.recipe
    #     conda build --dirty conda.recipe
    #     # conda install -y --use-local learn-jax
    #     # conda remove --force learn-jax
    #     # # This is similar to what meta.yaml uses.  Maybe we can use that instead?
    #     # python -m pip install --no-build-isolation --no-deps --ignore-installed -vv .
    #     # source activate  /home/moorjona/miniconda3/envs/jax/conda-bld/learn-jax_1723504425996/_build_env
    #     ;;
    debug)
          conda debug conda.recipe
          # This results in

          # a suggested setup command like
          # cd /home/moorjona/miniconda3/envs/jax/conda-bld/debug_1723907935504/work && source /home/moorjona/miniconda3/envs/jax/conda-bld/debug_1723907935504/work/build_env_setup.sh

          # work now contains a copy of all the files in the original git worktree plus the following
          # - build_env_setup.sh
          # - conda_build.sh
          # - metadata_conda_debug.yaml
          
          # files as follows
          # find ~ -type f  -name jmjax.py
          # /home/moorjona/git/jonmoore/learn-jax/src/learn_jax/jmjax.py
          # /home/moorjona/miniconda3/envs/jax/conda-bld/debug_1723907935504/work/src/learn_jax/jmjax.py

        ;;
    *)
        echo "Unknown mode: $mode"
        exit 1
        ;;
esac
