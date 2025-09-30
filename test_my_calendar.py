"""Unit tests for 2025 calendar generation functions."""

import calendar
import unittest


def get_2025_calendar():
    """Return the full calendar for the year 2025 as a string."""
    return calendar.TextCalendar().formatyear(2025)


def get_monthly_2025():
    """Return each month's calendar for 2025 as a list of lists of weeks."""
    return [calendar.monthcalendar(2025, month) for month in range(1, 13)]


class TestCalendar2025(unittest.TestCase):
    """Test cases for verifying the correctness of 2025 calendar functions."""

    def test_full_year_calendar(self):
        """Check if the full-year calendar matches expected output."""
        expected = calendar.TextCalendar().formatyear(2025)
        result = get_2025_calendar()
        self.assertEqual(result.strip(), expected.strip())

    def test_monthly_calendars(self):
        """Check if each month's calendar matches expected output."""
        expected = [calendar.monthcalendar(2025, month) for month in range(1, 13)]
        result = get_monthly_2025()
        self.assertEqual(result, expected)

    def test_monthly_calendar_content(self):
        """Check the *content* of a specific month's calendar (January 2025)."""
        january_calendar = calendar.monthcalendar(2025, 1)
        self.assertEqual(len(january_calendar), 5)  # January 2025 has 5 weeks
        self.assertEqual(january_calendar[0], [0, 0, 1, 2, 3, 4, 5])  # First week


def load_tests():
    """Create a test suite that includes all the test cases."""
    test_suite = unittest.TestSuite()
    test_suite.addTest(TestCalendar2025("test_full_year_calendar"))
    test_suite.addTest(TestCalendar2025("test_monthly_calendars"))
    test_suite.addTest(TestCalendar2025("test_monthly_calendar_content"))
    return test_suite


if __name__ == "__main__":
    runner = unittest.TextTestRunner()
    runner.run(load_tests())
