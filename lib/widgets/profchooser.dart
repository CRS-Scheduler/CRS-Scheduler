import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:showcaseview/showcaseview.dart';

class SubProfChooserShowcase extends StatelessWidget {
  final List<List> preflist;
  const SubProfChooserShowcase({Key? key, required this.preflist})
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
          builder: (context) => SubProfChooser(
                preflist: preflist,
              )),
      autoPlayDelay: const Duration(seconds: 3),
    );
  }
}

class SubProfChooser extends StatefulWidget {
  final List<List> preflist;

  const SubProfChooser({Key? key, required this.preflist}) : super(key: key);

  @override
  State<SubProfChooser> createState() => _SubProfChooserState();
}

class _SubProfChooserState extends State<SubProfChooser> {
  final GlobalKey _sub = GlobalKey();
  final GlobalKey _prof = GlobalKey();

  List<TextEditingController> controllers = [TextEditingController()];
  //List<TextEditingController> prof_controllers = [TextEditingController()];
  void addController() {
    TextEditingController newController = TextEditingController();
    controllers.add(newController);
    //prof_controllers.add(newerController);
  }

  Widget _addRemoveButton(
    bool add,
    int index,
  ) {
    List<String> blank = ["", ""];
    return InkWell(
      onTap: () {
        if (add) {
          // add new text-fields at the top of all friends textfields
          widget.preflist.insert(widget.preflist.length, blank);
          addController();
        } else {
          widget.preflist.removeAt(index);
          controllers[index].clear();
          // prof_controllers[index].clear();
        }
        setState(() {});
        if (kDebugMode) {
          print("User subs/profs:${widget.preflist} ");
        }
      },
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: (add) ? const Color(0xff00573F) : const Color(0xff7D0C0E),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(
          (add) ? Icons.add : Icons.remove,
          color: Colors.white,
        ),
      ),
    );
  }

  double heightret() {
    if (widget.preflist.length > 4) {
      return 700 + 67 * (widget.preflist.length.toDouble() - 3);
    }
    return 700;
  }

  double deviceHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;
  double deviceWidth(BuildContext context) => MediaQuery.of(context).size.width;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: heightret(),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 50.0, horizontal: 20),
              child: Column(
                children: [
                  const Text(
                    "Please type in your subjects and preferred professors\n",
                    textAlign: TextAlign.center,
                  ),
                  const Text(
                      "You may add new preferred classes by pressing the add class button",
                      textAlign: TextAlign.center),
                  const Text(
                      "You do not need to fill the preferred professor field for a class.",
                      textAlign: TextAlign.center),
                  const Text(
                      "All textfields except the last one need to be filled up for your preferences to be saved",
                      textAlign: TextAlign.center),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                            width: 3, color: const Color(0xff8B1538)),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                          iconSize: 15,
                          splashRadius: 1,
                          onPressed: () {
                            // if(widget.validDays.any((e) => e == 1)): null ?
                            ShowCaseWidget.of(context)
                                .startShowCase([_sub, _prof]);

                            if (kDebugMode) {
                              print("lets play");
                            }
                          },
                          icon: const Icon(Icons.question_mark_rounded),
                          color: const Color(0xff8B1538)),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Column(
                    children: [
                      for (int i = 0; i < widget.preflist.length; i++)
                        if (i == 0)
                          Padding(
                            padding:  EdgeInsets.symmetric(vertical: 5.0,horizontal: deviceWidth(context) * 0.15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                const Text("Subject"),
                                SizedBox(
                                  width: (deviceWidth(context) > 800)
                                      ? 300
                                      : deviceWidth(context) * 0.4,
                                  child: Showcase(
                                    key: _sub,
                                    description:
                                        "Input the course code of your preferred subject here.",
                                    child: TextFormField(
                                      controller: controllers[0],
                                      style: const TextStyle(
                                          fontFamily: 'Poppins'),
                                      onChanged: (value) {
                                        widget.preflist[i][0] = value;
                                        setState(() {});
                                      },
                                      decoration: const InputDecoration(
                                        filled: true,
                                        fillColor: Colors.white,
                                        border: OutlineInputBorder(),
                                        hintText:
                                            'Please enter your preferred subject',
                                      ),
                                      validator: (value) {
                                        if (value == null ||
                                            value.isEmpty &&
                                                i !=
                                                    widget.preflist.length -
                                                        1) {
                                          return 'Please enter some text';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ),

                                _addRemoveButton(
                                    i == widget.preflist.length - 1, i)
                              ],
                            ),
                          )
                        else
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                const Text("Subject"),
                                SizedBox(
                                  width: (deviceWidth(context) > 800)
                                      ? 300
                                      : deviceWidth(context) * 0.4,
                                  child: TextFormField(
                                    controller: controllers[i],
                                    style: const TextStyle(
                                        fontFamily: 'Poppins'),
                                    onChanged: (value) {
                                      widget.preflist[i][0] = value;
                                      setState(() {});
                                    },
                                    decoration: const InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(),
                                      hintText:
                                          'Please enter your preferred subject',
                                    ),
                                    validator: (value) {
                                      if (value == null ||
                                          value.isEmpty &&
                                              i !=
                                                  widget.preflist.length -
                                                      1) {
                                        return 'Please enter some text';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                /*Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("Professor"),
                                    SizedBox(
                                      width: (deviceWidth(context) > 800)
                                          ? 300
                                          : deviceWidth(context) * 0.4,
                                      child: TextFormField(
                                        controller: prof_controllers[i],
                                        style: const TextStyle(
                                            fontFamily: 'Poppins'),
                                        onChanged: (value) {
                                          widget.preflist[i][1] = value;
                                          setState(() {});
                                        },
                                        decoration: const InputDecoration(
                                          filled: true,
                                          fillColor: Colors.white,
                                          border: OutlineInputBorder(),
                                          hintText:
                                              'OPTIONAL: Please enter your preferred professor',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),*/
                                _addRemoveButton(
                                    i == widget.preflist.length - 1, i)
                              ],
                            ),
                          )
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
