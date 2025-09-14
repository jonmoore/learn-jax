import timeit

import jax
import jax.numpy as jnp
from jax import jit, grad
import numpy as np


def selu(x, alpha=1.67, lmbda=1.05):
  return lmbda * jnp.where(x > 0, x, alpha * jnp.exp(x) - alpha)


def sum_logistic(x):
    return jnp.sum(1.0 / (1.0 + jnp.exp(-x)))

def selu_timings():
    """Report on some post-compiled execution times for jit and non-jit versions of the
    selu function defined above.
    """
    def time_calls(selu_instance, x, number=100):
        return timeit.timeit(lambda: selu_instance(x).block_until_ready(), number=number)

    key = jax.random.key(1701)
    x = jax.random.normal(key, (1_000_000,))

    selu_jit = jit(selu)
    _ = selu_jit(x)  # compiles on first call

    return {
        'no-jit': time_calls(selu, x),
        'jit': time_calls(selu_jit, x),
    }


def grad_demo():
    """Report on autograd vs. finite-difference calculations.
    """

    def first_finite_differences(f, x, eps=1E-3):
        return jnp.array([(f(x + eps * v) - f(x - eps * v)) / (2 * eps)
                          for v in jnp.eye(len(x))])

    x_small = jnp.arange(3.)

    print()

    return {'compare-derivatives': {'autograd': grad(sum_logistic)(x_small),
                                    'finite-diff': first_finite_differences(sum_logistic, x_small)
                                    },
            'third-derivatives': {'no-jit': grad(grad(grad(sum_logistic)))(1.0),
                                  'jit': grad(jit(grad(jit(grad(sum_logistic)))))(1.0),
                                  }
            }


def jacobian_demo():
    return jax.jacobian(jnp.exp)(jnp.arange(3.))

def hessian_demo():
    def hessian(fun):
        return jit(jax.jacfwd(jax.jacrev(fun)))
    return hessian(sum_logistic)(jnp.arange(3.))

def vmap_demo():
    key = jax.random.key(1701)

    key1, key2 = jax.random.split(key)
    mat = jax.random.normal(key1, (150, 100))
    batched_x = jax.random.normal(key2, (10, 100))

    print(f"{mat.shape=}")
    print(f"{batched_x.shape=}")

    def apply_matrix(x):
        return jnp.dot(mat, x)

    def naive_batched(v_batched):
        return jnp.stack([apply_matrix(v) for v in v_batched])

    @jit
    def manual_batched(batched_x):
        return jnp.dot(batched_x, mat.T)

    @jit
    def vmap_batched(batched_x):
        return jax.vmap(apply_matrix)(batched_x)

    np.testing.assert_allclose(naive_batched(batched_x),
                               manual_batched(batched_x), atol=1E-4, rtol=1E-4)
    np.testing.assert_allclose(naive_batched(batched_x),
                               vmap_batched(batched_x), atol=1E-4, rtol=1E-4)

    return {'timings': {'naive': timeit.timeit(lambda: naive_batched(batched_x).block_until_ready(), number=100),
                        'manual': timeit.timeit(lambda: manual_batched(batched_x).block_until_ready(), number=100),
                        'vmap': timeit.timeit(lambda: vmap_batched(batched_x).block_until_ready(), number=100),
                        }
            }

def main():
    x = jnp.arange(-5.0, 5.0)
    print(f"{x=}")
    print(f"{selu(x, alpha=1, lmbda=1)=}")

    print(f"{selu_timings()=}")
    print(f"{grad_demo()=}")
    print(f"{jacobian_demo()=}")
    print(f"{hessian_demo()=}")
    print(f"{vmap_demo()=}")


if __name__ == '__main__':
    main()
