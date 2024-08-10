import jax.numpy as jnp
import numpy as np

def test_true():
    """A trivial test so that pytest does not complain about not finding tests.
    """

    assert 42 == 42


# def test_false():
#     """A trivial test so that pytest does not complain about not finding tests.
#     """

#     assert 42 != 42


def test_numpy_smoke_test():
    # Perform a simple calculation using NumPy
    a = np.array([1, 2, 3])
    b = np.array([4, 5, 6])
    result = a + b

    # Check if the result is as expected
    expected_result = np.array([5, 7, 9])
    assert np.array_equal(result, expected_result), f"Unexpected result: {result}"


def test_jax_smoke_test():
    a = jnp.array([1, 2, 3])
    b = jnp.array([4, 5, 6])
    result = a + b

    expected_result = jnp.array([5, 7, 9])
    assert jnp.array_equal(result, expected_result), f"Unexpected result: {result}"

