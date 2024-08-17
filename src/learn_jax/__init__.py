import os
import jax

# Get the absolute path to the current file
jm_learn_jax_init_path = os.path.abspath(__file__)

# Print the path
print(f"{jm_learn_jax_init_path=}")

try:
    from learn_jax._version import version as __version__
except ImportError:  # pragma: no cover
    __version__ = "unknown"

def add(x, y):
    return x + y

def bad_add(x, y):
    return x


