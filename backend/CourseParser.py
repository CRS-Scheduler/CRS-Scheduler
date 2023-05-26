from bs4 import BeautifulSoup
from requests import get
from re import findall
from re import search
from re import IGNORECASE
from datetime import time

# Schedule format:
# (class_name, raw_schedule, slots)

# Error printing (for debug only!)
def eprint(string):
    print(string)
    exit(1)

def time_lookup(raw_time):
    regex_string = r"(\d{1,2})[:]?(\d{0,2})"
    # print(findall(regex_string, time)[0])
    parsed_time = findall(regex_string, raw_time)[0]
    hours = int(parsed_time[0])
    minutes = int(parsed_time[1]) if parsed_time[1] != "" else 0
    return time(hours%12, minutes%60)

def get_sched(sched):
    start = time_lookup(sched[0])
    end = time_lookup(sched[2])
    if (sched[1] == "" and sched[3] == "PM") or (sched[1] == "PM"):
        start = time(12+start.hour, start.minute)
        end = time(12+end.hour, end.minute)
    elif (sched[3] == "PM"):
        end = time(12+end.hour, end.minute)
    # dateTimeA = datetime.datetime.combine(datetime.date.today(), start)
    # dateTimeB = datetime.datetime.combine(datetime.date.today(), end)
    # # Get the difference between datetimes (as timedelta)
    # dateTimeDifference = dateTimeA - dateTimeB
    # # Divide difference in seconds by number of seconds in hour (3600)  
    # dateTimeDifferenceInHours = (dateTimeDifference.total_seconds() / 3600)
    # print(dateTimeDifferenceInHours)
    return (start,end)

def get_sem_and_base_url():
    root_url = "https://crs.upd.edu.ph/schedule/"
    try:
        base_url_html = get(root_url, timeout=10).text
    except:
        error = "Check your internet connection and try again later."
        return (False, error)
    selection = BeautifulSoup(base_url_html, "html.parser").find_all('option', attrs={"selected": "selected"})[0]
    match selection.get_text().split()[0].lower():
        case "first": sem = 1
        case "second": sem = 2
        case "midyear": sem = 3
    base_url = root_url + selection['value'] + "/"
    return (sem, base_url)

def get_html(name, base_url):
    url = base_url + name.replace(" ", "%20")
    try:
        ret = get(url, timeout=10).text
        return (True, ret)
    except:
        error = "Error! Could not parse the url. Check the url and try again!"
        # print(contents)
        return (False, error)

def parse_contents(contents):
    try:
        ret = BeautifulSoup(contents, "html.parser").find_all('td')
        # findall(, str(ret))
        # print(ret)
        return (True, ret)
    except:
        error = "Error! Could not obtain the parse object. Perhaps the HTML is not fully loaded?"
        return (False, error)

def get_data_from_parsed_contents(name, parsed_contents):
    ret = []
    regex_string = r"(M|T|W|Th|F|S|MT|MW|MTh|MF|MS|TW|TTh|TF|TS|WTh|WF|WS|ThF|ThS|FS) (\d{1,2}[:]?\d{0,2})(AM|PM|)?-(\d{1,2}[:]?\d{0,2})(AM|PM) ([^ \n]+)"
    dissolved_offset = 0
    # print(parsed_contents)
    if len(parsed_contents) == 1: return ret
    for i in range(0, len(parsed_contents), 8):
        class_code = parsed_contents[i+dissolved_offset].get_text()
        class_name = parsed_contents[1+i+dissolved_offset].get_text()
        # print(class_name)
        search_string = str(parsed_contents[3+i+dissolved_offset])
        if not search(r"\b"+name+r"\b", class_name, IGNORECASE):
            continue
        slots = parsed_contents[5+i+dissolved_offset]
        if search("DISSOLVED", str(slots)):
            dissolved_offset -= 1 
            continue
        if search("OVERBOOKED", str(slots)):
            continue
        slots = int(slots.find_all('strong')[0].get_text())
        if slots == 0:
            continue
        raw_schedule = findall(regex_string, search_string)
        units = int(float(parsed_contents[2+i+dissolved_offset].get_text()))
        ret.append((class_code, class_name, raw_schedule, slots, units))
    return ret

def get_data(name, base_url):
    tmp = get_html(name, base_url)
    if not tmp[0]: eprint(tmp[1]) # error print for get_html
    tmp = parse_contents(tmp[1])
    if not tmp[0]: eprint(tmp[1]) # error print for parse_contents
    return get_data_from_parsed_contents(name, tmp[1])

def get_days(days_sched):
    days = []
    for i in range(0, len(days_sched)):
        match days_sched[i]:
            case "M": days.append("Monday")
            case "T":
                if i+1 == len(days_sched):
                    days.append("Tuesday")
                elif days_sched[i+1] == "h":
                    days.append("Thursday")
                else: days.append("Tuesday")
            case "W": days.append("Wednesday")
            case "F": days.append("Friday")
            case "S": days.append("Saturday")
    return days
