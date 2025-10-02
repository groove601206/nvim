"""Module for generating 2025 calendar data."""

import calendar


def get_2025_calendar() -> str:
    """
    Return the full calendar for the year 2025 as a formatted string.

    Returns:
        str: The full calendar for 2025.
    """
    return calendar.TextCalendar().formatyear(2025)


def get_monthly_2025() -> list[list[list[int]]]:
    """
    Return each month's calendar for 2025 as a list of weeks.

    Each month is represented as a list of weeks, and each week is a list
    of integers where 0 represents days outside the month.

    Returns:
        list[list[list[int]]]: A list of 12 months, each containing weeks of days.
    """
    return [calendar.monthcalendar(2025, month) for month in range(1, 13)]


if __name__ == "__main__":
    # Print the full calendar for 2025
    print(get_2025_calendar())
    print("\n")

    # Print each month's calendar for 2025
    monthly_calendar = get_monthly_2025()
    for month_index, month in enumerate(monthly_calendar, start=1):
        print(f"Month {month_index}:")
        for week in month:
            print(week)
        print("\n")
