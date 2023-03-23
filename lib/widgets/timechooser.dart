import 'package:flutter/material.dart';

/*
class WhenToMeetMenu extends StatefulWidget {
  const WhenToMeetMenu({super.key});

  @override
  _WhenToMeetMenuState createState() => _WhenToMeetMenuState();
}

class _WhenToMeetMenuState extends State<WhenToMeetMenu> {
  final controller = DragSelectGridViewController();

  @override
  void initState() {
    super.initState();
    controller.addListener(scheduleRebuild);
  }

  @override
  void dispose() {
    controller.removeListener(scheduleRebuild);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: DragSelectGridView(
        gridController: controller,
        itemCount: 20,
        itemBuilder: (context, index, selected) {
          return SelectableItem(
            index: index,
            color: Colors.blue,
            selected: selected,
          );
        },
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 80,
        ),
      ),
    );
  }

  void scheduleRebuild() => setState(() {});
}
class SelectableItem extends StatefulWidget {
  const SelectableItem({
    Key? key,
    required this.index,
    required this.color,
    required this.selected,
  }) : super(key: key);

  final int index;
  final MaterialColor color;
  final bool selected;

  @override
  _SelectableItemState createState() => _SelectableItemState();
}

class _SelectableItemState extends State<SelectableItem>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      value: widget.selected ? 1 : 0,
      duration: kThemeChangeDuration,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1, end: 0.8).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.ease,
      ),
    );
  }

  @override
  void didUpdateWidget(SelectableItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selected != widget.selected) {
      if (widget.selected) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: DecoratedBox(
            child: ,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              color: calculateColor(),
            ),
          ),
        );
      },
      child: Container(
        alignment: Alignment.center,
        child: Text(
          'Item\n#${widget.index}',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
    );
  }

  Color? calculateColor() {
    return Color.lerp(
      widget.color.shade500,
      widget.color.shade900,
      _controller.value,
    );
  }
}
*/
class TypeTimeEntry extends StatefulWidget {
  final List<int> validDays;
  final List<String> timeList;

   const TypeTimeEntry(
      {Key? key, required this.validDays, required this.timeList})
      : super(key: key);

  @override
  State<TypeTimeEntry> createState() => _TypeTimeEntryState();
}

class _TypeTimeEntryState extends State<TypeTimeEntry> {
  static List<String> days = [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday"
  ];
  RegExp timePattern = RegExp(
      r'^(2[0-3]|[0-1][0-9])[0-5][0-9]-(2[0-3]|[0-1][0-9])[0-5][0-9](,(2[0-3]|[0-1][0-9])[0-5][0-9]-(2[0-3]|[0-1][0-9])[0-5][0-9])*$');
  double heightret(){
    if(triggercheck(widget.validDays) >4){
      return 500+50*triggercheck(widget.validDays)-4;
    }
    return 500;
  }
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height:650,
      child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(

            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 50.0),
                child: Column(
                  children: const [
                    Text("Please type in your preferred times for each date.\n"),
                    Text(
                        "Your preferred time must be entered in the following manner:"
                            "\n • Time must be indicated in their 24-hour format e.g. 0700 not 7:00am"
                            "\n • To indicate time spans use the \"-\" character e.g 0700-1200"
                            "\n • To add additional time spans within a day, use the \",\" character e.g 0700-1200,1400-1800"),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Column(

                   children: [

                  Container(
                    child:
                    widget.validDays.any((e) => e == 1)
                        ? null
                        : Column(

                      children: [
                        const Text(style: TextStyle(fontWeight: FontWeight.bold,
                            color: Color(0xff7D0C0E),
                            fontSize: 20),
                            "Warning you have not chosen a preferred day"),
                        const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text("General Schedule for Monday to Saturday"),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [

                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20.0),
                              child: SizedBox(
                                width: 300,

                                child: TextFormField(
                                  initialValue: widget.timeList[6],
                                  style: const TextStyle(fontFamily: 'Poppins'),
                                  onChanged: (value) {

                                    setState(() {
                                      widget.timeList[6]= value;
                                    });

                                  },
                                  decoration: const InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(),
                                    hintText: 'Please enter your preferred timeslots',
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter some text';
                                    } else if (!timePattern.hasMatch(value)) {
                                      return 'Please enter a valid timespan';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),

                  ),
                  for (int x = 0; x < 6; x++)
                    if (widget.validDays[x] == 1)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(width: 100, child: Text(days[x])),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20.0),
                              child: SizedBox(
                                width: 300,
                                child: TextFormField(
                                  initialValue: widget.timeList[x],
                                  style: const TextStyle(fontFamily: 'Poppins'),
                                  onChanged: (value) {
                                    widget.timeList[x] = value;
                                  },
                                  decoration: const InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(),
                                    hintText: 'Please enter your preferred timeslots',
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter some text';
                                    } else if (!timePattern.hasMatch(value)) {
                                      return 'Please enter a valid timespan';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      )

                ],),
              )

            ],
          )

        //Column(children: [Text(widget.validDays[x])])

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