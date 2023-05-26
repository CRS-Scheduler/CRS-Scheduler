import random
from CourseLookup import course_lister
from CourseParser import get_data, get_days, get_sched, get_sem_and_base_url
from OptimalSchedule import OptimalSchedule

class DegreeProgram:
    def __init__(self, name, year):
        self.name = name
        # Require a lookup table for a particular degree program
        current_sem, base_url = get_sem_and_base_url()
        self.courses = course_lister(name, year, current_sem)
        self.years = len(self.courses)
        self.courses_data = list(map(lambda c: Course(c, base_url), self.courses))


        # print(self.courses)
        # print(self.years)
        # [print([i.__dict__ for i in course.section_list]) for course in self.courses_data]
        # [print([i.__dict__ for i in course.section_list]) for year in self.courses_data for sem in year for course in sem]

    # def fetch_courses_data(self, semester):
    #     courses_data = []
    #     for current_year in self.courses:
    #         first_sem = list(map(lambda c: Course(c), current_year[0]))
    #         second_sem = list(map(lambda c: Course(c), current_year[1]))
    #         midyear_sem = list(map(lambda c: Course(c), current_year[2]))
    #         courses_data.append((first_sem, second_sem, midyear_sem))
    #     return courses_data

class Course:
    def __init__(self, name, base_url):
        self.name = name
        self.section_list = list(map(lambda section: Section(section), get_data(name, base_url)))
        # print([i.__dict__ for i in self.section_list])

class Section:
    def __init__(self, section):
        self.code = section[0]
        self.name = section[1]
        # print(section)
        self.schedules = list(map(lambda schedule: Schedule(schedule), section[2]))
        self.slots = section[3]
        self.units = section[4]
        # print([i.__dict__ for i in self.schedules])

class Schedule:
    def __init__(self, schedule):
        self.days = get_days(schedule[0])
        self.time = get_sched(schedule[1:5])
        self.type = schedule[5]
        # print(self.days, self.time, self.type)

def get_course_list_from_program(program, year_level): #get_course_list_from_program(program) returns list of all courses required under program
    deg = DegreeProgram(program, year_level)
    return deg.courses

def schedule_optimizer(program, year_level): # returns optimal schedule
    optimal_schedule = OptimalSchedule()
    degree_program = DegreeProgram(program, year_level)
    random_courses_data = degree_program.courses_data.copy()
    random.shuffle(random_courses_data)
    for course in random_courses_data:
        random_section_list = course.section_list.copy()
        random.shuffle(random_section_list)
        if len(course.section_list) == 0: continue
        while True:
            reset = False
            if len(random_section_list) == 0: break;
            selected = random_section_list.pop()
            for schedule in selected.schedules:
                for day in schedule.days:
                    if not optimal_schedule.is_free(day, schedule.time[0], schedule.time[1], selected.name):
                        reset = True
                        break
            break
        if reset == True: continue
        for schedule in selected.schedules:
            for day in schedule.days:
                optimal_schedule.set_event(day, schedule.time[0], schedule.time[1], selected.name)
    print_str = ""
    for day, day_schedule in optimal_schedule.schedule.items():
        print_str += day + '\n'
        event_start = None
        event_end = None
        pr_event = ''
        for i, event in enumerate(day_schedule):
            if event:
                pr_event = event
                if event_start is None:
                    event_start = i
                    event_end = i
                else:
                    event_end = i  
            # Check if the event has ended or it's the last time slot of the day
            if (not event or i == len(day_schedule) - 1) and event_start is not None: 
                start_time = f'{event_start // 2 + 7:02}{event_start % 2 * 30:02}'
                end_time = f'{(event_end + 1) // 2 + 7:02}{(event_end + 1) % 2 * 30:02}'
                print_str += f'{start_time},{end_time},{pr_event}' + '\n'
                event_start = None
                event_end = None
    return print_str
