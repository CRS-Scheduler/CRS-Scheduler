// ignore_for_file: unused_field
import 'package:crs_scheduler/widgets/timechooser.dart';
import 'package:crs_scheduler/widgets/daychooser.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class Dashboard extends StatefulWidget {
  final String courseCode;
  final String yearLevel;

  const Dashboard({Key? key, required this.courseCode, required this.yearLevel})
      : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final List<int> daychecklist = [0, 0, 0, 0, 0, 0];
  final List<String> timelist = ["", "", "", "", "", ""];
  final _timeformkey = GlobalKey<FormState>();
  late String _day;
  late String _time;
  late String _course;

  @override
  Widget build(BuildContext context) {
    int count = 0;
    for (var num in daychecklist) {
      count += num == 1 ? 1 : 0;
    }
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(100, 25, 100, 100),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Mabuhay!',
                          style: TextStyle(
                              color: Color(0xff8B1538),
                              fontSize: 54,
                              fontWeight: FontWeight.w800),
                        ),
                        const Text(
                          'Welcome to your CRS Scheduler dashboard',
                          style: TextStyle(
                              color: Color(0xff7D0C0E),
                              fontSize: 24,
                              fontWeight: FontWeight.w600),
                        ),
                        Text(
                          'You are a ${widget.yearLevel} of ${widget.courseCode}',
                          style: const TextStyle(
                              color: Color(0xff7D0C0E),
                              fontSize: 24,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(100, 0, 100, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: const [
                        Text(
                          'Input your details',
                          style: TextStyle(
                              color: Color(0xff00573F),
                              fontSize: 30,
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
                          const TabBar(
                            indicatorColor: Color(0xffFEB81C),
                            labelColor: Color(0xff00573F),
                            tabs: [
                              Tab(icon: Icon(Icons.calendar_month)),
                              Tab(icon: Icon(Icons.timer)),
                              Tab(icon: Icon(Icons.school)),
                            ],
                          ),
                          SizedBox(
                            height: 550,
                            child: TabBarView(children: [
                              DayChooser(
                                dayvector: daychecklist,
                                timevector: timelist,
                              ),
                              KeepAliveWrapper(
                                child: TypeTimeEntry(
                                  validDays: daychecklist,
                                  timeList: timelist,
                                ),
                              ),
                              const Center(
                                child: Text('Display Tab 4',
                                    style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ]),
                          )
                        ])),
                    SizedBox(
                      height: 80,
                      width: 120,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff8B1538)),
                        onPressed: () {
                          if (_timeformkey.currentState!.validate() &&
                              !dayblank(daychecklist)) {
                            if (kDebugMode) {
                              print(
                                  "User inputs:\nDaylist: $daychecklist,\nTimelist: $timelist ");
                            }

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Saving preferences')),
                            );
                          }else{ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('WARNING: Error in preference entry')),
                          );}
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
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class KeepAliveWrapper extends StatefulWidget {
  final Widget child;

  const KeepAliveWrapper({Key? key, required this.child}) : super(key: key);

  @override
  KeepAliveWrapperState createState() => KeepAliveWrapperState();
}

class KeepAliveWrapperState extends State<KeepAliveWrapper>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }

  @override
  bool get wantKeepAlive => true;
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
  for (int i = 0; i < lister.length; i++) {
    if (lister[i] == 1) {
      valhold += 1;
    }
  }
  return valhold;
}
