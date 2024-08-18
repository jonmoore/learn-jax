#!/usr/bin/env bash

jm_assert_jax_env() {
    local conda_env="$1"
    echo "Checking if conda environment '$conda_env' is activated."

    if [ "$CONDA_DEFAULT_ENV" != "$conda_env" ]; then
        echo "Could not activate the '$conda_env' conda environment."
        exit 1
    fi
}

jm_activate() {
    local conda_env="$1"
    echo "Ensuring conda environment '$conda_env' is activated."

    # Guard running the eval/conda activate as it fails when the jax environment has
    # already been activated.
    if [ "$CONDA_DEFAULT_ENV" != "$conda_env" ]; then
        eval "$(conda shell.bash hook)"
        conda activate "$conda_env"
    fi

    jm_assert_jax_env "$conda_env"
}

jm_find_one_file() {
    # Example usage
    # result=$(jm_find_one_file "/path/to/directory" f "filename.txt")
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
