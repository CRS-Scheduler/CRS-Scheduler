from datetime import time
from schedule import Schedule

# Create a new schedule object
my_schedule = Schedule()

# Set CS21 on Monday from 7:00 to 8:30
my_schedule.set_event('Monday', time(7, 0), time(8, 30), 'CS21')
# Set CS138 on Tuesday, Thursday from 15:00 to 16:30
my_schedule.set_event('Tuesday', time(15, 0), time(16, 30), 'CS138')
my_schedule.set_event('Thursday', time(15, 0), time(16, 30), 'CS138')

# Print current schedule
my_schedule.print_schedule();
