import 'dart:convert';
import 'package:crs_scheduler/screens/prime_dash.dart';
import 'package:http/http.dart' as http;
import 'package:crs_scheduler/assets/scripts/csv_reader.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:showcaseview/showcaseview.dart';
import '../sizeconfig.dart';

class DetailParent extends StatelessWidget {
  const DetailParent({Key? key}) : super(key: key);

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
        builder:
            Builder(builder: (context) => DetailDash(csvReader: MyCsvReader())),
        autoPlayDelay: const Duration(seconds: 3),
      ),
    );
  }
}

class DetailDash extends StatefulWidget {
  final MyCsvReader csvReader;
  const DetailDash({Key? key, required this.csvReader}) : super(key: key);

  @override
  State<DetailDash> createState() => _DetailDashState();
}

class _DetailDashState extends State<DetailDash> {
  Future<void> getCourseNames(List<List<dynamic>> data, String college) async {
    _courseNames = data
        .where((row) => row[collegeInd] == college)
        .map((row) => row[courseNameInd])
        .toList();
  }
  List datar=[];
  Future<List<dynamic>> fetchlist(String course) async {
    List<dynamic> localhold = [];
    print("http://127.0.0.1:5000/api/courses?prgm=$course");
    var response = await http.get(
      Uri.parse("http://127.0.0.1:5000/api/courses?prgm=$course"),
      //headers: {"Accept": "application/json"}
    );
    setState(() {
      localhold = json.decode(response.body);
    });
    return localhold;
  }

  double deviceHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;
  List<dynamic> _courseNames = ["Unselected"];
  late List<String> _dropdownItems = ["Unselected"];
  final _formKey = GlobalKey<FormState>();
  late String _myStanding;
  bool _isActiveCourses = false;
  String _currentSelectedStanding = 'Unselected';
  String _currentSelectedCollege = 'Unselected';
  String _currentSelectedCourse = 'Unselected';
  final List<String> standing = [
    "Unselected",
    "Freshman",
    "Sophomore",
    "Junior",
    "Senior"
  ];
  final List<String> college = [
    "Unselected",
    "College of Engineering",
    "College of Social Sciences and Philosophy",
  ];
  List<String> _courseData = [];
  List<List<dynamic>>? data;
  late int collegeInd;
  late int courseNameInd;


  final GlobalKey _college = GlobalKey();
  final GlobalKey _degree = GlobalKey();
  final GlobalKey _standing = GlobalKey();
  final GlobalKey _next = GlobalKey();
  @override
  void initState() {
    super.initState();
    /* WidgetsBinding.instance.addPostFrameCallback(
          (_) => ShowCaseWidget.of(context)
          .startShowCase([_college,_degree,_standing,_next]),
    );*/
    widget.csvReader.loadData().then((value) => setState(() {
          data = value;
          collegeInd = value[0].indexOf('college');
          courseNameInd = value[0].indexOf('course_name');
        }));
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(
                      (SizeConfig.screenWidth > 600)
                          ? 100
                          : SizeConfig.safeBlockHorizontal * 12,
                      25,
                      (SizeConfig.screenWidth > 600)
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
                              'Hello!',
                              style: TextStyle(
                                  color: const Color(0xff8B1538),
                                  fontSize: (SizeConfig.screenWidth > 600)
                                      ? 54
                                      : SizeConfig.safeBlockHorizontal * 8,
                                  fontWeight: FontWeight.w800),
                            ),
                            Text(
                              'Are you looking for classes to enlist in?',
                              style: TextStyle(
                                  color: const Color(0xff7D0C0E),
                                  fontSize: (SizeConfig.screenWidth > 600)
                                      ? 24
                                      : SizeConfig.safeBlockHorizontal * 4,
                                  fontWeight: FontWeight.w600),
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
                              ShowCaseWidget.of(context).startShowCase(
                                  [_college, _degree, _standing, _next]);
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
                        mainAxisAlignment: MainAxisAlignment.start,
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
                  key: _formKey,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: 50,
                        horizontal: (SizeConfig.screenWidth > 600)
                            ? 100
                            : SizeConfig.safeBlockHorizontal * 12),
                    child: Column(
                      children: [
                        (SizeConfig.screenWidth > 848)
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 25.0),
                                      child: Showcase(
                                        targetPadding: const EdgeInsets.all(3),
                                        key: _college,
                                        description:
                                            'Pick your college from the drop down menu',
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'College',
                                                style: TextStyle(
                                                    color:
                                                        const Color(0xff7D0C0E),
                                                    fontSize: (SizeConfig
                                                                .screenWidth >
                                                            600)
                                                        ? 24
                                                        : SizeConfig
                                                                .safeBlockHorizontal *
                                                            4,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 25.0),
                                                child: Tooltip(
                                                  message:
                                                      "Pick the college you're currently enrolled in.",
                                                  child:
                                                      DropdownButtonHideUnderline(
                                                    child:
                                                        DropdownButtonFormField<
                                                            String>(
                                                      itemHeight: null,
                                                      decoration: InputDecoration(
                                                          filled: false,
                                                          fillColor: Colors
                                                              .white,
                                                          errorStyle:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .redAccent,
                                                                  fontSize:
                                                                      15.0),
                                                          border: OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5.0))),
                                                      value:
                                                          _currentSelectedCollege,
                                                      isDense: false,
                                                      isExpanded: true,
                                                      onChanged: (newValue) {
                                                        setState(() {
                                                          _currentSelectedCollege =
                                                              newValue!;
                                                          getCourseNames(data!,
                                                              _currentSelectedCollege);
                                                          _dropdownItems =
                                                              _courseNames
                                                                  .map((e) => e
                                                                      .toString())
                                                                  .toList();
                                                          _dropdownItems.insert(
                                                              0, "Unselected");
                                                          _isActiveCourses =
                                                              (newValue ==
                                                                      "Unselected")
                                                                  ? false
                                                                  : true;
                                                          _currentSelectedCourse =
                                                              "Unselected";
                                                        });

                                                        if (kDebugMode) {
                                                          print(_dropdownItems);
                                                        }
                                                      },
                                                      validator: (value) {
                                                        if (value ==
                                                            "Unselected") {
                                                          return 'Please choose your College';
                                                        }
                                                        return null;
                                                      },
                                                      items: college
                                                          .map((String value) {
                                                        return DropdownMenuItem<
                                                            String>(
                                                          value: value,
                                                          child: Text(value),
                                                        );
                                                      }).toList(),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 25.0),
                                      child: Showcase(
                                        targetPadding: const EdgeInsets.all(3),
                                        key: _degree,
                                        description:
                                            "Pick your degree program from the drop down menu",
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Degree',
                                                style: TextStyle(
                                                    color:
                                                        const Color(0xff7D0C0E),
                                                    fontSize: (SizeConfig
                                                                .screenWidth >
                                                            600)
                                                        ? 24
                                                        : SizeConfig
                                                                .safeBlockHorizontal *
                                                            4,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 25.0),
                                                child: Tooltip(
                                                  message:
                                                      "Pick your degree program.",
                                                  child:
                                                      DropdownButtonHideUnderline(
                                                    child:
                                                        DropdownButtonFormField<
                                                            String>(
                                                      disabledHint: const Text(
                                                          "Please choose your college first"),
                                                      isExpanded: true,
                                                      itemHeight: null,
                                                      decoration: InputDecoration(
                                                          filled: false,
                                                          fillColor: Colors
                                                              .white,
                                                          errorStyle:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .redAccent,
                                                                  fontSize:
                                                                      15.0),
                                                          border: OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5.0))),
                                                      value:
                                                          _currentSelectedCourse,
                                                      isDense: false,
                                                      onChanged: _isActiveCourses
                                                          ? (value) => setState(
                                                              () =>
                                                                  _currentSelectedCourse =
                                                                      value!)
                                                          : null,
                                                      validator: (value) {
                                                        if (value ==
                                                            "Unselected") {
                                                          return 'Please choose your degree program';
                                                        }
                                                        return null;
                                                      },
                                                      items: _dropdownItems
                                                          .map((String value) {
                                                        return DropdownMenuItem<
                                                            String>(
                                                          value: value,
                                                          child: Text(value),
                                                        );
                                                      }).toList(),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 25.0),
                                      child: Showcase(
                                        targetPadding: const EdgeInsets.all(3),
                                        key: _standing,
                                        description:
                                            "Pick your current standing from the drop down menu",
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Standing',
                                                style: TextStyle(
                                                    color:
                                                        const Color(0xff7D0C0E),
                                                    fontSize: (SizeConfig
                                                                .screenWidth >
                                                            600)
                                                        ? 24
                                                        : SizeConfig
                                                                .safeBlockHorizontal *
                                                            4,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 25.0),
                                                child: Tooltip(
                                                  message:
                                                      "Enter your current standing.",
                                                  child:
                                                      DropdownButtonHideUnderline(
                                                    child:
                                                        DropdownButtonFormField<
                                                            String>(
                                                      decoration: InputDecoration(
                                                          filled: false,
                                                          fillColor: Colors
                                                              .white,
                                                          errorStyle:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .redAccent,
                                                                  fontSize:
                                                                      15.0),
                                                          border: OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5.0))),
                                                      value:
                                                          _currentSelectedStanding,
                                                      itemHeight: (SizeConfig
                                                                  .screenWidth >
                                                              863)
                                                          ? null
                                                          : 57,
                                                      isDense: false,
                                                      onChanged: (newValue) {
                                                        setState(() {
                                                          _currentSelectedStanding =
                                                              newValue!;
                                                          _myStanding =
                                                              newValue;
                                                        });
                                                      },
                                                      validator: (value) {
                                                        if (value ==
                                                            "Unselected") {
                                                          return 'Please choose your year level';
                                                        }
                                                        return null;
                                                      },
                                                      items: standing
                                                          .map((String value) {
                                                        return DropdownMenuItem<
                                                            String>(
                                                          value: value,
                                                          child: Text(value),
                                                        );
                                                      }).toList(),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: Column(children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 25.0),
                                    child: Showcase(
                                      targetPadding: const EdgeInsets.symmetric(
                                          horizontal: 5),
                                      key: _college,
                                      description:
                                          'Pick your college from the drop down menu',
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'College',
                                            style: TextStyle(
                                                color: const Color(0xff7D0C0E),
                                                fontSize: (SizeConfig
                                                            .screenWidth >
                                                        600)
                                                    ? 24
                                                    : SizeConfig
                                                            .safeBlockHorizontal *
                                                        4,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 25.0),
                                            child: DropdownButtonHideUnderline(
                                              child: DropdownButtonFormField<
                                                  String>(
                                                itemHeight: null,
                                                decoration: InputDecoration(
                                                    filled: false,
                                                    fillColor: Colors.white,
                                                    errorStyle: const TextStyle(
                                                        color: Colors.redAccent,
                                                        fontSize: 15.0),
                                                    border: OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    5.0))),
                                                value: _currentSelectedCollege,
                                                isDense: false,
                                                isExpanded: true,
                                                onChanged: (newValue) {
                                                  setState(() {
                                                    _currentSelectedCollege =
                                                        newValue!;
                                                    getCourseNames(data!,
                                                        _currentSelectedCollege);
                                                    _dropdownItems =
                                                        _courseNames
                                                            .map((e) =>
                                                                e.toString())
                                                            .toList();
                                                    _dropdownItems.insert(
                                                        0, "Unselected");
                                                    _isActiveCourses =
                                                        (newValue ==
                                                                "Unselected")
                                                            ? false
                                                            : true;
                                                    _currentSelectedCourse =
                                                        "Unselected";
                                                  });

                                                  if (kDebugMode) {
                                                    print(_dropdownItems);
                                                  }
                                                },
                                                validator: (value) {
                                                  if (value == "Unselected") {
                                                    return 'Please choose your College';
                                                  }
                                                  return null;
                                                },
                                                items:
                                                    college.map((String value) {
                                                  return DropdownMenuItem<
                                                      String>(
                                                    value: value,
                                                    child: Text(value),
                                                  );
                                                }).toList(),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 25.0),
                                    child: Showcase(
                                      targetPadding: const EdgeInsets.symmetric(
                                          horizontal: 5),
                                      key: _degree,
                                      description:
                                          "Pick your degree program from the drop down menu",
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Degree',
                                            style: TextStyle(
                                                color: const Color(0xff7D0C0E),
                                                fontSize: (SizeConfig
                                                            .screenWidth >
                                                        600)
                                                    ? 24
                                                    : SizeConfig
                                                            .safeBlockHorizontal *
                                                        4,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 25.0),
                                            child: DropdownButtonHideUnderline(
                                              child: DropdownButtonFormField<
                                                  String>(
                                                disabledHint: const Text(
                                                    "Please choose your college first"),
                                                isExpanded: true,
                                                itemHeight: null,
                                                decoration: InputDecoration(
                                                    filled: false,
                                                    fillColor: Colors.white,
                                                    errorStyle: const TextStyle(
                                                        color: Colors.redAccent,
                                                        fontSize: 15.0),
                                                    border: OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    5.0))),
                                                value: _currentSelectedCourse,
                                                isDense: false,
                                                onChanged: _isActiveCourses
                                                    ? (value) => setState(() =>
                                                        _currentSelectedCourse =
                                                            value!)
                                                    : null,
                                                validator: (value) {
                                                  if (value == "Unselected") {
                                                    return 'Please choose your degree program';
                                                  }
                                                  return null;
                                                },
                                                items: _dropdownItems
                                                    .map((String value) {
                                                  return DropdownMenuItem<
                                                      String>(
                                                    value: value,
                                                    child: Text(value),
                                                  );
                                                }).toList(),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 25.0),
                                    child: Showcase(
                                      targetPadding: const EdgeInsets.symmetric(
                                          horizontal: 5),
                                      key: _standing,
                                      description:
                                          "Pick your current standing from the drop down menu",
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Standing',
                                            style: TextStyle(
                                                color: const Color(0xff7D0C0E),
                                                fontSize: (SizeConfig
                                                            .screenWidth >
                                                        600)
                                                    ? 24
                                                    : SizeConfig
                                                            .safeBlockHorizontal *
                                                        4,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 25.0),
                                            child: DropdownButtonHideUnderline(
                                              child: DropdownButtonFormField<
                                                  String>(
                                                decoration: InputDecoration(
                                                    filled: false,
                                                    fillColor: Colors.white,
                                                    errorStyle: const TextStyle(
                                                        color: Colors.redAccent,
                                                        fontSize: 15.0),
                                                    border: OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    5.0))),
                                                value: _currentSelectedStanding,
                                                itemHeight: 50,
                                                isDense: false,
                                                onChanged: (newValue) {
                                                  setState(() {
                                                    _currentSelectedStanding =
                                                        newValue!;
                                                    _myStanding = newValue;
                                                  });
                                                },
                                                validator: (value) {
                                                  if (value == "Unselected") {
                                                    return 'Please choose your year level';
                                                  }
                                                  return null;
                                                },
                                                items: standing
                                                    .map((String value) {
                                                  return DropdownMenuItem<
                                                      String>(
                                                    value: value,
                                                    child: Text(value),
                                                  );
                                                }).toList(),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                ]),
                              ),
                        Showcase(
                          key: _next,
                          targetPadding: const EdgeInsets.all(10),
                          description:
                              "When you've finished entering all your details above, press NEXT.",
                          child: SizedBox(
                            height: 80,
                            width: 120,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xff8B1538)),
                              onPressed: () async {

                                if (_formKey.currentState!.validate()) {
                                  // String holder = await getCourseSN(_currentSelectedCollege,   _currentSelectedCourse);
                                  _courseData = data!
                                      .where((row) =>
                                          row[collegeInd] ==
                                              _currentSelectedCollege &&
                                          row[courseNameInd] ==
                                              _currentSelectedCourse)
                                      .map((e) => e.toString())
                                      .toList();
                                  List<dynamic> courseList = await fetchlist(_courseData[0].split(', ')[3]);

                                  print(courseList.toString());
                                  //print(courseList[1]);
                                  if (kDebugMode) {
                                    print(_courseData[0].split(', ')[3]);

                                    print(
                                        "User inputs:\nCollege: $_currentSelectedCollege, Course: $_currentSelectedCourse, Year Standing: $_myStanding ");
                                  }

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        duration: Duration(seconds: 1),
                                        content: Text(
                                            'Saving details for your session')),
                                  );

                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => PrimeShowcaser(
                                              courseCode:
                                                  _currentSelectedCourse,
                                              yearLevel: _myStanding,
                                              courseData: _courseData,allowedCourse: courseList,)));
                                }
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
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

bool isNumeric(String s) {
  return double.tryParse(s) != null;
}
