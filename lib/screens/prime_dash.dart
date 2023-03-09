// ignore_for_file: unused_field
import 'package:crs_scheduler/widgets/timechooser.dart';
import 'package:crs_scheduler/widgets/daychooser.dart';
import 'package:crs_scheduler/widgets/profchooser.dart';
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

class _DashboardState extends State<Dashboard> with TickerProviderStateMixin {
  List<List> subproflist = [
    ["", ""]
  ];
  final List<int> daychecklist = [0, 0, 0, 0, 0, 0];
  final List<String> timelist = ["", "", "", "", "", "", ""];
  String nullday = "";
  final _timeformkey = GlobalKey<FormState>();
  late String _day;
  late String _time;
  late String _course;
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
                                            preflist: subproflist,
                                          ))



                          ])),
                      SizedBox(
                        height: 80,
                        width: 120,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xff8B1538)),
                          onPressed: () {
                            if (nullday == "" &&
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
                                    "User inputs:\nDaylist: $daychecklist,\nTimelist: $timelist \nNullweek choice: $nullday\n ProfSUb: ${subproflist.length}");
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

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  final bodyGlobalKey = GlobalKey();
  final List<Widget> myTabs = [
    const Tab(text: 'auto short'),
    const Tab(text: 'auto long'),
    const Tab(text: 'fixed'),
  ];
  late TabController _tabController;
  late ScrollController _scrollController;
  late bool fixedScroll;

  Widget _buildCarousel() {
    return Stack(
      children: const <Widget>[
        Placeholder(fallbackHeight: 100),
        Positioned.fill(
            child: Align(alignment: Alignment.center, child: Text('Slider'))),
      ],
    );
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_smoothScrollToTop);

    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  _scrollListener() {
    if (fixedScroll) {
      _scrollController.jumpTo(0);
    }
  }

  _smoothScrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(microseconds: 300),
      curve: Curves.ease,
    );

    setState(() {
      fixedScroll = _tabController.index == 2;
    });
  }

  _buildTabContext(int lineCount) => ListView.builder(
        physics: const ClampingScrollPhysics(),
        itemCount: lineCount,
        itemBuilder: (BuildContext context, int index) {
          return const Text('some content');
        },
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (context, value) {
          return [
            SliverToBoxAdapter(child: _buildCarousel()),
            SliverToBoxAdapter(
              child: TabBar(
                controller: _tabController,
                indicatorColor: const Color(0xffFEB81C),
                labelColor: const Color(0xff00573F),
                tabs: const [
                  Tab(icon: Icon(Icons.calendar_month)),
                  Tab(icon: Icon(Icons.timer)),
                  Tab(icon: Icon(Icons.school)),
                ],
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildTabContext(2),
            _buildTabContext(200),
            _buildTabContext(2)
          ],
        ),
      ),
    );
  }
}
