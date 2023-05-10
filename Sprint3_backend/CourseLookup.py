from pathlib import Path

def course_lister(root, year, semester):
    # p = Path(".")
    # degree_programs = filter(lambda x: x.is_dir(), p.iterdir())
    # year_levels = map(lambda x: (x, sorted(x.glob("*.txt"))), degree_programs)
    # for (root, txtfilepath) in year_levels:
    txtfilepath = sorted(Path(root).glob(f"{root}_{year}.txt"))
    return write_lookup(txtfilepath[0], semester)

def write_lookup(txtfilename, semester):
    file = open(txtfilename, "r+")
    data = tuple(file.read().split("\n\n"))
    write = list(map(lambda x: x.split("\n"), data))
    return write[semester]
