// ignore_for_file: unused_field
import 'dart:convert';
import 'dart:html'  as webFile;
import 'dart:io' as io;
import 'dart:js';

import 'package:crs_scheduler/widgets/timechooser.dart';
import 'package:crs_scheduler/widgets/daychooser.dart';
import 'package:crs_scheduler/widgets/profchooser.dart';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../sizeconfig.dart';
import 'dart:async';
import 'dart:io';
class Dashboard extends StatefulWidget {
  final String courseCode;
  final String yearLevel;
  final List<String> courseData;


  const Dashboard({Key? key, required this.courseCode, required this.yearLevel,required this.courseData})
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

  final _timeformkey = GlobalKey<FormState>();
  double deviceHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;
  double deviceWidth(BuildContext context) => MediaQuery.of(context).size.width;

  int _indexer = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.all(8.0),
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
                        mainAxisAlignment: MainAxisAlignment.start,
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
                                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                                  child: Text(
                                    'You are a ${widget.yearLevel} of ${widget.courseCode}',
                                    style:  TextStyle(
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
                            mainAxisAlignment: MainAxisAlignment.start,
                            children:  [
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
                                  tabs: const [
                                    Tab(icon: Icon(Icons.calendar_month)),
                                    Tab(icon: Icon(Icons.timer)),
                                    Tab(icon: Icon(Icons.school)),
                                  ],
                                ),
                                Container(
                                    child: (_indexer == 0)
                                        ? DayChooser(
                                      dayvector: daychecklist,
                                      timevector: timelist,
                                    )
                                        : (_indexer == 1)
                                        ? TypeTimeEntry(
                                      validDays: daychecklist,
                                      timeList: timelist,
                                    )
                                        : SubProfChooser(
                                      preflist: subproflist, ))



                              ])),
                          SizedBox(
                            height: 80,
                            width: 120,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xff8B1538)),
                              onPressed: () {
                                if (timelist[6] == "" &&
                                    dayblank(daychecklist) &&
                                    timeblank(timelist) &&
                                    _timeformkey.currentState!.validate() &&
                                    subproflist[0][0] == ''
                                ) {
                                  if (kDebugMode) {
                                    print("ERROR Log 1");
                                    print(
                                        "User inputs:\nDaylist: $daychecklist,\nTimelist: $timelist \nNullweek choice: ${timelist[6]},\n ProfSUb: $subproflist");
                                  }
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            'WARNING: Please ensure that you have a preference in at least one category: Days of the week, Time, and Instructor')),
                                  );
                                } else if (_timeformkey.currentState!.validate() &&
                                    dayblank(daychecklist)) {
                                  if (kDebugMode) {
                                    print("No day chosen case");
                                    print(
                                        "User inputs:\nDaylist: $daychecklist,\nNullweek choice: ${timelist[6]}\n ProfSUb: $subproflist");
                                  }

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('Saving preferences')),
                                  );
                                } else if (timeblank(timelist) &&
                                    !dayblank(daychecklist)) {
                                  if (kDebugMode) {
                                    print("No time chosen case");
                                    print(
                                        "User inputs:\nDaylist: $daychecklist,\nTimelist: $timelist \nNullweek choice: ${timelist[6]}\n ProfSUb: $subproflist");
                                  }

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('Saving preferences')),
                                  );
                                } else {
                                  if (kDebugMode) {
                                    print("maybe success");
                                    print(
                                        "User inputs:\nDaylist: $daychecklist,\nTimelist: $timelist \nNullweek choice: ${timelist[6]}\n ProfSUb: ${subproflist.length}");
                                  }
                                }
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Saving preferences')),
                                );
                              },
                              child: const Text(
                                'Next',
                                style: TextStyle(
                                  color: Color(0xffFFFFFF),
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                              height: 80,
                              width: 120,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xff8B1538)),
                                onPressed: () {
                                  final List dayRow = ["Day",daychecklist[0],daychecklist[1],daychecklist[2]
                                    ,daychecklist[3],daychecklist[4],daychecklist[5]];
                                  final List<String> timeRow = ['Time', timelist[0], timelist[1], timelist[2], timelist[3]
                                    ,timelist[4],timelist[5],timelist[6]];
                                  final List<String> newline = ['\n'];
                                  int profCount = subproflist.length;
                                  final List<String> subSel = ['Sub'];
                                  final List<String> profSel = ['Prof'];
                                  for (int i=0; i < profCount; i++ ){
                                    for (int j = 0; j < 1; j++ ){
                                      subSel.add(subproflist[i][j]);
                                      profSel.add(subproflist[i][j+1]);
                                    }
                                  }
                                  while (subSel.length < 6){
                                    subSel.add('');
                                  }
                                  while (profSel.length < 6){
                                    profSel.add('');
                                  }

                                  //PLUGIN of CSV used here
                                  if (kIsWeb) {

                                    var blob = webFile.Blob([dayRow] + [newline] + [timeRow] + [newline] + [subSel] +
                                        [newline] + [profSel], 'text/plain', 'native');
                                    var anchorElement = webFile.AnchorElement(
                                      href: webFile.Url.createObjectUrlFromBlob(blob).toString(),
                                    )..setAttribute("download", "user_preference.csv")..click();
                                  }

                                }, child: const Text(
                                  'Export',
                                  style: TextStyle(
                                    color: Color(0xffffffff),
                                    fontSize: 24,
                                  )
                              ),
                              )
                          ),
                          SizedBox(
                            height: 80,
                            width: 120,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xff8B1538)),
                              child: const Text('Import', style: TextStyle(color:Color(0xffffffff), fontSize: 24)),
                              onPressed: () async {
                                var picked = await FilePicker.platform.pickFiles();
                                if (picked != null) {
                                  PlatformFile selectedFile = picked.files.first;
                                  List<String> result = ReadFile(selectedFile);
                                  List<String> force = result[6].split('');
                                  if(force[0] == '1'){
                                    daychecklist[5] = 1;
                                  }
                                  //update day
                                  setState(() {
                                    var len_Day = 7;
                                    for(int i = 0; i<len_Day; i++){
                                      if(result[i+1] == '1'){
                                        daychecklist[i] = 1;
                                      }
                                    }
                                    //update time
                                    for(int i = 7; i<14; i++){
                                      if (result[i] != ''){
                                        timelist[i-7] = result[i];
                                      }else{
                                        timelist[i-7] = '';
                                      }
                                    }
                                    //update sub and prof
                                    int countSubs = 0;
                                    while(result[16+countSubs] != ''){
                                      countSubs ++;
                                    }
                                    for (int h = 0; h < countSubs; h++){
                                        for (int i = 16; i < 21; i++) {
                                          if (result [i] != '') {
                                            subproflist[h][0] = result[i];
                                          }
                                        }
                                        for (int j = 21; j < 24; j++){
                                          if(result[j] != ''){
                                            subproflist[h][1] = result[j];
                                          }
                                        }

                                    }

                                  });


                                }

                                if (timelist[6] == "" &&
                                    dayblank(daychecklist) &&
                                    timeblank(timelist) &&
                                    _timeformkey.currentState!.validate() &&
                                    subproflist[0][0] == ''
                                ) {
                                  if (kDebugMode) {
                                    print("CSV EMPTY");
                                    print(
                                        "User inputs:\nDaylist: $daychecklist,\nTimelist: $timelist \nNullweek choice: ${timelist[6]},\n ProfSUb: $subproflist");
                                  }
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('WARNING: Please ensure that you have a preference in at least one category: Days of the week, Time, and Instructor')),
                                  );
                                } else if (_timeformkey.currentState!.validate() &&
                                    dayblank(daychecklist)) {

                                  if(timelist[6] == ""){
                                    if (kDebugMode) {
                                      print("No default time");
                                    }
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('This CSV File contains no default time')),
                                    );
                                  }else{
                                    if (kDebugMode) {
                                      print(
                                          "User inputs:\nDaylist: $daychecklist,\nNullweek choice: ${timelist[6]}\n ProfSUb: $subproflist");
                                    }String defTime = timelist[6];
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Data Imported. Default time is set to $defTime')),
                                    );
                                  }


                                } else if (timeblank(timelist) &&
                                    !dayblank(daychecklist)) {
                                  if (kDebugMode) {
                                    print("No time chosen case");
                                    print(
                                        "User inputs:\nDaylist: $daychecklist,\nTimelist: $timelist \nNullweek choice: ${timelist[6]}\n ProfSUb: $subproflist");
                                  }

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Your CSV file contains no time for the date/s selected')),);
                                } else {
                                  if (kDebugMode) {
                                    print("maybe success");
                                    print(
                                        "User inputs:\nDaylist: $daychecklist,\nTimelist: $timelist \nNullweek choice: ${timelist[6]}\n ProfSUb: ${subproflist.length}");
                                  }
                                }
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Data Imported. Saving preferences')),
                                );

                              },

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

double triggercheck(List<int> lister) {
  double valhold = 0;
  for (int i = 0; i < 5; i++) {
    if (lister[i] == 1) {
      valhold += 1;
    }
  }
  return valhold;
}

List<String> ReadFile(x) {
  String fileContent = utf8.decode(x.bytes.toList());
  //var singleline = fileContent.replaceAll("\n", " ");
  List<String> result = (fileContent.split(','));
  return result;
}