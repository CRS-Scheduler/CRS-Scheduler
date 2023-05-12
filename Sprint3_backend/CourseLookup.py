from pathlib import Path

def course_lister(root, year, semester):
    file = open(f"{root}/{root}_{year}.txt", "r+")
    data = list(file.read().split("\n\n"))
    write = list(map(lambda x: x.split("\n"), data))[semester-1]
    return write
