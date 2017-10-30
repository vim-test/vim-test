def test_numbers():
    assert 1 == 1

def test_foo():
    class CustomException(Exception):
        pass
    mocker.patch('some.module', side_effect=CustomException())

    assert something
