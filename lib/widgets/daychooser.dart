// ignore_for_file: non_constant_identifier_names

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DayChooser extends StatefulWidget {
  final List<int> dayvector;
  const DayChooser({Key? key, required this.dayvector}) : super(key: key);

  @override
  State<DayChooser> createState() => _DayChooserState();
}

class _DayChooserState extends State<DayChooser> {
  //List<int> widget.dayvector = [0, 0, 0, 0, 0, 0];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Which days would you like your classes to be on?"),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              DayButton(
                Day: "Monday",
                Index: 0,
                checker: widget.dayvector,
              ),
              DayButton(
                Day: "Tuesday",
                Index: 1,
                checker: widget.dayvector,
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              DayButton(
                Day: "Wednesday",
                Index: 2,
                checker: widget.dayvector,
              ),
              DayButton(
                Day: "Thursday",
                Index: 3,
                checker: widget.dayvector,
              ),

            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              DayButton(
                Day: "Friday",
                Index: 4,
                checker: widget.dayvector,
              ), DayButton(
                Day: "Saturday",
                Index: 5,
                checker: widget.dayvector,
              ),
            ],
          )
        ],
      ),
    );
  }

  List dayRet() {
    return widget.dayvector;
  }
}

class DayButton extends StatelessWidget {
  final String Day;
  final int Index;
  final List checker;

  const DayButton(
      {Key? key, required this.Day, required this.Index, required this.checker})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: 150,
        height: 50,
        child: ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith((states) {
                  // If the button is pressed, return green, otherwise blue
                  if (checker[Index] == 1) {
                    return const Color(0xff8B1538);
                  }
                  return Colors.grey;
                })),
            onPressed: () {
              checker[Index] = checker[Index] == 1 ? 0 : 1;
              if (kDebugMode) {
                print(checker);
              }
            },
            child: Text(Day)),
      ),
    );
  }
}
