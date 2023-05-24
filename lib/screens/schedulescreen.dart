
// ignore_for_file: unused_local_variable

import 'package:showcaseview/showcaseview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../sizeconfig.dart';
import 'dart:convert';
import 'dart:html' as web_file;

import 'package:http/http.dart' as http;


class ScheduleShowcase extends StatelessWidget {

  final String courseCode;
  final int yrStanding;
  const ScheduleShowcase({Key? key, required this.courseCode,required this.yrStanding}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShowCaseWidget(
      enableAutoScroll: true,
      blurValue: 1,
      builder: Builder(builder: (context) =>  ScheduleScreen(courseCode: courseCode,yrStanding: yrStanding,)),
      autoPlayDelay: const Duration(seconds: 3),
    );
  }
}

class ScheduleScreen extends StatefulWidget {

  final String courseCode;
  final int yrStanding;
   const ScheduleScreen({Key? key,required this.courseCode,required this.yrStanding}) : super(key: key);

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();

}


class Course{
  String courseNameSection;


  DateTime startTime;
  DateTime endTime;

  Course(this.courseNameSection, this.startTime, this.endTime);
}
DateTime startDayTime =  DateTime(2023, 0,0, 7, 00, 0);
DateTime endDayTime =  DateTime(2023, 0, 0, 20, 00, 0);
double brickHeight=40;

class _ScheduleScreenState extends State<ScheduleScreen> {

  double deviceHeight(BuildContext context) => MediaQuery.of(context).size.height;
  double deviceWidth(BuildContext context) => MediaQuery.of(context).size.width;
  final GlobalKey _export = GlobalKey();

  final List<String> daysoftheweek=['Time','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday'];

  final List<List<Course>> dayStack=[
    [Course("Math 20 THUV", DateTime(2023, 0,0, 7, 0, 0), DateTime(2023, 0, 0, 9, 30, 0))],
    [Course("CS 12 THUV", DateTime(2023, 0,0, 10, 0, 0), DateTime(2023, 0, 0, 12, 0, 0)),
      Course("CS 21 THUV", DateTime(2023, 0,0, 13, 0, 0), DateTime(2023, 0, 0, 15, 30, 0)),],
    [Course("CS 21 THUV", DateTime(2023, 0,0, 13, 0, 0), DateTime(2023, 0, 0, 15, 30, 0))],
    [Course("CS 12 THUV", DateTime(2023, 0,0, 10, 0, 0), DateTime(2023, 0, 0, 12, 0, 0)),
      Course("CS 21 THUV", DateTime(2023, 0,0, 13, 0, 0), DateTime(2023, 0, 0, 15, 30, 0)),],
    [ Course("Math 20 THUV", DateTime(2023, 0,0, 7, 0, 0), DateTime(2023, 0, 0, 9, 30, 0)),],
    []
  ];
  late  List<List<Course>> stacker=[[],[],[],[],[],[]];
  late List<String> ExportList = [];


  fetchSched(String course, int yr) async {
// Define the API endpoint URL
    final String apiUrl = 'http://127.0.0.1:5000/api/schedule?prgm=$course&yrlvl=$yr';
    if (kDebugMode) {
      print(apiUrl);
    }
// Make an HTTP GET request to the API endpoint
    final response = await http.get(Uri.parse(apiUrl));
// Check if the request was successful (status code 200)
    if (response.statusCode == 200) {
      // Parse the response data as a string
       String localhold = json.decode(response.body);
       return localhold;
    } else {
      // Handle the error case, such as displaying an error message to the user
      if (kDebugMode) {
        print('Error: ${response.statusCode}');
      }
    }

  }

  schedParser(String schedule){

  List<String> lines = schedule.split("\n");

  lines.removeLast();
  int stackInd=0;
  for(String i in lines){
    if (kDebugMode) {
      print(i);
    }
    if(daysoftheweek.contains(i)){
      if (i!="Monday") {
        stackInd+=1;
      }
    }//increments matrix index
    else if (i!="\n"){
      List<String> listhold = i.split(",");


      int hourStart = int.parse(listhold[0].substring(0, 2));
      int minStart = int.parse(listhold[0].substring(2, 4));
      int hourEnd = int.parse(listhold[1].substring(0, 2));
      int minEmd = int.parse(listhold[1].substring(2, 4));

      String text = '${listhold[2]} $hourStart:${minStart}0-$hourEnd:${minEmd}0';
      Course newCourse = Course(listhold[2], DateTime(2023, 0, 0, hourStart, minStart), DateTime(2023, 0, 0, hourEnd, minEmd));
      if (kDebugMode) {
        print("${newCourse.courseNameSection}:${newCourse.startTime}-${newCourse.endTime}");
      }
      stacker[stackInd].add(newCourse);
      ExportList.add(text);
      ExportList.add('\n');
    }

  }

  }
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    String hold;
    Future.delayed(Duration.zero, () async {
      // your async operation here
      final result = await fetchSched(widget.courseCode, widget.yrStanding);
      // update the state using setState
      setState(() {
        // update the state with the result of the async operation
        hold = result;
        schedParser(hold);
        isLoading = false;
        if (kDebugMode) {
          print(stacker);
        }
      });
    });

  }
  @override
  Widget build(BuildContext context) {
    // time block calculations
    int numTimeBlocks = endDayTime.hour * 2 + endDayTime.minute ~/ 30 - startDayTime.hour * 2 - startDayTime.minute ~/ 30;
    List<Widget> timeBlockWidgets = [];
    for (int i = 0; i <= numTimeBlocks-1; i++) {
  // calculate the time for this time block
      DateTime time = startDayTime.add( Duration(minutes: i*30));
      DateTime endtime = startDayTime.add( Duration(minutes: (i+1)*30));
      String timeString = "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')} - ${endtime.hour.toString().padLeft(2, '0')}:${endtime.minute.toString().padLeft(2, '0')}";
      // create a widget for the time block and add it to the list of time block widgets
      timeBlockWidgets.add(Container(
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(),left: BorderSide(),right: BorderSide())),
        child: SizedBox(height: brickHeight,
          child: Center(child: Text(timeString,style: const TextStyle(color: Color(0xff00573F)),),),),
      ),);
    }
    return  Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color:  Color(0xff00573F)), )
          :SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 20),
          child:Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                  (deviceWidth(context) > 600) ? 100 : SizeConfig.safeBlockHorizontal * 12, 25,
                  (deviceWidth(context) > 600) ? 100 : SizeConfig.safeBlockHorizontal * 12, 100),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Mabuhay!',
                        style: TextStyle(
                            color: const Color(0xff8B1538),
                            fontSize: (SizeConfig.screenWidth > 600)
                                ? 54
                                : SizeConfig.safeBlockHorizontal * 8,
                            fontWeight: FontWeight.w800),
                      ),
                      Text(
                        'Welcome to your CRS Scheduler dashboard',
                        style: TextStyle(
                            color: const Color(0xff7D0C0E),
                            fontSize: (SizeConfig.screenWidth > 600)
                                ? 24
                                : SizeConfig.safeBlockHorizontal * 4,
                            fontWeight: FontWeight.w600),
                      ),
                      Padding(
                        padding:
                        const EdgeInsets.symmetric(vertical: 15.0),
                        child: Text(
                          'Here is your generated schedule!',
                          style: TextStyle(
                              color:  const Color(0xff00573F),
                              fontSize: (SizeConfig.screenWidth > 600)
                                  ? 24
                                  : SizeConfig.safeBlockHorizontal * 4,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Padding(
                      padding:  EdgeInsets.symmetric(horizontal: SizeConfig.safeBlockHorizontal * 2),
                      child: Container(decoration: BoxDecoration(border: Border.all(width: 3, color: const Color(0xff8B1538)), shape: BoxShape.circle,),
                        child: IconButton(
                            iconSize: 20,
                            splashRadius: 1,
                            onPressed: () {
                              //ShowCaseWidget.of(context).startShowCase([]);
                              if (kDebugMode) {
                                print("lets play");
                              }
                              Navigator.of(context).pop();
                            },
                            icon: const Icon(Icons.arrow_back_rounded),
                            color: const Color(0xff8B1538)),
                      ),
                    ),//back arrow
                    Padding(
                      padding:  EdgeInsets.symmetric(horizontal: SizeConfig.safeBlockHorizontal * 2),
                      child: Container(decoration: BoxDecoration(border: Border.all(width: 3, color: const Color(0xff8B1538)), shape: BoxShape.circle,),
                        child: IconButton(
                            iconSize: 20,
                            splashRadius: 1,
                            onPressed: () {
                              //ShowCaseWidget.of(context).startShowCase([]);
                              if (kDebugMode) {
                                print("lets play");
                              }
                            },
                            icon: const Icon(Icons.question_mark_rounded),
                            color: const Color(0xff8B1538)),
                      ),
                    ),
                  ],
                ) //tutorial button
              ],
            ),
          ),
            SizedBox(
              width: SizeConfig.safeBlockHorizontal * 80,

              child: Column(
                mainAxisAlignment:MainAxisAlignment.start,
                children: [
                Row(children: [
                  for(String x in daysoftheweek)
                    Container(color:const Color(0xff00573F),
                    width: (SizeConfig.safeBlockHorizontal * 80)/7,
                    height: brickHeight,child:  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: FittedBox(
                            fit: BoxFit.fitWidth,
                            child: Text(x,style:const TextStyle(color: Color(0xffffffff),))),
                      )
                      ),
                    )
                 ],),// Days of the Week
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(width:(SizeConfig.safeBlockHorizontal * 80)/7,
                        child: Column(
                          children: timeBlockWidgets,)),
                    Container(color: const Color(0xff8B1538),
                      child: Row(
                        children: [
                          for (List<Course> x in stacker)
                            SizedBox(
                            height: (brickHeight+1)*(timeBlockWidgets.length.toDouble()),
                            width: SizeConfig.safeBlockHorizontal * 80/7,
                            child: Stack(children:[
                              for(Course i in x)
                                CourseWidget(course: i)
                            ]),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: 30.0),
              child: Showcase(
                key: _export,
                description:
                "Press this to export your schedule as a CSV",
                child: SizedBox(
                  height: 65,
                  width: SizeConfig.safeBlockHorizontal * 15,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor:
                        const Color(0xff8B1538)),
                    onPressed: () {
                      if (kIsWeb) {
                        var blob = web_file.Blob(
                            ExportList, 'text/plain', 'native');
                        var anchorElement =
                        web_file.AnchorElement(
                          href: web_file.Url
                              .createObjectUrlFromBlob(
                              blob)
                              .toString(),
                        )
                          ..setAttribute("download",
                              "OptimizedSchedule.csv")
                          ..click();
                      }
                      if (kDebugMode) {
                        print(ExportList);
                        print(timeBlockWidgets.length);
                      }
                    },
                    child: const Text(
                      'Download as CSV',
                      style: TextStyle(
                        color: Color(0xffFFFFFF),
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ),
            )],),
        ),
      ),
    );
  }
}
class CourseWidget extends StatefulWidget {
  final Course course;


  const CourseWidget({Key? key,required this.course}) : super(key: key);

  @override
  State<CourseWidget> createState() => _CourseWidgetState();
}

class _CourseWidgetState extends State<CourseWidget> {
  @override
  Widget build(BuildContext context) {
    return
      Positioned(
        top:(brickHeight+1)*_heightGenerator(startDayTime, widget.course.startTime),
        child: Container(width:(SizeConfig.safeBlockHorizontal * 80)/7, 
          height:(brickHeight+1)*_heightGenerator(widget.course.startTime, widget.course.endTime),
          decoration: BoxDecoration(color: Colors.amber, border: Border.all(),), 
          child: Padding(
            padding: const EdgeInsets.all(8.0), 
            child: Column(
              mainAxisAlignment:MainAxisAlignment.center,
              children: [ FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text(widget.course.courseNameSection,softWrap: true))
             ],
            ),
          ),
        ),
      );
  }
}

double _heightGenerator(DateTime start, DateTime end){
  final difference = end.difference(start);

  return difference.inMinutes / 30;
}

class ScheduleLoading extends StatelessWidget {
  const ScheduleLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

