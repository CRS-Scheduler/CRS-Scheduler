// ignore_for_file: unused_field
import 'dart:convert';
import 'dart:io';

import 'package:crs_scheduler/widgets/timechooser.dart';
import 'package:crs_scheduler/widgets/daychooser.dart';
import 'package:crs_scheduler/widgets/profchooser.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../sizeconfig.dart';
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
  List<List<dynamic>> _importedData = [];
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
                            final List<String> rowHeader = ["Day","Time","Professor"];
                            List<List<dynamic>> rows = [];
                            rows.add(rowHeader); // add header
                            for(int i=0;i<6;i++){ //For 6 Days
                              //loop to add new row
                              List<dynamic> dataRow=[];
                              if (daychecklist[i] != 0){
                                dataRow.add(i);
                                dataRow.add(timelist[i]);
                                dataRow.add(subproflist);
                                rows.add(dataRow);
                              }
                            }
                            //PLUGIN of CSV used here
                            String csv = const ListToCsvConverter().convert(rows);
                            String dir = Directory.current.path;
                            //print("dir $dir");  //debug directory
                            String file = "$dir";
                            File f = File("$file/user_preferences.csv");
                            f.writeAsString(csv);
                            if (kDebugMode) {
                              print(csv);
                            } //debug csv
                          }, child: const Text(
                          'Export',
                          style: TextStyle(
                            color: Color(0xffffffff),
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
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
                            onPressed: () async {
                              final input = File('user_preferences.csv').openRead();
                              _importedData = await input.transform(utf8.decoder).transform(const CsvToListConverter()).toList();
                              //print(_importedData[0]); // header debug
                              //print(_importedData[1]); // row 1 debug
                              //print(_importedData[1][0]); // row 1 col 0 debug
                              setState(() {
                                final len = _importedData.length;
                                for(int i = 1; i<len; i++){
                                  for (int j = 0; j < 3; j++){
                                    //update days
                                    if (j == 0){
                                      daychecklist[_importedData[i][j]] = 1;
                                    }
                                    //update time
                                    if (j == 1){
                                      timelist[_importedData[i][j-1]] = _importedData[i][j];
                                    }
                                  }
                                }
                              });

                              if (kDebugMode) {
                                print(daychecklist);
                                print(timelist);
                              }
                            },
                          child: const Text(
                            'Import',
                            style: TextStyle(
                              color: Color(0xffffffff),
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            )
                          ),

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

