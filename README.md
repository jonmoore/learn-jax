# learn-jax
For working through JAX tutorials, playing around, etc.

# Usage
Run these from the workspace root directory unless mentioned otherwise.

## lock.sh
Create a `conda-lock.yml` file based on `environment.yml`.

## run_all.sh
Runs most of the commands below to go through a complete build/test sequence.

## init.sh
Create a conda environment called `jax` based on `conda-lock.yml`

## clean.sh
Clean stale files using hatch, conda and coverage

## build.sh
Invoke `conda-build` to perform its own build and test, leaving behind working directories, environments, etc.

## install\_from\_local.sh
Remove the installed `learn_jax` package from the conda-build test environment and link the local src directory into this using a `.pth` file.  If run, this will affect the outcomes of both test scripts below.

## test-conda.sh
Run the installed tests that are run by conda-build, using the conda-build test environment.

## test-local.sh
Run the local tests (under `tests`) using the conda-build test environment.

# Questions

## Is using hatch worth the dependency?

Known uses
- for calculating a version, through "hatch version"
- ...

## What are the environments that conda-build uses?

According to chatgpt / editing.

- Render/host environment: Used during evaluation of meta.yaml. CONDA\_BUILD\_STATE is set to RENDER.
- Build/run Environment: Used during the processing of conda's build.sh. CONDA\_BUILD\_STATE is set to BUILD.
- Test Environment: Used during running of run\_test scripts.  CONDA\_BUILD\_STATE is set to TEST.

- host
  - aka render, PREFIX
  - example location: $CONDAENV/conda-bld/learn-jax_1723504425996/_h_env
  - pyproject['project']['requires-python']
  - pip
  - pyproject['build-system']
- run
  - aka BUILD\_PREFIX
  - example location: $CONDAENV/conda-bld/learn-jax\_1723504425996/\_build\_env
  - pyproject['project']['requires-python']
  - pyproject['project']['dependencies']
- test
  - pyproject['project']['optional-dependencies']
  - example location: $CONDAENV/conda-bld/learn-jax\_1723504425996/\_test\_env\_placehold...

- source
  - aka SRC\_DIR, work
  - example location: SRC\_DIR=$CONDAENV/conda-bld/learn-jax\_1723504425996/work
