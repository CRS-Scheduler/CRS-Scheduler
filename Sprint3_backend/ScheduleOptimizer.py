import random
from CourseLookup import course_lister
from CourseParser import get_data
from CourseParser import get_days
from CourseParser import get_sched
from CourseParser import get_sem_and_base_url
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
        [print([i.__dict__ for i in course.section_list]) for course in self.courses_data]
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
        self.name = section[0]
        # print(section)
        self.schedules = list(map(lambda schedule: Schedule(schedule), section[1]))
        self.slots = section[2]
        # print([i.__dict__ for i in self.schedules])

class Schedule:
    def __init__(self, schedule):
        self.days = get_days(schedule[0])
        self.time = get_sched(schedule[1:5])
        self.type = schedule[5]
        # print(self.days, self.time, self.type)

def get_course_list_from_program(program: str): #get_course_list_from_program(program) returns list of all courses required under program
    deg = DegreeProgram(program, 3)
    return deg.courses
    # flat = []
    # [flat.extend(sem) for year in deg.courses for sem in year]
    # return list(set(flat))

def main():
    # print(get_course_list_from_program('BS_CS'))
    deg = DegreeProgram('BS_CS', 3)
    
if __name__ == "__main__":
    main()
