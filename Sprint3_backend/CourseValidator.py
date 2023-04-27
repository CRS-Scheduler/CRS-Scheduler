from bs4 import BeautifulSoup
import requests
import re
import CourseLookup

# Schedule format:
# (class_name, raw_schedule, slots)

# Error printing (for debug only!)
def eprint(string):
    print(string)
    exit(1)

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
        # re.findall(, str(ret))
        # print(ret)
        return (True, ret)
    except:
        error = "Error! Could not obtain the parse object. Perhaps the HTML is not fully loaded?"
        return (False, error)

def get_data_from_parsed_contents(name, parsed_contents):
    ret = []
    regex_string = r"(M|T|W|Th|F|S|MT|MW|MTh|MF|MS|TW|TTh|TF|TS|WTh|WF|WS|ThF|ThS|FS) (\d{1,2}[:]?\d{0,2})(AM|PM|)?-(\d{1,2}[:]?\d{0,2})(AM|PM) (lab|lec)"
    dissolved_offset = 0
    if len(parsed_contents) == 1: return ret
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
    return ret

def get_data(name):
    tmp = get_html(name)
    if not tmp[0]: eprint(tmp[1]) # error print for get_html
    tmp = parse_contents(tmp[1])
    if not tmp[0]: eprint(tmp[1]) # error print for parse_contents
    return get_data_from_parsed_contents(name, tmp[1])

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
                days.append("Tuesday")
            case "W": days.append("Wednesday")
            case "F": days.append("Friday")
            case "S": days.append("Saturday")
    return days

class DegreeProgram:
    def __init__(self, name):
        self.name = name
        # Require a lookup table for a particular degree program
        self.courses = CourseLookup.course_lister(name)
        self.years = len(self.courses)
        self.courses_data = self.fetch_courses_data()

    def print_courses(self):
        print(self.courses)
    
    def print_years(self):
        print(self.years)

    def fetch_courses_data(self):
        courses_data = []
        for current_year in self.courses:
            first_sem = map(lambda c: Course(c), current_year[0])
            second_sem = map(lambda c: Course(c), current_year[1])
            midyear_sem = map(lambda c: Course(c), current_year[2])
            courses_data.append((first_sem, second_sem, midyear_sem))
        return courses_data

    def print_courses_data(self):
        [course.print_data() for year in self.courses_data for sem in year for course in sem]

class Course:
    def __init__(self, name):
        self.name = name
        self.section_list = map(lambda section: Section(section), get_data(name))
    def print_data(self):
        print([i.__dict__ for i in self.section_list])

class Section:
    def __init__(self, section):
        self.name = section[0]
        self.schedules = map(lambda schedule: Schedule(schedule), section[1])
        self.slots = section[2]
    def print_section(self):
        print([i.__dict__ for i in self.schedules])

class Schedule:
    def __init__(self, schedule):
        self.days = get_days(schedule[0])
        self.time = get_sched(schedule[1:5])
        self.type = schedule[5]

def get_course_list_from_program(program: str): #get_course_list_from_program(bs_cs) returns list of all courses required under program
    deg = DegreeProgram(program)
    flat = []
    [flat.extend(sem) for year in deg.courses for sem in year]
    return list(set(flat))

def main():
    print(get_course_list_from_program('BS_CS'))
    
if __name__ == "__main__":
    main()