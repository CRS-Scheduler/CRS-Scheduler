import 'package:crs_scheduler/screens/prime_dash.dart';
import 'package:crs_scheduler/widgets/daychooser.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:crs_scheduler/widgets/timechooser.dart';

class DetailDash extends StatefulWidget {
  const DetailDash({Key? key}) : super(key: key);

  @override
  State<DetailDash> createState() => _DetailDashState();
}

class _DetailDashState extends State<DetailDash> {
  final List<int> daychecklist = [0, 0, 0, 0, 0, 0];

  final _formKey = GlobalKey<FormState>();
  late String _courseCode;
  late String _myStanding;
  String _currentSelectedStanding = 'Unselected';
  final List<String> standing = [
    "Unselected",
    "Freshman",
    "Sophomore",
    "Junior",
    "Senior"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
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
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Degree Code',
                                  style: TextStyle(
                                      color: Color(0xff7D0C0E),
                                      fontSize: 24,
                                      fontWeight: FontWeight.w600),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  child: TextFormField(
                                    style:
                                        const TextStyle(fontFamily: 'Poppins'),
                                    onChanged: (value) {
                                      _courseCode = value;
                                    },
                                    decoration: const InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(),
                                      hintText:
                                          'Please enter your course code (e.g. BS CS)',
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter some text';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
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
                                        vertical: 16.0),
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
                                                    BorderRadius.circular(
                                                        5.0))),
                                        value: _currentSelectedStanding,
                                        isDense: true,
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
                            if (kDebugMode) {
                              print("Saving the following:");
                              print(daychecklist);
                            }
                            /*if (_formKey.currentState!.validate()) {
                              if (kDebugMode) {
                                print(
                                  "User inputs:\nCourse code: $_courseCode,Year Standing: $_myStanding ");
                              }

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Saving details for your session')),
                              );
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Dashboard(
                                          courseCode: _courseCode,
                                          yearLevel: _myStanding)));
                            }*/
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
              DefaultTabController(
                  length: 3,
                  child: Column(children: [
                    TabBar(
                      labelColor: Colors.black,
                      tabs: [
                        Tab(icon: Icon(Icons.calendar_month)),
                        Tab(icon: Icon(Icons.timer)),
                        Tab(icon: Icon(Icons.school)),
                      ],
                    ),
                    SizedBox(
                      height: 400,
                      child: TabBarView(children: [
                        DayChooser(dayvector: daychecklist),
                        WhenToMeetMenu(),
                        Center(
                          child: Text('Display Tab 4',
                              style: TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.bold)),
                        ),
                      ]),
                    )
                  ]))
            ],
          ),
        ),
      ),
    );
  }
}

bool isNumeric(String s) {
  return double.tryParse(s) != null;
}
