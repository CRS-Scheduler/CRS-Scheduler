from bs4 import BeautifulSoup
import requests
import re

# Schedule format:
# (class_name, raw_schedule, slots)

def sched_lookup(sched):
    regex_string = r"(\d{1})[:](\d{2})?"
    sched = re.findall(regex_string, sched)
    return sched[0]

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

def get_data_from_parsed_contents(parsed_contents):
    error = "No courses to display!"
    ret = []
    regex_string = r"(M|T|W|Th|F|S|MT|MW|MTh|MF|MS|TW|TTh|TF|TS|WTh|WF|WS|ThF|ThS|FS) (\d{1,2}[:]?\d{0,2})(AM|PM|)?-(\d{1,2}[:]?\d{0,2})(AM|PM)?"
    dissolved_offset = 0
    if len(parsed_contents) == 1: return (False, error)
    for i in range(0, len(parsed_contents), 8):
        class_name = parsed_contents[1+i+dissolved_offset].get_text()
        search_string = str(parsed_contents[3+i+dissolved_offset])
        slots = parsed_contents[5+i+dissolved_offset]
        if not re.search(r"\b"+class_name+r"\b", class_name):
            continue
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
    tmp = get_data_from_parsed_contents(tmp[1])
    return tmp[1]

class Course:
    def __init__(self, name):
        self.name = name
        self.course_list = get_data(name)
    def print_data(self):
        print(self.course_list)

class DegreeProgram:
    def __init__(self, name):
        self.name = name
        self.year_levels = 4

def main():
    all_courses = [ "CS 192",
                    "CS 194",
                    "CS 145",
                    "CS 153",
                    "CS 180",
                    "math 23" ]
    for i in all_courses:
        Course(i).print_data()

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