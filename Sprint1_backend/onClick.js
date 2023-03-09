const days = {
    "monday": false,
    "tuesday": false,
    "wednesday": false,
    "thursday": false,
    "friday": false,
    "saturday": false
};

const time = {
    "7am": false,
    "730am": false,
    "8am": false,
    "830am": false,
    "9am": false,
    "930am": false,
    "10am": false,
    "1030am": false,
    "11am": false,
    "1130am": false,
    "12pm": false,
    "1230pm": false,
    "1pm": false,
    "130pm": false,
    "2pm": false,
    "230pm": false,
    "3pm": false,
    "330pm": false,
    "4pm": false,
    "430pm": false,
    "5pm": false,
    "530pm": false,
    "6pm": false,
    "630pm": false
};

// Function changes color of clicked DIV
function changeClass(x){ 
    document.getElementById(x).classList.toggle('optionSel');
    const parent_id = document.getElementById(x).parentNode.id;
    switch(parent_id){
        case "day_parent":
            days[x] = !days[x];
            break;
        case "time_parent":
            time[x] = !time[x];
            break;
    }
}

// Function to store selected preferences into a dict
function storeSel(){
    const days_results = Object.entries(days);
    const time_results = Object.entries(time);
    const days_only = days_results.filter(([_, value]) => value).map(entry => entry[0]);
    const time_only = time_results.filter(([_, value]) => value).map(entry => entry[0]);
    createDiv();
    document.getElementById("results_inner_day").innerHTML = 'Day selected:';
    for (var i in days_only) {
      document.getElementById("results_inner_day").innerHTML += "<p>" + days_only[i] + "</p>";
    }
    document.getElementById("results_inner_time").innerHTML = 'Time selected:';
    for (var i in time_only) {
        document.getElementById("results_inner_time").innerHTML += "<p>" + time_only[i] + "</p>";
    }

    //console.log(days_only);
    //console.log(time_only);
    // instructor["WMTAN"] = false;
    // instructor["WILSON"] = false;
    // console.log(instructor);
}


// // Write new div for results
function createDiv(){
    var div_day = document.createElement('div');
    div_day.setAttribute('id','results_inner_day')
    div_day.style.backgroundColor = "maroon";
    div_day.style.marginTop = '30px';
    div_day.style.height = "200px";
    div_day.style.width = "80%";
    document.getElementById('results_outer').appendChild(div_day);

    var div_time = document.createElement('div');
    div_time.setAttribute('id','results_inner_time')
    div_time.style.backgroundColor = "maroon";
    div_time.style.marginTop = '30px';
    div_time.style.height = "200px";
    div_time.style.width = "80%";
    document.getElementById('results_outer').appendChild(div_time);
}