# learn-jax
For working through JAX tutorials, playing around, etc.

# Questions

Is using hatch worth the dependency?  Known uses
- for calculating a version, through "hatch version"
- ...

How to set up an editable dev environment? Current best guess

1. build our conda package
-   build using conda-build
2. install the local files to the active environment along with dependencies
- conda install --use-local learn-jax
3. remove the installed package but leave the dependencies
- conda remove --force learn-jax
4. use pip to install the package but leave it editable
- pip install --no-build-isolation --no-deps -e .

Note that conda develop has been confirmed as broken / deprecated by the maintainers for
years now, even though they haven't put this in the docs.

Refs:

- https://github.com/conda/conda-build/issues/4251#issuecomment-1053460542
- https://github.com/conda/conda-build/pull/5380

What are the environments that conda-build uses?

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
