import 'package:crs_scheduler/screens/prime_dash.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';

class DetailDash extends StatefulWidget {
  const DetailDash({Key? key}) : super(key: key);

  @override
  State<DetailDash> createState() => _DetailDashState();
}

class _DetailDashState extends State<DetailDash> {
  Future<List<dynamic>> getCourseNames(String query) async {
    String csvData = await rootBundle
        .loadString('lib/assets/media/course_college_rel_demo.csv');
    List<List<dynamic>> rowsAsListOfValues =
        const CsvToListConverter().convert(csvData);
    int collegeIndex = rowsAsListOfValues[0]
        .indexOf("course_name"); // find the index of the 'College' column

    return rowsAsListOfValues
        .where((row) =>
            row[1] ==
            query) // filter the rows where the second column (index 1) matches the specified college
        .map((row) =>
            row[collegeIndex]) // extract the values from the first column
        .toList();
  }

  retCollegeCourseCells(String college) async {
    final cells = await getCourseNames(college);
    if (kDebugMode) {
      print(cells);
    }
  }

  List<dynamic> _courseNames = ["Unselected"];
  late List<String> _dropdownItems=["Unselected"];
  final _formKey = GlobalKey<FormState>();
  late String _courseCode;
  late String _myStanding;
  bool _isActive = false;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(100, 25, 100, 100),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Hello!',
                        style: TextStyle(
                            color: Color(0xff8B1538),
                            fontSize: 54,
                            fontWeight: FontWeight.w800),
                      ),
                      Text(
                        'Are you looking for classes to enlist in?',
                        style: TextStyle(
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
              key: _formKey,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 50, horizontal: 100),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'College',
                                  style: TextStyle(
                                      color: Color(0xff7D0C0E),
                                      fontSize: 24,
                                      fontWeight: FontWeight.w600),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 25.0),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButtonFormField<String>(

                                      itemHeight: null,
                                      decoration: InputDecoration(
                                          filled: false,
                                          fillColor: Colors.white,
                                          errorStyle: const TextStyle(
                                              color: Colors.redAccent,
                                              fontSize: 15.0),
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5.0))),
                                      value: _currentSelectedCollege,
                                      isDense: false,
                                      isExpanded: true,
                                      onChanged: (newValue) async {
                                        setState(() {
                                          _currentSelectedCollege = newValue!;
                                        });
                                        _courseNames = await getCourseNames(
                                            _currentSelectedCollege);
                                        setState(() {
                                          _dropdownItems=  _courseNames.map((e) => e.toString()).toList();
                                          _dropdownItems.insert(0, "Unselected");

                                          _isActive= newValue=="Unselected"? false : true;
                                          _currentSelectedCourse="Unselected";

                                        });
                                        if (kDebugMode) {
                                          print(_courseNames);
                                        }
                                      },
                                      validator: (value) {
                                        if (value == "Unselected") {
                                          return 'Please choose your year level';
                                        }
                                        return null;
                                      },
                                      items: college.map((String value) {
                                        return DropdownMenuItem<String>(
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
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Degree',
                                  style: TextStyle(
                                      color: Color(0xff7D0C0E),
                                      fontSize: 24,
                                      fontWeight: FontWeight.w600),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 25.0),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButtonFormField<String>(
                                      disabledHint: const Text("Please choose your college first"),
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
                                                  BorderRadius.circular(5.0))),
                                      value: _currentSelectedCourse,
                                      isDense: false
                                      ,
                                      onChanged:  _isActive ?(value) => setState(() => _currentSelectedCourse = value!) : null,
                                      validator: (value) {
                                        if (value == "Unselected") {
                                          return 'Please choose your degree program';
                                        }
                                        return null;
                                      },
                                      items:  _dropdownItems.map((String value) {
                                        return DropdownMenuItem<String>(
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
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Standing',
                                  style: TextStyle(
                                      color: Color(0xff7D0C0E),
                                      fontSize: 24,
                                      fontWeight: FontWeight.w600),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 25.0),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButtonFormField<String>(
                                      decoration: InputDecoration(
                                          filled: false,
                                          fillColor: Colors.white,
                                          errorStyle: const TextStyle(
                                              color: Colors.redAccent,
                                              fontSize: 15.0),
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5.0))),
                                      value: _currentSelectedStanding,
                                      itemHeight: 50,
                                      isDense: false,
                                      onChanged: (newValue) {
                                        setState(() {
                                          _currentSelectedStanding = newValue!;
                                          _myStanding = newValue;
                                        });
                                      },
                                      validator: (value) {
                                        if (value == "Unselected") {
                                          return 'Please choose your year level';
                                        }
                                        return null;
                                      },
                                      items: standing.map((String value) {
                                        return DropdownMenuItem<String>(
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
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 80,
                      width: 120,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff8B1538)),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            if (kDebugMode) {
                              print(
                                  "User inputs:\nCourse code: $_courseCode,Year Standing: $_myStanding ");
                            }

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  duration: Duration(seconds: 1),
                                  content:
                                      Text('Saving details for your session')),
                            );
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Dashboard(
                                        courseCode: _courseCode,
                                        yearLevel: _myStanding)));
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

                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

bool isNumeric(String s) {
  return double.tryParse(s) != null;
}
