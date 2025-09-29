import calendar  # Standard library calendar

# Create an instance of TextCalendar
cal = calendar.TextCalendar()

# Get the full calendar for the year 2025
year_calendar = cal.formatyear(2025)
print("Full Calendar for 2025:")
print(year_calendar)

# Get the calendar for a specific month (e.g., January 2025)
month_calendar = cal.formatmonth(2025, 1)
print("\nCalendar for January 2025:")
print(month_calendar)
