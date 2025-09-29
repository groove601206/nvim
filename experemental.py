import calendar


def get_2025_calendar():
    """Return the full calendar for the year 2025 as a string."""
    return calendar.TextCalendar().formatyear(2025)


def get_monthly_2025():
    """Return each month's calendar for 2025 as a list of lists of weeks."""
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
