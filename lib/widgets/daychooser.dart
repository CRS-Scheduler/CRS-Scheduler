// ignore_for_file: non_constant_identifier_names
import 'package:showcaseview/showcaseview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DayChooserShowcase extends StatelessWidget {
  final List<int> dayvector;
  final List<String> timevector;
  const DayChooserShowcase(
      {Key? key, required this.dayvector, required this.timevector})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShowCaseWidget(
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
      builder: Builder(
          builder: (context) =>
              DayChooser(dayvector: dayvector, timevector: timevector)),
      autoPlayDelay: const Duration(seconds: 3),
    );
  }
}

class DayChooser extends StatefulWidget {
  final List<int> dayvector;
  final List<String> timevector;

  const DayChooser(
      {Key? key, required this.dayvector, required this.timevector})
      : super(key: key);

  @override
  State<DayChooser> createState() => _DayChooserState();
}

class _DayChooserState extends State<DayChooser> {
  //List<int> widget.dayvector = [0, 0, 0, 0, 0, 0];
  GlobalKey _day = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 500,
      child: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 50.0),
              child: Text("Which days would you like your classes to be on?"),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Showcase(
                        key: _day,
                        description:
                            "Press any of the following buttons to choose which days you prefer to have your classes on.",
                        child: DayButton(
                          Day: "Monday",
                          Index: 0,
                          checker: widget.dayvector,
                          tv: widget.timevector,
                        ),
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
                      ),
                      DayButton(
                        Day: "Saturday",
                        Index: 5,
                        checker: widget.dayvector,
                        tv: widget.timevector,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(width: 3, color: const Color(0xff8B1538)),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                  iconSize: 15,
                  splashRadius: 1,
                  onPressed: () {
                    ShowCaseWidget.of(context).startShowCase([_day]);
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
      {Key? key,
      required this.Day,
      required this.Index,
      required this.checker,
      required this.tv})
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
                widget.checker[widget.Index] =
                    widget.checker[widget.Index] == 1 ? 0 : 1;
                widget.tv[widget.Index] = "";
                widget.tv[6] = "";
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

double triggercheck(List<int> lister) {
  double valhold = 0;
  for (int i = 0; i < 5; i++) {
    if (lister[i] == 1) {
      valhold += 1;
    }
  }
  return valhold;
}
