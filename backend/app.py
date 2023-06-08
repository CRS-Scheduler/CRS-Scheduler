from flask import Flask, request
import ScheduleOptimizer, json
app = Flask(__name__)

@app.route('/')
def hello_world():
    return 'Hello, World!'

@app.route("/index")
def home_page():
    return "<p>Hellloooo</p>"

@app.route("/api/courses")
def get_courses_from_program():
    program = request.args.get("prgm")
    year_level = request.args.get("yrlvl")
    jsonstr = json.dumps(ScheduleOptimizer.get_course_list_from_program(program, year_level))
    return jsonstr

@app.route("/api/schedule")
def optimal_schedule2():
    program = request.args.get("prgm")
    year_level = request.args.get("yrlvl")
    seed = request.args.get("seed")
    jsonstr = json.dumps(Scheduler2.sched2api(program, year_level, seed))
    return jsonstr