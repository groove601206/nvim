"""
Module to generate and test calendars for the year 2025.

Provides functions to get the full-year calendar as a string,
monthly calendars as lists of weeks, and unit tests to verify
the correctness of the generated calendars.
"""

import calendar
import unittest


def get_2025_calendar():
    """
    Return the full calendar for the year 2025 as a string.

    Uses Python's built-in `calendar.TextCalendar` to generate a
    plain-text formatted year calendar.

    Returns:
        str: Full calendar of 2025 in text format.
    """
    return calendar.TextCalendar().formatyear(2025)


def get_monthly_2025():
    """
    Return the monthly calendars for 2025.

    Each month is represented as a list of weeks, where each week
    is a list of integers. Days outside the month are represented as 0.

    Returns:
        list[list[list[int]]]: A list of 12 months, each containing
                               a list of weeks (list of integers).
    """
    return [calendar.monthcalendar(2025, month) for month in range(1, 13)]


class TestCalendar2025(unittest.TestCase):
    """
    Unit tests for verifying the correctness of 2025 calendar functions.

    Tests include checking the full-year calendar string, the monthly
    calendars as lists of weeks, and the content of a specific month's
    calendar.
    """

    def test_full_year_calendar(self):
        """Check if the full-year calendar matches the expected output."""
        expected = calendar.TextCalendar().formatyear(2025)
        result = get_2025_calendar()
        self.assertEqual(result.strip(), expected.strip())

    def test_monthly_calendars(self):
        """Check if each month's calendar matches the expected output."""
        expected = [calendar.monthcalendar(2025, month) for month in range(1, 13)]
        result = get_monthly_2025()
        self.assertEqual(result, expected)

    def test_monthly_calendar_content(self):
        """Check the content of January 2025's calendar specifically."""
        january_calendar = calendar.monthcalendar(2025, 1)  # January is month 1
        self.assertEqual(len(january_calendar), 5)  # January 2025 has 5 weeks
        self.assertEqual(january_calendar[0], [0, 0, 1, 2, 3, 4, 5])  # First week


def suite():
    """
    Create a test suite for all TestCalendar2025 test cases.

    Returns:
        unittest.TestSuite: A test suite containing all calendar tests.
    """
    test_suite = unittest.TestSuite()
    test_suite.addTest(TestCalendar2025("test_full_year_calendar"))
    test_suite.addTest(TestCalendar2025("test_monthly_calendars"))
    test_suite.addTest(TestCalendar2025("test_monthly_calendar_content"))
    return test_suite


if __name__ == "__main__":
    # Run the test suite
    runner = unittest.TextTestRunner()
    runner.run(suite())
