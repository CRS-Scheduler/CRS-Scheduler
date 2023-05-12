from flask import Flask, request
import ScheduleOptimizer, json
app = Flask(__name__)

@app.route("/index")
def home_page():
    return "<p>Hellloooo</p>"

@app.route("/api/courses")
def get_courses_from_program():
    prgm = request.args.get("prgm")
    #yrlvl = request.args.get("yrlvl")
    #l = ["doe a deer a female deer re a drop of golden sun".split()]
    #jsonstr = json.dumps(l)
    jsonstr = json.dumps(ScheduleOptimizer.get_course_list_from_program(prgm))
    return jsonstr



