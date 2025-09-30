"""Unit tests for factorial function implementation."""

import unittest


def factorial(num):
    """Compute the factorial of a non-negative integer.

    Args:
        num (int): The number to compute factorial for.

    Returns:
        int: The factorial of the number.

    Raises:
        ValueError: If num is negative.
    """
    if num < 0:
        raise ValueError("Factorial does not exist for negative numbers")
    if num == 0:  # no need for elif after raise
        return 1

    result = 1
    for i in range(1, num + 1):
        result *= i
    return result


class TestFactorial(unittest.TestCase):
    """Unit tests for the factorial function."""

    def test_factorial_positive(self):
        """Test factorial for a positive integer."""
        self.assertEqual(factorial(7), 5040)

    def test_factorial_zero(self):
        """Test factorial when the input is zero."""
        self.assertEqual(factorial(0), 1)

    def test_factorial_negative(self):
        """Test factorial raises ValueError for negative input."""
        with self.assertRaises(ValueError):
            factorial(-5)


if __name__ == "__main__":
    unittest.main()
