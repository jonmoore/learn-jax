@echo off
for /f %%i in ('hatch version') do set VERSION=%%i
echo running conda-build with VERSION set to %VERSION%
conda build conda.recipe/
