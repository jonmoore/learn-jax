#!/usr/bin/env bash

    # set +e
    # local errexit_state=$(set +o | grep -E 'errexit')
    # eval "$errexit_state"

################################################################################
# begin from functions.sh
################################################################################
_jm_assert_jax_env() {
    local conda_env="$1"
    echo "Checking if conda environment '$conda_env' is activated."

    if [ "$CONDA_DEFAULT_ENV" != "$conda_env" ]; then
        echo "Could not activate the '$conda_env' conda environment."
        exit 1
    fi
}

_jm_activate() {
    local conda_env="$1"
    echo "Ensuring conda environment '$conda_env' is activated."

    # Guard running the eval/conda activate as it fails when the jax environment has
    # already been activated.
    if [ "$CONDA_DEFAULT_ENV" != "$conda_env" ]; then
        eval "$(conda shell.bash hook)"
        conda activate "$conda_env"
    fi

    _jm_assert_jax_env "$conda_env"
}

_jm_find_one_file() {
    # Example usage
    # result=$(_jm_find_one_file "/path/to/directory" f "filename.txt")
    local directory="$1"
    local type="$2"
    local filename="$3"

    local files=($(find "$directory" -type $type -name "$filename"))

    # Check the number of matching files
    if [ ${#files[@]} -eq 1 ]; then
        echo "${files[0]}"
        return 0
    else
        return 1
    fi
}

_jm_test_init() {
    source $(find $CONDA_PREFIX -type f -name conda_test_env_vars.sh)
    # Make the conda environment label in PS1 more useful
    PS1=$(echo "$PS1" | perl -pe 's/_placehold[^)]*\)/\)/' | perl -pe 's/\Q$ENV{HOME}\/miniconda3\/envs\/\E//')
}

################################################################################
# end from functions.sh
################################################################################




function default {
    help
}

function help {
    echo "$0 <task> <args>"
    echo "Tasks:"
    compgen -A function | grep -v "^_jm" | cat -n
}

TIMEFORMAT="Task completed in %3lR"
time ${@:-default}
