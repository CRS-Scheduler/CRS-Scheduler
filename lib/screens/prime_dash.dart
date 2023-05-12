// ignore_for_file: unused_field
import 'dart:convert';
import 'dart:html' as webFile;
import 'package:crs_scheduler/widgets/timechooser.dart';
import 'package:crs_scheduler/widgets/daychooser.dart';
import 'package:crs_scheduler/widgets/profchooser.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../sizeconfig.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:crs_scheduler/screens/schedulescreen.dart';

class PrimeShowcaser extends StatelessWidget {
  final String courseCode;
  final String yearLevel;
  final List<String> courseData;
  final List allowedCourse;
  const PrimeShowcaser(
      {Key? key,
      required this.courseCode,
      required this.yearLevel,
      required this.courseData,
      required this.allowedCourse})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ShowCaseWidget(
        onStart: (index, key) {
          if (kDebugMode) {
            print('onStart: $index, $key');
          }
        },
        onComplete: (index, key) {
          if (kDebugMode) {
            print('onComplete: $index, $key');
          }
        },
        enableAutoScroll: true,
        blurValue: 1,
        builder: Builder(
            builder: (context) => Dashboard(
                courseCode: courseCode,
                yearLevel: yearLevel,
                courseData: courseData,allowedCourse: allowedCourse,)),
        autoPlayDelay: const Duration(seconds: 3),
      ),
    );
  }
}

class Dashboard extends StatefulWidget {
  final String courseCode;
  final String yearLevel;
  final List<String> courseData;
  final List allowedCourse;

  const Dashboard(
      {Key? key,
      required this.courseCode,
      required this.yearLevel,
      required this.courseData,
       required this.allowedCourse})
      : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> with TickerProviderStateMixin {
  List<List> subproflist = [
    ["", ""]
  ];
  final List<int> daychecklist = [0, 0, 0, 0, 0, 0];
  final List<String> timelist = ["", "", "", "", "", "", ""];
  final List<String> standing = [
    "Unselected",
    "Freshman",
    "Sophomore",
    "Junior",
    "Senior"
  ];
  final _timeformkey = GlobalKey<FormState>();
  double deviceHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;
  double deviceWidth(BuildContext context) => MediaQuery.of(context).size.width;

  int _indexer = 0;
  final GlobalKey _day = GlobalKey();
  final GlobalKey _time = GlobalKey();
  final GlobalKey _prof = GlobalKey();
  final GlobalKey _next = GlobalKey();
  final GlobalKey _export = GlobalKey();
  final GlobalKey _import = GlobalKey();
  final GlobalKey _click1 = GlobalKey();
  final GlobalKey _click2 = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 20),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(
                      (deviceWidth(context) > 600)
                          ? 100
                          : SizeConfig.safeBlockHorizontal * 12,
                      25,
                      (deviceWidth(context) > 600)
                          ? 100
                          : SizeConfig.safeBlockHorizontal * 12,
                      100),
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
                                'You are a ${widget.yearLevel} of ${widget.courseCode}',
                                style: TextStyle(
                                    color: const Color(0xff7D0C0E),
                                    fontSize: (SizeConfig.screenWidth > 600)
                                        ? 24
                                        : SizeConfig.safeBlockHorizontal * 4,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                              width: 3, color: const Color(0xff8B1538)),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                            iconSize: 20,
                            splashRadius: 1,
                            onPressed: () {
                              ShowCaseWidget.of(context).startShowCase([
                                _day,
                                _time,
                                _prof,
                                _next,
                                _export,
                                _import
                              ]);
                              if (kDebugMode) {
                                print("lets play");
                              }
                            },
                            icon: const Icon(Icons.question_mark_rounded),
                            color: const Color(0xff8B1538)),
                      )
                    ],
                  ),
                ),
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: (SizeConfig.screenWidth > 600)
                              ? 100
                              : SizeConfig.safeBlockHorizontal * 12),
                      child: Row(
                        mainAxisAlignment: (SizeConfig.screenWidth > 848)
                            ? MainAxisAlignment.start
                            : MainAxisAlignment.center,
                        children: [
                          Text(
                            'Input your details',
                            style: TextStyle(
                                color: const Color(0xff00573F),
                                fontSize: (SizeConfig.screenWidth > 600)
                                    ? 30
                                    : SizeConfig.safeBlockHorizontal * 5,
                                fontWeight: FontWeight.w800),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Form(
                  key: _timeformkey,
                  child: Column(
                    children: [
                      DefaultTabController(
                          length: 3,
                          child: Column(children: [
                            TabBar(
                              onTap: (index) {
                                setState(() {
                                  _indexer = index;
                                });
                              },
                              indicatorColor: const Color(0xffFEB81C),
                              labelColor: const Color(0xff00573F),
                              tabs: [
                                Showcase(
                                    key: _day,
                                    targetPadding: EdgeInsets.symmetric(
                                        horizontal:
                                            SizeConfig.safeBlockHorizontal *
                                                10),
                                    description:
                                        "This tab allows you to enter the days you\nprefer to have your subjects in",
                                    child: const Tab(
                                        icon: Icon(Icons.calendar_month))),
                                Showcase(
                                    key: _time,
                                    targetPadding: EdgeInsets.symmetric(
                                        horizontal:
                                            SizeConfig.safeBlockHorizontal *
                                                10),
                                    description:
                                        "This tab allows you to enter the times you\nprefer to have your subjects in",
                                    child: const Tab(icon: Icon(Icons.timer))),
                                Showcase(
                                    key: _prof,
                                    description:
                                        "This tab allows you to enter your preferred classes and \noptionally, your preferred professors for those classes",
                                    child: const Tab(icon: Icon(Icons.school))),
                              ],
                            ),
                            Container(
                                child: (_indexer == 0)
                                    ? DayChooserShowcase(
                                        dayvector: daychecklist,
                                        timevector: timelist,
                                      )
                                    : (_indexer == 1)
                                        ? TimeChooserShowcase(
                                            validDays: daychecklist,
                                            timeList: timelist,
                                          )
                                        : SubProfChooserShowcase(
                                            preflist: subproflist,
                                          ))
                          ])),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: SizeConfig.safeBlockHorizontal * 10,
                            vertical: 40),
                        child: (SizeConfig.screenWidth > 848)
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Showcase(
                                    key: _export,
                                    description:
                                        "Press this to export your preferences into a CSV file",
                                    child: SizedBox(
                                        height: 65,
                                        width: 120,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  const Color(0xff8B1538)),
                                          onPressed: () {
                                            final List dayRow = [
                                              "Day",
                                              daychecklist[0],
                                              daychecklist[1],
                                              daychecklist[2],
                                              daychecklist[3],
                                              daychecklist[4],
                                              daychecklist[5]
                                            ];
                                            final List<String> timeRow = [
                                              'Time',
                                              timelist[0],
                                              timelist[1],
                                              timelist[2],
                                              timelist[3],
                                              timelist[4],
                                              timelist[5],
                                              timelist[6]
                                            ];
                                            final List<String> newline = ['\n'];
                                            int profCount = subproflist.length;
                                            final List<String> subSel = ['Sub'];
                                            final List<String> profSel = [
                                              'Prof'
                                            ];
                                            for (int i = 0;
                                                i < profCount;
                                                i++) {
                                              for (int j = 0; j < 1; j++) {
                                                subSel.add(subproflist[i][j]);
                                                profSel
                                                    .add(subproflist[i][j + 1]);
                                              }
                                            }
                                            while (subSel.length < 6) {
                                              subSel.add('');
                                            }
                                            while (profSel.length < 6) {
                                              profSel.add('');
                                            }

                                            //PLUGIN of CSV used here
                                            if (kIsWeb) {
                                              var blob = webFile.Blob(
                                                  [dayRow] +
                                                      [newline] +
                                                      [timeRow] +
                                                      [newline] +
                                                      [subSel] +
                                                      [newline] +
                                                      [profSel],
                                                  'text/plain',
                                                  'native');
                                              var anchorElement =
                                                  webFile.AnchorElement(
                                                href: webFile.Url
                                                        .createObjectUrlFromBlob(
                                                            blob)
                                                    .toString(),
                                              )
                                                    ..setAttribute("download",
                                                        "user_preference.csv")
                                                    ..click();
                                            }
                                          },
                                          child: const Text('Export',
                                              style: TextStyle(
                                                color: Color(0xffffffff),
                                                fontSize: 24,
                                              )),
                                        )),
                                  ),
                                  Showcase(
                                    key: _next,
                                    description:
                                        "Press this when you have finished inputting all your preferences",
                                    child: SizedBox(
                                      height: 65,
                                      width: 120,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                const Color(0xff8B1538)),
                                        onPressed: () {
                                          //No Entries
                                          if(timelist[6] == "" && dayblank(daychecklist) && timeblank(timelist)  && subproflist[0][0] == ''){
                                            _timeformkey.currentState!.validate();
                                            if (kDebugMode) {
                                              print("ERROR! Blank Entry");
                                            }
                                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                                duration: Duration(seconds: 1),
                                                content: Text(
                                                    'WARNING: Please ensure that you have a preference in at least one category: Days of the week, Time, and subject')),);
                                          } else
                                          if (subproflist.any((sublist) {for (var item in widget.allowedCourse) {if (item == sublist[0]) {return false; // the element was found in data, no need to panic
                                          }}
                                          return true; // the element was not found in data, trigger a panic
                                          })&&!_timeformkey.currentState!.validate()&&!checkTimeSpansoverall(timelist)) {

                                            if (kDebugMode) {
                                              print("ERROR: Time and Subject Error");
                                              print(
                                                  "User inputs:\nDaylist: $daychecklist,\nTimelist: $timelist \nNullweek choice: ${timelist[6]},\n ProfSUb: $subproflist");
                                            }
                                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                                duration: Duration(seconds: 1),
                                                content: Text(
                                                    'WARNING: You have made an error in your time and subject preference input')),
                                            );
                                          }else
                                          if(!_timeformkey.currentState!.validate()|| !checkTimeSpansoverall(timelist)){
                                            if (kDebugMode) {
                                              print("ERROR: Preferred time error");
                                              print(
                                                  "User inputs:\nDaylist: $daychecklist,\nTimelist: $timelist \nNullweek choice: ${timelist[6]},\n ProfSUb: $subproflist");
                                            }
                                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                                duration: Duration(seconds: 1),
                                                content: Text(
                                                    'WARNING: You have an error in your inputted prefered times.')),
                                            );
                                          }else if(subproflist.any((sublist) {for (var item in widget.allowedCourse) {
                                            if (item == sublist[0]) {

                                            return false; // the element was found in data, no need to panic
                                          }
                                          }
                                          return true; // the element was not found in data, trigger a panic
                                          })){if (kDebugMode) {
                                            //print(sublist[0]);
                                            print("ERROR: Preferred Subject Error");
                                            print(
                                                "User inputs:\nDaylist: $daychecklist,\nTimelist: $timelist \nNullweek choice: ${timelist[6]},\n ProfSUb: $subproflist");
                                          }
                                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                              duration: Duration(seconds: 1),
                                              content: Text(
                                                  'WARNING: You have inputted a course that is unavailable to your degree program.')),
                                          );}
                                          else{
                                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                                duration: Duration(seconds: 1),
                                                content: Text(
                                                    'Saving Preferences')));
                                            Navigator.push(context,MaterialPageRoute(builder: (context) =>
                                                ScheduleShowcase(courseCode: widget.courseData[0].split(', ')[3],yrStanding: standing.indexOf(widget.yearLevel),)
                                            ));
                                          }

                                        },
                                        child: const Text(
                                          'Next',
                                          style: TextStyle(
                                            color: Color(0xffFFFFFF),
                                            fontSize: 30,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Showcase(
                                    key: _import,
                                    targetPadding: EdgeInsets.symmetric(
                                        horizontal:
                                            SizeConfig.safeBlockHorizontal *
                                                10),
                                    description:
                                        "Press this if you wish to import your preferences from a previous session",
                                    child: SizedBox(
                                      height: 65,
                                      width: 120,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                const Color(0xff8B1538)),
                                        child: const Text('Import',
                                            style: TextStyle(
                                                color: Color(0xffffffff),
                                                fontSize: 24)),
                                        onPressed: () async {
                                          var sm = ScaffoldMessenger.of(context);
                                          var picked = await FilePicker.platform
                                              .pickFiles();
                                          if (picked != null) {
                                            PlatformFile selectedFile =
                                                picked.files.first;
                                            List<String> result =
                                                readFile(selectedFile);
                                            List<String> force =
                                                result[6].split('');
                                            if (force[0] == '1') {
                                              daychecklist[5] = 1;
                                            }
                                            //update day
                                            setState(() {
                                              var lenDay = 7;
                                              for (int i = 0;
                                                  i < lenDay;
                                                  i++) {
                                                if (result[i + 1] == '1') {
                                                  daychecklist[i] = 1;
                                                }
                                              }
                                              //update time
                                              for (int i = 7; i < 14; i++) {
                                                if (result[i] != '') {
                                                  timelist[i - 7] = result[i];
                                                } else {
                                                  timelist[i - 7] = '';
                                                }
                                              }
                                              //update sub and prof
                                              int countSubs = 0;
                                              while (result[16 + countSubs] !=
                                                  '') {
                                                countSubs++;
                                              }
                                              for (int h = 0;
                                                  h < countSubs;
                                                  h++) {
                                                for (int i = 16; i < 21; i++) {
                                                  if (result[i] != '') {
                                                    subproflist[h][0] =
                                                        result[i];
                                                  }
                                                }
                                                for (int j = 21; j < 24; j++) {
                                                  if (result[j] != '') {
                                                    subproflist[h][1] =
                                                        result[j];
                                                  }
                                                }
                                              }
                                            });
                                          }

                                          if (timelist[6] == "" &&
                                              dayblank(daychecklist) &&
                                              timeblank(timelist) &&
                                              _timeformkey.currentState!
                                                  .validate() &&
                                              subproflist[0][0] == '') {
                                            if (kDebugMode) {
                                              print("CSV EMPTY");
                                              print(
                                                  "User inputs:\nDaylist: $daychecklist,\nTimelist: $timelist \nNullweek choice: ${timelist[6]},\n ProfSUb: $subproflist");
                                            }
                                            sm.showSnackBar(
                                              const SnackBar(
                                                  duration:
                                                      Duration(seconds: 1),
                                                  content: Text(
                                                      'WARNING: Please ensure that you have a preference in at least one category: Days of the week, Time, and Instructor')),
                                            );
                                          } else if (_timeformkey.currentState!
                                                  .validate() &&
                                              dayblank(daychecklist)) {
                                            if (timelist[6] == "") {
                                              if (kDebugMode) {
                                                print("No default time");
                                              }
                                              sm.showSnackBar(
                                                const SnackBar(
                                                    duration:
                                                        Duration(seconds: 1),
                                                    content: Text(
                                                        'This CSV File contains no default time')),
                                              );
                                            } else {
                                              if (kDebugMode) {
                                                print(
                                                    "User inputs:\nDaylist: $daychecklist,\nNullweek choice: ${timelist[6]}\n ProfSUb: $subproflist");
                                              }
                                              String defTime = timelist[6];
                                              sm
                                                  .showSnackBar(
                                                SnackBar(
                                                    duration: const Duration(
                                                        seconds: 1),
                                                    content: Text(
                                                        'Data Imported. Default time is set to $defTime')),
                                              );
                                            }
                                          } else if (timeblank(timelist) &&
                                              !dayblank(daychecklist)) {
                                            if (kDebugMode) {
                                              print("No time chosen case");
                                              print(
                                                  "User inputs:\nDaylist: $daychecklist,\nTimelist: $timelist \nNullweek choice: ${timelist[6]}\n ProfSUb: $subproflist");
                                            }

                                            sm
                                                .showSnackBar(
                                              const SnackBar(
                                                  duration:
                                                      Duration(seconds: 1),
                                                  content: Text(
                                                      'Your CSV file contains no time for the date/s selected')),
                                            );
                                          } else {
                                            if (kDebugMode) {
                                              print("maybe success");
                                              print(
                                                  "User inputs:\nDaylist: $daychecklist,\nTimelist: $timelist \nNullweek choice: ${timelist[6]}\n ProfSUb: ${subproflist.length}");
                                            }
                                          }
                                          sm.showSnackBar(
                                            const SnackBar(
                                                duration: Duration(seconds: 1),
                                                content: Text(
                                                    'Data Imported. Saving preferences')),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10.0),
                                    child: Showcase(
                                      key: _export,
                                      description:
                                          "Press this to export your preferences into a CSV file",
                                      child: SizedBox(
                                          height: 65,
                                          width: 120,
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    const Color(0xff8B1538)),
                                            onPressed: () {
                                              final List dayRow = [
                                                "Day",
                                                daychecklist[0],
                                                daychecklist[1],
                                                daychecklist[2],
                                                daychecklist[3],
                                                daychecklist[4],
                                                daychecklist[5]
                                              ];
                                              final List<String> timeRow = [
                                                'Time',
                                                timelist[0],
                                                timelist[1],
                                                timelist[2],
                                                timelist[3],
                                                timelist[4],
                                                timelist[5],
                                                timelist[6]
                                              ];
                                              final List<String> newline = [
                                                '\n'
                                              ];
                                              int profCount =
                                                  subproflist.length;
                                              final List<String> subSel = [
                                                'Sub'
                                              ];
                                              final List<String> profSel = [
                                                'Prof'
                                              ];
                                              for (int i = 0;
                                                  i < profCount;
                                                  i++) {
                                                for (int j = 0; j < 1; j++) {
                                                  subSel.add(subproflist[i][j]);
                                                  profSel.add(
                                                      subproflist[i][j + 1]);
                                                }
                                              }
                                              while (subSel.length < 6) {
                                                subSel.add('');
                                              }
                                              while (profSel.length < 6) {
                                                profSel.add('');
                                              }

                                              //PLUGIN of CSV used here
                                              if (kIsWeb) {
                                                var blob = webFile.Blob(
                                                    [dayRow] +
                                                        [newline] +
                                                        [timeRow] +
                                                        [newline] +
                                                        [subSel] +
                                                        [newline] +
                                                        [profSel],
                                                    'text/plain',
                                                    'native');
                                                var anchorElement =
                                                    webFile.AnchorElement(
                                                  href: webFile.Url
                                                          .createObjectUrlFromBlob(
                                                              blob)
                                                      .toString(),
                                                )
                                                      ..setAttribute("download",
                                                          "user_preference.csv")
                                                      ..click();
                                              }
                                            },
                                            child: const Text('Export',
                                                style: TextStyle(
                                                  color: Color(0xffffffff),
                                                  fontSize: 24,
                                                )),
                                          )),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10.0),
                                    child: Showcase(
                                      key: _next,
                                      description:
                                          "Press this when you have finished inputting all your preferences",
                                      child: SizedBox(
                                        height: 65,
                                        width: 120,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  const Color(0xff8B1538)),
                                          onPressed: () {
                                            //No Entries
                                            if(timelist[6] == "" && dayblank(daychecklist) && timeblank(timelist)  && subproflist[0][0] == ''){
                                              _timeformkey.currentState!.validate();
                                              if (kDebugMode) {
                                                print("ERROR! Blank Entry");
                                              }
                                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                                  duration: Duration(seconds: 1),
                                                  content: Text(
                                                      'WARNING: Please ensure that you have a preference in at least one category: Days of the week, Time, and subject')),
                                              );
                                            } else
                                            if (subproflist.any((sublist) {for (var item in widget.allowedCourse) {if (item == sublist[0]) {
                                              return false; // the element was found in data, no need to panic
                                            }
                                            }
                                            return true; // the element was not found in data, trigger a panic
                                            })&&!_timeformkey.currentState!.validate()&&!checkTimeSpansoverall(timelist)) {

                                              if (kDebugMode) {
                                                print("ERROR: Time and Subject Error");
                                                print(
                                                    "User inputs:\nDaylist: $daychecklist,\nTimelist: $timelist \nNullweek choice: ${timelist[6]},\n ProfSUb: $subproflist");
                                              }
                                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                                  duration: Duration(seconds: 1),
                                                  content: Text(
                                                      'WARNING: You have made an error in your time and subject preference input')),
                                              );
                                            }else
                                            if(!_timeformkey.currentState!.validate()|| !checkTimeSpansoverall(timelist)){
                                              if (kDebugMode) {
                                                print("ERROR: Preferred time error");
                                                print(
                                                    "User inputs:\nDaylist: $daychecklist,\nTimelist: $timelist \nNullweek choice: ${timelist[6]},\n ProfSUb: $subproflist");
                                              }
                                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                                  duration: Duration(seconds: 1),
                                                  content: Text(
                                                      'WARNING: You have an error in your inputted prefered times.')),
                                              );
                                            }else if(subproflist.any((sublist) {for (var item in widget.allowedCourse) {if (item == sublist[0]) {
                                              return false; // the element was found in data, no need to panic
                                            }
                                            }
                                            return true; // the element was not found in data, trigger a panic
                                            })){if (kDebugMode) {
                                              print("ERROR: Preferred Subject Error");
                                              print(
                                                  "User inputs:\nDaylist: $daychecklist,\nTimelist: $timelist \nNullweek choice: ${timelist[6]},\n ProfSUb: $subproflist");
                                            }
                                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                                duration: Duration(seconds: 1),
                                                content: Text(
                                                    'WARNING: You have inputted a course that is unavailable to your degree program.')),
                                            );}
                                            else{
                                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                                  duration: Duration(seconds: 1),
                                                  content: Text(
                                                      'Saving Preferences')));
                                              Navigator.push(context,MaterialPageRoute(builder: (context) =>
                                                  ScheduleShowcase(courseCode: widget.courseData[0].split(', ')[3],yrStanding: standing.indexOf(widget.yearLevel),)
                                              ));
                                            }

                                          },
                                          child: const Text(
                                            'Next',
                                            style: TextStyle(
                                              color: Color(0xffFFFFFF),
                                              fontSize: 30,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10.0),
                                    child: Showcase(
                                      key: _import,
                                      targetPadding: EdgeInsets.symmetric(
                                          horizontal:
                                              SizeConfig.safeBlockHorizontal *
                                                  10),
                                      description:
                                          "Press this if you wish to import your preferences from a previous session",
                                      child: SizedBox(
                                        height: 65,
                                        width: 120,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  const Color(0xff8B1538)),
                                          child: const Text('Import',
                                              style: TextStyle(
                                                  color: Color(0xffffffff),
                                                  fontSize: 24)),
                                          onPressed: () async {
                                            var sm = ScaffoldMessenger.of(context);
                                            var picked = await FilePicker.platform.pickFiles();
                                            if (picked != null) {
                                              PlatformFile selectedFile =
                                                  picked.files.first;
                                              List<String> result =
                                                  readFile(selectedFile);
                                              List<String> force =
                                                  result[6].split('');
                                              if (force[0] == '1') {
                                                daychecklist[5] = 1;
                                              }
                                              //update day
                                              setState(() {
                                                var lenDay = 7;
                                                for (int i = 0;
                                                    i < lenDay;
                                                    i++) {
                                                  if (result[i + 1] == '1') {
                                                    daychecklist[i] = 1;
                                                  }
                                                }
                                                //update time
                                                for (int i = 7; i < 14; i++) {
                                                  if (result[i] != '') {
                                                    timelist[i - 7] = result[i];
                                                  } else {
                                                    timelist[i - 7] = '';
                                                  }
                                                }
                                                //update sub and prof
                                                int countSubs = 0;
                                                while (result[16 + countSubs] !=
                                                    '') {
                                                  countSubs++;
                                                }
                                                for (int h = 0;
                                                    h < countSubs;
                                                    h++) {
                                                  for (int i = 16;
                                                      i < 21;
                                                      i++) {
                                                    if (result[i] != '') {
                                                      subproflist[h][0] =
                                                          result[i];
                                                    }
                                                  }
                                                  for (int j = 21;
                                                      j < 24;
                                                      j++) {
                                                    if (result[j] != '') {
                                                      subproflist[h][1] =
                                                          result[j];
                                                    }
                                                  }
                                                }
                                              });
                                            }

                                            if (timelist[6] == "" && dayblank(daychecklist) && timeblank(timelist) && _timeformkey.currentState!.validate() && subproflist[0][0] == '') {
                                              if (kDebugMode) {
                                                print("CSV EMPTY");
                                                print(
                                                    "User inputs:\nDaylist: $daychecklist,\nTimelist: $timelist \nNullweek choice: ${timelist[6]},\n ProfSUb: $subproflist");
                                              }
                                              sm.showSnackBar(const SnackBar(
                                                  duration: Duration(seconds: 1),
                                                  content: Text('WARNING: Please ensure that you have a preference in at least one category: Days of the week, Time, and Instructor')),
                                              );
                                            } else if (_timeformkey
                                                    .currentState!
                                                    .validate() &&
                                                dayblank(daychecklist)) {
                                              if (timelist[6] == "") {
                                                if (kDebugMode) {
                                                  print("No default time");
                                                }
                                                sm.showSnackBar(
                                                  const SnackBar(
                                                      duration:
                                                          Duration(seconds: 1),
                                                      content: Text(
                                                          'This CSV File contains no default time')),
                                                );
                                              } else {
                                                if (kDebugMode) {
                                                  print(
                                                      "User inputs:\nDaylist: $daychecklist,\nNullweek choice: ${timelist[6]}\n ProfSUb: $subproflist");
                                                }
                                                String defTime = timelist[6];
                                                sm
                                                    .showSnackBar(
                                                  SnackBar(
                                                      duration: const Duration(
                                                          seconds: 1),
                                                      content: Text(
                                                          'Data Imported. Default time is set to $defTime')),
                                                );
                                              }
                                            } else if (timeblank(timelist) &&
                                                !dayblank(daychecklist)) {
                                              if (kDebugMode) {
                                                print("No time chosen case");
                                                print(
                                                    "User inputs:\nDaylist: $daychecklist,\nTimelist: $timelist \nNullweek choice: ${timelist[6]}\n ProfSUb: $subproflist");
                                              }

                                              sm
                                                  .showSnackBar(
                                                const SnackBar(
                                                    duration:
                                                        Duration(seconds: 1),
                                                    content: Text(
                                                        'Your CSV file contains no time for the date/s selected')),
                                              );
                                            } else {
                                              if (kDebugMode) {
                                                print("maybe success");
                                                print(
                                                    "User inputs:\nDaylist: $daychecklist,\nTimelist: $timelist \nNullweek choice: ${timelist[6]}\n ProfSUb: ${subproflist.length}");
                                              }
                                            }
                                           sm
                                                .showSnackBar(
                                              const SnackBar(
                                                  duration:
                                                      Duration(seconds: 1),
                                                  content: Text(
                                                      'Data Imported. Saving preferences')),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                      )
                    ],
                  ),
                ),
              ])),
    ));
  }
}

bool timeblank(List<String> lister) {
  for (int i = 0; i < lister.length; i++) {
    if (lister[i] != "") {
      return false;
    }
  }
  return true;
}

bool dayblank(List<int> lister) {
  for (int i = 0; i < lister.length; i++) {
    if (lister[i] == 1) {
      return false;
    }
  }
  return true;
}
bool subchecker(List<List> lister,List allowed) {
  for (int i = 0; i < lister.length; i++) {
    if (!allowed.contains(lister[i][0])) {
      return true;
    }
  }
  return false;
}

double triggercheck(List<int> lister) {
  double valhold = 0;
  for (int i = 0; i < 5; i++) {
    if (lister[i] == 1) {
      valhold += 1;
    }
  }
  return valhold;
}

List<String> readFile(x) {
  String fileContent = utf8.decode(x.bytes.toList());
  //var singleline = fileContent.replaceAll("\n", " ");
  List<String> result = (fileContent.split(','));
  return result;
}
bool checkTimeSpansoverall(List<String> times) {

  for (String input in times) {
    if(input==""){continue;}
    List<String> spanStrings = input.split(',').map((s) => s.trim()).toList();
    List<DateTime> startTimes = [];
    List<DateTime> endTimes = [];
    

    for (String spanString in spanStrings) {
      List<String> times = spanString.split('-').map((s) => s.trim()).toList();
      int startHour = int.parse(times[0].substring(0, 2));
      int startMinute = int.parse(times[0].substring(2, 4));
      int endHour = int.parse(times[1].substring(0, 2));
      int endMinute = int.parse(times[1].substring(2, 4));
      startTimes.add(DateTime(2023, 1, 1, startHour, startMinute));
      endTimes.add(DateTime(2023, 1, 1, endHour, endMinute));
    }
    for (int i = 0; i < startTimes.length; i++) {
      for (int j = i + 1; j < startTimes.length; j++) {
        if (startTimes[i].isBefore(endTimes[j]) && startTimes[j].isBefore(endTimes[i])) {
          return false;
        }
      }
    }
  }
  return true;
}