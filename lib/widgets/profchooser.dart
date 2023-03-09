import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
class SubProfChooser extends StatefulWidget {
  final List<List> preflist;

  const SubProfChooser({Key? key, required this.preflist}) : super(key: key);

  @override
  State<SubProfChooser> createState() => _SubProfChooserState();
}

class _SubProfChooserState extends State<SubProfChooser> {
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
        } else {
          widget.preflist.removeAt(index);
        }
        setState(() {});
        if (kDebugMode) {
          print(
              "User subs/profs:${widget.preflist} ");
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
  double heightret(){
    if(widget.preflist.length >4){
      return 700+67*(widget.preflist.length.toDouble()-3);
    }
    return 700;
  }
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: heightret(),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 50.0),
              child: Column(
                children: const [
                  Text("Please type in your subjects and preferred professors\n"),
                  Text(
                      "You may add new preferred classes by pressing the add class button"),
                  Text(
                      "You do not need to fill the preferred professor field for a class."),
                  Text(
                      "All textfields except the last one need to be filled up for your preferences to be saved"),
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
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("Subject"),
                                  SizedBox(
                                    width: 300,
                                    child: TextFormField(
                                      style: const TextStyle(fontFamily: 'Poppins'),
                                      onChanged: (value) {
                                        widget.preflist[i][0]=value;
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
                                        if (value == null || value.isEmpty && i!=widget.preflist.length-1) {
                                          return 'Please enter some text';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("Professor"),
                                  SizedBox(
                                    width: 300,
                                    child: TextFormField(
                                      style: const TextStyle(fontFamily: 'Poppins'),
                                      onChanged: (value) {
                                        widget.preflist[i][1]=value;
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
                              ),
                              _addRemoveButton(i==widget.preflist.length-1, i)
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
