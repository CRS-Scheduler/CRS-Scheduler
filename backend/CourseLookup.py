import random
from pathlib import Path

def course_lister(root, year, semester):
    file = open(f"{root}/{root}_{year}.txt", "r+")
    data = file.read().split("\n\n")
    file.close()
    write = list(map(lambda x: x.split("\n"), data))[semester-1]
    return course_parser(root, year, write)

def course_parser(root, year, course_list):
    initial_length = len(course_list)
    for i in range(0,initial_length):
        course = course_list[i]
        if len(course) < len(root): continue
        if course[0:len(root)] == root:
            extras_file = open(f"{root}/{root}{course[len(root):]}.txt", "r+")
            course_extras = extras_file.read().split("\n")
            extras_file.close()
            while True:
                if len(course_extras) == 0: break
                course_list.append(course_extras.pop())
            del course_list[i]
    return course_list
