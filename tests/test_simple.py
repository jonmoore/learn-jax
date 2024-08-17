import learn_jax as lj

def test_add():
    """Test the add function
    """

    assert lj.add(2, 2) == 4

def test_bad_add():
    """Test the bad_add function
    """

    assert lj.bad_add(2, 2) != 4
