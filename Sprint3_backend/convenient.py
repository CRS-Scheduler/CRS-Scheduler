import sys
# import os.path

file = open(sys.argv[1], "r+")
python = open(f"course_lookup.py", "w")
data = tuple(file.read().split("\n\n"))
write = tuple(map(lambda x: x.split("\n"), data))
python.seek(0)
python.truncate()
python.write(str(write))
sys.exit()
