import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final _formKey = GlobalKey<FormState>();
  late String _courseCode;
  late String _myStanding;
  String _currentSelectedStanding = 'Unselected';
  final List<String> standing = [
    "Unselected",
    "Freshman",
    "Sophomore","Junior",
    "Senior"
  ];
  @override
  Widget build(BuildContext context) {
    return   Scaffold(
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
            /*Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Card(
                  elevation: 10,
                  color: const Color(0xffFFD5AA),
                  child: InkWell(
                    onTap: () {},
                    splashColor: Colors.lightBlueAccent.withAlpha(30),
                    child: SizedBox(
                      width: 300,
                      height: 200,
                      child: Padding(
                        padding: const EdgeInsets.all(35.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Orders',
                              style: TextStyle(
                                  color: Color(0xff000000),
                                  fontSize: 30,
                                  fontWeight: FontWeight.w700),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [

                              ],
                            ),
                            const Spacer(
                              flex: 1,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Card(
                  elevation: 10,
                  color: const Color(0xffCADEFF),
                  child: InkWell(
                    splashColor: Colors.lightBlueAccent.withAlpha(30),
                    onTap: () {},
                    child: SizedBox(
                      width: 300,
                      height: 200,
                      child: Padding(
                        padding: const EdgeInsets.all(35.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Sales to Date',
                              style: TextStyle(
                                  color: Color(0xff000000),
                                  fontSize: 30,
                                  fontWeight: FontWeight.w700),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [

                              ],
                            ),
                            const Spacer(
                              flex: 1,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Card(
                  elevation: 10,
                  color: const Color(0xffFDC1C3),
                  child: InkWell(
                    splashColor: Colors.lightBlueAccent.withAlpha(30),
                    onTap: () {},
                    child: SizedBox(
                      width: 300,
                      height: 200,
                      child: Padding(
                        padding: const EdgeInsets.all(35.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text(
                              'Monthly Cost',
                              style: TextStyle(
                                  color: Color(0xff000000),
                                  fontSize: 30,
                                  fontWeight: FontWeight.w700),
                            ),

                            Spacer(
                              flex: 1,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Card(
                  elevation: 10,
                  color: const Color(0xffC4F0B5),
                  child: InkWell(
                    splashColor: Colors.lightBlueAccent.withAlpha(30),
                    onTap: () {},
                    child: SizedBox(
                      width: 300,
                      height: 200,
                      child: Padding(
                        padding: const EdgeInsets.all(35.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text(
                              'Breakeven',
                              style: TextStyle(
                                  color: Color(0xff000000),
                                  fontSize: 30,
                                  fontWeight: FontWeight.w700),
                            ),

                            Spacer(
                              flex: 1,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),*/
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
                                'Course Code',
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
                                    _courseCode = value;
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
                                Padding(
                                  padding:
                                  const EdgeInsets.symmetric(vertical: 16.0),
                                  child: FormField<String>(
                                    builder: (FormFieldState<String> state) {
                                      return InputDecorator(
                                        isEmpty: false,
                                        decoration: InputDecoration(
                                            filled: false,
                                            fillColor: Colors.white,
                                            errorStyle: const TextStyle(
                                                color: Colors.redAccent,
                                                fontSize: 20.0),
                                            hintText: 'Please select expense',
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                BorderRadius.circular(5.0))),
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton<String>(
                                            value: _currentSelectedStanding,
                                            isDense: true,
                                            onChanged: (newValue) {
                                              setState(() {
                                                _currentSelectedStanding = newValue!;
                                                _myStanding = newValue;
                                              });
                                            },
                                            items: standing.map((String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(value),
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                      );
                                    },
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
                        style:  ElevatedButton.styleFrom(backgroundColor: Color(0xff8B1538)),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Adding to database')),
                            );
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
