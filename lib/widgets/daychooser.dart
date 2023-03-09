// ignore_for_file: non_constant_identifier_names

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DayChooser extends StatefulWidget {
  final List<int> dayvector;
  final List<String> timevector;
  const DayChooser({Key? key, required this.dayvector,required this.timevector}) : super(key: key);

  @override
  State<DayChooser> createState() => _DayChooserState();
}

class _DayChooserState extends State<DayChooser> {
  //List<int> widget.dayvector = [0, 0, 0, 0, 0, 0];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(

        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 50.0),
            child: Text("Which days would you like your classes to be on?"),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    DayButton(
                      Day: "Monday",
                      Index: 0,
                      checker: widget.dayvector,
                      tv: widget.timevector,
                    ),
                    DayButton(
                      Day: "Tuesday",
                      Index: 1,
                      checker: widget.dayvector,
                      tv: widget.timevector,
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
                      tv: widget.timevector,
                    ),
                    DayButton(
                      Day: "Thursday",
                      Index: 3,
                      checker: widget.dayvector,
                      tv: widget.timevector,
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
                      tv: widget.timevector,
                    ), DayButton(
                      Day: "Saturday",
                      Index: 5,
                      checker: widget.dayvector,
                      tv: widget.timevector,
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  List dayRet() {
    return widget.dayvector;
  }
}

class DayButton extends StatefulWidget {
  final String Day;
  final int Index;
  final List checker;
  final List<String> tv;

  const DayButton(
      {Key? key, required this.Day, required this.Index, required this.checker, required this.tv})
      : super(key: key);

  @override
  State<DayButton> createState() => _DayButtonState();
}

class _DayButtonState extends State<DayButton> {
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
                  if (widget.checker[widget.Index] == 1) {
                    return const Color(0xff8B1538);
                  }
                  return Colors.grey;
                })),
            onPressed: () {
              setState(() {
                widget.checker[widget.Index] = widget.checker[widget.Index] == 1 ? 0 : 1;
                widget.tv[widget.Index]="";

              });
              if (kDebugMode) {
                print("date chosen");
                print(widget.checker);
                print(widget.tv);
              }
            },
            child: Text(widget.Day)),
      ),
    );
  }
}
