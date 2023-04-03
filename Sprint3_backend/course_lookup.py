import sys
# from pathlib import PurePath 
from pathlib import Path

def course_lister(root):
    obj = dict()
    # p = Path(".")
    # degree_programs = filter(lambda x: x.is_dir(), p.iterdir())
    # year_levels = map(lambda x: (x, sorted(x.glob("*.txt"))), degree_programs)
    # for (root, txtfilepath) in year_levels:
    txtfilepath = sorted(Path(root).glob("*.txt"))
    obj[root] = []
    for txtfilename in txtfilepath:
        obj[root].append(write_lookup(txtfilename))
    return obj

def write_lookup(txtfilename):
    file = open(txtfilename, "r+")
    data = tuple(file.read().split("\n\n"))
    write = list(map(lambda x: x.split("\n"), data))
    return write

ret = course_lister("BS-CS")
# python = open(f"course_lookup.py", "w")
# python.seek(0)
# python.truncate()
# python.write(str(ret))
print(ret)
sys.exit()
