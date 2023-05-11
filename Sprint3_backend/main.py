from datetime import time
from OptimalSchedule import OptimalSchedule

# Create a new optimal schedule object
my_schedule = OptimalSchedule()

my_schedule.set_event('Monday', time(17, 0), time(18, 0), 'CS194')
my_schedule.set_event('Tuesday', time(11,30), time(13,0), 'STS1')
my_schedule.set_event('Tuesday', time(15,0), time(16,0), 'PE2')
my_schedule.set_event('Thursday', time(11,30), time(13,0), 'STS1')
my_schedule.set_event('Thursday', time(15,0), time(16,0), 'PE2')
my_schedule.set_event('Wednesday', time(10,0), time(11,30), 'CS 132')
my_schedule.set_event('Saturday', time(7,0), time(12,30), 'ROTC')

my_schedule.print_schedule()

#test get_event method
print('\nget_event method:')
print(my_schedule.get_event('Monday', time(17,0)))
#test remove_event method
print('\nremove_event method:')
my_schedule.remove_event('Monday', time(17,0))
print(my_schedule.get_event('Monday', time(17,0)))
