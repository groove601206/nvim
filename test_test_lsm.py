"""
Module for computing Least Common Multiple (LCM) and its unit tests.
"""

import math
import unittest


def compute_lcm(x, y):
    """
    Compute the Least Common Multiple (LCM) of two integers using the formula:
    LCM(x, y) = abs(x * y) / GCD(x, y)
    """
    return abs(x * y) // math.gcd(x, y)


class TestLCM(unittest.TestCase):
    """
    Unit tests for the compute_lcm function.
    """

    def test_lcm_basic(self):
        """Test basic LCM calculations."""
        self.assertEqual(compute_lcm(54, 24), 216)
        self.assertEqual(compute_lcm(10, 5), 10)
        self.assertEqual(compute_lcm(7, 3), 21)

    def test_lcm_with_one(self):
        """Test LCM where one number is 1."""
        self.assertEqual(compute_lcm(1, 15), 15)
        self.assertEqual(compute_lcm(1, 100), 100)

    def test_lcm_same_numbers(self):
        """Test LCM of the same number."""
        self.assertEqual(compute_lcm(7, 7), 7)
        self.assertEqual(compute_lcm(25, 25), 25)

    def test_lcm_primes(self):
        """Test LCM of two prime numbers."""
        self.assertEqual(compute_lcm(13, 17), 221)
        self.assertEqual(compute_lcm(19, 23), 437)

    def test_lcm_zero(self):
        """Test LCM involving zero."""
        self.assertEqual(compute_lcm(0, 10), 0)
        self.assertEqual(compute_lcm(0, 25), 0)


if __name__ == "__main__":
    unittest.main(verbosity=2)
