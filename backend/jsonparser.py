import os, json
progs = dict()

for (root,dirs,files) in os.walk('./DPrograms', topdown=True):
    if root == './DPrograms':
        continue
    else:
        mroot = root.split("\\")[1]
    progs[mroot] = dict()
    print(root, files)
    for f in files:
        progs[mroot][f.rstrip(".txt")] = "\n".join(open((os.getcwd()+root[1:]+"/"+f).replace("\\", "/"), "r").readlines()).split("\n")
        progs[mroot][f.rstrip(".txt")] = list(set(progs[mroot][f.rstrip(".txt")]))

js = open("dprograms.json", "w")
js.write(json.dumps(progs))
js.close()

