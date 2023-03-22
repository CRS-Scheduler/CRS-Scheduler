from bs4 import BeautifulSoup
import requests
import re

# Schedule format:
# (class_name, raw_schedule, slots)

def time_lookup(time):
    regex_string = r"(\d{1,2})[:]?(\d{0,2})"
    # print(re.findall(regex_string, time)[0])
    parsed_time = re.findall(regex_string, time)[0]
    hours = int(parsed_time[0]) * 100
    minutes = int(parsed_time[1]) if parsed_time[1] != "" else 0
    return (hours + minutes) % 1200

def get_sched(sched):
    start = time_lookup(sched[0])
    end = time_lookup(sched[2])
    AM = 0000
    PM = 1200
    if sched[1] == "": start = start + AM if sched[3] == "AM" else start + PM
    else: start = start + AM if sched[1] == "AM" else start + PM
    end = end + AM if sched[3] == "AM" else end + PM
    return (start,end)

# Error printing (for debug only!)
def eprint(string):
    print(string)
    exit(1)

def get_html(name):
    url = "https://crs.upd.edu.ph/schedule/120222/" + name.replace(" ", "%20")
    try:
        ret = requests.get(url, timeout=3).text
        return (True, ret)
    except:
        error = "Error! Could not parse the url. Check the url and try again!"
        # print(contents)
        return (False, error)

def parse_contents(contents):
    try:
        ret = BeautifulSoup(contents, "html.parser").find_all('td')
        # print(ret)
        return (True, ret)
    except:
        error = "Error! Could not obtain the parse object. Perhaps the HTML is not fully loaded?"
        return (False, error)

def get_data_from_parsed_contents(name, parsed_contents):
    error = "No courses to display!"
    ret = []
    regex_string = r"(M|T|W|Th|F|S|MT|MW|MTh|MF|MS|TW|TTh|TF|TS|WTh|WF|WS|ThF|ThS|FS) (\d{1,2}[:]?\d{0,2})(AM|PM|)?-(\d{1,2}[:]?\d{0,2})(AM|PM) (lab|lec)"
    dissolved_offset = 0
    if len(parsed_contents) == 1: return (False, error)
    for i in range(0, len(parsed_contents), 8):
        class_name = parsed_contents[1+i+dissolved_offset].get_text(" ")
        # print(class_name)
        search_string = str(parsed_contents[3+i+dissolved_offset])
        if not re.search(r"\b"+name+r"\b", class_name, re.IGNORECASE):
            continue
        slots = parsed_contents[5+i+dissolved_offset]
        if re.search("DISSOLVED", str(slots)):
            dissolved_offset -= 1 
            continue
        if re.search("OVERBOOKED", str(slots)):
            continue
        slots = int(slots.find_all('strong')[0].get_text())
        if slots == 0:
            continue
        raw_schedule = re.findall(regex_string, search_string)
        ret.append((class_name, raw_schedule, slots))
    if len(ret) == 0: return (False, error)
    return (True, ret)

def get_data(name):
    tmp = get_html(name)
    if not tmp[0]: eprint(tmp[1]) # error print for get_html
    tmp = parse_contents(tmp[1])
    if not tmp[0]: eprint(tmp[1]) # error print for parse_contents
    tmp = get_data_from_parsed_contents(name, tmp[1])
    return tmp[1] if tmp[0] else eprint(tmp[1])

def get_days(days_sched):
    days = []
    for i in range(0, len(days_sched)):
        match days_sched[i]:
            case "M": days.append("Monday")
            case "T":
                if i+1 == len(days_sched):
                    days.append("Tuesday")
                elif days_sched[i+1] == "h":
                    days.append("Thursday")
                else:
                    days.append("Tuesday")
            case "W": days.append("Wednesday")
            case "F": days.append("Friday")
            case "S": days.append("Saturday")
    return days

class DegreeProgram:
    def __init__(self, name):
        self.name = name
        self.courses = {
            1: (
                ["KAS 1", "PHILO 1", "MATH 21", "CS 11", "CS 30", "CS 10", "PE 1", "PE 2"],
                ["SOC SCI 1", "SOC SCI 2", "CS 12", "CS 31", "MATH 22", "PHYSICS 71", "PE 1", "PE 2"],
                [],
            ),
            2: (
                ["ENG 13", "CS 20", "CS 32", "MATH 23", "PHYSICS 72", "PE 1", "PE 2", "NSTP"],
                ["SPEECH 30", "CS 21", "CS 33", "CS 136", "MATH 40", "PE 1", "PE 2", "NSTP"],
                [],
            ),
            3: (
                ["FIL 40", "CS 138", "CS 140", "CS 150", "CS 165", "CS 191"],
                ["ENG 30", "CS 145", "CS 153", "CS 180", "CS 192", "CS 194"],
                ["CS 195"],
            ),
            4: (
                ["STS 1", "CS 133", "CS 198", "ENGG 150"],
                ["ARTS 1", "CS 132", "CS 155", "CS 196", "CS 199", "CS 200", "PI 100"],
                [],
            ),
        }
        self.years = len(self.courses)

    def print_courses(self):
        print(self.courses)

    class Course:
        def __init__(self, name):
            self.name = name
            self.course_list = map(lambda section: self.Section(section), get_data(name))
        def print_data(self):
            print([i.__dict__ for i in self.course_list])

        class Section:
            def __init__(self, section):
                self.name = section[0]
                self.schedules = map(lambda schedule: self.Schedule(schedule), section[1])
                self.slots = section[2]
            def print_section(self):
                print([i.__dict__ for i in self.schedules])
            # def print_time(self):
            #     print(self.time)

            class Schedule:
                def __init__(self, schedule):
                    self.days = get_days(schedule[0])
                    self.time = get_sched(schedule[1:5])
                    self.type = schedule[5]
                    # self.start, self.end = get_times(schedule[1:2], schedule[3:4])

def main():
    # DegreeProgram("BS CS", 4).print_courses()
    course = "PHILO 1"
    DegreeProgram("BS CS").Course(course).print_data()
    for i in DegreeProgram("BS CS").Course(course).course_list:
        i.print_section()
    # print(parse_schedule([('TTh', '8:30', '', '9:30', 'AM')]))
    # print(parse_schedule("ThT"))

if __name__ == "__main__":
    main()

# class DegreeProgramDAO:
#     def __init__(self):
#         self.CourseDict = set()

#     def insertDegree(self, degree_name):
#         self.CourseDict.add(degree_name)

#     def degreeValidator(self, degree_name):
#         if degree_name in self.CourseDict:
#             # print("Valid!")
#             return
#         # print("Invalid!")
    
#     # def printCourseDict(self):
#     #     print(self.CourseDict)

# degree_programs = DegreeProgramDAO()
# degree_programs.insertDegree("BS CS")
# degree_programs.insertDegree("BS EE")
# degree_programs.degreeValidator("BS CS")
# degree_programs.degreeValidator("BS AE")

# degree_programs.printCourseDict()