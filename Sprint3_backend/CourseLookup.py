import sys
# from pathlib import PurePath 
from pathlib import Path

def course_lister(root):
    # p = Path(".")
    # degree_programs = filter(lambda x: x.is_dir(), p.iterdir())
    # year_levels = map(lambda x: (x, sorted(x.glob("*.txt"))), degree_programs)
    # for (root, txtfilepath) in year_levels:
    txtfilepath = sorted(Path(root).glob("*.txt"))
    return list(map(lambda x: write_lookup(x), txtfilepath))

def write_lookup(txtfilename):
    file = open(txtfilename, "r+")
    data = tuple(file.read().split("\n\n"))
    write = list(map(lambda x: x.split("\n"), data))
    return write