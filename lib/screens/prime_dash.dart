// ignore_for_file: unused_field

import 'package:flutter/material.dart';
class Dashboard extends StatefulWidget {
   final String courseCode;
   final String yearLevel;
   const Dashboard({Key? key, required this.courseCode, required this.yearLevel }) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final _formKey = GlobalKey<FormState>();
  late String _day;
  late String _time;
  late String _course;

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Padding(
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
                    children:  [
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




            /*Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical:50,horizontal: 100),
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
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                child: TextFormField(
                                  style: const TextStyle(fontFamily: 'Poppins'),
                                  onChanged: (value) {

                                  },
                                  decoration: const InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(),
                                    hintText: 'Please enter your course code (e.g. BS CS)',
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
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children:  [
                                const Text(
                                  'Standing',
                                  style: TextStyle(
                                      color: Color(0xff7D0C0E),
                                      fontSize: 24,
                                      fontWeight: FontWeight.w600),
                                ),



                              ],
                            ),
                          ),
                        ),


                      ],
                    ),

                  ],
                ),
              ),
            ),*/
          ],
        ),
      ),
    );
  }
}
