import random, time, datetime, os
from ScheduleOptimizer import DegreeProgram

DEFAULTBIAS = 5 #default requirement bias
PERUNITSCORE = 2

def weighted_sample_without_replacement(population, weights, k, rng=random):
        v = [rng.random() ** (1 / w) for w in weights]
        order = sorted(range(len(population)), key=lambda i: v[i])
        return [population[i] for i in order[-k:]]

class Requirement: #interface for requirements
    def isSatisfied(self) -> bool:
        """Checks if requirement is satisfied"""
        pass

    def bindSchedList(self, schedlist: list) -> list:
        """Binds this requirement to a schedlist"""
        self.schedlist = schedlist[:]
        return self.schedlist

class RequiredClass(Requirement): #Class code restriction
    def __init__(self, schedlist: list, coursecode: int, bias: int = DEFAULTBIAS, strict: bool = True):
        self.schedlist = schedlist
        self.coursecode = coursecode
        self.bias = bias
        self.strict = strict

    def isSatisfied(self):
        if self.coursecode in [x.code for x in schedlist]:
            return True
        return False
        

class RequiredCourse(Requirement):
    def __init__(self, schedlist: list, coursename: str, bias: int = DEFAULTBIAS, strict: bool = True):
        self.schedlist = schedlist
        self.coursename = coursename
        self.bias = bias
        self.strict = strict

    def isSatisfied(self):
        if self.coursename in [x.name for x in schedlist]:
            return True
        return False

"""Add future restrictions here"""
        



class Course:
    class timeint:
        def __init__(self, hour, minute, durationInMinutes):
            if hour > 23 or hour < 0 or minute > 59 or minute < 0:
                raise Exception("Invalid time")
            self.shour = hour
            self.sminute = minute
            self.duration = durationInMinutes
        
        def intersects(self, othertimeint):
            a = [self.shour * 60 + self.sminute, self.shour * 60 + self.sminute + self.duration]
            b = [othertimeint.shour * 60 + othertimeint.sminute, othertimeint.shour * 60 + othertimeint.sminute + othertimeint.duration]
            return bool(max(0, min(a[1], b[1]) - max(a[0], b[0])))

    def __init__(self, code: int, name: str, startTimeH: int, startTimeM: int, duration: int, days: list, units: int, instructor: str = "CONCEALED"):
        self.code = code
        self.name = name
        self.tint = self.timeint(startTimeH, startTimeM, duration)
        self.days = days #[("Su", "M", "T", "W", "Th", "F", "Sa")[x] for x in range(len(days)) if days[x] != "0"] #str base 2, 0th index is Sunday
        self.instructor = instructor
        self.units = units

    def __str__(self):
        daystr = " ".join(days)
        return "\nCourse Code: %s\n%s\n%s-%s,%s\n%s" % (self.code, self.name, str(self.startTimeH) + ":" + str(self.startTimeM), self.duration, daystr, self.instructor)

    
    def isConflicting(self, course): #needs a course object
        if len(set(self.days).intersection(set(course.days))) == 0:
            return False
        else:
            return self.tint.intersects(course.tint)
            

class Schedule:
    def __init__(self, name: str, requirements: list, courses: list):
        self.name = name
        self.reqs = requirements
        self.sched = courses

    def __str__(self):
        strs = list()
        for i in self.sched:
            strbuild.append(i.__str__())
        return "\n\n".join(strs)

    def get_score(self):
        """getting the value of this schedule is defined here"""
        schedscore = 0
        for i in self.reqs:
            if i.strict:
                if i.isSatisfied:
                    continue
                else:
                    return 0
            else:
                if i.isSatisfied:
                    schedscore += i.bias
                else:
                    continue
        schedscore += sum([x.units for x in self.sched])
        return schedscore

    def isValid(self):
        if len(self.sched) == 0:
            return False
        elif len(self.sched) == 1:
            return True
        else:
            for i in range(len(self.sched)):
                for j in range(i, len(self.sched)):
                    if i == j:
                        continue
                    if self.sched[i].isConflicting(self.sched[j]):
                        return False
                    if self.sched[i].name == self.sched[j].name:
                        return False
            else:
                return True


class Scheduler:
    #rng = random.Random(42)
    #weighted_sample_without_replacement(population, weights, k, rng)
    def __init__(self, coursepool: list, requirements: list, maxcourses: int = 7 ,seed: int = 0, iterations: int = 1000):
        STARTINGWEIGHT = 20
        if seed == 0:
            self.seed = random.random()
        else:
            self.seed = seed
        random.seed(self.seed)
        self.scheds = dict()
        self.coursepool = coursepool
        self.requirements = requirements
        self.weightedpool = dict()
        self._rng = random.Random(self.seed)

        for i in self.coursepool:
            self.weightedpool[i] = 20
        
        for j in range(iterations):
            for i in range(3, maxcourses+1):
                sample = weighted_sample_without_replacement(coursepool, [self.weightedpool[i] for i in self.coursepool], i)
                sched = Schedule("Iteration_%s_n_%s" % (j, i), requirements, sample)
                if not sched.isValid():
                    #print("Iter %s failed." % j)
                    continue
                self.scheds[sched] = sched.get_score()
                #print(self.scheds[sched], [x.__str__() for x in sched.sched])
                for course in sched.sched:
                    denom = iterations-(j*2)
                    if denom == 0:
                        denom += 1
                    self.weightedpool[course] += (sched.get_score()/denom)
        print("[%s] Finished" % (self.seed)) 
        
def gen_course_pool(li):
    coursepool = list()
    subcode = 0

    # flattening
    for i in li:
        print(i.name, i.section_list)
        for j in i.section_list:
            schedob = j.schedules[0]
            print(schedob.days, schedob.time[0].hour, schedob.time[0].minute, (schedob.time[1].hour - schedob.time[0].hour) * 60 + schedob.time[1].minute - schedob.time[0].minute)
            #startTime = j.schedules[0][]
            continue
            coursepool.append(Course(subcode, i.name,startTime, duration, days, units))
            subcode += 1
    return

os.chdir("./backend")
dat = DegreeProgram("BS_CS", 2)
gen_course_pool(dat.courses_data)

'''
coursepool = list()
coursepool.append(Course(0, "SUBJ 0", 700, 130, "0010100", 3, "Sir Paul"))
coursepool.append(Course(1, "SUBJ 1", 830, 130, "0010100", 3, "Sir Paul"))
coursepool.append(Course(2, "SUBJ 2", 1100, 300, "0010100", 4, "Sir Paul"))
coursepool.append(Course(3, "SUBJ 3", 1600, 130, "0010100", 4, "Sir Paul"))
coursepool.append(Course(4, "SUBJ 4", 700, 300, "0100000", 4, "Sir Paul"))
coursepool.append(Course(5, "SUBJ 5", 800, 300, "0001010", 4, "Sir Paul"))
coursepool.append(Course(6, "SUBJ 6", 1200, 200, "0010100", 1, "Sir Paul"))
coursepool.append(Course(7, "SUBJ 7", 1500, 230, "0010100", 4, "Sir Paul"))
coursepool.append(Course(8, "SUBJ 0", 800, 130, "0010100", 3, "Sir Paul"))
coursepool.append(Course(9, "SUBJ 0", 1100, 130, "0010100", 3, "Sir Paul"))
coursepool.append(Course(10, "SUBJ 1", 730, 130, "0010100", 3, "Sir Paul"))
coursepool.append(Course(11, "SUBJ 1", 830, 130, "0010100", 3, "Sir Paul"))
coursepool.append(Course(12, "SUBJ 1", 900, 130, "0010100", 3, "Sir Paul"))
coursepool.append(Course(13, "SUBJ 2", 1100, 300, "0010100", 4, "Sir Paul"))
coursepool.append(Course(14, "SUBJ 2", 1400, 300, "0010100", 4, "Sir Paul"))
coursepool.append(Course(15, "SUBJ 3", 830, 130, "0010100", 4, "Sir Paul"))
coursepool.append(Course(16, "SUBJ 3", 930, 130, "0010100", 4, "Sir Paul"))
coursepool.append(Course(17, "SUBJ 3", 1030, 130, "0010100", 4, "Sir Paul"))
coursepool.append(Course(18, "SUBJ 3", 1530, 130, "0010100", 4, "Sir Paul"))
coursepool.append(Course(19, "SUBJ 4", 1330, 300, "0010100", 4, "Sir Paul"))
coursepool.append(Course(20, "SUBJ 4", 1330, 300, "0010100", 4, "Sir Paul"))
coursepool.append(Course(21, "SUBJ 4", 1730, 300, "0010100", 4, "Sir Paul"))
coursepool.append(Course(22, "SUBJ 5", 1830, 300, "0010100", 4, "Sir Paul"))
coursepool.append(Course(23, "SUBJ 5", 1630, 300, "0010100", 4, "Sir Paul"))
coursepool.append(Course(24, "SUBJ 5", 700, 300, "0010100", 4, "Sir Paul"))
coursepool.append(Course(25, "SUBJ 5", 800, 300, "0010100", 4, "Sir Paul"))
coursepool.append(Course(26, "SUBJ 5", 900, 300, "0010100", 4, "Sir Paul"))
coursepool.append(Course(27, "SUBJ 6", 900, 230, "0010100", 1, "Sir Paul"))

def main():
    seed = random.randint(0,9999999)
    scheduler = Scheduler(coursepool, list(), 7, seed, 1000)
    for sched in scheduler.scheds.keys():
        if scheduler.scheds[sched] > 18:
            print("------------------------------------------------------------------")
            print("UNITS: ", scheduler.scheds[sched], "\n","".join([x.__str__() for x in sched.sched]))
            print("------------------------------------------------------------------")
        
'''
