import 'package:showcaseview/showcaseview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../sizeconfig.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'dart:typed_data';
import 'package:flutter/rendering.dart';
import 'package:image/image.dart' as img;
import 'package:widgets_to_image/widgets_to_image.dart';
class ScheduleShowcase extends StatelessWidget {
  const ScheduleShowcase({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShowCaseWidget(
      enableAutoScroll: true,
      blurValue: 1,
      builder: Builder(builder: (context) => const ScheduleScreen()),
      autoPlayDelay: const Duration(seconds: 3),
    );
  }
}

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({Key? key}) : super(key: key);

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}


class Course{
  String name;
  String section;

  DateTime startTime;
  DateTime endTime;

  Course(this.name, this.section, this.startTime, this.endTime);
}
DateTime startDayTime =  DateTime(2023, 0,0, 7, 00, 0);
DateTime endDayTime =  DateTime(2023, 0, 0, 18, 30, 0);
double brickHeight=40;

class _ScheduleScreenState extends State<ScheduleScreen> {
  double deviceHeight(BuildContext context) => MediaQuery.of(context).size.height;
  double deviceWidth(BuildContext context) => MediaQuery.of(context).size.width;
  final GlobalKey _export = GlobalKey();
  final List<Course> courses = [
    Course("Math 20","THUV", DateTime(2023, 0,0, 7, 0, 0), DateTime(2023, 0, 0, 9, 30, 0)),
    Course("CS 12","THUV", DateTime(2023, 0,0, 10, 0, 0), DateTime(2023, 0, 0, 12, 0, 0)),
    Course("CS 21","THUV", DateTime(2023, 0,0, 13, 0, 0), DateTime(2023, 0, 0, 15, 30, 0)),
    Course("CS 32","THUV",DateTime(2023, 0,0, 15, 30, 0), DateTime(2023, 0, 0, 17, 00, 0)),
    // add more courses here
  ];
  final List<String> daysoftheweek=['Time','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday'];

  final List<List<Course>> dayStack=[
    [Course("Math 20","THUV", DateTime(2023, 0,0, 7, 0, 0), DateTime(2023, 0, 0, 9, 30, 0))],
    [Course("CS 12","THUV", DateTime(2023, 0,0, 10, 0, 0), DateTime(2023, 0, 0, 12, 0, 0)),
      Course("CS 21","THUV", DateTime(2023, 0,0, 13, 0, 0), DateTime(2023, 0, 0, 15, 30, 0)),],
    [Course("CS 21","THUV", DateTime(2023, 0,0, 13, 0, 0), DateTime(2023, 0, 0, 15, 30, 0))],
    [Course("CS 12","THUV", DateTime(2023, 0,0, 10, 0, 0), DateTime(2023, 0, 0, 12, 0, 0)),
      Course("CS 21","THUV", DateTime(2023, 0,0, 13, 0, 0), DateTime(2023, 0, 0, 15, 30, 0)),],
    [ Course("Math 20","THUV", DateTime(2023, 0,0, 7, 0, 0), DateTime(2023, 0, 0, 9, 30, 0)),],
    [Course("Math 20","THUV", DateTime(2023, 0,0, 7, 0, 0), DateTime(2023, 0, 0, 9, 30, 0))]
  ];
  

  WidgetsToImageController controller = WidgetsToImageController();
// to save image bytes of widget
  Uint8List? bytes;

  /*Future<void> _exportContainer() async {
    try {


      final bytes = await controller.capture();

      final Uint8List pngBytes = bytes;
      final directory = await getApplicationDocumentsDirectory();
      File file = File('${directory.path}/image.png');
      await file.writeAsBytes(pngBytes);
    } catch (e) {
      print(e);
    }
  }*/
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
      body: SingleChildScrollView(
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
                          for (List<Course> x in dayStack)
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
                "Press this to export your schedule as a PNG",
                child: SizedBox(
                  height: 65,
                  width: SizeConfig.safeBlockHorizontal * 15,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor:
                        const Color(0xff8B1538)),
                    onPressed: () {
                      if (kDebugMode) {
                        print("Click click");
                        print(timeBlockWidgets.length);
                      }
                    },
                    child: const Text(
                      'Export Schedule',
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
              children: [
                Text('${widget.course.name}-${widget.course.section}'),],
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


